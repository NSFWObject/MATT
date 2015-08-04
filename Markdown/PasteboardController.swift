//
//  PasteboardController.swift
//  Markdown
//
//  Created by Sash Zats on 8/3/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import AppKit


struct PasteboardController {
    
    static func pasteboardContents() -> [NSPasteboardItem]? {
        let pasteboard = NSPasteboard.generalPasteboard()
        return pasteboard.pasteboardItems as? [NSPasteboardItem]
    }
    
    static func setPasteboardContents(items: [NSPasteboardItem]) {
        let pasteboard = NSPasteboard.generalPasteboard()
        pasteboard.clearContents()
        pasteboard.writeObjects(items)
    }
    
    static func writeToPasteboard(writeBlock: NSPasteboard -> Void) {
        let pasteboard = NSPasteboard.generalPasteboard()
        pasteboard.clearContents()
        writeBlock(pasteboard)
    }
}

extension NSPasteboardItem: NSCopying {
    public func copyWithZone(zone: NSZone) -> AnyObject {
        let item = NSPasteboardItem()
        if let types = self.types {
            for type in types as! [String] {
                if let data = self.dataForType(type) {
                    item.setData(data, forType: type)
                }
            }
        }
        return item
    }
}
