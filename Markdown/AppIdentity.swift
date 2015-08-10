//
// Created by Sash Zats on 8/8/15.
// Copyright (c) 2015 Sash Zats. All rights reserved.
//

import Foundation

struct AppIdentity {
    static let bundleId = NSBundle.mainBundle().bundleIdentifier!
    
    static let marketingVersion = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
    static let buildVersion = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion") as! String

    static let displayName = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleDisplayName") as! String
    static let shortName = "MATT"
}
