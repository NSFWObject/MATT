//
//  ScriptManager.swift
//  Markdown
//
//  Created by Sash Zats on 7/29/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import AppKit

public struct ScriptManager {
    private static let ScriptFilename: String = "PasteboardHelper.scpt"
    
    private func originalScriptURL() -> NSURL {
        return NSBundle.mainBundle().URLForResource(ScriptManager.ScriptFilename.stringByDeletingPathExtension, withExtension: ScriptManager.ScriptFilename.pathExtension)!
    }
    
    private func destinationScriptURL() -> NSURL? {
        if let appScriptURL = NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.ApplicationScriptsDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: true, error: nil) {
            return appScriptURL.URLByAppendingPathComponent(ScriptManager.ScriptFilename)
        }
        return nil
    }
    
    public func shouldInstallScriptFile() -> Bool {
        if let URL = destinationScriptURL() {
            let manager = NSFileManager.defaultManager()
            if !manager.fileExistsAtPath(URL.relativePath!) {
                return true
            }
            if let destinationModificationDate = (manager.attributesOfItemAtPath(URL.relativePath!, error: nil) as? NSDictionary)?.fileModificationDate(),
                sourceModificationDate = (manager.attributesOfItemAtPath(originalScriptURL().relativePath!, error: nil) as? NSDictionary)?.fileModificationDate() {
                    return sourceModificationDate.compare(destinationModificationDate) == .OrderedDescending
            }

        }
        return false
    }
    
    public func executeScript(completion: Bool -> Void) {
        if let scriptURL = self.destinationScriptURL(), task = NSUserAppleScriptTask(URL: scriptURL, error: nil) {
            task.executeWithCompletionHandler{ error in
                completion(error == nil)
                assert(error == nil, "Failed to execute script: \(error)")
            }
        } else {
            completion(false)
            assertionFailure("No script or no task")
        }
    }
    
    public func isScriptInstalled() -> Bool {
        if let scriptURL = destinationScriptURL() {
            var isDirectory: ObjCBool = false
            return NSFileManager.defaultManager().fileExistsAtPath(scriptURL.relativePath!, isDirectory: &isDirectory) && !isDirectory
        }
        return false
    }
    
    public enum PromptResult {
        case Cancel, Install, ShowScript
    }
    
    public func installScript(completion: Bool -> Void) {
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
                        let fileManager = NSFileManager.defaultManager()
                        let destinationURL = selectedURL.URLByAppendingPathComponent(ScriptManager.ScriptFilename)
                        let sourceURL = self.originalScriptURL()
                        var error: NSError?
                        if fileManager.fileExistsAtPath(destinationURL.relativePath!) {
                            if !fileManager.removeItemAtURL(destinationURL, error: &error) {
                                assertionFailure("Failed to remove file: \(error)")
                                completion(false)
                                return
                            }
                        }
                        if fileManager.copyItemAtURL(sourceURL, toURL: destinationURL, error: &error) {
                            completion(true)
                            return
                        } else {
                            assertionFailure("Failed to copy file \(error)")
                        }
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