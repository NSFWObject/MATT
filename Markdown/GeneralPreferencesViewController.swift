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
    var scriptManager: ScriptInstallationManager!
    var styleController: StyleController!
    var loginItemManager: LoginItemManager!
    var firstTimeController: FirstTimeController!
    
    @IBOutlet weak var explanationHeightConstraint: NSLayoutConstraint!
    
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
    @IBOutlet weak var warningContainerView: NSView!
    @IBOutlet weak var warningTextField: NSTextField!
    
    // MARK: - Action
    
    private func scriptUpdateHandler() {
        updateUI()
    }
    
    // MARK: - Private
    
    private func setupFirstTimeWarning() {
        warningContainerView.wantsLayer = true
        if let layer = warningContainerView.layer {
            layer.backgroundColor = NSColor(red:0.2, green:0.2, blue:0.2, alpha:1).CGColor
        }
        updateUI()
    }
    
    private func updateUI() {
        if !firstTimeController.shouldShowFirstTimeExperience() {
            if let textField = warningTextField {
                textField.removeFromSuperview()
            }
        }
    }
    
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
        
        setupFirstTimeWarning()
        
        stylePreferencesController = StylePreferencesController(styleController: styleController, popupButton: stylePopupButton)
        loginItemPreferencesController = LoginItemPreferencesController(loginItemManager: loginItemManager, loginItemCheckbox: loginItemCheckbox)
        scriptPreferencesController = ScriptPreferencesController(installScriptButton: installScriptButton, scriptManager: scriptManager, updateHandler: scriptUpdateHandler)
        shortcutPreferencesController = ShortcutPreferencesController(shortcutView: shortcutView, shortcutManager: shortcutManager)
    }
}

