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

public final class WindowStateObserver {
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
    private var currentState: State
    private weak var observingWindow: NSWindow?
    
    public init() {
        self.currentState = State(window: nil)
    }

    public convenience init(block: @escaping ObserverBlock) {
        self.init()

        self.block = block
    }

    deinit {
        deregisterForWindowNotifications()
    }

    private func registerForWindowNotifications(_ window: NSWindow) {
        if (window.canBecomeKey || window.canBecomeMain) == false {
            print("Warning: WindowStateObserver is monitoring a window that cannot become key or main")
        }

        self.observingWindow = window
        
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

        // While this API is actually available in 10.12, observing this will reliably cause crashes in 10.14...
        if #available(macOS 10.15, *) {
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
        self.observingWindow = nil
    }

    public func observe(window: NSWindow?) {
        deregisterForWindowNotifications()

        if let win = window {
            registerForWindowNotifications(win)
        }
    }

    @objc private func windowStateChange(_ notification: Notification) {
        guard let window = notification.object as? NSWindow else { return }
        guard let observingWindow = observingWindow else { return }
        
        // this is a very important check to prevent recursion
        let tabStateChange = notification.name == NSWindow.tabStateDidChangeNotification
        
        if tabStateChange && observingWindow === window {
            return
        }
        
        handlePossibleStateChange(for: observingWindow, forward: tabStateChange == false)
    }
    
    private func handlePossibleStateChange(for window: NSWindow, forward: Bool) {
        precondition(window === observingWindow)
        
        let newState = State(window: window)
        
        if currentState == newState {
            return
        }
        
        let lastState = currentState
        currentState = newState
        
        // make certain to update the currentState *before* invoking the block
        
        block?(lastState, newState)
        
        let tabStateChange = lastState.tabStateEqual(to: newState) == false
        if forward && tabStateChange {
            // use this notification to inform other observers that their tabbing state may have changed
            // as well. Also, careful as we will recieve this notification ourselves, so
            // we have to be sure it will not cause recursion.
            NotificationCenter.default.post(name: NSWindow.tabStateDidChangeNotification, object: window)
        }
    }
}
