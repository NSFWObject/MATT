//
//  StyleManager.swift
//  Markdown
//
//  Created by Sash Zats on 7/28/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import AppKit
import Mustache


public struct AppStyle {
    public let bundleId: String
    public let name: String
    public let icon: NSImage
    
    public let styleName: String
}


public class StyleManager {
    
    private static let DefaultStyleNameKey = "MATTDefaultStyleName"
    private static let AssociatedAppStylesKey = "MATTAssociatedAppStylesKey"
    
    private static let DefaultStyleName = "DefaultStyleName"
    
    public var defaultStyleName: String = StyleManager.DefaultStyleName
    private(set) public var appStyles: Set<AppStyle> = []
    
    
    // MARK: Public
    
    public func load(userDefaults: NSUserDefaults, completion: Void -> Void) {
        defaultStyleName = userDefaults.objectForKey(StyleManager.DefaultStyleNameKey) as? String ?? StyleManager.DefaultStyleName
        if let mapping = userDefaults.objectForKey(StyleManager.AssociatedAppStylesKey) as? [String: String] {
            appStylesFromMapping(mapping){ [unowned self] appStyles in
                self.appStyles = appStyles
                completion()
            }
        } else {
            self.appStyles = []
            completion()
        }
    }
    
    public func save(userDefaults: NSUserDefaults) {
        userDefaults.setObject(defaultStyleName, forKey: StyleManager.DefaultStyleNameKey)
        
        let bundleIdToStyle = mappingFromAppStyles(self.appStyles)
        userDefaults.setObject(bundleIdToStyle, forKey: StyleManager.AssociatedAppStylesKey)
    }
        
    public func cssContentsForBundleId(bundleId: String?) -> String {
        let styleName = styleNameForBundleId(bundleId)
        if let URL = NSBundle.mainBundle().URLForResource(styleName, withExtension: "css", subdirectory: "CSS"),
            cssContents = String(contentsOfURL: URL, encoding: NSUTF8StringEncoding, error: nil) {
                return cssContents
        }
        // default
        if let URL = NSBundle.mainBundle().URLForResource("GitHub2", withExtension: "css", subdirectory: "CSS"),
            contents = String(contentsOfURL: URL, encoding: NSUTF8StringEncoding, error: nil) {
                return contents
        }
        return ""
    }
    
    public func addAppStyle(appStyle: AppStyle) {
        appStyles.insert(appStyle)
    }
    
    // MARK: - Private

    private func styleNameForBundleId(bundleId: String?) -> String {
        if let bundleId = bundleId, appStyle = appStyle(bundleId: bundleId) {
            return appStyle.styleName
        }
        return defaultStyleName
    }

    private func appStyle(#bundleId: String) -> AppStyle? {
        for appStyle in appStyles {
            if appStyle.bundleId == bundleId {
                return appStyle
            }
        }
        return nil
    }
    
    
    private func mappingFromAppStyles(appStyles: Set<AppStyle>) -> [String: String] {
        var mapping: [String: String] = [:]
        for appStyle in appStyles {
            mapping[appStyle.bundleId] = appStyle.styleName
        }
        return mapping
    }
    
    private func appStylesFromMapping(mapping: [String: String], completion: Set<AppStyle> -> Void) {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue) {
            let workspace = NSWorkspace.sharedWorkspace()
            var result: Set<AppStyle> = []
            for (bundleId, styleName) in mapping {
                if let path = workspace.absolutePathForAppBundleWithIdentifier(bundleId) {
                    let icon = workspace.iconForFile(path)
                    let name = path.lastPathComponent.stringByDeletingPathExtension // TODO: should use the key from the bundle
                    let appStyle = AppStyle(bundleId: bundleId, name: name, icon: icon, styleName: styleName)
                    result.insert(appStyle)
                }
            }
            dispatch_async(dispatch_get_main_queue()) {
                completion(result)
            }
        }
    }
}

extension AppStyle: Hashable {
    public var hashValue: Int {
        return bundleId.hashValue ^ styleName.hashValue
    }
}

public func ==(lhs: AppStyle, rhs: AppStyle) -> Bool {
    return lhs.bundleId == rhs.bundleId && lhs.styleName == rhs.styleName
}

extension AppStyle: Printable {
    public var description: String {
        return "<AppStyle:xxx> {bundleId=\"\(bundleId)\"; styleName=\"\(styleName)\"}"
    }
}