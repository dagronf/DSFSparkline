//
//  File.swift
//
//
//  Created by Darren Ford on 3/2/21.
//

#if os(macOS)
import Cocoa
#else
import UIKit
#endif

@objc public class DSFSparklineOverlay: CALayer {
	override public init() {
		super.init()
		self.anchorPoint = CGPoint(x: 0, y: 0)
		self.isOpaque = false
	}

	override public init(layer: Any) {
		super.init(layer: layer)
		self.anchorPoint = CGPoint(x: 0, y: 0)
		self.isOpaque = false
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.anchorPoint = CGPoint(x: 0, y: 0)
		self.isOpaque = false
	}

	open func drawGraph(context: CGContext, bounds: CGRect, hostedIn view: DSFView) -> CGRect {
		fatalError("must be implemented in overridden classes")
	}
}

@objc public class DSFSparklineDataSourceOverlay: DSFSparklineOverlay {
	/// The datasource for displaying the overlay
	@objc public var dataSource: DSFSparklineDataSource? {
		didSet {
			self.updateDataObserver()
		}
	}

	/// Should the graph be centered at the zero line?
	@objc public var centeredAtZeroLine: Bool = false {
		didSet {
			self.setNeedsDisplay()
		}
	}

	/// The value of the 'zero line' for this graph.
	@objc public var zeroLineValue: CGFloat = 0.0 {
		didSet {
			self.setNeedsDisplay()
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

	@objc public init(dataSource: DSFSparklineDataSource? = nil,
							zeroLineValue: CGFloat = 0.0)
	{
		self.dataSource = dataSource
		self.zeroLineValue = zeroLineValue
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
