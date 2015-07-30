//
//  HotkeyManager.swift
//  Markdown
//
//  Created by Sash Zats on 7/27/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import Foundation
import MASShortcut


public class HotkeyManager {
    
    private let ShortcutKey = "com.zats.MATT.shortcut"
    
    private let manager = MASShortcutMonitor.sharedMonitor()
    private(set) public var shortcut: MASShortcut?
    
    public var handler: (Void -> Void)?
    
    public func registerHotkey(keyCode: UInt = UInt(kVK_ANSI_D), modifier: NSEventModifierFlags = NSEventModifierFlags.AlternateKeyMask) {
        let shortcut: MASShortcut = MASShortcut(keyCode: keyCode, modifierFlags: modifier.rawValue)
        registerHotkey(shortcut)
    }
    
    public func registerHotkey(shortcut: MASShortcut) {
        self.shortcut = shortcut
        manager.unregisterAllShortcuts()
        manager.registerShortcut(shortcut) {
            if let handler = self.handler {
                handler()
            }
        }
    }
    
    public func save() {
        if let shortcut = shortcut {
            let data = NSMutableData()
            let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
            archiver.encodeObject(shortcut)
            archiver.finishEncoding()
            NSUserDefaults.standardUserDefaults().setObject(data, forKey: ShortcutKey)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    public func load() {
        if let shortcutData = NSUserDefaults.standardUserDefaults().objectForKey(ShortcutKey) as? NSData {
            let unarchiver = NSKeyedUnarchiver(forReadingWithData: shortcutData)
            if let shortcut = unarchiver.decodeObject() as? MASShortcut {
                registerHotkey(shortcut)
            }
        }
    }
}