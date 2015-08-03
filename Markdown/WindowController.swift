//
//  WindowController.swift
//  Markdown
//
//  Created by Sash Zats on 7/28/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import AppKit


class WindowController: NSWindowController {
    let appManager = AppManager()
    
    // MARK: - Lifecycle
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Actions
    
    func applicationDidBecomeActiveObserver(sender: AnyObject) {
        if let app = appManager.capturedApp, name = app.localizedName {
            self.window?.title = "\(name) + MATT = ♥︎"
        } else {
            self.window?.title = (NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleDisplayName") as! String)
        }
    }
        
    // MARK: - NSWindowController
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        if let controller = self.contentViewController as? ViewController {
            controller.appManager = appManager
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("applicationDidBecomeActiveObserver:"), name: NSApplicationDidBecomeActiveNotification, object: nil)
    }
}
