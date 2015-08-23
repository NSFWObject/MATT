//
//  PasteboardController.swift
//  Markdown
//
//  Created by Sash Zats on 8/3/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import AppKit
import WebKit


public class PasteboardController {
    
    public typealias PasteboardState = [NSPasteboardItem]?
    
    public func pasteboardState() -> PasteboardState {
        let pasteboard = NSPasteboard.generalPasteboard()
        return pasteboard.pasteboardItems?.map{ $0.copy() as! NSPasteboardItem }
    }
    
    public func restorePasteboardState(state: PasteboardState) {
        let pasteboard = NSPasteboard.generalPasteboard()
        pasteboard.clearContents()
        if let items = state {
            pasteboard.writeObjects(items)
        }
    }
    
    public func writeToPasteboard(writeBlock: NSPasteboard -> Void) {
        let pasteboard = NSPasteboard.generalPasteboard()
        pasteboard.clearContents()
        writeBlock(pasteboard)
    }
    
    public func stringContent() -> String? {
        let pasteboard = NSPasteboard.generalPasteboard()
        if let data = pasteboard.dataForType(NSPasteboardTypeString) {
            return NSString(data: data, encoding: NSUTF8StringEncoding) as? String
        }
        return nil
    }
    
    // MARK: - Markdown

    private var lastHandledMarkdown: String?
    
    public func markdown() -> String? {
        if let markdown = markdownContent() {
            if lastHandledMarkdown == markdown {
                return nil
            }
            lastHandledMarkdown = markdown
            return markdown
        } else {
            lastHandledMarkdown = nil
            return nil
        }
    }
    
    private func markdownContent() -> String? {
        if let HTML = HTMLContent() {
            return HTML
        } else if let attributedString = attributedStringContent() {
            return attributedString.string
        }
        return nil
    }
    
    private func webarchiveData() -> String? {
        let pasteboard = NSPasteboard.generalPasteboard()
        if let items = pasteboard.pasteboardItems as? [NSPasteboardItem] {
            for item in items {
                if let data = item.dataForType("com.apple.webarchive") {
                    if let webarchive = WebArchive(data: data),
                        htmlData = webarchive.mainResource?.data {
                            return NSString(data: htmlData, encoding: NSUTF8StringEncoding) as? String
                    }
                }
            }
        }
        return nil
    }
    
    private func attributedStringContent() -> NSAttributedString? {
        let pasteboard = NSPasteboard.generalPasteboard()
        if let data = pasteboard.dataForType(NSPasteboardTypeRTF) {
            return NSAttributedString(RTF: data, documentAttributes: nil)
        } else if let data = pasteboard.dataForType(NSPasteboardTypeRTFD) {
            return NSAttributedString(RTFD: data, documentAttributes: nil)
        }
        return nil
    }
    
    private func HTMLContent() -> String? {
        let pasteboard = NSPasteboard.generalPasteboard()
        if let data = pasteboard.dataForType(NSPasteboardTypeHTML) {
            return NSString(data: data, encoding: NSUTF8StringEncoding) as? String
        } else if let webarchive = webarchiveData() {
            return webarchive
        }
        return nil
    }

}

extension NSPasteboardItem: NSCopying {
    public func copyWithZone(zone: NSZone) -> AnyObject {
        let item = NSPasteboardItem()
        if let types = types {
            for type in types as! [String] {
                if let data = dataForType(type) {
                    item.setData(data, forType: type)
                }
            }
        }
        return item
    }
}
