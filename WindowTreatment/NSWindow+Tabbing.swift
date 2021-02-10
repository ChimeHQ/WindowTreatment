//
//  NSWindow+Tabbing.swift
//  WindowTreatment
//
//  Created by Matt Massicotte on 2019-05-10.
//  Copyright © 2019 Chime Systems Inc. All rights reserved.
//

import Cocoa

extension NSWindow {
    public var isTabBarVisible: Bool {
        if #available(OSX 10.13, *) {
            // be extremely careful here. Just *accessing* the tabGroup property can
            // affect NSWindow's tabbing behavior
            if tabbedWindows == nil {
                return false
            }
            
            return tabGroup?.isTabBarVisible ?? false
        } else {
            return false
        }
    }
}
