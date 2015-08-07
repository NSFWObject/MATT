//
//  NSURLExtensions.swift
//  Markdown
//
//  Created by Sash Zats on 8/6/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import Foundation

extension NSURL {
    var fileName: String? {
        return self.lastPathComponent?.stringByDeletingPathExtension
    }
}
