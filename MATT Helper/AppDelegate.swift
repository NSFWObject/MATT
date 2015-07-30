//
//  AppDelegate.swift
//  MATT Helper
//
//  Created by Sash Zats on 7/29/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        let components = NSBundle.mainBundle().bundlePath.pathComponents
        if components.count > 4 {
            let parentComponents = Array(components[0..<components.count-4])
            let parentPath = String.pathWithComponents(parentComponents)
            NSWorkspace.sharedWorkspace().launchApplication(parentPath)
            NSApplication.sharedApplication().terminate(nil)
        }
    }
}

