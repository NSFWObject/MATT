//
//  ScriptPreferencesViewController.swift
//  Markdown
//
//  Created by Sash Zats on 7/29/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import AppKit


class ScriptPreferencesController: NSObject {

    let scriptManager: ScriptInstallationManager
    
    let installScriptButton: NSButton
    
    init(installScriptButton: NSButton, scriptManager: ScriptInstallationManager) {
        self.installScriptButton = installScriptButton
        self.scriptManager = scriptManager
        super.init()
        installScriptButton.target = self
        installScriptButton.action = Selector("installScriptButtonAction:")
        updateUI()
    }
    
    // MARK: - Actions
    
    @IBAction func installScriptButtonAction(sender: AnyObject) {
        scriptManager.installScripts{ success in
            // TODO: a great case for `Result`. success == false might be user canceled
            // assert(success, "Failed to copy script")
            self.updateUI()
        }
    }
    
    // MARK: - Private
    
    private func updateUI() {
        let shouldInstallScript = scriptManager.shouldInstallScripts()
        if shouldInstallScript {
            installScriptButton.title = "Install"
            installScriptButton.image = NSImage(named: NSImageNameStatusPartiallyAvailable)
        } else {
            installScriptButton.title = "Installed"
            installScriptButton.image = NSImage(named: NSImageNameStatusAvailable)
        }
    }
}
