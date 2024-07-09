//
//  NSWindow+Animation.swift
//  WindowTreatment
//
//  Created by Matt Massicotte on 2019-05-10.
//  Copyright © 2019 Chime Systems Inc. All rights reserved.
//

import Cocoa

extension NSWindow {
    public func withAnimationDisabled(block: @MainActor () -> Void) {
        let currentBehavior = animationBehavior

        animationBehavior = .none

        block()

		DispatchQueue.main.async {
            self.animationBehavior = currentBehavior
        }
    }
}
