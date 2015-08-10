//
//  LoginItemPreferencesViewController.swift
//  Markdown
//
//  Created by Sash Zats on 7/30/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import AppKit

class LoginItemPreferencesController: NSObject {
    
    private let loginItemManager: LoginItemManager
    private let loginItemCheckbox: NSButton
    
    init(loginItemManager: LoginItemManager, loginItemCheckbox: NSButton) {
        self.loginItemCheckbox = loginItemCheckbox
        self.loginItemManager = loginItemManager
        super.init()
        loginItemCheckbox.target = self
        loginItemCheckbox.action = Selector("loginItemCheckoutAction:")
        
        loginItemCheckbox.state = loginItemManager.loginItemsEnabled ? NSOnState : NSOffState
    }
    
    // MARK: - Actions
    
    @IBAction func loginItemCheckoutAction(sender: AnyObject) {
        let enable = self.loginItemCheckbox.state == NSOnState
        loginItemManager.loginItemsEnabled = enable
    }
}
