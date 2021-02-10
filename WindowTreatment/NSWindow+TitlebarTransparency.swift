//
//  NSWindow+TitlebarTransparency.swift
//  WindowTreatment
//
//  Created by Matt Massicotte on 2019-05-10.
//  Copyright © 2019 Chime Systems Inc. All rights reserved.
//

import Cocoa

extension NSWindow {
    public var titlebarTransparentWithFullSizeContent: Bool {
        get {
            return titlebarAppearsTransparent && usesFullSizeContentView
        }
        set {
            // This is subtle, but just touching titlebarAppearsTransparent,
            // even to set it to its existing value, can affect other
            // window behavior (like tabbing) during this runtime loop.
            if titlebarAppearsTransparent == newValue {
                return
            }

            let currentHeight = titleBarHeight
            
            titlebarAppearsTransparent = newValue
            usesFullSizeContentView = newValue
            
            // if we are removing transparency, AppKit will
            // change the window height. This adjustment keeps
            // things looking the same
            if newValue == false {
                let delta = currentHeight - titleBarHeight

                adjustFrameHeight(using: delta)
            }
        }
    }

    private func adjustFrameHeight(using delta: CGFloat) {
        guard delta != 0.0 else { return }
        
        let rect = frame
        let newFrame = NSRect(x: rect.origin.x,
                              y: rect.origin.y,
                              width: rect.width,
                              height: rect.height - delta)

        setFrame(newFrame, display: false)
    }
    
    public var usesFullSizeContentView: Bool {
        get {
            return styleMask.contains(.fullSizeContentView)
        }
        set {
            if newValue {
                styleMask = styleMask.union(.fullSizeContentView)
            } else {
                styleMask = styleMask.subtracting(.fullSizeContentView)
            }
        }
    }
}
