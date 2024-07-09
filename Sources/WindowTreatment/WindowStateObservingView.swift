import Cocoa
import SwiftUI

@available(macOS 10.15, *)
public struct WindowStateKey: EnvironmentKey {
    public static let defaultValue: WindowStateObserver.State = .init()
}

@available(macOS 10.15, *)
public extension EnvironmentValues {
    var windowState: WindowStateObserver.State {
        get { self[WindowStateKey.self] }
        set { self[WindowStateKey.self] = newValue }
    }
}

@available(macOS 10.15, *)
struct WindowStateObservingView<Content: View>: NSViewRepresentable {
    private typealias WindowState = WindowStateObserver.State

    @State private var windowState: WindowState = .init()
    private let content: Content

    init(content: () -> Content) {
        self.content = content()
    }

    var envContent: some View {
        return content
            .environment(\.windowState, windowState)
    }

    func makeNSView(context: Context) -> WindowStateAwareView {
        let view = WindowStateAwareView()

        let hostingView = NSHostingView(rootView: envContent)

        view.subviews = [hostingView]
		hostingView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            hostingView.topAnchor.constraint(equalTo: view.topAnchor),
			hostingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			hostingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        view.stateChangeHandler = {
            self.windowState = $1
        }

        return view
    }

    func updateNSView(_ nsView: WindowStateAwareView, context: Context) {
        let subview = nsView.subviews.first

        // this allows us to avoid knowing the generic type within NSHostingView
        (subview as? NSHostingView)?.rootView = envContent
    }
}

@available(macOS 10.15, *)
struct WindowStateObserving: ViewModifier {
    func body(content: Content) -> some View {
        WindowStateObservingView {
            content
        }
    }
}

@available(macOS 10.15, *)
public extension View {
	/// This makes WindowStateKey available in the environment
	@available(*, deprecated, message: "Please migrate to observeWindowState")
    func windowStateEnvironment() -> some View {
        modifier(WindowStateObserving())
    }
}
