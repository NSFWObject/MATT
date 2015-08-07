//
//  StylePreferencesViewController.swift
//  
//
//  Created by Sash Zats on 8/6/15.
//
//

import AppKit


class StylePreferencesController: NSObject {
   
    var styleController: StyleController
    let popupButton: NSPopUpButton
    
    init(styleController: StyleController, popupButton: NSPopUpButton) {
        self.popupButton = popupButton
        self.styleController = StyleController()
        super.init()
        setupStyleDropdownMenu(popupButton: popupButton)
    }
    
    private func setupStyleDropdownMenu(#popupButton: NSPopUpButton) {
        let menu = NSMenu()
        for style in styleController.bundledStyles {
            let wrapper = StyleWrapper(style: style)
            let menuItem: NSMenuItem
            switch style {
            case .None:
                menuItem = NSMenuItem(title: "None", action: Selector("styleMenuAction:"), keyEquivalent: "")
                menuItem.target = self
                menuItem.representedObject = wrapper
            case .File(let fileName, let URL):
                menuItem = NSMenuItem(title: fileName, action: Selector("styleMenuAction:"), keyEquivalent: "")
                menuItem.target = self
                menuItem.representedObject = wrapper
            }
            menuItem.state = styleController.selectedStyle == style ? NSOnState : NSOffState
            menu.addItem(menuItem)
        }
        popupButton.menu = menu
    }
    
    @IBAction private func styleMenuAction(menu: NSMenuItem) {
        if let wrapper = menu.representedObject as? StyleWrapper {
            styleController.selectedStyle = wrapper.style
        }
    }
    
}

private class StyleWrapper {
    private let style: Style
    private init(style: Style) {
        self.style = style
    }
}
