//
//  MarkdownRenderer.swift
//  Markdown
//
//  Created by Sash Zats on 7/27/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import Foundation
import hoedown
import CocoaMark


public struct MarkdownRenderer {
    let ext: hoedown_extensions
    let processor: CocoaMarkDocumentProcessor
    let renderer: CocoaMarkBasicRenderer
    
    public init() {
        let ext = hoedown_extensions.ALL
        let renderer = CocoaMarkRenderer(flags: Int32(ext.value))
        self.ext = ext
        self.renderer = renderer
        self.processor = CocoaMarkDocumentProcessor(renderer: renderer, extensions: Int32(ext.value), maxNesting: 16)
    }

    public func render(#markdown: String) -> String {
        return processor.renderMarkdown(markdown)
    }
    
    public func render(#HTML: String) -> NSAttributedString? {
        let documentAttributes: AutoreleasingUnsafeMutablePointer<NSDictionary?> = AutoreleasingUnsafeMutablePointer()
        if let HTMLData = HTML.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true),
            URL = NSURL(string:"127.0.0.1") {
            if let attributedString = NSAttributedString(HTML: HTMLData, baseURL: URL, documentAttributes: documentAttributes) {
                return attributedString
            }
        }
        return nil
    }
}

extension hoedown_extensions {
    static var ALL: hoedown_extensions {
        return hoedown_extensions(
              HOEDOWN_EXT_TABLES.value
            | HOEDOWN_EXT_FENCED_CODE.value
            | HOEDOWN_EXT_FOOTNOTES.value
            | HOEDOWN_EXT_AUTOLINK.value
            | HOEDOWN_EXT_STRIKETHROUGH.value
            | HOEDOWN_EXT_UNDERLINE.value
            | HOEDOWN_EXT_HIGHLIGHT.value
            | HOEDOWN_EXT_QUOTE.value
            | HOEDOWN_EXT_SUPERSCRIPT.value
            | HOEDOWN_EXT_MATH.value
        )
    }
}