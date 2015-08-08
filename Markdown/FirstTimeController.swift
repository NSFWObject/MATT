//
//  FirstTimeController.swift
//  Markdown
//
//  Created by Sash Zats on 8/7/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import AppKit


class FirstTimeController {
    
    private static let preferncesController = PreferencesController()
    
    static func executeIfNeeded(presenter: NSViewController, completion: Void -> Void) {
        if !shouldShowFirstTimeExperience() {
            return
        }
        execute(presenter, completion: completion)
    }
    
    static func finish() {
        if let currentVersion = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as? String {
            preferncesController.lastAppVersion = currentVersion
        } else {
            assertionFailure("Can't extract CFBundleShortVersionString from Info.plist \(NSBundle.mainBundle().infoDictionary)")
        }
    }
    
    // MARK: - Private
    
    private static func execute(presenter: NSViewController, completion: Void -> Void) {
        if let storyboard = NSStoryboard(name: "Main", bundle: nil),
            controller = storyboard.instantiateControllerWithIdentifier("Intro") as? IntroViewController {
                presenter.presentViewControllerAsSheet(controller)
        }
//        let alert = NSAlert()
//        alert.messageText = "\(AppManager.shortName) is more fun when you don't need to remember to launch it."
//        alert.informativeText = "Do you want to enable \(AppManager.shortName) to run automatically upon startup?"
//        alert.addButtonWithTitle("Enable")
//        alert.addButtonWithTitle("Cancel")
//        alert.beginSheetModalForWindow(window) { results in
//            if results == NSAlertFirstButtonReturn {
//                // Enable
//                println("Enable login item")
//            }
//            completion()
//        }
    }
    
    private static func shouldShowFirstTimeExperience() -> Bool {
        if let currentVersion = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as? String {
            if let lastVersion = preferncesController.lastAppVersion {
                if lastVersion == currentVersion {
                    return false
                }
            }
            return true
        } else {
            assertionFailure("Can't extract CFBundleShortVersionString from Info.plist \(NSBundle.mainBundle().infoDictionary)")
            return false
        }
    }
}
