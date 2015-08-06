//
//  AppDelegate.swift
//  Markdown
//
//  Created by Sash Zats on 7/21/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    // TODO: remove me!
    func applicationDidFinishLaunching(notification: NSNotification) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.registerDefaults(["MATTDefaultStyleName": "GitHub2"])
        defaults.synchronize()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }
    
}

