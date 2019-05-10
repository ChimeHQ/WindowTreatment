//
//  NSWindow+TitlebarTransparency.swift
//  WindowTreatment
//
//  Created by Matt Massicotte on 2019-05-10.
//  Copyright © 2019 Chime Systems Inc. All rights reserved.
//

import Foundation

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

            titlebarAppearsTransparent = newValue
            usesFullSizeContentView = newValue
        }
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
