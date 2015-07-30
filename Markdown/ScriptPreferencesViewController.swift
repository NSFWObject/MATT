//
//  ScriptPreferencesViewController.swift
//  Markdown
//
//  Created by Sash Zats on 7/29/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import AppKit


class ScriptPreferencesViewController: NSViewController {
    
    private let scriptManager = ScriptManager()
    
    @IBOutlet weak var scriptStatusLabel: NSTextField!
    @IBOutlet weak var installScriptButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    @IBAction func installScriptButtonAction(sender: AnyObject) {
        scriptManager.installScript{ completion in
            self.updateUI()
        }
    }
    
    // MARK: - Private
    
    private func updateUI() {
        let isScriptInstalled = scriptManager.isScriptInstalled()
        scriptStatusLabel.stringValue = isScriptInstalled ?
            "Script is installed and accessible." :
            "Script is not installed or not accessible. Click the button above to fix it."
        installScriptButton.title = isScriptInstalled ? "Installed" : "Install"
        installScriptButton.enabled = !isScriptInstalled
    }
}
