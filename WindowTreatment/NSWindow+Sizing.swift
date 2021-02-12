//
//  NSWindow+Sizing.swift
//  WindowTreatment
//
//  Created by Matt Massicotte on 2019-05-10.
//  Copyright © 2019 Chime Systems Inc. All rights reserved.
//

import Cocoa

extension NSWindow {
    /// Make the receiver a sensible size, given the current screen
    ///
    /// This method attempts to size the window to match the current screen
    /// aspect ratio and dimensions. It will not exceed 1024 x 900.
    public func makeReasonableSize() {
        let minWindowSize = NSSize(width: 800, height: 600)
        let maxWindowSize = NSSize(width: 1024, height: 900)
        let fraction: CGFloat = 0.6

        let screenSize = NSScreen.main?.visibleFrame.size ?? minWindowSize

        let width = min(screenSize.width * fraction, maxWindowSize.width)
        let height = min(screenSize.height * fraction, maxWindowSize.height)

        setContentSize(NSSize(width: ceil(width), height: ceil(height)))
    }
    
    /// Returns the total titlebar height
    ///
    /// Takes into account the tab bar, as well as transparent title bars and
    /// full size content.
    public var titleBarHeight: CGFloat {
        let frameHeight = contentView?.frame.height ?? frame.height
        let contentLayoutRectHeight = contentLayoutRect.height

        return frameHeight - contentLayoutRectHeight
    }
    
    /// Returns the tab bar height
    ///
    /// This value will be zero if the tab bar is not visible
    public var tabBarHeight: CGFloat {
        // hard-coding this isn't excellent, but I don't know
        // of another way to determine it without messing around
        // with hidden windows.
        return isTabBarVisible ? 28.0 : 0.0
    }
}
