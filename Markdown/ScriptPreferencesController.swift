//
//  ScriptPreferencesViewController.swift
//  Markdown
//
//  Created by Sash Zats on 7/29/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import AppKit


class ScriptPreferencesController: NSObject {

    let scriptManager: ScriptManager
    
    let installScriptButton: NSButton
    
    init(installScriptButton: NSButton, scriptManager: ScriptManager) {
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
        let isScriptInstalled = scriptManager.shouldInstallScripts()
        installScriptButton.title = isScriptInstalled ? "Installed" : "Install"
    }
}
