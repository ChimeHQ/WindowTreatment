//
//  WindowTitlebarAwareView.swift
//  WindowTreatment
//
//  Created by Matt Massicotte on 2019-05-10.
//  Copyright © 2019 Chime Systems Inc. All rights reserved.
//

import Cocoa

public class WindowTitlebarAwareView: WindowStateAwareView {
    private let containerView: NSView
    private var topContraint: NSLayoutConstraint?
    
    public var ignoreTabBar = false {
        didSet {
            needsLayout = true
        }
    }

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
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    public var contentView: NSView? {
        get {
            return containerView.subviews.first
        }
        set {
            installNewContent(newValue)
        }
    }

    private func installNewContent(_ contentView: NSView?) {
		guard let contentView = contentView else {
			containerView.subviews = []
			return
		}

		containerView.subviews = [contentView]
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: containerView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])
    }
    
    override public func updateConstraints() {
        if let window = window {
            createLayoutGuideConstraint(for: window)
        }

        super.updateConstraints()
    }

    private func createLayoutGuideConstraint(for window: NSWindow) {
        topContraint?.isActive = false

        if ignoreTabBar && window.isTabBarVisible {
            let offset = window.titleBarHeight - window.tabBarHeight

            topContraint = containerView.topAnchor.constraint(equalTo: topAnchor, constant: offset)
        } else {
            let contentLayoutGuide = window.contentLayoutGuide as AnyObject

            topContraint = containerView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor)
        }

        topContraint!.isActive = true
    }
    
    public override func windowTabStateChanged() {
        // this is awkward, but the tab state isn't always established when contraints are updated
        // by default
        if ignoreTabBar {
            self.needsUpdateConstraints = true
        }
    }
}
