import SwiftUI

public struct TabBarState: Hashable, Sendable {
	public let isVisible: Bool
	public let tabCount: Int
}

@available(macOS 11.0, *)
public struct WindowTabBarStateKey: EnvironmentKey {
	public static let defaultValue = TabBarState(isVisible: false, tabCount: 0)
}

@available(macOS 11.0, *)
extension EnvironmentValues {
	public var windowTabBarState: TabBarState {
		get { self[WindowTabBarStateKey.self] }
		set { self[WindowTabBarStateKey.self] = newValue }
	}
}

@available(macOS 11.0, *)
final class WindowObserverModel: ObservableObject {
	private let observer = WindowStateObserver()
	@Published var windowState = WindowStateObserver.State(window: nil)

	var tabBarState: TabBarState {
		TabBarState(isVisible: windowState.tabBarVisible, tabCount: windowState.tabCount)
	}

	init() {
		self.observer.block = { [weak self] in
			self?.windowState = $1
		}
	}

	func observe(window: NSWindow?) {
		observer.observe(window: window)
	}
}

@available(macOS 11.0, *)
struct WindowTabBarStateObservingModifier: ViewModifier {
	@StateObject private var observer = WindowObserverModel()

	func body(content: Content) -> some View {
		content
			.environment(\.windowTabBarState, observer.tabBarState)
			.background(WindowObservingView { observer.observe(window:$0) })
	}
}

@available(macOS 11.0, *)
extension View {
	/// Puts the parent window's `windowTabBarState` into the environment.
	public func observeWindowTabBarState() -> some View {
		modifier(WindowTabBarStateObservingModifier())
	}
}
