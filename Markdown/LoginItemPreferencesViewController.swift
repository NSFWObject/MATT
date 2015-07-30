//
//  LoginItemPreferencesViewController.swift
//  Markdown
//
//  Created by Sash Zats on 7/30/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import AppKit

class LoginItemPreferencesViewController: NSViewController {
    
    private let loginItemManager = LoginItemManager()
    
    @IBOutlet weak var loginItemCheckout: NSButton!
    
    // MARK: - Actions
    
    @IBAction func loginItemCheckoutAction(sender: AnyObject) {
        let enable = self.loginItemCheckout.state == NSOnState
        loginItemManager.setLoginItemsEnabled(enable)
    }

    // MARK: - NSViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginItemCheckout.state = loginItemManager.isLoginItemEnabled() ? NSOnState : NSOffState
    }
    
}
