//
//  WindowStateAwareView.swift
//  WindowTreatment
//
//  Created by Matt Massicotte on 2019-05-29.
//  Copyright © 2019 Chime Systems Inc. All rights reserved.
//

import Foundation

open class WindowStateAwareView: NSView {
    private lazy var observer = WindowStateObserver.init { [unowned self] (state) in
        switch state {
        case .becameMain, .resignedMain:
            self.windowMainStateChanged()
        case .becameKey, .resignedKey:
            self.windowKeyStateChanged()
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
