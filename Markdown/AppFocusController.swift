//
// Created by Sash Zats on 8/8/15.
// Copyright (c) 2015 Sash Zats. All rights reserved.
//

import AppKit
import Result


enum AppFocusError: ErrorType {
    case NoAppCaptured
}


class AppFocusController {
    private(set) var capturedApp: NSRunningApplication?

    func hideMe() {
        NSApplication.sharedApplication().hide(self)
    }

    func captureActiveApp() {
        if let app = activeApp() {
            capturedApp = app
        } else {
            capturedApp = nil
        }
    }

    func switchToCapturedApp(completion: Result<Void, AppFocusError> -> Void) {
        if let app = capturedApp {
            app.activateWithOptions(NSApplicationActivationOptions.ActivateIgnoringOtherApps)
            waitForCapturedAppToBecomeActive {
                completion(.success())
            }
        } else {
            completion(.failure(.NoAppCaptured))
        }
    }

    // MARK: - Private

    private func activeApp() -> NSRunningApplication? {
        if let app = NSWorkspace.sharedWorkspace().frontmostApplication {
            if app.bundleIdentifier == AppIdentity.bundleId {
                return nil
            }
            return app
        }
        return nil
    }

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
