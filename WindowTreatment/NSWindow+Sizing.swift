//
//  NSWindow+Sizing.swift
//  WindowTreatment
//
//  Created by Matt Massicotte on 2019-05-10.
//  Copyright © 2019 Chime Systems Inc. All rights reserved.
//

import Cocoa

extension NSWindow {
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
