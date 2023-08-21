import SwiftUI

final class HostWindowChangedView: NSView {
	typealias Handler = (NSWindow?) -> ()

	let handler: Handler

	init(handler: @escaping Handler) {
		self.handler = handler

		super.init(frame: .zero)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewWillMove(toWindow newWindow: NSWindow?) {
		super.viewWillMove(toWindow: newWindow)

		handler(newWindow)
	}
}

@available(macOS 10.15, *)
struct WindowObservingView: NSViewRepresentable {
	let handler: HostWindowChangedView.Handler

	func makeNSView(context: Self.Context) -> NSView {
		let view = HostWindowChangedView(handler: handler)

		view.translatesAutoresizingMaskIntoConstraints = false

		return view
	}

	func updateNSView(_ nsView: NSView, context: Context) {
	}
}

@available(macOS 10.15, *)
public struct WindowKey: EnvironmentKey {
	public static let defaultValue: NSWindow? = nil
}

@available(macOS 10.15, *)
extension EnvironmentValues {
	public var window: NSWindow? {
		get { self[WindowKey.self] }
		set { self[WindowKey.self] = newValue }
	}
}

@available(macOS 10.15, *)
struct WindowObservingViewModifier: ViewModifier {
	@State private var window: NSWindow?

	func body(content: Content) -> some View {
		content
			.environment(\.window, window)
			.background(WindowObservingView { self.window = $0 })
	}
}

@available(macOS 10.15, *)
extension View {
	/// Puts the view's parent `window` into the environment.
	///
	/// This makes the window available in child views. It is accessible via the `.window` environment key.
	public func observeCurrentWindow() -> some View {
		modifier(WindowObservingViewModifier())
	}
}
