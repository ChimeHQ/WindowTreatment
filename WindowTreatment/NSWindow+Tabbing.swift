import Cocoa

extension NSWindow {
    /// Indicates the state of the window's tab bar
    public var isTabBarVisible: Bool {
        if #available(OSX 10.13, *) {
            // be extremely careful here. Just *accessing* the tabGroup property can
            // affect NSWindow's tabbing behavior
            if tabbedWindows == nil {
                return false
            }
            
            return tabGroup?.isTabBarVisible ?? false
        } else {
            return false
        }
    }
}
