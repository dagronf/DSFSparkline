//
//  DSFSparklineOverlay+WiperGauge.swift
//  DSFSparklines
//
//  Copyright © 2023 Darren Ford. All rights reserved.
//
//  MIT license
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
//  documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial
//  portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
//  WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
//  OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
//  OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import Foundation
import QuartzCore

#if os(macOS)
import AppKit
#else
import UIKit
#endif

public extension DSFSparklineOverlay {
	/// A pie graph
	@objc(DSFSparklineOverlayWiperGauge) class WiperGauge: DSFSparklineOverlay.StaticDataSource {
		/// The palette to use when drawing the pie chart
		@objc public var valueColor: DSFSparkline.FillContainer = DSFSparkline.FillContainer.sharedPalette {
			didSet {
				self.updatePalette()
			}
		}

		/// The value to display in the gauge
		@objc public var value: CGFloat = 0.0 {
			didSet {
				let v = max(0, min(1, self.value))
				if animated {
					animate(to: v)
				}
				else {
					self.currentValue__ = v
				}
			}
		}

		/// The color to draw the dial and outer border
		@objc public var strokeColor: CGColor = _strokeColor {
			didSet {
				self.updatePalette()
			}
		}

		/// The color to draw the value in radial component
		@objc public var arcBackgroundColor: CGColor = _arcBackgroundColor {
			didSet {
				self.updatePalette()
			}
		}

		/// The color to draw in the background
		@objc public var wiperBackgroundColor: CGColor? = _wiperBackgroundColor

		/// Should changes to `value` be animated?
		@objc public var animated: Bool = false

		@objc public override init() {
			super.init()
			self.configure()
		}

		public override init(layer: Any) {
			guard let orig = layer as? Self else { fatalError() }
			self.valueColor = orig.valueColor.copyColorContainer()
			super.init(layer: layer)

			self.configure()
		}

		@available(*, unavailable)
		required init?(coder _: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}

		override func staticDataSourceDidChange() {
			super.staticDataSourceDidChange()
		}

		override internal func drawGraph(context: CGContext, bounds: CGRect, scale: CGFloat) {
			// Do nothing.  All the content is handled by layers
			return
		}

		// Private

		private let wiperBackgroundShape = CAShapeLayer()
		private let arcShape = CAShapeLayer()
		private let centroid = CAShapeLayer()
		private let arcInnerShape = CAShapeLayer()
		private let arcColorInnerShape = CAShapeLayer()
		private let arcline = CAShapeLayer()

		private var animator = ArbitraryAnimator()

		private var currentValue__: CGFloat = 0.0 {
			didSet {
				self.updatePalette()
				self.updateLayout()
			}
		}

		private static let _wiperBackgroundColor: CGColor? = nil

		#if os(macOS)
		private static let _strokeColor = NSColor.textColor.cgColor
		private static let _arcBackgroundColor = NSColor.quaternaryLabelColor.cgColor
		#else
		private static let _strokeColor = UIColor.label.cgColor
		private static let _arcBackgroundColor = UIColor.quaternaryLabel.cgColor
		#endif
	}
}

extension DSFSparklineOverlay.WiperGauge {
	private func configure() {

		self.isGeometryFlipped = true

		self.addSublayer(wiperBackgroundShape)
		wiperBackgroundShape.zPosition = -110

		self.addSublayer(arcShape)
		arcShape.zPosition = -100
		self.addSublayer(arcInnerShape)
		arcInnerShape.zPosition = -90
		self.addSublayer(arcColorInnerShape)
		arcColorInnerShape.zPosition = -80

		self.addSublayer(centroid)
		centroid.zPosition = -70
		self.addSublayer(arcline)
		arcline.zPosition = -80
	}

	private func updatePalette() {

		if self.valueColor.isPalette == false {
			// We want paletted colors to fade when the color changes
			CATransaction.setDisableActions(true)
		}

		arcColorInnerShape.strokeColor = self.valueColor.color(atFraction: self.value)
		wiperBackgroundShape.fillColor = self.wiperBackgroundColor
		arcShape.strokeColor = self.strokeColor
		arcInnerShape.strokeColor = self.arcBackgroundColor
		arcline.strokeColor = self.strokeColor
		centroid.fillColor = self.strokeColor

		if self.valueColor.isPalette == false {
			CATransaction.commit()
		}
	}

	private func updateLayout() {
		CATransaction.setDisableActions(true)
		defer { CATransaction.commit() }

		let bb = self.bounds

		let sx = bb.width
		let sy = bb.height

		var destWidth: CGFloat = 0
		var destHeight: CGFloat = 0

		let rr: CGRect = {
			if (sx / 2) > sy {
				let dx = sy/(sx/2)
				destWidth =  bb.width * dx
				destHeight = bb.height
				return CGRect(
					x: (bb.width - destWidth) / 2,
					y: 0,
					width: destWidth,
					height: destHeight
				)
			}
			else {
				let dy = (sx/2)/sy
				destWidth =  bb.width
				destHeight = bb.height * dy
				return CGRect(
					x: (bb.width - destWidth) / 2,
					y: (bb.height - destHeight) / 2,
					width: destWidth,
					height: destHeight
				)
			}
		}()

		let sz = rr.size.height
		let ptsize = sz / 12

		let origin = CGPoint(
			x: (rr.width / 2) + rr.origin.x,
			y: rr.origin.y + ptsize
		)

		if let wiperBackgroundColor = self.wiperBackgroundColor {
			let path = CGMutablePath()
			path.addArc(center: origin, radius: (sz / 2) - (ptsize), startAngle: 0, endAngle: .pi, clockwise: false)
			path.closeSubpath()
			wiperBackgroundShape.path = path
			wiperBackgroundShape.lineWidth = sz
			wiperBackgroundShape.strokeColor = wiperBackgroundColor
			wiperBackgroundShape.fillColor = nil
			wiperBackgroundShape.lineJoin = .round
		}

		do {
			let path = CGMutablePath()
			path.addArc(center: origin, radius: sz - (ptsize * 2), startAngle: 0.2, endAngle: .pi - 0.2, clockwise: false)
			arcShape.path = path
			arcShape.fillColor = .clear
			arcShape.lineWidth = ptsize
			arcShape.strokeColor = self.strokeColor
			arcShape.lineCap = .round
		}

		let frac: Double = self.currentValue__
		let fullSweep = .pi - 0.2 - 0.2

		do {

			let innerArcRadius = (sz / 1.9)
			let innerArcWidth = (sz / 1.8)

			do {
				let colorstart = ((1.0 - frac) * fullSweep)

				let path4 = CGMutablePath()
				path4.addArc(center: origin, radius: innerArcRadius - ptsize, startAngle: 0.2 + colorstart, endAngle: .pi - 0.2, clockwise: false)
				arcColorInnerShape.path = path4
				arcColorInnerShape.lineWidth = innerArcWidth
				arcColorInnerShape.fillColor = .clear
			}

			do {
				let colorstart = (frac * fullSweep)

				let path3 = CGMutablePath()
				path3.addArc(center: origin, radius: innerArcRadius - ptsize, startAngle: 0.2, endAngle: .pi - 0.2 - colorstart, clockwise: false)
				arcInnerShape.path = path3
				arcInnerShape.lineWidth = innerArcWidth
				arcInnerShape.strokeColor = self.arcBackgroundColor
				arcInnerShape.fillColor = .clear
			}
		}

		do {
			let pointy = CGRect(x: origin.x - ptsize, y: origin.y - ptsize, width: ptsize*2, height: ptsize*2)
			let path2 = CGPath(ellipseIn: pointy, transform: nil)
			centroid.fillColor = self.strokeColor
			centroid.path = path2
		}

		do {
			let pth = CGMutablePath()
			pth.move(to: CGPoint(x: 0, y: 0))
			pth.addLine(to: CGPoint(x: sz / 1.4, y: 0))

			let colorstart = ((1.0 - frac) * fullSweep)

			let res = CGMutablePath()
			res.addPath(pth, transform:
					.init(translationX: origin.x, y: max(0, origin.y))
					.rotated(by: 0.2 + colorstart))

			arcline.path = res
			arcline.lineWidth = ptsize
			arcline.lineCap = .round
			arcline.strokeColor = self.strokeColor
		}
	}

	public override func layoutSublayers() {
		super.layoutSublayers()
		self.updateLayout()
	}
}

// MARK: Animation

private extension DSFSparklineOverlay.WiperGauge {
	func animate(to newValue: CGFloat) {
		// Stop any animation that is currently active
		self.animator.stop()

		let startValue = self.currentValue__
		let diff = newValue - self.currentValue__

		self.animator.animationFunction = ArbitraryAnimator.Function.EaseInEaseOut()
		self.animator.progressBlock = { progress in
			self.currentValue__ = startValue + (CGFloat(progress) * diff)
		}

		self.animator.duration = 0.2
		self.animator.start()
	}
}
