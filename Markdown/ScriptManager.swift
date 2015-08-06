//
//  ScriptManager.swift
//  Markdown
//
//  Created by Sash Zats on 7/29/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import AppKit


public enum Script {
    case Copy
    case Paste
}

private extension Script {
    var fileName: String {
        switch self {
        case .Copy:
            return "⌘C"
        case .Paste:
            return "⌘V"
        }
    }
    
    var bundledURL: NSURL {
        return NSBundle.mainBundle().URLForResource(self.fileName, withExtension: "scpt", subdirectory: "Scripts")!
    }

    var destinationURL: NSURL? {
        let manager = NSFileManager.defaultManager()
        if let URL = manager.URLForDirectory(.ApplicationScriptsDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false, error: nil) {
            return URL.URLByAppendingPathComponent("\(self.fileName).scpt")
        }
        return nil
    }
}

public extension Script {
    func execute(handler: Bool -> Void) {
        if let URL = self.destinationURL {
            var error: NSError?
            if let task = NSUserAppleScriptTask(URL: URL, error: &error) {
                task.executeWithCompletionHandler{ error in
                    assert(error == nil, "Failed to execute script \(error)")
                    handler(error == nil)
                }
            } else {
                assertionFailure("Failed to create task: \(error)")
                handler(false)
            }
        } else {
            assertionFailure("Script \(self) is not found in the destination folder")
            handler(false)
        }
    }
}

public struct ScriptManager {
    
    private static let DestinationURL: NSURL? = {
        return NSFileManager.defaultManager().URLForDirectory(.ApplicationScriptsDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true, error: nil)
    }()
    
    public func shouldInstallScripts() -> Bool {
        let bundle = NSBundle.mainBundle()
        if let URLs = bundle.URLsForResourcesWithExtension("scpt", subdirectory: "Scripts") as? [NSURL],
            destinationURL = ScriptManager.DestinationURL {
            let manager = NSFileManager.defaultManager()
            for URL in URLs {
                if let fileName = URL.lastPathComponent {
                    let destinationURL = destinationURL.URLByAppendingPathComponent(fileName)
                    if let path = destinationURL.relativePath {
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
    
    public func installScripts(completion: Bool -> Void) {
        if let scriptsFolderURL = NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.ApplicationScriptsDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: true, error: nil) {
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
                        let manager = NSFileManager.defaultManager()
                        let scripts: [Script] = [.Copy, .Paste]
                        for script in scripts {
                            if let URL = script.destinationURL, path = URL.relativePath {
                                // remove existent
                                if manager.fileExistsAtPath(path) {
                                    var error: NSError?
                                    let result = manager.removeItemAtPath(path, error: &error)
                                    assert(result, "Failed to remove file: \(error)")
                                }
                                // copy bundled
                                var error: NSError?
                                let result = manager.copyItemAtURL(script.bundledURL, toURL: URL, error: &error)
                                assert(result, "Failed to copy file: \(error)")
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