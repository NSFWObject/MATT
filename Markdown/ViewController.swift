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
    
    var appController: AppController!
    var presentPreferences: (Void -> Void)!
    var shortcutManager: ShortcutManager! {
        didSet {
            setupShortcuts()
        }
    }

    let renderer = MarkdownRenderer()
    let scriptManager = ScriptInstallationManager()
    
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
            presentPreferences()
        } else {
            pasteMarkdownIntoAnotherApp()
        }
        
    }
    
    // MARK: - Private

    private func pasteMarkdownIntoAnotherApp() {
        if let markdown = textView.string {
            appController.process(markdown: markdown) { result in
                
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
    
    private func checkIfScriptNeedsToBeInstalled(completion: Bool -> Void) {
        if !scriptManager.shouldInstallScripts() {
            completion(true)
            return
        }
        scriptManager.promptScriptInstallation(completion)
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
}
