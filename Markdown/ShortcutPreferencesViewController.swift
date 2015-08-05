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
            shortcutView.shortcutValue = shortcutManager.shortcutForType(.ToggleAppVisibility)
            shortcutView.shortcutValidator.allowAnyShortcutWithOptionModifier = true
            shortcutView.shortcutValueChange = shortcutValueDidChange
        }
    }
    
    private func shortcutValueDidChange(shortcutView: MASShortcutView!) {
        shortcutManager.registerShortcut(shortcutView.shortcutValue, type: .ToggleAppVisibility)
        let defaults = NSUserDefaults.standardUserDefaults()
        shortcutManager.save(defaults: defaults)
        defaults.synchronize()
    }
}
