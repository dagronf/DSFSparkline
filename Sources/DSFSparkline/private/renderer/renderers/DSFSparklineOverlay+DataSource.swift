//
//  File.swift
//
//
//  Created by Darren Ford on 3/2/21.
//

import QuartzCore

@objc public class DSFSparklineDataSourceOverlay: DSFSparklineOverlay {
	/// The datasource for displaying the overlay
	@objc public var dataSource: DSFSparklineDataSource? {
		didSet {
			self.updateDataObserver()
		}
	}

	// Listen for changes in the data and update appropriately
	private var dataObserver: NSObjectProtocol?

	private func updateDataObserver() {
		self.dataObserver = nil
		if let datasource = self.dataSource {
			self.dataObserver = NotificationCenter.default.addObserver(
				forName: DSFSparklineDataSource.DataChangedNotification,
				object: datasource,
				queue: nil, using: { [weak self] _ in
					self?.setNeedsDisplay()
				}
			)
		}
	}

	@objc public init(dataSource: DSFSparklineDataSource? = nil) {
		self.dataSource = dataSource
		super.init()
	}

	override public init(layer: Any) {
		super.init(layer: layer)
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	deinit {
		self.dataObserver = nil
		self.dataSource = nil
	}
}
