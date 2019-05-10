//
//  NSWindow+Animation.swift
//  WindowTreatment
//
//  Created by Matt Massicotte on 2019-05-10.
//  Copyright © 2019 Chime Systems Inc. All rights reserved.
//

import Foundation

extension NSWindow {
    public func withAnimationDisabled(block: () -> Void) {
        let currentBehavior = animationBehavior

        animationBehavior = .none

        block()

        OperationQueue.main.addOperation {
            self.animationBehavior = currentBehavior
        }
    }
}
