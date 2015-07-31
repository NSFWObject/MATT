//
//  PreferencesManager.swift
//  Markdown
//
//  Created by Sash Zats on 7/28/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import Foundation
import MASPreferences


struct PreferenceManager {
    private static var windowController: NSWindowController?
    
    static func showPreferences(shortcutManager: ShortcutManager) {
        if let storyboard = NSStoryboard(name: "Preferences", bundle: nil),
            general = storyboard.instantiateControllerWithIdentifier("General") as? GeneralPreferencesViewController,
            styles = storyboard.instantiateControllerWithIdentifier("Styles") as? StylePreferencesViewController {
                general.shortcutManager = shortcutManager
                let preferencesWindow = MASPreferencesWindowController(viewControllers: [general, styles])
                preferencesWindow.showWindow(nil)
                windowController = preferencesWindow
        }
        
    }
}
