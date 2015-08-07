//
//  AppDelegate.swift
//  Markdown
//
//  Created by Sash Zats on 7/21/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let shortcutManager = ShortcutManager()
    let scriptManager = ScriptManager()

    private var windowController: NSWindowController?
    
    // MARK: - Actions

    @IBAction func showMainWindowMenuAction(sender: NSMenuItem) {
        if NSApplication.sharedApplication().keyWindow == nil {
            if let storyboard = NSStoryboard(name: "Main", bundle: nil),
                controller = storyboard.instantiateInitialController() as? NSWindowController {
                    controller.showWindow(self)
                    windowController = controller
            }
        }
    }
    
    @IBAction func preferencesMenuAction(sender: AnyObject) {
        PreferencesViewManager.showPreferences(shortcutManager: shortcutManager, scriptManager: scriptManager)
    }
}

