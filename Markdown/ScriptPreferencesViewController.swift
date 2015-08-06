//
//  ScriptPreferencesViewController.swift
//  Markdown
//
//  Created by Sash Zats on 7/29/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import AppKit


class ScriptPreferencesViewController: NSViewController {

    var scriptManager: ScriptManager!
    
    @IBOutlet weak var installScriptButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
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
