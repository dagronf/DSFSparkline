//
//  File.swift
//
//
//  Created by Darren Ford on 3/2/21.
//

import QuartzCore


/// The core sparkline overlay class.
///
/// All sparkline renderers must inherit from this class
@objc public class DSFSparklineOverlay: CALayer {
	override public init() {
		super.init()
		self.configure()
	}

	override public init(layer: Any) {
		super.init(layer: layer)
		self.configure()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.configure()
	}

	private func configure() {
		self.anchorPoint = CGPoint(x: 0, y: 0)
		self.isOpaque = false

		// Disable the implicit animations on the layer to stop the fade when data changes
		let newActions = [
			"onOrderIn": NSNull(),
			"onOrderOut": NSNull(),
			"sublayers": NSNull(),
			"contents": NSNull(),
			"bounds": NSNull(),
		]

		self.actions = newActions
	}

	/// To be overridden by sub-classes to draw their content into the provided context
	open func drawGraph(context: CGContext, bounds: CGRect, scale: CGFloat) -> CGRect {
		fatalError("must be implemented in overridden classes")
	}
}
