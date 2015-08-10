//
//  ScriptInstallationManager.swift
//  Markdown
//
//  Created by Sash Zats on 7/29/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import AppKit


public struct ScriptInstallationManager {
    
    private static let DestinationURL: NSURL? = {
        return NSFileManager.defaultManager().URLForDirectory(.ApplicationScriptsDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true, error: nil)
    }()
    
    public func shouldInstallScripts() -> Bool {
        let bundle = NSBundle.mainBundle()
        if let URLs = bundle.URLsForResourcesWithExtension("scpt", subdirectory: "Scripts") as? [NSURL],
            destinationURL = ScriptInstallationManager.DestinationURL {
            let manager = NSFileManager.defaultManager()
            for URL in URLs {
                if let fileName = URL.lastPathComponent {
                    let destinationURL = destinationURL.URLByAppendingPathComponent(fileName)
                    if let path = destinationURL.absoluteURL?.relativePath {
                        if !manager.fileExistsAtPath(path) {
                            return true
                        }
                        if destinationURL.modificationDate < URL.modificationDate {
                            return true
                        }
                    } else {
                        assertionFailure("No relative path for \(URL)")
                    }
                } else {
                    assertionFailure("No filename for \(URL)")
                }
            }
        } else {
            assertionFailure("No scripts found in the bundle!")
        }
        return false
    }

    public enum PromptResult {
        case Cancel, Install, ShowScript
    }
    
    public func promptScriptInstallation(completion: Bool -> Void) {
        let alert = NSAlert()
        alert.messageText = "Do you want to install pasteboard helper script?"
        alert.informativeText = "Due to App Store limitations, without this script app can only copy formatted markdown in the Pasteboard."
        alert.addButtonWithTitle("Install")
        alert.addButtonWithTitle("Cancel")
        let result = alert.runModal()
        if result == NSAlertFirstButtonReturn {
            installScripts(completion)
        } else {
            completion(false)
        }
    }
    
    public func installScripts(completion: Bool -> Void) {
        if let scriptsFolderURL = ScriptInstallationManager.DestinationURL {
            let openPanel = NSOpenPanel()
            openPanel.directoryURL = scriptsFolderURL
            openPanel.canChooseDirectories = true
            openPanel.canChooseFiles = false
            openPanel.prompt = "Install script"
            openPanel.message = "Please select the \(scriptsFolderURL.relativePath!) folder"
            openPanel.beginWithCompletionHandler{ status in
                if status != NSFileHandlingPanelOKButton {
                    completion(false)
                    return
                }
                if let selectedURL = openPanel.URL {
                    if selectedURL == scriptsFolderURL {
                        self.removeScriptsFolder()
                        let manager = NSFileManager.defaultManager()
                        var error: NSError?
                        let result = manager.createDirectoryAtURL(scriptsFolderURL, withIntermediateDirectories: true, attributes: nil, error: &error)
                        assert(result, "Failed to create Scripts folder at \(ScriptInstallationManager.DestinationURL): \(error)")
                        let scripts: [Script] = [.Copy, .Paste]
                        for script in scripts {
                            if let URL = script.destinationURL {
                                let result = manager.copyItemAtURL(script.bundledURL, toURL: URL, error: &error)
                                assert(result, "Failed to copy file from \(script.bundledURL) to \(URL): \(error)")
                            }
                        }
                        completion(true)
                    }
                }
                completion(false)
            }
        } else {
            completion(false)
        }
    }
    
    /**
        Prompts user to install the script.
    
        :param: window target window to run alert in
        :param: completion handler called upon user finished interaction, will return one `PromptResult` parameter
            indicating whether user wants to proceed, show script or cancel
     */
    public func promptScriptInstallation(window: NSWindow, completion: PromptResult -> Void) {
        let alert = NSAlert()
        alert.messageText = "We need to install an AppleScript to continue."
        alert.informativeText = "You will be prompted to select this app's personal folder storing scripts. Are you sure you want to continue?"
        alert.addButtonWithTitle("Install")
        alert.addButtonWithTitle("Show Script")
        alert.addButtonWithTitle("Cancel")
        alert.beginSheetModalForWindow(window){ response in
            if response == NSAlertFirstButtonReturn {
                completion(.Install)
            } else if response == NSAlertSecondButtonReturn {
                completion(.ShowScript)
            } else {
                completion(.Cancel)
            }
        }
    }
    
    // MARK: - Private
    
    private func removeScriptsFolder() {
        if let URL = ScriptInstallationManager.DestinationURL {
            let manager = NSFileManager.defaultManager()
            var error: NSError?
            let result = manager.removeItemAtURL(URL, error: &error)
//            assert(result, "Failed to remove scripts folder: \(error)")
//            if let files = manager.contentsOfDirectoryAtURL(URL, includingPropertiesForKeys: nil, options: .SkipsHiddenFiles, error: &error) as? [NSURL] {
//                for file in files {
//                    let result = manager.removeItemAtURL(file, error: &error)
//                    assert(result, "Failed to remove file at \(file): \(error)")
//                }
//            } else {
//                assertionFailure("Failed to get contents of Scripts folder: \(error)")
//            }
        }
    }
}


// MARK: - ResettablePreferences
extension ScriptInstallationManager: ResettablePreferences {
    func reset(storage: NSUserDefaults) {
        removeScriptsFolder()
    }
}


private extension NSURL {
    var modificationDate: NSDate? {
        let manager = NSFileManager.defaultManager()
        if let path = self.absoluteURL?.relativePath {
            var error: NSError?
            if let attributes = manager.attributesOfItemAtPath(path, error: &error) {
                return (attributes as NSDictionary).fileModificationDate()
            } else {
                assertionFailure("Failed to fetch attributes for \(self): \(error)")
            }
        }
        return nil
    }
}

extension NSDate: Comparable {
}

public func <=(lhs: NSDate, rhs: NSDate) -> Bool {
    let comparison = lhs.compare(rhs)
    return comparison != .OrderedDescending
}
public func >=(lhs: NSDate, rhs: NSDate) -> Bool {
    let comparison = lhs.compare(rhs)
    return comparison != .OrderedAscending
}
public func >(lhs: NSDate, rhs: NSDate) -> Bool {
    let comparison = lhs.compare(rhs)
    return comparison == .OrderedDescending
}
public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    let comparison = lhs.compare(rhs)
    return comparison == .OrderedAscending
}
public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    let comparison = lhs.compare(rhs)
    return comparison == .OrderedSame
}