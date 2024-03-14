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

		// MARK: - Settings

		/// The value to display in the gauge
		@objc public var value: CGFloat = 0.0 {
			didSet {
				let v = max(0, min(1, self.value))
				let tra = DSFSparkline.AnimationTransition(start: currentValue__, stop: v)
				if isAnimated {
					self.animate(tra)
				}
				else {
					self.currentValue__ = v
				}
			}
		}

		/// The palette to use when drawing the value part of the gauge
		@objc public var valueColor: DSFSparkline.ValueBasedFill = DSFSparkline.ValueBasedFill.sharedPalette {
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
		@objc public var gaugeBackgroundColor: CGColor? = _gaugeBackgroundColor {
			didSet {
				self.updatePalette()
			}
		}

		/// Should the pie chart animate in?
		@objc public var animationStyle: DSFSparkline.AnimationStyle? = nil

		private var isAnimated: Bool { self.animationStyle != nil }

		// MARK: - Initializers

		@objc public override init() {
			super.init()
			self.configure()
		}

		public override init(layer: Any) {
			guard let orig = layer as? Self else { fatalError() }
			self.value = orig.value

			self.valueColor = orig.valueColor.copyColorContainer()
			self.valueBackgroundColor = orig.valueBackgroundColor.copy() ?? CGColor(gray: 0, alpha: 0)

			self.gaugePointerColor = orig.gaugePointerColor.copy() ?? CGColor(gray: 1, alpha: 1)
			self.gaugeUpperArcColor = orig.gaugeUpperArcColor.copy() ?? CGColor(gray: 1, alpha: 1)

			self.gaugeBackgroundColor = orig.gaugeBackgroundColor?.copy() ?? CGColor(gray: 0, alpha: 0)

			self.animationStyle = orig.animationStyle

			super.init(layer: layer)

			self.configure()
		}

		@available(*, unavailable)
		required init?(coder _: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}

		// MARK: - Private

		override internal func drawGraph(context: CGContext, bounds: CGRect, scale: CGFloat) {
			// Do nothing.  All the content is handled by layers
			return
		}

		// Private

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

		private static let _gaugeBackgroundColor: CGColor? = nil

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

		self.updatePalette()
	}

	// Update the colors used within the gauge
	private func updatePalette() {

		// The gauge's background color
		wiperBackgroundShape.fillColor = self.gaugeBackgroundColor

		if self.valueColor.isPalette == false {
			// We want paletted colors to fade when the color changes
			CATransaction.setDisableActions(true)
		}

		// The outer ring
		arcShape.fillColor = .clear
		arcShape.strokeColor = self.gaugeUpperArcColor

		// The color component of the arc
		arcColorInnerShape.fillColor = self.valueColor.color(atFraction: self.value)
		arcColorInnerShape.strokeColor = .clear

		// The background color component of the arc
		arcInnerShape.fillColor = self.valueBackgroundColor
		arcInnerShape.strokeColor = .clear

		// The pointer and the pinion
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
				return CGRect(
					x: x,
					y: y,
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

		// The gauge's pinion point
		let centroidLocation = CGPoint(x: origin.x, y: bb.height - (bb.height - rr.height) / 2 - ptsize)

		// Draw the background

		do {
			let pth = CGMutablePath()
			pth.addArc(center: centroidLocation, radius: sz - ptsize, startAngle: .pi, endAngle: .pi * 2, clockwise: false)
			let brect = CGRect(
				x: centroidLocation.x - (sz - ptsize),
				y: centroidLocation.y,
				width: (sz - ptsize) * 2,
				height: ptsize
			)
			pth.addRect(brect)
			pth.closeSubpath()
			wiperBackgroundShape.path = pth
		}

		// Draw the outer ring

		do {
			let path = CGMutablePath()
			path.addArc(center: centroidLocation, radius: sz - (ptsize * 2), startAngle: .pi + 0.2, endAngle: .pi - .pi - 0.2, clockwise: false)
			arcShape.path = path
			arcShape.lineWidth = ptsize
			arcShape.lineCap = .round
		}

		let frac: CGFloat = self.currentValue__
		let fullSweep: CGFloat = .pi - 0.2 - 0.2

		// Draw the inner sweeps

		do {

			// Color fill

			do {
				let colorstart: CGFloat = ((1.0 - frac) * fullSweep)

				let pth = CGMutablePath()
				pth.addArc(center: centroidLocation, radius: ptsize * 2, startAngle: .pi + 0.2, endAngle: .pi * 2 - 0.2 - colorstart, clockwise: false)
				pth.addArc(center: centroidLocation, radius: (sz - (ptsize * 2)) / 1.15, startAngle: .pi * 2 - 0.2 - colorstart, endAngle: .pi + 0.2, clockwise: true)
				pth.closeSubpath()
				arcColorInnerShape.path = pth
			}

			// Background fill

			do {
				let colorstart: CGFloat = (frac * fullSweep)

				let pth = CGMutablePath()
				pth.addArc(center: centroidLocation, radius: ptsize * 2, startAngle: .pi + 0.2 + colorstart, endAngle: .pi * 2 - 0.2, clockwise: false)
				pth.addArc(center: centroidLocation, radius: (sz - (ptsize * 2)) / 1.15, startAngle: .pi * 2 - 0.2, endAngle: .pi + 0.2 + colorstart, clockwise: true)
				pth.closeSubpath()
				arcInnerShape.path = pth
			}
		}

		// Draw the pinon (the circle where the pointer rotates around)

		do {
			let dialPoint = CGPoint(x: centroidLocation.x - ptsize, y: centroidLocation.y - ptsize)
			let pointy = CGRect(origin: dialPoint, size: CGSize(width: ptsize*2, height: ptsize*2))
			let path2 = CGPath(ellipseIn: pointy, transform: nil)
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
		}
	}

	public override func layoutSublayers() {
		super.layoutSublayers()
		self.updateLayout()
	}
}

// MARK: Animation

private extension DSFSparklineOverlay.WiperGauge {
	func animate(_ transition: DSFSparkline.AnimationTransition) {
		guard let anim = self.animationStyle else { return }
		// Stop any animation that is currently active
		self.animator.progressBlock = nil
		self.animator.stop()

		self.animator.animationFunction = anim.function.function
		self.animator.duration = anim.duration
		self.animator.progressBlock = { [weak self] progress in
			self?.currentValue__ = transition.start + (transition.distance * progress)
		}

		self.animator.start()
	}
}
