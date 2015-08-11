//
//  Script.swift
//  Markdown
//
//  Created by Sash Zats on 8/10/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import Foundation


public enum Script {
    case Copy
    case Paste
}

extension Script {
    var fileName: String {
        switch self {
        case .Copy:
            return "⌘C"
        case .Paste:
            return "⌘V"
        }
    }
    
    var bundledURL: NSURL {
        return NSBundle.mainBundle().URLForResource(self.fileName, withExtension: "scpt", subdirectory: "Scripts")!
    }
    
    var destinationURL: NSURL? {
        let manager = NSFileManager.defaultManager()
        if let URL = manager.URLForDirectory(.ApplicationScriptsDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false, error: nil) {
            return URL.URLByAppendingPathComponent("\(self.fileName).scpt")
        }
        return nil
    }
}

public extension Script {
    func execute(handler: Bool -> Void) {
        if let URL = self.destinationURL {
            var error: NSError?
            if let task = NSUserAppleScriptTask(URL: URL, error: &error) {
                task.executeWithCompletionHandler{ error in
                    assert(error == nil, "Failed to execute script \(error)")
                    dispatch_async(dispatch_get_main_queue()) {
                        handler(error == nil)
                    }
                }
            } else {
                assertionFailure("Failed to create task: \(error)")
                dispatch_async(dispatch_get_main_queue()) {
                    handler(false)
                }
            }
        } else {
            assertionFailure("Script \(self) is not found in the destination folder")
            dispatch_async(dispatch_get_main_queue()) {
                handler(false)
            }
        }
    }
}
