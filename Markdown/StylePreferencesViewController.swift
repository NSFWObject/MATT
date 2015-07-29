//
//  StylePreferencesViewController.swift
//  Markdown
//
//  Created by Sash Zats on 7/28/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import AppKit
import MASPreferences

class StylePreferencesViewController: NSViewController, MASPreferencesViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    // MARK: - NSTableViewDataSource
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return 10
    }
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        return NSAttributedString(string: "Hello")
    }
    
    // MARK: - MASPreferencesViewController
    
    var toolbarItemImage: NSImage! {
        // TODO: replace me
        return NSImage(named: NSImageNameColorPanel)
    }
    
    var toolbarItemLabel: String! {
        return "Styles"
    }

}