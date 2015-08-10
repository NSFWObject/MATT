//
//  PreferencesController.swift
//  Markdown
//
//  Created by Sash Zats on 8/6/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import Foundation



public class PreferencesController {
    private let defaults = NSUserDefaults.standardUserDefaults()
    private static let StyleNameKey = "MATTStyleName"
    private static let LastAppVersionKey = "MATTLastAppVersion"
        
    public var styleName: String? {
        get {
            return defaults.objectForKey(PreferencesController.StyleNameKey)
        }
        set {
            defaults.setObject(newValue, forKey: PreferencesController.StyleNameKey)
        }
    }
    
    public var lastAppVersion: String? {
        get {
            return defaults.objectForKey(PreferencesController.LastAppVersionKey)
        }
        set {
            defaults.setObject(newValue, forKey: PreferencesController.LastAppVersionKey)
        }
    }
    
    public func save() {
        defaults.synchronize()
    }
}

private extension NSUserDefaults {
    func objectForKey<T>(key: String) -> T? {
        if let object = objectForKey(key) as? T {
            return object
        }
        return nil
    }
}
