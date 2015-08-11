//
//  PreferencesPresenter.swift
//  Markdown
//
//  Created by Sash Zats on 7/28/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import Foundation
import MASPreferences


public class PreferencesPresenter {
    private static var windowController: NSWindowController?
    private var windowController: NSWindowController?
    private var observer: AnyObject!
    
    public init() {
        setupNotificationObserver()
    }
    
    deinit {
        teardownNotificationObserver()
    }

    public func showPreferences(#shortcutManager: ShortcutManager, scriptManager: ScriptInstallationManager, styleController: StyleController, loginItemManager: LoginItemManager, firstTimeController: FirstTimeController) {
        if let controller = windowController {
            controller.showWindow(self)
        } else {
            if let storyboard = NSStoryboard(name: "Preferences", bundle: nil),
                general = storyboard.instantiateControllerWithIdentifier("General") as? GeneralPreferencesViewController {
                    general.shortcutManager = shortcutManager
                    general.scriptManager = scriptManager
                    general.styleController = styleController
                    general.loginItemManager = loginItemManager
                    general.firstTimeController = firstTimeController
                    let preferencesWindow = MASPreferencesWindowController(viewControllers: [general])
                    preferencesWindow.showWindow(self)
                    windowController = preferencesWindow
            }
        }
    }
    
    private func setupNotificationObserver() {
        let center = NSNotificationCenter.defaultCenter()
        observer = center.addObserverForName(NSWindowWillCloseNotification, object: nil, queue: nil) { [unowned self] notification in
            if self.windowController?.window == notification.object as? NSWindow {
                self.windowController = nil
            }
        }
    }
    
    private func teardownNotificationObserver() {
        let center = NSNotificationCenter.defaultCenter()
        center.removeObserver(observer)
    }
}
