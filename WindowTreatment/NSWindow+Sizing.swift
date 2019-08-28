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
        let minWindowSize = NSMakeSize(800, 600)
        let maxWindowSize = NSMakeSize(1024, 900)
        let fraction: CGFloat = 0.6

        let screenSize = NSScreen.main?.visibleFrame.size ?? minWindowSize

        let width = min(screenSize.width * fraction, maxWindowSize.width)
        let height = min(screenSize.height * fraction, maxWindowSize.height)

        setContentSize(NSSize(width: ceil(width), height: ceil(height)))
    }
}
