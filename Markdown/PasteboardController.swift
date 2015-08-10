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
        if let items = pasteboardContents() {
            return items.map{$0.copy() as! NSPasteboardItem}
        }
        return nil
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
    
    // MARK: - Private
    
    private func pasteboardContents() -> [NSPasteboardItem]? {
        let pasteboard = NSPasteboard.generalPasteboard()
        return pasteboard.pasteboardItems as? [NSPasteboardItem]
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
