//
//  ViewController.swift
//  Markdown
//
//  Created by Sash Zats on 7/21/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import AppKit
import MASShortcut
import CocoaMark
import hoedown


class ViewController: NSViewController {
    
    let shortcutManager = ShortcutManager()
    let styleManager = StyleManager()
    let renderer = MarkdownRenderer()
    let scriptManager = ScriptManager()
    var appManager: AppManager!
    
    let monitor: MASShortcutMonitor = MASShortcutMonitor.sharedMonitor()
    
    @IBOutlet var textView: NSTextView!
    
    // MARK: - Public 
    
    func windowWillAppear() {
        selectTextFieldContents()
    }
    
    // MARK: - Actions
    
    @IBAction func preferencesMenuAction(sender: AnyObject) {
        PreferencesViewManager.showPreferences(shortcutManager: shortcutManager, scriptManager: scriptManager)
    }

    private func toggleAppVisibilityAction() {
        toggleAppVisibility()
    }
    
    private func pasteMarkdownAction() {
        assertionFailure("Not implemented")
    }

    @IBAction func doneButtonAction(sender: AnyObject) {
        if let markdown = textView.string {
            appManager.process(markdown: markdown, styleManager: styleManager, renderer: renderer, scriptManager: scriptManager) { success in
                // no-op
            }
        } else {
            assertionFailure("No text view")
        }
    }
    
    // MARK: - Private
    
    private func toggleAppVisibility() {
        if let activeApp = self.appManager.activeApp() {
            if activeApp.bundleIdentifier == NSBundle.mainBundle().bundleIdentifier {
                self.appManager.hideMe()
            } else {
                self.appManager.activateMeCapturingActiveApp()
            }
        }
    }
    
    private func setupSystemWideHotkey() {
        shortcutManager.load()
        shortcutManager.handler = toggleAppVisibilityAction
    }
    
    private func setupView() {
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.whiteColor().CGColor
    }
    
    private func setupTextView() {
        textView.textColor = NSColor(red:0.058, green:0.173, blue:0.166, alpha:1)
        if let font = NSFont(name: "Menlo", size: 13) {
            textView.font = font
        } else {
            textView.font = NSFont.userFixedPitchFontOfSize(12)
        }
    }
    
    private func loadStyles() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        styleManager.load(userDefaults) {
            print("styleManager.appStyles: \(self.styleManager.appStyles)")
        }
        
    }

    private func checkIfScriptNeedsToBeInstalled() {
        if !scriptManager.shouldInstallScriptFile() {
            return
        }
        
        let alert = NSAlert()
        alert.messageText = "Do you want to install pasteboard helper script?"
        alert.informativeText = "Due to App Store limitations, without this script app can only copy formatted markdown in the Pasteboard."
        alert.addButtonWithTitle("Install")
        alert.addButtonWithTitle("Cancel")
        alert.beginSheetModalForWindow(self.view.window!) { response in
            if response == NSAlertFirstButtonReturn {
                self.scriptManager.installScript{ _ in }
            }
        }
    }
    
    private func selectTextFieldContents() {
        textView.selectAll(self)
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadStyles()
        setupView()
        setupTextView()
        setupSystemWideHotkey()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        checkIfScriptNeedsToBeInstalled()
    }
}
