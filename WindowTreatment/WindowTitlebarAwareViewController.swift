//
//  WindowTitlebarAwareViewController.swift
//  WindowTreatment
//
//  Created by Matt Massicotte on 2019-05-10.
//  Copyright © 2019 Chime Systems Inc. All rights reserved.
//

import Foundation

public class WindowTitlebarAwareViewController: NSViewController {
    private let windowAwareView: WindowTitlebarAwareView

    public init() {
        self.windowAwareView = WindowTitlebarAwareView()

        super.init(nibName: nil, bundle: nil)
    }

    public convenience init(contentViewController: NSViewController) {
        self.init()

        self.contentViewController = contentViewController

        installView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func loadView() {
        self.view = windowAwareView
    }

    public var contentViewController: NSViewController? {
        didSet {
            installView()
        }
    }

    public var contentView: NSView? {
        get {
            return windowAwareView.contentView
        }
        set {
            windowAwareView.contentView = newValue
        }
    }
    private func installView() {
        contentView = contentViewController?.view
    }
}
