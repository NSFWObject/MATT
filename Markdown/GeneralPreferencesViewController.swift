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
    
    // MARK: - MASPreferencesViewController
    
    var toolbarItemImage: NSImage! {
        // TODO: replace me
        return NSImage(named: NSImageNameAdvanced)
    }
    
    var toolbarItemLabel: String! {
        return "General"
    }

}

