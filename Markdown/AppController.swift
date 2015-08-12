//
//  AppController.swift
//  Markdown
//
//  Created by Sash Zats on 8/8/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import AppKit
import Result


public enum ProcessingError: ErrorType {
    case ScriptError
    case AppFocusError(MATT.AppFocusError)
}

public enum ProcessingResult {
    case PastedToCapturedApp
    case CopiedToPasteboard
}

public class AppController {
    
    public var focusController: AppFocusController!
    public let renderEngine: MarkdownRenderer = MarkdownRenderer()
    public var styleManager: StyleController!
    public var pasteboardController: PasteboardController!
    
    public func process(#markdown: String, completion: Result<ProcessingResult, ProcessingError> -> Void) {
        // preserve pasteboard
        let pasteboardState = pasteboardController.pasteboardState()

        // set pasteboard to the processed markdown
        let styleContents = styleManager.content(style: styleManager.selectedStyle)
        let renderResult = renderEngine.render(markdown: markdown, style: styleContents)
        pasteboardController.writeToPasteboard{ pasteboard in
            pasteboard.writeObjects([renderResult.attributedString])
            // for apps that understand in `div`s and `span`s (Evernote, Safari etc… Not Pages:/)
            pasteboard.setString(renderResult.HTMLString, forType: NSPasteboardTypeHTML)
        }
        
        // Do not try to switch back, just keep the copyied text
        if focusController.capturedApp == nil {
            completion(.success(.CopiedToPasteboard))
            return
        }

        focusController.switchToCapturedApp{ result in
            switch result {
            case .Success:
                Script.Paste.execute{ success in
                    assert(success, "Failed to paste!")
                    self.pasteboardController.restorePasteboardState(pasteboardState)
                    if success {
                        completion(success ? .success(.PastedToCapturedApp) : .failure(.ScriptError))
                    }
                }
            case .Failure(let error):
                completion(.failure(.AppFocusError(error.value)))
            }
        }
   }
    
}