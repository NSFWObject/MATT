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
        defaults.setObject("Clearness", forKey: "MATTDefaultStyleName")
        defaults.setObject([
            "com.google.Chrome": "Github",
            "com.apple.Safari": "Clearness Dark"
        ], forKey: "MATTAssociatedAppStylesKey")
        defaults.synchronize()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }
    
}

