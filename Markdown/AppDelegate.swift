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
    
    let appManager = AppManager()
    let shortcutManager = ShortcutManager()
    let scriptManager = ScriptManager()

    private var windowController: NSWindowController!
    
    // MARK: - Actions

    @IBAction func showMainWindowMenuAction(sender: NSMenuItem) {
        if let window = NSApplication.sharedApplication().keyWindow {
            window.makeKeyAndOrderFront(self)
        } else {
            createNewWindow()
        }
    }
    
    private func createNewWindow() {
        if let storyboard = NSStoryboard(name: "Main", bundle: nil),
            controller = storyboard.instantiateInitialController() as? WindowController {
                controller.showWindow(self)
                configureController(controller)
        }
    }
    
    @IBAction func preferencesMenuAction(sender: AnyObject) {
        PreferencesViewManager.showPreferences(shortcutManager: shortcutManager, scriptManager: scriptManager)
    }
    
    private func toggleAppVisibility() {
        
        if let activeApp = appManager.activeApp() {
            if activeApp.bundleIdentifier == NSBundle.mainBundle().bundleIdentifier {
                if !self.windowController.window!.visible {
                    createNewWindow()
                } else {
                    appManager.hideMe()
                }
            } else {
                appManager.activateMeCapturingActiveApp()
                if !self.windowController.window!.visible {
                    createNewWindow()
                }
            }
        } else {
            appManager.activateMeCapturingActiveApp()
            if !self.windowController.window!.visible {
                createNewWindow()
            }
        }
    }

    // MARK: - Private
    
    private func configureController(controller: WindowController) {
        windowController = controller
        controller.appManager = appManager
        if let controller = controller.contentViewController as? ViewController {
            controller.shortcutManager = shortcutManager
            controller.appManager = appManager
        }
    }
    
    private func setupGlobalShortcuts() {
        let defaults = NSUserDefaults.standardUserDefaults()
        shortcutManager.load(defaults: defaults)
        shortcutManager.appVisibilityHandler = toggleAppVisibility
    }

    private func setupInitialController() {
        for window in NSApplication.sharedApplication().windows as! [NSWindow] {
            if let controller = window.windowController() as? WindowController {
                configureController(controller)
            }
        }
    }
    
    // MARK: NSApplicationDelegate
    
    func applicationDidFinishLaunching(notification: NSNotification) {
        setupInitialController()
        setupGlobalShortcuts()
    }
}

