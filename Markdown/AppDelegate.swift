//
//  AppDelegate.swift
//  Markdown
//
//  Created by Sash Zats on 7/21/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import AppKit


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let appController = AppController()
    let focusManager = AppFocusController()
    let shortcutManager = ShortcutManager()
    let scriptManager = ScriptInstallationManager()
    let loginItemManager = LoginItemManager()
    let firstTimerExperience = FirstTimeController()
    let preferencesController = PreferencesController()
    var resettablePreferences: [ResettablePreferences]!

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
        if let storyboard = NSStoryboard(name: "Main", bundle: nil),
            controller = storyboard.instantiateInitialController() as? WindowController {
                controller.showWindow(self)
                configureController(controller)
        }
    }
    
    @IBAction func preferencesMenuAction(sender: AnyObject) {
        PreferencesPresenter.showPreferences(shortcutManager: shortcutManager, scriptManager: scriptManager, loginItemManager: loginItemManager)
    }
    
    private func toggleAppVisibility() {
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
        controller.focusManager = focusManager
        if let controller = controller.contentViewController as? ViewController {
            controller.appController = appController
            controller.shortcutManager = shortcutManager
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
    
    private func setupWindowCloseNotification() {
        let center = NSNotificationCenter.defaultCenter()
        center.addObserverForName(NSWindowWillCloseNotification, object: nil, queue: NSOperationQueue.mainQueue()) { notification in
            if self.windowController?.window == notification.object as? NSWindow {
                self.windowController = nil
            }
        }
    }
    
    private func firstTimeExperience() {
        firstTimerExperience.preferncesController = preferencesController
        firstTimerExperience.executeIfNeeded{
            PreferencesPresenter.showPreferences(
                shortcutManager: self.shortcutManager,
                scriptManager: self.scriptManager,
                loginItemManager: self.loginItemManager)
        }
    }
    
    private func setupResettables() {
        resettablePreferences = [shortcutManager, scriptManager, loginItemManager, preferencesController]
        if let arguments = NSProcessInfo.processInfo().arguments as? [String] {
            if find(arguments, "RESETT") != nil {
                resetResettables()
            }
        }
    }
    
    private func resetResettables() {
        let defaults = NSUserDefaults.standardUserDefaults()
        for resettable in resettablePreferences {
            resettable.reset(defaults)
        }

    }
    
    // MARK: NSApplicationDelegate
    
    func applicationDidFinishLaunching(notification: NSNotification) {
        setupResettables()
        setupWindowCloseNotification()
        setupInitialController()
        setupGlobalShortcuts()
        firstTimeExperience()
    }
    
    func applicationDidBecomeActive(notification: NSNotification) {
        if windowController == nil {
            createNewWindow()
        }
    }
}

