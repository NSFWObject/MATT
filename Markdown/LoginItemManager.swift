//
//  LoginItemManager.swift
//  Markdown
//
//  Created by Sash Zats on 7/29/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import Foundation
import ServiceManagement


public struct LoginItemManager {
    private let HelperBundleId = "com.zats.MATT-Helper"
    
    public func isLoginItemEnabled() -> Bool {
        if let jobs = SMCopyAllJobDictionaries(kSMDomainUserLaunchd).takeRetainedValue() as? [[String: AnyObject]] {
            for job in jobs {
                if let bundleId = job["Label"] as? String,
                    onDemand = job["OnDemand"] as? NSNumber {
                        if bundleId == HelperBundleId && onDemand.boolValue {
                            return true
                        }
                }
            }
        }
        return false
    }
    
    public func setLoginItemsEnabled(enabled: Bool) -> Bool {
        return SMLoginItemSetEnabled(HelperBundleId as CFStringRef, Boolean(booleanLiteral: enabled)).boolValue
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