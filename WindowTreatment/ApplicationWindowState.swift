//
//  ApplicationWindowState.swift
//  WindowTreatment
//
//  Created by Matt Massicotte on 2019-11-08.
//  Copyright © 2019 Chime Systems Inc. All rights reserved.
//

import Foundation

public class ApplicationWindowState {
    private var windows: Set<NSWindow>
    private var lastMainWindow: NSWindow?

    public var changeHandler: (() -> Void)?

    public init() {
        self.windows = Set()

        NotificationCenter.default.addObserver(self, selector: #selector(windowsChangedNotification(_:)), name: NSWindow.willCloseNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(windowsChangedNotification(_:)), name: NSWindow.didBecomeMainNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func windowsChangedNotification(_ notification: NSNotification) {
        let current = Set(currentWindows)

        if windows == current && mainWindow == lastMainWindow {
            return
        }

        windows = Set(current)
        lastMainWindow = mainWindow

        changeHandler?()
    }

    public var windowsMenu: NSMenu? {
        NSApp.windowsMenu
    }

    public var currentWindows: [NSWindow] {
        return NSApp.windows
    }

    public var mainWindow: NSWindow? {
        return NSApp.mainWindow
    }
}
