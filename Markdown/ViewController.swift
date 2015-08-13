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
    
    var focusController: AppFocusController!
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
    @IBOutlet weak var titleLabel: NSTextField!
    
    // MARK: - Lifecycle
    
    deinit {
        highlighter.deactivate()
    }
    
    // MARK: - Public 
    
    func windowWillAppear() {
        selectTextFieldContents()
    }
    
    func updateWindowTitle() {
        self.titleLabel.stringValue = windowTitle()
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

    private func windowTitle() -> String {
        let randomEmoji: Void -> String = {
            let emojis = ["💥", "🍌", "♥︎", "🔥", "🎉", "😃", "👍", "🐔", "🐙", "❤️", "💜", "👌", "💛", "💚", "💃", "🚀"]
            let index = Int(arc4random_uniform(UInt32(emojis.count)))
            return emojis[index]
        }
        
        if let app = focusController.capturedApp, name = app.localizedName {
            return "\(name) + \(AppIdentity.shortName) = \(randomEmoji())"
        } else {
            return AppIdentity.displayName
        }
    }

    
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
        textView.font = NSFont(name: "Times New Roman", size: 14)
        textView.layoutManager!.hyphenationFactor = 0.5
    }
    
    private func setupHighlighter() {
        highlighter = HGMarkdownHighlighter(textView: textView, waitInterval: 0)
        let styleURL = NSBundle.mainBundle().URLForResource("Default", withExtension: "theme", subdirectory: "Theme")!
        let style = String(contentsOfURL: styleURL, encoding: NSUTF8StringEncoding, error: nil)!
        highlighter.readClearTextStylesFromTextView()
        highlighter.applyStylesFromStylesheet(style, withErrorHandler: nil)
        highlighter.extensions = Int32(hoedown_extensions.ALL.value)
        highlighter.makeLinksClickable = false
        highlighter.activate()
        highlighter.parseAndHighlightNow()
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
