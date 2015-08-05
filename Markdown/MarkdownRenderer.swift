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
    public typealias HTML = String
    
    public init() {
    }
        
    public func render(#markdown: String, style: String) -> (NSAttributedString, HTML) {
        let html = render(markdown: markdown)
        let styledHTML = "<html><head><style>\(style)</style></head><body>\(html)</body>"
        let attributedString = render(HTML: styledHTML)
        return (attributedString, styledHTML)
    }

    // MARK: - Private
    
    private func render(#markdown: String) -> String {
        let ext = hoedown_extensions.ALL
        let renderer = CocoaMarkRenderer(flags: Int32(ext.value))
        let processor = CocoaMarkDocumentProcessor(renderer: renderer, extensions: Int32(ext.value), maxNesting: 16)
        return processor.renderMarkdown(markdown)
    }
    
    private func render(#HTML: String) -> NSAttributedString {
        let documentAttributes: AutoreleasingUnsafeMutablePointer<NSDictionary?> = AutoreleasingUnsafeMutablePointer()
        let HTMLData = HTML.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
        let attributedString = NSAttributedString(HTML: HTMLData, options:nil, documentAttributes: documentAttributes)!
        return attributedString
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
            | HOEDOWN_HTML_ESCAPE.value
        )
    }
}