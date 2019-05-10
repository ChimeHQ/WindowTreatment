//
//  NSWindow+Tabbing.swift
//  WindowTreatment
//
//  Created by Matt Massicotte on 2019-05-10.
//  Copyright © 2019 Chime Systems Inc. All rights reserved.
//

import Foundation

extension NSWindow {
    public var isTabBarVisible: Bool {
        if #available(OSX 10.13, *) {
            return tabGroup?.isTabBarVisible ?? false
        } else {
            return false
        }
    }
}
