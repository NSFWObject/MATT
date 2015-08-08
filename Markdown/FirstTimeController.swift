//
//  FirstTimeController.swift
//  Markdown
//
//  Created by Sash Zats on 8/7/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import AppKit


struct FirstTimeController {
    
    static func executeIfNeeded(window: NSWindow, completion: Void -> Void) {
        if !shouldShowFirstTimeExperience() {
            return
        }
        execute(window, completion: completion)
    }
    
    // MARK: - Private
    
    private static func execute(window: NSWindow, completion: Void -> Void) {
        let alert = NSAlert()
        alert.messageText = "\(AppManager.shortName) is more fun when you don't need to remember to launch it."
        alert.informativeText = "Do you want to enable \(AppManager.shortName) to run automatically upon startup?"
        alert.addButtonWithTitle("Enable")
        alert.addButtonWithTitle("Cancel")
        alert.beginSheetModalForWindow(window) { results in
            if results == NSAlertFirstButtonReturn {
                // Enable
                println("Enable login item")
            }
            completion()
        }
    }
    
    private static func shouldShowFirstTimeExperience() -> Bool {
        if let currentVersion = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as? String {
            var preferncesController = PreferencesController()
            if let lastVersion = preferncesController.lastAppVersion {
                if lastVersion == currentVersion {
                    return false
                }
            }
            preferncesController.lastAppVersion = currentVersion
            return true
        } else {
            assertionFailure("Can't extract CFBundleShortVersionString from Info.plist \(NSBundle.mainBundle().infoDictionary)")
            return false
        }
    }
}
