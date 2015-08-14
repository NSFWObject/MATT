//
//  AppDelegate.swift
//  Markdown
//
//  Created by Sash Zats on 7/21/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import AppKit
import MASShortcut


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let appController = AppController()
    let firstTimeController = FirstTimeController()
    let focusManager = AppFocusController()
    let loginItemManager = LoginItemManager()
    let pasteboardController = PasteboardController()
    let preferencesController = PreferencesController()
    let scriptManager = ScriptInstallationManager()
    let shortcutManager = ShortcutManager()
    let styleController = StyleController()
    let preferencesPresenter = PreferencesPresenter()
    
    private var windowController: NSWindowController?
    
    // MARK: - Actions

    @IBAction func showMainWindowMenuAction(sender: NSMenuItem) {
        if let window = NSApplication.sharedApplication().keyWindow {
            window.makeKeyAndOrderFront(self)
        } else {
            createNewWindow()
        }
    }
    
    private func createNewWindow() {
        assert(windowController == nil, "Existent window detected!")
        if let storyboard = NSStoryboard(name: "Main", bundle: nil),
            controller = storyboard.instantiateInitialController() as? WindowController {
                controller.showWindow(self)
                configureController(controller)
        }
    }
    
    @IBAction func preferencesMenuAction(sender: AnyObject) {
        showPreferences()
    }
    
    private func showPreferences() {
        preferencesPresenter.showPreferences(
            shortcutManager: shortcutManager,
            scriptManager: scriptManager,
            styleController: styleController,
            loginItemManager: loginItemManager,
            firstTimeController: firstTimeController)
    }
    
    private func toggleAppVisibility(shortcut: MASShortcut) {
        if let activeApp = focusManager.activeApp() {
            if activeApp.bundleIdentifier == AppIdentity.bundleId {
                if windowController == nil {
                    createNewWindow()
                } else {
                    focusManager.hideMe()
                }
            } else {
                if windowController == nil {
                    createNewWindow()
                }
                focusManager.showMe()
            }
        } else {
            if windowController == nil {
                createNewWindow()
            }
            focusManager.showMe()
        }
    }
    
    // MARK: - Private
    
    private func configureController(controller: WindowController) {
        windowController = controller
        if let controller = controller.contentViewController as? ViewController {
            controller.focusController = focusManager
            controller.appController = appController
            controller.presentPreferences = showPreferences
            controller.shortcutManager = shortcutManager
        }
    }
    
    private func setupGlobalShortcuts() {
        let defaults = NSUserDefaults.standardUserDefaults()
        shortcutManager.load(defaults: defaults)
        shortcutManager.registerHandler(toggleAppVisibility, forType: .ToggleAppVisibility)
    }

    private func setupInitialController() {
        for window in NSApplication.sharedApplication().windows as! [NSWindow] {
            if let controller = window.windowController() as? WindowController {
                configureController(controller)
            }
        }
    }
    
    private func setupWindowCloseNotification() {
        let center = NSNotificationCenter.defaultCenter()
        center.addObserverForName(NSWindowWillCloseNotification, object: nil, queue: NSOperationQueue.mainQueue()) { notification in
            if self.windowController?.window == notification.object as? NSWindow {
                self.windowController = nil
            }
        }
    }
    
    private func runFirstTimeExperienceIfNeeded() {
        firstTimeController.preferncesController = preferencesController
        firstTimeController.executeIfNeeded{ [unowned self] in
            self.showPreferences()
        }
    }
    
    private func setupResettables() {
        let resettables: [ResettablePreferences] = [shortcutManager, scriptManager, loginItemManager, preferencesController]
        if NSEvent.modifierFlags() & .AlternateKeyMask == .AlternateKeyMask {
            resetResettables(resettables)
        }
    }
    
    private func resetResettables(resettables: [ResettablePreferences]) {
        let defaults = NSUserDefaults.standardUserDefaults()
        for resettable in resettables {
            resettable.reset(defaults)
        }
    }
    
    private func setupDependancies() {
        appController.pasteboardController = pasteboardController
        appController.styleManager = styleController
        appController.focusController = focusManager
        
        firstTimeController.scriptManager = scriptManager
    }
    
    // MARK: NSApplicationDelegate
    
    func applicationDidFinishLaunching(notification: NSNotification) {
        setupDependancies()
        setupResettables()
        setupWindowCloseNotification()
        setupInitialController()
        setupGlobalShortcuts()
        runFirstTimeExperienceIfNeeded()
    }
    
    func applicationDidBecomeActive(notification: NSNotification) {
        if windowController == nil {
            createNewWindow()
        }
    }
    
    func applicationShouldHandleReopen(sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            createNewWindow()
        }
        return true
    }
    
    // TODO: for now we terminate application when the last window is closed, but actually infrastructure is in place to recreate window if app stays alive
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }
}

