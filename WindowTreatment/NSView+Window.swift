//
//  NSView+Window.swift
//  WindowTreatment
//
//  Created by Matt Massicotte on 2019-05-29.
//  Copyright © 2019 Chime Systems Inc. All rights reserved.
//

import Cocoa

extension NSView {
    /// Convenience accessor for window?.isMainWindow
    ///
    /// This method returns false if the receiver does not belong to a window view hierarchy.
    public var windowIsMain: Bool {
        return window?.isMainWindow ?? false
    }

    /// Convenience accessor for window?.windowIsKey
    ///
    /// This method returns false if the receiver does not belong to a window view hierarchy.
    public var windowIsKey: Bool {
        return window?.isKeyWindow ?? false
    }
}
