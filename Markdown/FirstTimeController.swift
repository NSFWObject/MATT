//
//  FirstTimeController.swift
//  Markdown
//
//  Created by Sash Zats on 8/7/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import AppKit


public class FirstTimeController {
    
    public var preferncesController: PreferencesController!
    public var scriptManager: ScriptInstallationManager!
    
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
        if scriptManager.shouldInstallScripts() {
            return true
        }
        
        if let lastVersion = preferncesController.lastAppVersion {
            if lastVersion == AppIdentity.marketingVersion {
                return false
            }
        }
        
        return true
    }
}
