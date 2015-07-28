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

class WindowController: NSWindowController {
    let manager = AppManager()
    
    // MARK: - Lifecycle
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Actions
    
    func applicationDidBecomeActiveObserver(sender: AnyObject) {
        if let app = manager.capturedApp, name = app.localizedName {
            self.window?.title = "\(name) + MATT = ♥︎"
        } else {
            self.window?.title = (NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleDisplayName") as! String)
        }
    }

    // MARK: - NSWindowController
    
    override func windowDidLoad() {
        super.windowDidLoad()

        if let controller = self.contentViewController as? ViewController {
            controller.manager = manager
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("applicationDidBecomeActiveObserver:"), name: NSApplicationDidBecomeActiveNotification, object: nil)
    }
}


class ViewController: NSViewController {
    let hotkeyManager = HotkeyManager()
    let renderer = MarkdownRenderer()
    var manager: AppManager!
    
    let monitor: MASShortcutMonitor = MASShortcutMonitor.sharedMonitor()
    
    @IBOutlet var textView: NSTextView!
    
    // MARK: - Actions
    
    private func toggleAppVisibilityAction() {
        self.toggleAppVisibility()
    }
    
    private func pasteMarkdownAction() {
        
    }

    @IBAction func doneButtonAction(sender: AnyObject) {
        if let markdown = textView.string {
            let HTMLString = renderer.render(markdown: markdown)
            if let attributedString = renderer.render(HTML: HTMLString) {
                self.manager.pasteAttributedString(attributedString) { success in
                    if !success {
                        let alert = NSAlert()
                        alert.alertStyle = .CriticalAlertStyle
                        alert.messageText = "Something went wrong :("
                        alert.runModal()
                    }
                }
            } else {
                let alert = NSAlert()
                alert.alertStyle = .CriticalAlertStyle
                alert.messageText = "Failed to process markdown"
                alert.runModal()
            }

        }
    }
    
    @IBAction func installScriptMenuItemAction(sender: AnyObject) {
        var error: NSError?
        if let URL = NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.ApplicationScriptsDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: true, error: &error) {
            let openPanel = NSOpenPanel()
            openPanel.directoryURL = URL
            openPanel.canChooseDirectories = true
            openPanel.canChooseFiles = false
            openPanel.prompt = "Select Script Folder"
            openPanel.message = "Please select the User > Library > Application Scripts > \(NSBundle.mainBundle().bundleIdentifier!) folder"
            openPanel.beginWithCompletionHandler{ status in
                if status != NSFileHandlingPanelOKButton {
                    return
                }
                if let selectedURL = openPanel.URL {
                    if selectedURL == URL {
                        let destinationURL = selectedURL.URLByAppendingPathComponent("PasteboardHelper.scpt")
                        let sourceURL = NSBundle.mainBundle().URLForResource("PasteboardHelper", withExtension: "scpt")!
                        if NSFileManager.defaultManager().copyItemAtURL(sourceURL, toURL: destinationURL, error: &error) {
                            self.scriptMessage("Script successfully installed!", style: NSAlertStyle.InformationalAlertStyle)
                        } else {
                            self.scriptMessage("Failed to copy file from \(sourceURL) to \(destinationURL): \(error?.localizedDescription)")
                        }
                    } else {
                        self.scriptMessage("You didn't select the right folder. Please try again.")
                    }
                } else {
                    self.scriptMessage("You didn't select the right folder. Please try again.")
                }
            }
        } else {
            scriptMessage("Failed to create scripting folder")
        }
    }
    
    // MARK: - Private

    private func toggleAppVisibility() {
        if let activeApp = self.manager.activeApp() {
            if activeApp.bundleIdentifier == NSBundle.mainBundle().bundleIdentifier {
                self.manager.hideMe()
            } else {
                self.manager.activateMeCapturingActiveApp()
            }
        }
    }
    
    private func scriptMessage(message: String, style: NSAlertStyle = NSAlertStyle.WarningAlertStyle) {
        let alert = NSAlert()
        alert.messageText = message
        alert.addButtonWithTitle("OK")
        alert.alertStyle = style
        alert.runModal()
    }
    
    private func setupSystemWideHotkey() {
        hotkeyManager.registerHotkey()
        hotkeyManager.handler = toggleAppVisibilityAction
    }
    
    private func setupTextView() {
        textView.font = NSFont.userFixedPitchFontOfSize(12)
    }
    
    private func writeToPasteborad(markdown: String) {

        if let html = CocoaMark.renderMarkdown(markdown) {
            let styledHTML = styleHTML(html)
            if let htmlData = styledHTML.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true) {
                let baseURL = NSURL(string:"127.0.0.1")!
                var attributes = [:]
                let attributesPointer: AutoreleasingUnsafeMutablePointer<NSDictionary?> = AutoreleasingUnsafeMutablePointer(&attributes)
                if let attributedString = NSAttributedString(HTML: htmlData, baseURL: baseURL, documentAttributes: attributesPointer) {
                    let pasteboard = NSPasteboard.generalPasteboard()
                    pasteboard.clearContents()
                    pasteboard.writeObjects([attributedString])
                }
            }
        }
    }
    
    private let defaultStyle: String = {
        let styleURL = NSBundle.mainBundle().URLForResource("default-style", withExtension: "css")!
        return String(contentsOfURL: styleURL, encoding: NSUTF8StringEncoding, error: nil)!
    }()
    
    private func styleHTML(HTML: String) -> String {
        return "<head><style>\(defaultStyle)</style><body>\(HTML)</body>"
    }

    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextView()
        setupSystemWideHotkey()
    }
}

