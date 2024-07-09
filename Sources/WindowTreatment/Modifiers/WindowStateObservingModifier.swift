import SwiftUI

@available(macOS 11.0, *)
@MainActor
final class WindowObserverModel: ObservableObject {
	private let observer = WindowStateObserver()
	@Published var windowState = WindowStateObserver.State(window: nil)

	init() {
		self.observer.block = { [weak self] in self?.windowState = $1 }
	}

	func observe(window: NSWindow?) {
		observer.observe(window: window)
	}
}

@available(macOS 11.0, *)
struct WindowStateObservingModifier: ViewModifier {
	@StateObject private var observer = WindowObserverModel()

	func body(content: Content) -> some View {
		content
			.environment(\.windowState, observer.windowState)
			.background(WindowObservingView { observer.observe(window:$0) })
	}
}

@available(macOS 11.0, *)
extension View {
	/// Puts the parent window's `WindowStateObserver.State` into the environment.
	///
	/// This makes the state available in child views. It is accessible via the `.windowState` environment key.
	@MainActor
	public func observeWindowState() -> some View {
		modifier(WindowStateObservingModifier())
	}
}
