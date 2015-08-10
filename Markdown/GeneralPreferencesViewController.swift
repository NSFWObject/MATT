//
//  PreferencesViewController.swift
//  Markdown
//
//  Created by Sash Zats on 7/28/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import AppKit
import MASPreferences
import MASShortcut

class GeneralPreferencesViewController: NSViewController, MASPreferencesViewController {
    
    var shortcutManager: ShortcutManager!
    var scriptManager: ScriptManager!
    var styleController: StyleController!
    var loginItemManager: LoginItemManager!

    // Section controllers
    var stylePreferencesController: StylePreferencesController!
    var loginItemPreferencesController: LoginItemPreferencesController!
    var scriptPreferencesController: ScriptPreferencesController!
    var shortcutPreferencesController: ShortcutPreferencesController!

    // UI
    @IBOutlet weak var stylePopupButton: NSPopUpButton!
    @IBOutlet weak var loginItemCheckbox: NSButton!
    @IBOutlet weak var installScriptButton: NSButton!
    @IBOutlet weak var shortcutView: MASShortcutView!
    
    // MARK: - MASPreferencesViewController
    
    var toolbarItemImage: NSImage! {
        // TODO: replace me
        return NSImage(named: NSImageNameAdvanced)
    }
    
    var toolbarItemLabel: String! {
        return "General"
    }
    
    // MARK: - NSViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleController = StyleController()
        self.stylePreferencesController = StylePreferencesController(styleController: styleController, popupButton: stylePopupButton)
        self.loginItemPreferencesController = LoginItemPreferencesController(loginItemManager: loginItemManager, loginItemCheckbox: loginItemCheckbox)
        self.scriptPreferencesController = ScriptPreferencesController(installScriptButton: installScriptButton, scriptManager: scriptManager)
        self.shortcutPreferencesController = ShortcutPreferencesController(shortcutView: shortcutView, shortcutManager: shortcutManager)
    }
}

