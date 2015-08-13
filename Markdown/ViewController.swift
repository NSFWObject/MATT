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
    
    private var highlighter: HGMarkdownHighlighter!
    
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
            pasteMarkdownIntoCapturedApp()
        }
        
    }
    
    // MARK: - Private

    private func pasteMarkdownIntoCapturedApp() {
        if let markdown = textView.string {
            appController.process(markdown: markdown) { result in
                
            }
        } else {
            assertionFailure("No text view")
        }
    }
    
    private func processSelectedMarkdown(shortcut: MASShortcut) {
        appController.processInPlace{ result in

        }
    }
    
    private func setupShortcuts() {
        shortcutManager.registerHandler(processSelectedMarkdown, forType: .ProcessSelectedMarkdown)
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
    
    private func setupHighlighter() {
        highlighter = HGMarkdownHighlighter(textView: textView, waitInterval: 0)
        let styleURL = NSBundle.mainBundle().URLForResource("Default", withExtension: "theme", subdirectory: "Theme")!
        let style = String(contentsOfURL: styleURL, encoding: NSUTF8StringEncoding, error: nil)!
        highlighter.applyStylesFromStylesheet(style, withErrorHandler: nil)
        highlighter.extensions = Int32(hoedown_extensions.ALL.value)
        highlighter.parseAndHighlightNow()
        highlighter.activate()
        view.layer!.backgroundColor = textView.backgroundColor.CGColor
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
        setupHighlighter()
    }
}
