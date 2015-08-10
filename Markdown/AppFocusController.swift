//
// Created by Sash Zats on 8/8/15.
// Copyright (c) 2015 Sash Zats. All rights reserved.
//

import AppKit
import Result


public enum AppFocusError: ErrorType {
    case NoAppCaptured
}


public class AppFocusController {
    private(set) var capturedApp: NSRunningApplication?

    public func hideMe() {
        NSApplication.sharedApplication().hide(self)
    }
    
    public func showMe() {
        captureActiveApp()
        NSApplication.sharedApplication().activateIgnoringOtherApps(true)
    }

    public func captureActiveApp() {
        if let app = activeApp() {
            if app.bundleIdentifier == AppIdentity.bundleId {
                capturedApp = nil
            } else {
                capturedApp = app
            }
        } else {
            capturedApp = nil
        }
    }

    public func switchToCapturedApp(completion: Result<Void, AppFocusError> -> Void) {
        if let app = capturedApp {
            app.activateWithOptions(NSApplicationActivationOptions.ActivateIgnoringOtherApps)
            waitForCapturedAppToBecomeActive {
                completion(.success())
            }
        } else {
            completion(.failure(.NoAppCaptured))
        }
    }

    public func activeApp() -> NSRunningApplication? {
        return NSWorkspace.sharedWorkspace().frontmostApplication
    }

    // MARK: - Private


    private static let pollQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
   
    private func waitForCapturedAppToBecomeActive(handler: Void -> Void) {
        dispatch_async(AppFocusController.pollQueue) {
            var app: NSRunningApplication?
            do {
                app = self.activeApp()
            } while (app != self.capturedApp)
            dispatch_async(dispatch_get_main_queue()) {
                handler()
            }

        }
    }

}
