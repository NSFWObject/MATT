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
    
    var appManager: AppManager!
    var shortcutManager: ShortcutManager! {
        didSet {
            setupShortcuts()
        }
    }

    let renderer = MarkdownRenderer()
    let scriptManager = ScriptManager()
    
    @IBOutlet var textView: NSTextView!
    
    // MARK: - Public 
    
    func windowWillAppear() {
        selectTextFieldContents()
    }
    
    // MARK: - Actions
    
    private func pasteMarkdownAction() {
        assertionFailure("Not implemented")
    }

    @IBAction func doneButtonAction(sender: AnyObject) {
        if scriptManager.shouldInstallScripts() {
            checkIfScriptNeedsToBeInstalled{ result in
                if result {
                    self.pasteMarkdownIntoAnotherApp()
                }
            }
        } else {
            pasteMarkdownIntoAnotherApp()
        }
        
    }
    
    // MARK: - Private

    private func pasteMarkdownIntoAnotherApp() {
        if let markdown = textView.string {
            appManager.process(markdown: markdown, renderer: renderer, scriptManager: scriptManager) { success in
                // no-op
            }
        } else {
            assertionFailure("No text view")
        }
    }
    
    private func processSelectedMarkdown() {
        
    }
    
    private func setupShortcuts() {
        shortcutManager.processMarkdownHandler = processSelectedMarkdown
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
    
    private func runFirstTimeExperienceIfNeeded() {
        FirstTimeController.executeIfNeeded(self.view.window!) {
            self.checkIfScriptNeedsToBeInstalled{_ in}
        }
    }

    private func checkIfScriptNeedsToBeInstalled(completion: Bool -> Void) {
        if !scriptManager.shouldInstallScripts() {
            completion(true)
            return
        }

        installScript(completion)
    }
    
    private func installScript(completion: Bool -> Void) {
        let alert = NSAlert()
        alert.messageText = "Do you want to install pasteboard helper script?"
        alert.informativeText = "Due to App Store limitations, without this script app can only copy formatted markdown in the Pasteboard."
        alert.addButtonWithTitle("Install")
        alert.addButtonWithTitle("Cancel")
        alert.beginSheetModalForWindow(self.view.window!) { response in
            if response == NSAlertFirstButtonReturn {
                self.scriptManager.installScripts(completion)
            } else {
                completion(false)
            }
        }
    }
    
    private func selectTextFieldContents() {
        textView.selectAll(self)
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupTextView()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        runFirstTimeExperienceIfNeeded()
    }
}
