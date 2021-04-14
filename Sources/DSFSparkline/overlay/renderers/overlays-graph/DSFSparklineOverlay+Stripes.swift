//
//  DSFSparklineOverlay+Stripes.swift
//  DSFSparklines
//
//  Created by Darren Ford on 26/2/21.
//  Copyright © 2021 Darren Ford. All rights reserved.
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

import QuartzCore

public extension DSFSparklineOverlay {
	@objc(DSFSparklineOverlayStripes) class Stripes: DSFSparklineOverlay.DataSource {

		// A default gradient pattern
		static let defaultGradient = DSFSparkline.GradientBucket(posts: [
			DSFSparkline.GradientBucket.Post(color: DSFColor.systemRed.cgColor, location: 0),
			DSFSparkline.GradientBucket.Post(color: DSFColor.systemOrange.cgColor, location: 1 / 5),
			DSFSparkline.GradientBucket.Post(color: DSFColor.systemYellow.cgColor, location: 2 / 5),
			DSFSparkline.GradientBucket.Post(color: DSFColor.systemGreen.cgColor, location: 3 / 5),
			DSFSparkline.GradientBucket.Post(color: DSFColor.systemBlue.cgColor, location: 4 / 5),
			DSFSparkline.GradientBucket.Post(color: DSFColor.systemPurple.cgColor, location: 5 / 5),
		])

		/// The width of the stroke for the tablet
		@objc public var integral: Bool = true {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The spacing (in pixels) between each bar
		@objc public var barSpacing: UInt = 1 {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The color gradient to use when rendering.
		///
		/// Note that transparent gradients display strangely and not as I would expect them to.
		/// Stick with solid colors in your gradient for the current time.
		@objc public var gradient: DSFSparkline.GradientBucket = Stripes.defaultGradient {
			didSet {
				self.setNeedsDisplay()
			}
		}

		override internal func drawGraph(context: CGContext, bounds: CGRect, scale: CGFloat) {
			if self.integral {
				self.drawStripeGraph(context: context, bounds: bounds, scale: scale)
			}
			else {
				self.drawStripeGraphFloat(context: context, bounds: bounds, scale: scale)
			}
		}
	}
}

private extension DSFSparklineOverlay.Stripes {
	func drawStripeGraph(context: CGContext, bounds: CGRect, scale: CGFloat) {
		guard let dataSource = self.dataSource else {
			return
		}

		let integralRect = bounds.integral

		// This represents the _full_ width of a bar within the graph, including the spacing.
		let componentWidth = Int(integralRect.width) / Int(dataSource.windowSize)

		// The width of the BAR component
		let barWidth = componentWidth - Int(barSpacing)

		// The left offset in order to center X
		let xOffset: Int = Int(self.bounds.minX) + (Int(bounds.width) - (componentWidth * Int(dataSource.windowSize))) / 2

		let normalizedPoints = dataSource.normalized

		context.usingGState { outer in

			outer.setRenderingIntent(.perceptual)
			outer.interpolationQuality = .default
			outer.setShouldAntialias(false)

			if dataSource.counter < dataSource.windowSize {
				let pos = xOffset + (Int(dataSource.counter) * componentWidth)
				let clipRect = bounds.divided(atDistance: CGFloat(pos), from: .maxXEdge).slice
				outer.clip(to: clipRect)
			}

			for value in normalizedPoints.enumerated() {
				outer.usingGState { inner in
					let color = gradient.color(at: value.element)
					inner.setFillColor(color)
					let r = CGRect(x: CGFloat(xOffset + value.offset * componentWidth),
										y: integralRect.minX,
										width: CGFloat(barWidth) + (1.0 / scale),
										height: integralRect.height)
					inner.fill(r)
				}
			}
		}
	}

	private func drawStripeGraphFloat(context: CGContext, bounds: CGRect, scale _: CGFloat) {
		guard let dataSource = self.dataSource else {
			return
		}

		let drawRect = bounds

		// This represents the _full_ width of a bar within the graph, including the spacing.
		let componentWidth = drawRect.width / CGFloat(dataSource.windowSize)

		// The width of the BAR component
		let barWidth = componentWidth - CGFloat(barSpacing)

		let normalizedPoints = dataSource.normalized

		context.usingGState { outer in

			if dataSource.counter < dataSource.windowSize {
				let pos = CGFloat(dataSource.counter) * componentWidth
				let clipRect = bounds.divided(atDistance: CGFloat(pos), from: .maxXEdge).slice
				outer.clip(to: clipRect)
			}

			for value in normalizedPoints.enumerated() {
				outer.usingGState { inner in
					let color = gradient.color(at: value.element)
					inner.setFillColor(color)
					let r = CGRect(
						x: bounds.minX + CGFloat(value.offset) * componentWidth - (barSpacing == 0 ? 0.5 : 0),
						y: drawRect.minY,
						width: barWidth + (barSpacing == 0 ? 0.5 : 0),
						height: drawRect.height
					)
					inner.addRect(r)
					inner.drawPath(using: .fill)
				}
			}
		}
	}
}
