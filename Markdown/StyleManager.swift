//
//  StyleManager.swift
//  Markdown
//
//  Created by Sash Zats on 7/28/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import Foundation
import Mustache

struct StyleManager {
    
    static var DefaultStyle: String = {
        let URL = NSBundle.mainBundle().URLForResource("default-style", withExtension: "css")!
        let style = String(contentsOfURL: URL, encoding: NSUTF8StringEncoding, error: nil)!
        return style
    }()
    
    static var DefaultTemplate: Template = {
        let URL = NSBundle.mainBundle().URLForResource("Template", withExtension: "mustache")!
        let contents = String(contentsOfURL: URL, encoding: NSUTF8StringEncoding, error: nil)!
        return Template(string: contents)!
    }()
    
    func process(#content: String, template: Template = DefaultTemplate, CSS: String = DefaultStyle) -> String? {
        let arguments = [
            "title": "MATT",
            "style": CSS,
            "content":  content
        ]
        return template.render(Box(arguments))
    }
}
