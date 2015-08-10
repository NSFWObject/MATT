//
//  FirstTimeController.swift
//  Markdown
//
//  Created by Sash Zats on 8/7/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import AppKit


public class FirstTimeController {
    
    private let preferncesController = PreferencesController()
    
    public func executeIfNeeded(block: Void -> Void) {
        if shouldShowFirstTimeExperience() {
            block()
            finish()
        }
    }

    public func finish() {
        preferncesController.lastAppVersion = AppIdentity.marketingVersion
    }
    
    // MARK: - Private

    public func shouldShowFirstTimeExperience() -> Bool {
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
