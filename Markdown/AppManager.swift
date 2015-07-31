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

class AppManager {
    static let sharedInstance = AppManager()
    
    private(set) var capturedApp: NSRunningApplication?
        
    // MARK: - Public
    
    func pasteAttributedString(attributedString: NSAttributedString, completion: Bool -> Void) {
        goBackToCapturedApp{ [unowned self] success in
            if !success {
                completion(false)
                return
            }
            self.writeToPasteboard(attributedString)
            self.sendCmdV()
        }
    }
    
    func hideMe() {
        goBackToCapturedApp(completion: nil)
    }
    
    func activateMeCapturingActiveApp() {
        captureActiveApp()
        NSApplication.sharedApplication().activateIgnoringOtherApps(true)
    }
    
    func captureActiveApp() {
        if let app = activeApp() {
            capturedApp = app
        } else {
            capturedApp = nil
        }
    }
    
    func writeToPasteboard(attributedString: NSAttributedString) {
        let pasteborad = NSPasteboard.generalPasteboard()
        pasteborad.clearContents()
        pasteborad.writeObjects([attributedString])
    }
    
    // MARK: - Private
    
    private func sendCmdV() {
        //        carbonWay()
        scriptWay()
    }

    private func carbonWay() {
        var keyVDown : CGEvent = CGEventCreateKeyboardEvent(nil, CGKeyCode(kVK_ANSI_V), true).takeUnretainedValue()
        CGEventSetFlags(keyVDown, UInt64(kCGEventFlagMaskCommand))
        CGEventPost(UInt32(kCGHIDEventTap), keyVDown)
        
        var keyVUp : CGEvent = CGEventCreateKeyboardEvent(nil, CGKeyCode(kVK_ANSI_V), false).takeUnretainedValue()
        CGEventSetFlags(keyVUp, UInt64(kCGEventFlagMaskCommand))
        CGEventPost(UInt32(kCGHIDEventTap), keyVUp)
    }
    
    private func scriptWay() {
        if let URL = NSFileManager.defaultManager().URLForDirectory(.ApplicationScriptsDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: false, error: nil) {
            println(URL)
            let scriptURL = URL.URLByAppendingPathComponent("PasteboardHelper.scpt")
            var error: NSError? = nil
            if let task = NSUserAppleScriptTask(URL: scriptURL, error: &error) {
                task.executeWithCompletionHandler{ error in
                    println("error: \(error)")
                }
            } else {
                println("error: \(error)")
            }
        }
    }
    
    private func goBackToCapturedApp(#completion: (Bool -> Void)?) {
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