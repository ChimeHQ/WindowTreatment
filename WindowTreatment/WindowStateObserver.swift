//
//  WindowStateObserver.swift
//  WindowTreatment
//
//  Created by Matt Massicotte on 2019-05-29.
//  Copyright © 2019 Chime Systems Inc. All rights reserved.
//

import Cocoa

extension NSWindow {
    static var tabStateDidChangeNotification = Notification.Name("windowTabStateDidChangeNotification")
}

public class WindowStateObserver {
    public struct State: Hashable {
        public var isMain: Bool
        public var isKey: Bool
        public var tabBarVisible: Bool
        public var tabCount: Int
        
        init(window: NSWindow?) {
            self.isMain = window?.isMainWindow ?? false
            self.isKey = window?.isKeyWindow ?? false
            
            // use of this property is essential
            self.tabBarVisible = window?.isTabBarVisible ?? false
            
            if #available(macOS 10.12, *) {
                self.tabCount = window?.tabbedWindows?.count ?? 0
            } else {
                self.tabCount = 0
            }
        }
        
        public var isKeyOrMain: Bool {
            return isMain || isKey
        }
        
        public var tabbed: Bool {
            return tabBarVisible && tabCount > 1
        }
        
        public func tabStateEqual(to other: State) -> Bool {
            return tabBarVisible == other.tabBarVisible && tabCount == other.tabCount
        }
    }
    
    public typealias ObserverBlock = (State, State) -> Void

    public var block: ObserverBlock?

    private var tabbedWindowsObservation: NSKeyValueObservation?
    private var lastState: State
    
    public init() {
        self.lastState = State(window: nil)
    }

    public convenience init(block: @escaping ObserverBlock) {
        self.init()

        self.block = block
    }

    deinit {
        deregisterForWindowNotifications()
    }

    private func registerForWindowNotifications(_ window: NSWindow) {
        let center = NotificationCenter.default

        center.addObserver(self,
                           selector: #selector(windowStateChange(_:)),
                           name: NSWindow.didBecomeMainNotification,
                           object: window)
        center.addObserver(self,
                           selector: #selector(windowStateChange(_:)),
                           name: NSWindow.didResignMainNotification,
                           object: window)

        center.addObserver(self,
                           selector: #selector(windowStateChange(_:)),
                           name: NSWindow.didBecomeKeyNotification,
                           object: window)
        center.addObserver(self,
                           selector: #selector(windowStateChange(_:)),
                           name: NSWindow.didResignKeyNotification,
                           object: window)

        // listen to all windows, as some tab changes are only reported to the current window
        // and not to siblings
        center.addObserver(self,
                           selector: #selector(windowStateChange(_:)),
                           name: NSWindow.tabStateDidChangeNotification,
                           object: nil)

        if #available(macOS 10.12, *) {
            self.tabbedWindowsObservation = window.observe(\.tabbedWindows, options: [], changeHandler: { [unowned self] (obj, _) in
                self.handlePossibleStateChange(for: obj, forward: true)
            })
        }
    }

    private func deregisterForWindowNotifications() {
        let center = NotificationCenter.default

        center.removeObserver(self, name: NSWindow.didResignMainNotification, object: nil)
        center.removeObserver(self, name: NSWindow.didBecomeMainNotification, object: nil)
        center.removeObserver(self, name: NSWindow.didResignKeyNotification, object: nil)
        center.removeObserver(self, name: NSWindow.didBecomeKeyNotification, object: nil)
        center.removeObserver(self, name: NSWindow.tabStateDidChangeNotification, object: nil)
        
        self.tabbedWindowsObservation = nil
    }

    public func observe(window: NSWindow?) {
        deregisterForWindowNotifications()

        if let win = window {
            registerForWindowNotifications(win)
        }
    }

    @objc private func windowStateChange(_ notification: Notification) {
        let window = notification.object as! NSWindow
        
        handlePossibleStateChange(for: window, forward: false)
    }
        
    private func handlePossibleStateChange(for window: NSWindow, forward: Bool) {
        let newState = State(window: window)
        
        if lastState == newState {
            return
        }
        
        block?(lastState, newState)
        
        lastState = newState
        
        if forward && lastState.tabStateEqual(to: newState) == false {
            // use this notification to inform other observers that their tabbing state may have changed
            // as well
            NotificationCenter.default.post(name: NSWindow.tabStateDidChangeNotification, object: window)
        }
    }
}
