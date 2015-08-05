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
    public typealias ShortcutHandler = (Void -> Void)?

    private let monitor = MASShortcutMonitor.sharedMonitor()
    public var appVisibilityHandler: ShortcutHandler
    public var processMarkdownHandler: ShortcutHandler
    
    private struct ShortcutWithHandler {
        private let shortcut: MASShortcut?
        private let handler: ShortcutHandler
    }
    
    private var storage: [ShortcutType: MASShortcut] = [:]
    
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
                    fn()
                }
                
            }
        }
    }
    
    public func shortcutForType(type: ShortcutType) -> MASShortcut? {
        return storage[type]
    }
    
    // MARK: - Private
    
    private func shortcutHandlerForType(type: ShortcutType) -> ShortcutHandler {
        switch type {
        case .ToggleAppVisibility:
            return appVisibilityHandler
        case .ProcessSelectedMarkdown:
            return processMarkdownHandler
        }
    }
}

extension ShortcutManager: NSCoding {
    @objc convenience public init(coder aDecoder: NSCoder) {
        self.init()
        storage[ShortcutType.ToggleAppVisibility] = aDecoder.decodeObjectForKey(ShortcutType.ToggleAppVisibility.rawValue) as? MASShortcut
        storage[ShortcutType.ProcessSelectedMarkdown] = aDecoder.decodeObjectForKey(ShortcutType.ProcessSelectedMarkdown.rawValue) as? MASShortcut
    }
    
    @objc public func encodeWithCoder(aCoder: NSCoder) {
        if let shortcut = storage[ShortcutType.ToggleAppVisibility] {
            aCoder.encodeObject(shortcut, forKey: ShortcutType.ToggleAppVisibility.rawValue)
        }
        if let shortcut = storage[ShortcutType.ProcessSelectedMarkdown] {
            aCoder.encodeObject(shortcut, forKey: ShortcutType.ProcessSelectedMarkdown.rawValue)
        }
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
    }
}