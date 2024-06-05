import AppKit

private extension NSWindow {
    /// Key of double click action. It can be customized in macOS System Settings app within the Dock subsettings.
    static let actionOnDoubleClickKey: String = "AppleActionOnDoubleClick"
    /// Value of zoom action for the ``actionOnDoubleClickKey`` key typically set by the macOS System Settings app.
    static let zoomActionOnDoubleClickValue: String = "Maximize"
    /// Value of minimize action for the ``actionOnDoubleClickKey`` key typically set by the macOS System Settings app.
    static let miniaturizeActionOnDoubleClickValue: String = "Minimize"
}

/// Simple NSWindow subclass honoring the titlebar double click action from the macOS System Settings app.
open class TitlebarClickAwareWindow: NSWindow {
    override open func mouseDown(with event: NSEvent) {
        if event.clickCount > 1, isEventLocationEligible(event.locationInWindow) {
            zoomOrMiniaturize(self)
        }
        super.mouseDown(with: event)
    }
}

private extension TitlebarClickAwareWindow {
    func isEventLocationEligible(_ location: CGPoint) -> Bool {
        guard let windowFrame = contentView?.frame else {
            return false
        }
        var titleBarRect = contentLayoutRect
        titleBarRect.origin.y += contentLayoutRect.height
        titleBarRect.size.height = windowFrame.height - contentLayoutRect.height
        return titleBarRect.contains(location)
    }

    func zoomOrMiniaturize(_ sender: Any?) {
        let actionOnDoubleClickValue = UserDefaults.standard.string(forKey: Self.actionOnDoubleClickKey)

        switch actionOnDoubleClickValue {
        case Self.zoomActionOnDoubleClickValue:
            zoom(sender)
        case Self.miniaturizeActionOnDoubleClickValue:
            miniaturize(sender)
        default:
            zoom(sender)
        }
    }
}
