//
//  WindowStateAwareView.swift
//  WindowTreatment
//
//  Created by Matt Massicotte on 2019-05-29.
//  Copyright © 2019 Chime Systems Inc. All rights reserved.
//

import Cocoa

open class WindowStateAwareView: NSView {
    private lazy var observer = WindowStateObserver { [unowned self] (oldState, newState) in
        if oldState.isKey != newState.isKey {
            windowKeyStateChanged()
        }
        
        if oldState.isMain != newState.isMain {
            windowMainStateChanged()
        }
    }

    override open func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()

        observer.observe(window: window)
    }

    open func windowMainStateChanged() {
        // for subclasses
    }

    open func windowKeyStateChanged() {
        // for subclasses
    }
}
