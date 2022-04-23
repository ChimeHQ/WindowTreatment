import AppKit

/// Simple NSWindow subclass that can control it's ability to become key and main.
open class CustomizableMainKeyWindow: NSWindow {
    public var canBecomeKeyValue: Bool = true
    public var canBecomeMainValue: Bool = true

    override open var canBecomeKey: Bool {
        return canBecomeKeyValue
    }

    override open var canBecomeMain: Bool {
        return canBecomeMainValue
    }
}
