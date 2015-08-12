//
//  PasteboardController.swift
//  Markdown
//
//  Created by Sash Zats on 8/3/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import AppKit


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
