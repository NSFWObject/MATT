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
    @IBOutlet weak var shortcutView: MASShortcutView!
    var hotkeyManager: HotkeyManager? {
        didSet{
            setupShortcutView()
        }
    }
    
    // MARK: - Actions
    
    private func shortcutValueDidChange(shortcutView: MASShortcutView!) {
        if let shortcut = shortcutView.shortcutValue, manager = hotkeyManager {
            manager.registerHotkey(shortcut)
        }
    }
    
    
    // MARK: - Private
    
    private func setupShortcutView() {
        if let manager = hotkeyManager {
            if self.viewLoaded {
                if let shortcut = manager.shortcut {
                    shortcutView.shortcutValue = shortcut
                }
                shortcutView.shortcutValueChange = shortcutValueDidChange
            }
        }
    }
    
    // MARK: - NSViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupShortcutView()
    }
    
    // MARK: - MASPreferencesViewController
    
    var toolbarItemImage: NSImage! {
        // TODO: replace me
        return NSImage(named: NSImageNameAdvanced)
    }
    
    var toolbarItemLabel: String! {
        return "General"
    }

}

