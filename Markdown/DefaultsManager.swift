//
//  DefaultsManager.swift
//  Markdown
//
//  Created by Sash Zats on 8/4/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import Foundation

class DefaultsManager {
    
    private var defaults: NSUserDefaults
    
    init() {
        defaults = NSUserDefaults.standardUserDefaults()
    }
    
    func objectForKey<T>(key: String) -> T? {
        return defaults.objectForKey(key) as? T
    }
    
    func setObject<T: AnyObject>(obj: T, key: String) -> Void {
        defaults.setObject(obj, forKey: key)
    }
}

