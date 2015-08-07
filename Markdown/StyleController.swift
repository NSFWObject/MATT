//
//  StyleController.swift
//  Markdown
//
//  Created by Sash Zats on 8/6/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import Foundation

enum Style {
    case None
    case File(String, NSURL)
}

struct StyleController {
    private var preferencesController: PreferencesController

    var selectedStyle: Style {
        didSet {
            switch selectedStyle {
            case .None:
                preferencesController.styleName = nil
            case .File(let name, let URL):
                preferencesController.styleName = name
            }
        }
    }
    let bundledStyles: [Style]
    
    init() {
        let bundle = NSBundle.mainBundle()
        let preferences = PreferencesController()
        let selectedStyleName = preferences.styleName

        self.selectedStyle = .None
        var bundledStyles: [Style] = [.None]
        if let URLs = bundle.URLsForResourcesWithExtension("css", subdirectory: "CSS") as? [NSURL] {
            for URL in URLs {
                if let fileName = URL.fileName {
                    let style: Style = .File(fileName, URL)
                    bundledStyles.append(style)
                    if selectedStyleName == fileName {
                        self.selectedStyle = style
                    }
                }
            }
        }
        
        self.bundledStyles = bundledStyles
        self.preferencesController = preferences
    }
}

extension Style: Equatable {
}

func ==(lhs: Style, rhs: Style) -> Bool {
    switch (lhs, rhs) {
    case (.None, .None):
        return true
    case (.File(let fileName1, let URL1), .File(let fileName2, let URL2)):
        return fileName1 == fileName2 && URL1 == URL2
    default:
        return false
    }
}