//
//  IntroViewController.swift
//  Markdown
//
//  Created by Sash Zats on 8/7/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import AppKit


class IntroViewController: NSViewController {
    @IBOutlet weak var installAppleScriptsCheckbox: NSButton!
    @IBOutlet weak var launchOnLoginCheckbox: NSButton!
    
    var scriptManager: ScriptInstallationManager!
    
    @IBAction func _doneButtonAction(sender: AnyObject) {
        presentingViewController?.dismissViewController(self)
        if installAppleScriptsCheckbox.state == NSOnState {
            scriptManager.installScripts{ _ in }
        }
        
        
    }
    
    // MARK: - Private
}
