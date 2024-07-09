//
//  ApplicationWindowState.swift
//  WindowTreatment
//
//  Created by Matt Massicotte on 2019-11-08.
//  Copyright © 2019 Chime Systems Inc. All rights reserved.
//

import Cocoa

@MainActor
public class ApplicationWindowState {
    private var lastWindowListHash: Int
    private var lastMainWindowHash: Int

    public var changeHandler: (() -> Void)?

    public init() {
        self.lastWindowListHash = 0
        self.lastMainWindowHash = 0

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(windowWillCloseNotification(_:)),
                                               name: NSWindow.willCloseNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(mainWindowChangedNotification(_:)),
                                               name: NSWindow.didBecomeMainNotification,
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func mainWindowChangedNotification(_ notification: NSNotification) {
        deliverChangeNotificationIfNeeded()
    }

    @objc private func windowWillCloseNotification(_ notification: NSNotification) {
        // The reason for the async thing here is because this notification tells
        // you which window *will* close, but it is currently still in the current list.
		DispatchQueue.main.async {
            self.deliverChangeNotificationIfNeeded()
        }
    }

    private func deliverChangeNotificationIfNeeded() {
        // Set would be nicer, but need weak referencing
        let windowListHash = currentWindows.hashValue
        let mainWindowHash = mainWindow.hashValue

        // filter out duplicates
        if lastWindowListHash == windowListHash && lastMainWindowHash == mainWindowHash {
            return
        }

        lastMainWindowHash = mainWindowHash
        lastWindowListHash = windowListHash

        self.changeHandler?()
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
