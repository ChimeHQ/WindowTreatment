//
//  NSView+Window.swift
//  WindowTreatment
//
//  Created by Matt Massicotte on 2019-05-29.
//  Copyright © 2019 Chime Systems Inc. All rights reserved.
//

import Foundation

extension NSView {
    public var windowIsMain: Bool {
        return window?.isMainWindow ?? false
    }

    public var windowIsKey: Bool {
        return window?.isKeyWindow ?? false
    }
}
