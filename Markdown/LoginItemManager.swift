//
//  LoginItemManager.swift
//  Markdown
//
//  Created by Sash Zats on 7/29/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import Foundation
import ServiceManagement


public class LoginItemManager {
    private static let HelperBundleId = "com.zats.MATT-Helper"
    
    public var loginItemsEnabled: Bool {
        set {
            SMLoginItemSetEnabled(LoginItemManager.HelperBundleId as CFStringRef, Boolean(booleanLiteral: newValue))
        }
        get {
            if let jobs = SMCopyAllJobDictionaries(kSMDomainUserLaunchd).takeRetainedValue() as? [[String: AnyObject]] {
                for job in jobs {
                    if let bundleId = job["Label"] as? String,
                        onDemand = job["OnDemand"] as? NSNumber {
                            if bundleId == LoginItemManager.HelperBundleId && onDemand.boolValue {
                                return true
                            }
                    }
                }
            }
            return false
        }
    }
}

extension LoginItemManager: ResettablePreferences {

    // MARK: - ResettablePreferences
    
    func reset(storage: NSUserDefaults) {
        self.loginItemsEnabled = false
    }
}

extension Boolean: BooleanLiteralConvertible, BooleanType {
    public init(booleanLiteral value: BooleanLiteralType) {
        self.init(value ? 1 : 0)
    }
    
    public var boolValue: Bool {
        return self == 1
    }
}
