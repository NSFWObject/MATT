//
//  ResetablePreferenaces.swift
//  Markdown
//
//  Created by Sash Zats on 8/10/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

import Foundation

protocol ResettablePreferences {
    // TODO: refactor defaults into a protocol
    func reset(storage: NSUserDefaults)
}
