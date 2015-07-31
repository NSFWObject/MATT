//
//  PreferencesViewController.swift
//  Markdown
//
//  Created by Sash Zats on 7/28/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import AppKit
import MASPreferences


class GeneralPreferencesViewController: NSViewController, MASPreferencesViewController {
    
    var shortcutManager: HotkeyManager!
    
    var shortcutViewController: ShortcutPreferencesViewController! {
        didSet {
            shortcutViewController.shortcutManager = shortcutManager
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
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "LoginItem":
                break
            case "Script":
                break
            case "Shortcut":
                self.shortcutViewController = segue.destinationController as! ShortcutPreferencesViewController
            default:
                break
            }
        }
    }
}

