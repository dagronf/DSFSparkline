//
//  File.swift
//
//
//  Created by Darren Ford on 3/2/21.
//

import QuartzCore

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
