//
//  ShortcutPreferencesViewController.swift
//  Markdown
//
//  Created by Sash Zats on 7/29/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import Foundation
import MASShortcut


class ShortcutPreferencesController: NSObject {
    
    let shortcutManager: ShortcutManager
    let shortcutView: MASShortcutView
    
    init(shortcutView: MASShortcutView, shortcutManager: ShortcutManager) {
        self.shortcutManager = shortcutManager
        self.shortcutView = shortcutView
        super.init()
        setupView()
    }
    
    private func setupView() {
        shortcutView.style = MASShortcutViewStyleTexturedRect

        let defaults = NSUserDefaults.standardUserDefaults()
        shortcutManager.load(defaults: defaults)
        shortcutView.shortcutValue = shortcutManager.shortcutForType(.ToggleAppVisibility)
        shortcutView.shortcutValidator.allowAnyShortcutWithOptionModifier = true
        
        shortcutView.shortcutValueChange = shortcutValueDidChange
    }
    
    private func shortcutValueDidChange(shortcutView: MASShortcutView!) {
        shortcutManager.registerShortcut(shortcutView.shortcutValue, type: .ToggleAppVisibility)
        let defaults = NSUserDefaults.standardUserDefaults()
        shortcutManager.save(defaults: defaults)
    }
}
