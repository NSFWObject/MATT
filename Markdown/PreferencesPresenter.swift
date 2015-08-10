//
//  PreferencesPresenter.swift
//  Markdown
//
//  Created by Sash Zats on 7/28/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import Foundation
import MASPreferences


class PreferencesPresenter {
    private static var windowController: NSWindowController?
    
    static func showPreferences(#shortcutManager: ShortcutManager, scriptManager: ScriptManager, loginItemManager: LoginItemManager) {
        
        if let controller = windowController {
            controller.showWindow(self)
        } else {
            if let storyboard = NSStoryboard(name: "Preferences", bundle: nil),
                general = storyboard.instantiateControllerWithIdentifier("General") as? GeneralPreferencesViewController {
                    general.shortcutManager = shortcutManager
                    general.scriptManager = scriptManager
                    general.loginItemManager = loginItemManager
                    let preferencesWindow = MASPreferencesWindowController(viewControllers: [general])
                    preferencesWindow.showWindow(self)
                    windowController = preferencesWindow
            }
        }
    }
}
