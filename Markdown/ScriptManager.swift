//
//  ScriptManager.swift
//  Markdown
//
//  Created by Sash Zats on 7/29/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import Foundation

struct ScriptManager {
    private let ScriptFilename = "PasteboardHelper.scpt"
    
    private func destinationScriptURL() -> NSURL? {
        if let appScriptURL = NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.ApplicationScriptsDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: true, error: nil) {
            return appScriptURL.URLByAppendingPathComponent(ScriptFilename)
        }
        return nil
    }
    
    func isScriptInstalled() -> Bool {
        if let scriptURL = destinationScriptURL() {
            var isDirectory: ObjCBool = false
            return NSFileManager.defaultManager().fileExistsAtPath(scriptURL.relativePath!, isDirectory: &isDirectory) && !isDirectory
        }
        return false
    }
}