//
//  WindowStateObserver.swift
//  WindowTreatment
//
//  Created by Matt Massicotte on 2019-05-29.
//  Copyright © 2019 Chime Systems Inc. All rights reserved.
//

import Cocoa

public class WindowStateObserver {
    public enum StateChange {
        case becameKey
        case resignedKey
        case becameMain
        case resignedMain
    }

    public typealias ObserverBlock = (StateChange) -> Void

    public var block: ObserverBlock?

    public init() {
    }

    public convenience init(block: @escaping ObserverBlock) {
        self.init()

        self.block = block
    }

    deinit {
        deregisterForWindowNotifications()
    }

    private func registerFoWindowNotifications(_ window: NSWindow) {
        let center = NotificationCenter.default

        center.addObserver(self, selector: #selector(windowDidBecomeMain(_:)), name: NSWindow.didBecomeMainNotification, object: window)
        center.addObserver(self, selector: #selector(windowDidResignMain(_:)), name: NSWindow.didResignMainNotification, object: window)

        center.addObserver(self, selector: #selector(windowDidBecomeKey(_:)), name: NSWindow.didBecomeKeyNotification, object: window)
        center.addObserver(self, selector: #selector(windowDidResignKey(_:)), name: NSWindow.didResignKeyNotification, object: window)
    }

    private func deregisterForWindowNotifications() {
        let center = NotificationCenter.default

        center.removeObserver(self, name: NSWindow.didResignMainNotification, object: nil)
        center.removeObserver(self, name: NSWindow.didBecomeMainNotification, object: nil)
        center.removeObserver(self, name: NSWindow.didResignKeyNotification, object: nil)
        center.removeObserver(self, name: NSWindow.didBecomeKeyNotification, object: nil)

    }

    public func observe(window: NSWindow?) {
        deregisterForWindowNotifications()

        if let w = window {
            registerFoWindowNotifications(w)
        }
    }

    @objc private func windowDidBecomeMain(_ notification: Notification) {
        block?(StateChange.becameMain)
    }

    @objc private func windowDidResignMain(_ notification: Notification) {
        block?(StateChange.resignedMain)
    }

    @objc private func windowDidBecomeKey(_ notification: Notification) {
        block?(StateChange.becameKey)
    }

    @objc private func windowDidResignKey(_ notification: Notification) {
        block?(StateChange.resignedKey)
    }
}
