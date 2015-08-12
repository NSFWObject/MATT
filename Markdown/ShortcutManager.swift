//
//  ShortcutManager.swift
//  Markdown
//
//  Created by Sash Zats on 7/27/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import Foundation
import MASShortcut


public enum ShortcutType: String {
    case ToggleAppVisibility = "MATTGlobalShortcut"
    case ProcessSelectedMarkdown = "MATTProcessMarkdownShortcut"
}



public final class ShortcutManager: NSObject {
    public typealias Handler = MASShortcut -> Void
    private let monitor = MASShortcutMonitor.sharedMonitor()
    private var storage: [ShortcutType: MASShortcut] = [:]
    private var handlers: [ShortcutType: Handler] = [:]
    
    public override required init() {
    }
            
    public func registerShortcut(shortcut: MASShortcut?, type: ShortcutType) {
        if let shortcut = storage[type] {
            monitor.unregisterShortcut(shortcut)
        }
        if let shortcut = shortcut {
            storage[type] = shortcut
            monitor.registerShortcut(shortcut) {
                if let fn = self.shortcutHandlerForType(type) {
                    fn(shortcut)
                }
                
            }
        }
    }
    
    public func registerHandler(handler: Handler, forType type: ShortcutType) {
        handlers[type] = handler
    }
    
    public func shortcutForType(type: ShortcutType) -> MASShortcut? {
        return storage[type]
    }
    
    // MARK: - Private
    
    private func shortcutHandlerForType(type: ShortcutType) -> Handler? {
        return handlers[type]
    }
    
    private func registerDefaultShortcutsIfNeeded() {
        if shortcutForType(.ToggleAppVisibility) == nil {
            let shortcut = MASShortcut(keyCode: UInt(kVK_ANSI_D), modifierFlags: NSEventModifierFlags.AlternateKeyMask.rawValue)
            self.registerShortcut(shortcut, type: .ToggleAppVisibility)
        }
        if shortcutForType(.ProcessSelectedMarkdown) == nil {
            let shortcut = MASShortcut(keyCode: UInt(kVK_ANSI_M), modifierFlags: NSEventModifierFlags.AlternateKeyMask.rawValue)
            self.registerShortcut(shortcut, type: .ProcessSelectedMarkdown)
        }
    }
}

extension ShortcutManager: NSCoding {
    
    private static let ShortcutManagerKey = "MATT"
    
    public convenience init(coder aDecoder: NSCoder) {
        self.init()
        if let encodableStorage = aDecoder.decodeObjectForKey(ShortcutManager.ShortcutDataKey) as? [String: MASShortcut] {
            var storage: [ShortcutType: MASShortcut] = [:]
            for (typeString, shortcut) in encodableStorage {
                if let type = ShortcutType(rawValue: typeString) {
                    storage[type] = shortcut
                }
            }
            self.storage = storage
        }
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        var encodableStorage: [String: MASShortcut] = [:]
        for (type, shortcut) in storage {
            encodableStorage[type.rawValue] = shortcut
        }
        aCoder.encodeObject(encodableStorage, forKey: ShortcutManager.ShortcutDataKey)
    }

}

// MARK: - Persistance
extension ShortcutManager {
    
    private static let ShortcutDataKey = "MATTShortcutDataKey"

    public func save(#defaults: NSUserDefaults) {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(self)
        archiver.finishEncoding()
        defaults.setObject(data, forKey: ShortcutManager.ShortcutDataKey)
    }
    
    public func load(#defaults: NSUserDefaults) {
        if let data = defaults.objectForKey(ShortcutManager.ShortcutDataKey) as? NSData {
            let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
            if let manager = unarchiver.decodeObject() as? ShortcutManager {
                storage = manager.storage
                monitor.unregisterAllShortcuts()
                for (type, shortcut) in storage {
                    registerShortcut(shortcut, type: type)
                }
            }
        }
        registerDefaultShortcutsIfNeeded()
    }
}

// MARK: - ResettablePreferences

extension ShortcutManager: ResettablePreferences {
    func reset(defaults: NSUserDefaults) {
        defaults.removeObjectForKey(ShortcutManager.ShortcutDataKey)
    }
}
