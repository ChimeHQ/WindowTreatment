import Cocoa

open class WindowStateAwareView: NSView {
    public typealias StateChangeHandler = (WindowStateObserver.State, WindowStateObserver.State) -> Void

    public var stateChangeHandler: StateChangeHandler? = nil

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

        self.stateChangeHandler?(oldState, newState)
    }

    override open func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()

        observer.observe(window: window)
    }

    /// Override this method to react to main state changes
    open func windowMainStateChanged() {
        // for subclasses
    }

    /// Override this method to react to key state changes
    open func windowKeyStateChanged() {
        // for subclasses
    }

    /// Override this method to react to tab state changes
    open func windowTabStateChanged() {
        // for subclasses
    }
}
