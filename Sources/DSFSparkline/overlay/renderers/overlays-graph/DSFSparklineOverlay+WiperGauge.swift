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

		/// The palette to use when drawing the value part of the gauge
		@objc public var valueColor: DSFSparkline.FillContainer = DSFSparkline.FillContainer.sharedPalette {
			didSet {
				self.updatePalette()
			}
		}

		/// The palette to use when drawing the unset value part of the gauge
		@objc public var valueBackgroundColor: CGColor = _valueBackgroundColor {
			didSet {
				self.updatePalette()
			}
		}

		/// The color to draw the dial and outer border
		@objc public var gaugeUpperArcColor: CGColor = _gaugeUpperArcColor {
			didSet {
				self.updatePalette()
			}
		}

		/// The color to draw the value in radial component
		@objc public var gaugePointerColor: CGColor = _gaugePointerColor {
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
			self.value = orig.value

			self.valueColor = orig.valueColor.copyColorContainer()
			self.valueBackgroundColor = orig.valueBackgroundColor.copy() ?? CGColor(gray: 0, alpha: 0)

			self.gaugeUpperArcColor = orig.gaugeUpperArcColor.copy() ?? CGColor(gray: 0, alpha: 1)

			self.gaugePointerColor = orig.gaugePointerColor.copy() ?? CGColor(gray: 1, alpha: 1)
			self.gaugeUpperArcColor = orig.gaugeUpperArcColor.copy() ?? CGColor(gray: 1, alpha: 1)

			self.animated = orig.animated

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

		//private let dummyShape = CAShapeLayer()

		private let wiperBackgroundShape = CAShapeLayer()
		private let arcShape = CAShapeLayer()

		private let arcInnerShape = CAShapeLayer()
		private let arcColorInnerShape = CAShapeLayer()

		private let pinion = CAShapeLayer()
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
		private static let _valueBackgroundColor = NSColor.quaternaryLabelColor.cgColor
		private static let _gaugeUpperArcColor = NSColor.textColor.cgColor
		private static let _gaugePointerColor = NSColor.textColor.cgColor
		#else
		private static let _valueBackgroundColor = UIColor.quaternaryLabel.cgColor
		private static let _gaugeUpperArcColor = UIColor.label.cgColor
		private static let _gaugePointerColor = UIColor.label.cgColor
		#endif
	}
}

extension DSFSparklineOverlay.WiperGauge {
	private func configure() {

//		self.addSublayer(dummyShape)
//		dummyShape.zPosition = -200

		self.addSublayer(wiperBackgroundShape)
		wiperBackgroundShape.zPosition = -110

		self.addSublayer(arcShape)
		arcShape.zPosition = -100
		self.addSublayer(arcInnerShape)
		arcInnerShape.zPosition = -90
		self.addSublayer(arcColorInnerShape)
		arcColorInnerShape.zPosition = -80

		self.addSublayer(pinion)
		pinion.zPosition = -70
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
		arcShape.strokeColor = self.gaugeUpperArcColor
		arcInnerShape.strokeColor = self.valueBackgroundColor


		arcline.strokeColor = self.gaugePointerColor
		pinion.fillColor = self.gaugePointerColor

		if self.valueColor.isPalette == false {
			CATransaction.commit()
		}
	}

	private func updateLayout() {
		CATransaction.setDisableActions(true)
		defer { CATransaction.commit() }

		let bb = self.bounds
		if bb.isEmpty { return }

		let sx = bb.width
		let sy = bb.height

		var destWidth: CGFloat = 0
		var destHeight: CGFloat = 0

		let rr: CGRect = {
			if (sx / 2) > sy {
				// wider than it is higher
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
				// higher than it is wide
				let dy = (sx / 2) / sy
				destWidth =  bb.width
				destHeight = bb.height * dy
				let x = (bb.width - destWidth) / 2.0
				let y = (bb.height - destHeight) / 2.0
				Swift.print("destWidth = \(destWidth), destHeight = \(destHeight)")
				Swift.print("x = \(x), y = \(y)")
				return CGRect(
					x: x,
					y: y,
					width: destWidth,
					height: destHeight
				)
			}
		}()

//		dummyShape.path = CGPath(rect: rr, transform: nil)
//		dummyShape.strokeColor = NSColor.green.cgColor
//		dummyShape.lineWidth = 1

		let sz = rr.size.height
		let ptsize = sz / 12

		let origin = CGPoint(
			x: (rr.width / 2) + rr.origin.x,
			y: rr.origin.y + ptsize
		)

		// The gauge's pinion point
		let centroidLocation = CGPoint(x: origin.x, y: bb.height - (bb.height - rr.height) / 2 - ptsize)
		Swift.print("cl = \(centroidLocation)")
		// Draw the background if specified

//		if let wiperBackgroundColor = self.wiperBackgroundColor {
//			let path = CGMutablePath()
//			path.addArc(center: centroidLocation, radius: sz / 2, startAngle: .pi + 0.2, endAngle: 2.0 * .pi - 0.2, clockwise: false)
//			wiperBackgroundShape.path = path
//			wiperBackgroundShape.lineWidth = sz / 1.1
//			wiperBackgroundShape.strokeColor = wiperBackgroundColor
//			wiperBackgroundShape.fillColor = nil
//			wiperBackgroundShape.lineJoin = .round
//		}

		// Draw the outer ring

		do {
			let path = CGMutablePath()
			path.addArc(center: centroidLocation, radius: sz - (ptsize * 2), startAngle: .pi + 0.2, endAngle: .pi - .pi - 0.2, clockwise: false)
			arcShape.path = path
			arcShape.fillColor = .clear
			arcShape.lineWidth = ptsize
			arcShape.strokeColor = self.gaugeUpperArcColor
			arcShape.lineCap = .round
		}

		let frac: Double = self.currentValue__
		let fullSweep = .pi - 0.2 - 0.2

		// Draw the inner sweeps

		do {

			let innerArcRadius = (sz / 1.9)
			let innerArcWidth = (sz / 1.8)

			do {
				let colorstart = ((1.0 - frac) * fullSweep)

				let path4 = CGMutablePath()
				path4.addArc(center: centroidLocation, radius: innerArcRadius - ptsize, startAngle: .pi + 0.2, endAngle: .pi - .pi - 0.2 - colorstart, clockwise: false)
				arcColorInnerShape.path = path4
				arcColorInnerShape.lineWidth = innerArcWidth
				arcColorInnerShape.fillColor = .clear
			}

			do {
				let colorstart = (frac * fullSweep)

				let path3 = CGMutablePath()
				path3.addArc(center: centroidLocation, radius: innerArcRadius - ptsize, startAngle: .pi + 0.2 + colorstart, endAngle: .pi - .pi - 0.2, clockwise: false)
				arcInnerShape.path = path3
				arcInnerShape.lineWidth = innerArcWidth
				arcInnerShape.strokeColor = self.valueBackgroundColor
				arcInnerShape.fillColor = .clear
			}
		}

		// Draw the pinon (the circle where the pointer rotates around)

		do {
			let dialPoint = CGPoint(x: centroidLocation.x - ptsize, y: centroidLocation.y - ptsize)
			let pointy = CGRect(origin: dialPoint, size: CGSize(width: ptsize*2, height: ptsize*2))
			let path2 = CGPath(ellipseIn: pointy, transform: nil)
			pinion.fillColor = self.gaugePointerColor
			pinion.path = path2
		}

		// Draw the pointer

		do {
			let pth = CGMutablePath()
			pth.move(to: CGPoint(x: 0, y: 0))
			pth.addLine(to: CGPoint(x: sz / 1.4, y: 0))

			let colorstart = ((1.0 - frac) * fullSweep)

			let res = CGMutablePath()
			let transform = CGAffineTransform(translationX: centroidLocation.x, y: centroidLocation.y)
				.rotated(by: .pi - .pi - 0.2 - colorstart)
			res.addPath(pth, transform: transform)

			arcline.path = res
			arcline.lineWidth = ptsize
			arcline.lineCap = .round
			arcline.strokeColor = self.gaugePointerColor
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
