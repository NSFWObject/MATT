//
//  ShortcutPreferencesViewController.swift
//  Markdown
//
//  Created by Sash Zats on 7/29/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import AppKit
import MASShortcut


class ShortcutPreferencesViewController: NSViewController {
    
    var shortcutManager: ShortcutManager!
    
    @IBOutlet weak var shortcutView: MASShortcutView! {
        didSet {
            shortcutView.style = MASShortcutViewStyleTexturedRect

            shortcutManager.load()
            shortcutView.shortcutValue = shortcutManager.shortcut
            
            shortcutView.shortcutValueChange = shortcutValueDidChange
        }
    }
    
    private func shortcutValueDidChange(shortcutView: MASShortcutView!) {
        shortcutManager.registerHotkey(shortcutView.shortcutValue)
        shortcutManager.save()
    }
}
