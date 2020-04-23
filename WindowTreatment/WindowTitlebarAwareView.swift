//
//  WindowTitlebarAwareView.swift
//  WindowTreatment
//
//  Created by Matt Massicotte on 2019-05-10.
//  Copyright © 2019 Chime Systems Inc. All rights reserved.
//

import Cocoa

public class WindowTitlebarAwareView: NSView {
    private let containerView: NSView
    private var titlebarConstraint: NSLayoutConstraint?

    public init() {
        self.containerView = NSView()

        super.init(frame: NSRect.zero)

        setupView()
    }

    required init?(coder decoder: NSCoder) {
        self.containerView = NSView()

        super.init(coder: decoder)

        setupView()
    }

    private func setupView() {
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }

    public var contentView: NSView? {
        willSet {
            removeOldContent()
        }
        didSet {
            installNewContent()
        }
    }

    private func removeOldContent() {
        guard let view = contentView else {
            return
        }

        for subview in view.subviews {
            subview.removeFromSuperview()
        }
    }

    private func installNewContent() {
        guard let view = contentView else {
            return
        }

        containerView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            view.topAnchor.constraint(equalTo: containerView.topAnchor),
            view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])
    }
}

extension WindowTitlebarAwareView {
    override public func updateConstraints() {
        if let window = self.window {
            createLayoutGuideConstraint(for: window)
        }

        super.updateConstraints()
    }

    private func createLayoutGuideConstraint(for window: NSWindow) {
        titlebarConstraint?.isActive = false

        let contentLayoutGuide = window.contentLayoutGuide as AnyObject

        titlebarConstraint = containerView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor)
        titlebarConstraint!.isActive = true
    }
}
