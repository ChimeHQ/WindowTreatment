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
            self.windowKeyStateChanged()
        }
        
        if oldState.isMain != newState.isMain {
            self.windowMainStateChanged()
        }
        
        if oldState.tabStateEqual(to: newState) == false {
            self.windowTabStateChanged()
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
    
    open func windowTabStateChanged() {
        // for subclasses
    }
}
