//
//  WindowController.swift
//  Markdown
//
//  Created by Sash Zats on 7/28/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import AppKit


class WindowController: NSWindowController, NSWindowDelegate {
    var appManager: AppManager!
    
    // MARK: - Lifecycle
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Actions
    
    func applicationDidBecomeActiveObserver(sender: AnyObject) {
        if let manager = appManager,
            app = appManager.capturedApp,
            name = app.localizedName {
                self.window?.title = "\(name) + MATT = ♥︎"
        } else {
            self.window?.title = (NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleDisplayName") as! String)
        }
    }
        
    // MARK: - NSWindowController
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        if let window = window {
            window.titlebarAppearsTransparent = true
            window.styleMask |= NSFullSizeContentViewWindowMask
            window.delegate = self
        }
                
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("applicationDidBecomeActiveObserver:"), name: NSApplicationDidBecomeActiveNotification, object: nil)
    }
    
    override func showWindow(sender: AnyObject?) {
        super.showWindow(sender)
        
        if let controller = contentViewController as? ViewController {
            controller.windowWillAppear()
        }
    }
    
    // MARK: - NSWindowDelegate
    
    func windowDidChangeOcclusionState(notification: NSNotification) {
        if let window = self.window, controller = self.contentViewController as? ViewController {
            if window.occlusionState & NSWindowOcclusionState.Visible == NSWindowOcclusionState.Visible {
                controller.windowWillAppear()
            }
        }
    }
}
