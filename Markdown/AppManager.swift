//
//  Manager.swift
//  Markdown
//
//  Created by Sash Zats on 7/22/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import AppKit
import Carbon
import ApplicationServices

let AppName = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleDisplayName") as! String

public class AppManager {
    static let sharedInstance = AppManager()
    
    private(set) var capturedApp: NSRunningApplication?
        
    // MARK: - Public
    
    public func process(#markdown: String, styleManager: StyleManager, renderer: MarkdownRenderer, scriptManager: ScriptManager, completion: Bool -> Void) {
        let cssContents = cssContentsForCapturedApp(capturedApp, styleManager: styleManager)
        let (attributedString, HTML) = renderer.render(markdown: markdown, style: cssContents)
        
        let pasteboardItems = (PasteboardController.pasteboardContents() ?? []).map{ $0.copy() as! NSPasteboardItem }

        PasteboardController.writeToPasteboard{ pasteboard in
            pasteboard.writeObjects([attributedString])
            pasteboard.setString(HTML, forType: NSPasteboardTypeHTML)
        }
        if let _ = capturedApp {
            switchToPreviouslyCapturedApp{ [unowned self] success in
                if !success {
                    PasteboardController.setPasteboardContents(pasteboardItems)
                    completion(false)
                    assertionFailure("Failed to switch back to the app")
                } else {
                    self.sendCmdV(scriptManager: scriptManager){ success in
                        // restoring pasteboard content
                        PasteboardController.setPasteboardContents(pasteboardItems)
                        completion(success)
                    }
                }

            }
        } else {
            PasteboardController.setPasteboardContents(pasteboardItems)
            completion(true)
        }
    }
    
    public func hideMe() {
        NSApplication.sharedApplication().hide(nil)
    }
    
    public func activateMeCapturingActiveApp() {
        captureActiveApp()
        NSApplication.sharedApplication().activateIgnoringOtherApps(true)
    }
    
    public func captureActiveApp() {
        if let app = activeApp() {
            capturedApp = app
        } else {
            capturedApp = nil
        }
    }

    // MARK: - Private
    
    private func cssContentsForCapturedApp(app: NSRunningApplication?, styleManager: StyleManager) -> String {
        return styleManager.cssContentsForBundleId(app?.bundleIdentifier)
    }
    
    private func sendCmdV(#scriptManager: ScriptManager, completion: Bool -> Void) {
//        carbonWay()
        scriptWay(scriptManager: scriptManager, completion: completion)
    }

    private func carbonWay() {
        let keyVDown: CGEvent = CGEventCreateKeyboardEvent(nil, CGKeyCode(kVK_ANSI_V), true).takeUnretainedValue()
        CGEventSetFlags(keyVDown, UInt64(kCGEventFlagMaskCommand))
        CGEventPost(UInt32(kCGHIDEventTap), keyVDown)
        
        let keyVUp: CGEvent = CGEventCreateKeyboardEvent(nil, CGKeyCode(kVK_ANSI_V), false).takeUnretainedValue()
        CGEventSetFlags(keyVUp, UInt64(kCGEventFlagMaskCommand))
        CGEventPost(UInt32(kCGHIDEventTap), keyVUp)
    }
    
    private func scriptWay(#scriptManager: ScriptManager, completion: Bool -> Void) {
        scriptManager.executeScript(completion)
    }
    
    private func switchToPreviouslyCapturedApp(#completion: (Bool -> Void)?) {
        if let app = capturedApp {
            app.activateWithOptions(NSApplicationActivationOptions.ActivateIgnoringOtherApps)
            pollForCapturedApp(app) { success in
                if let completion = completion {
                    completion(success)
                }
            }
        } else {
            if let completion = completion {
                completion(false)
            }
        }
    }
    
    
    
    private let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    private func pollForCapturedApp(capturedApp: NSRunningApplication, completion: Bool -> Void) {
        dispatch_async(queue) {
            var app: NSRunningApplication?
            do {
                app = self.activeApp()
            } while (app != capturedApp)
            dispatch_async(dispatch_get_main_queue()) {
                completion(true)
            }
        }
    }
    
    func activeApp() -> NSRunningApplication? {
        return NSWorkspace.sharedWorkspace().frontmostApplication
    }
}