//
//  ScriptManager.swift
//  Markdown
//
//  Created by Sash Zats on 7/29/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import AppKit

public struct ScriptManager {
    private let ScriptFilename = "PasteboardHelper.scpt"
    
    private func destinationScriptURL() -> NSURL? {
        if let appScriptURL = NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.ApplicationScriptsDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: true, error: nil) {
            return appScriptURL.URLByAppendingPathComponent(ScriptFilename)
        }
        return nil
    }
    
    public func isScriptInstalled() -> Bool {
        if let scriptURL = destinationScriptURL() {
            var isDirectory: ObjCBool = false
            return NSFileManager.defaultManager().fileExistsAtPath(scriptURL.relativePath!, isDirectory: &isDirectory) && !isDirectory
        }
        return false
    }
    
    /**
        Prompts user to install the script.
    
        :param: window target window to run alert in
        :param: completion handler called upon user finished interaction, will return one `Bool` parameter
        indicating whether user wants to proceed or not
     */
    public func promptScriptInstallation(window: NSWindow, completion: Bool -> Void) {
        let alert = NSAlert()
        alert.messageText = "We need to install an AppleScript to continue."
        alert.informativeText = "You will be prompted to select this app's personal folder storing scripts. Are you sure you want to continue?"
        alert.addButtonWithTitle("Install")
        alert.addButtonWithTitle("Cancel")
        alert.beginSheetModalForWindow(window){ response in
            if response == NSAlertFirstButtonReturn {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}