//
//  WindowTitlebarAwareViewTests.swift
//  WindowTreatmentTests
//
//  Created by Matt Massicotte on 2020-04-23.
//  Copyright © 2020 Chime Systems Inc. All rights reserved.
//

import XCTest
@testable import WindowTreatment

final class WindowTitlebarAwareViewTests: XCTestCase {
	@MainActor
    func testCreateViewInWindowWithVisibleTitlebar() {
        let view = WindowTitlebarAwareView()
        let contentView = NSView()
        view.contentView = contentView

        let window = NSWindow()
        window.titleVisibility = .visible
        window.contentView = view

        let rect = NSRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
        window.setFrame(rect, display: false)

        XCTAssert(window.contentLayoutRect.height < 100.0)
        XCTAssertEqual(window.contentLayoutRect.width, rect.width)
        XCTAssertEqual(contentView.frame, window.contentLayoutRect)
    }

	@MainActor
    func testCreateViewInWindowWithInvisibleTitlebar() {
        let view = WindowTitlebarAwareView()
        let contentView = NSView()
        view.contentView = contentView

        let window = NSWindow(contentRect: .zero, styleMask: [.fullSizeContentView], backing: .buffered, defer: true)
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.contentView = view

        let rect = NSRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
        window.setFrame(rect, display: false)

        XCTAssertEqual(window.contentLayoutRect.height, rect.height)
        XCTAssertEqual(window.contentLayoutRect.width, rect.width)
        XCTAssertEqual(contentView.frame, window.contentLayoutRect)
    }
}
