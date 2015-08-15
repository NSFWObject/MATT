//
//  WindowController.swift
//  Markdown
//
//  Created by Sash Zats on 7/28/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import AppKit


class WindowController: NSWindowController, NSWindowDelegate {

    // MARK: - Lifecycle
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Actions
    
    func applicationDidBecomeActiveObserver(sender: AnyObject) {
        notifyViewControllerDidBecomeActive()
    }
    
    // MARK: - Private
    
    private func notifyViewControllerDidBecomeActive() {
        if let controller = self.contentViewController as? ViewController {
            controller.viewControllerDidBecomeActive()
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
        
        self.window?.title = ""
    }
}
