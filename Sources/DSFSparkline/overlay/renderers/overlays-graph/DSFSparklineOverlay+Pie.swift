//
//  DSFSparklineOverlay+Pie.swift
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
	/// A pie graph
	@objc(DSFSparklineOverlayPie) class Pie: DSFSparklineOverlay.StaticDataSource {
		/// The palette to use when drawing the pie chart
		@objc public var palette = DSFSparkline.Palette.shared {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The stroke color for the pie chart
		@objc public var strokeColor: CGColor? {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The width of the stroke line
		@objc public var lineWidth: CGFloat = 0.5 {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// Should the pie chart animate in?
		@objc public var animated: Bool = false

		/// The length of the animate-in duration
		@objc public var animationDuration: CGFloat = 0.25

		override func staticDataSourceDidChange() {
			super.staticDataSourceDidChange()
			if self.animated {
				self.startAnimateIn()
			}
			else {
				self.fractionComplete = 1.0
				self.setNeedsDisplay()
			}
		}

		override internal func drawGraph(context: CGContext, bounds: CGRect, scale: CGFloat) {
			self.drawPieGraph(context: context, bounds: bounds, scale: scale)
		}

		// MARK: - Privates

		internal var animator = ArbitraryAnimator()
		internal var fractionComplete: CGFloat = 0
	}
}

private extension DSFSparklineOverlay.Pie {
	func startAnimateIn() {
		// Stop any animation that is currently active
		self.animator.stop()

		self.fractionComplete = 0

		self.animator.animationFunction = ArbitraryAnimator.Function.EaseInEaseOut()
		self.animator.progressBlock = { progress in
			self.fractionComplete = CGFloat(progress)
			self.setNeedsDisplay()
		}

		self.animator.start()
	}
}

private extension DSFSparklineOverlay.Pie {

	func drawPieGraph(context: CGContext, bounds: CGRect, scale _: CGFloat) {
		if fractionComplete == 0 {
			return
		}

		let rect = bounds.insetBy(dx: 1, dy: 1)

		// radius is the half the frame's width or height (whichever is smallest)
		let radius = min(rect.width, rect.height) * 0.5

		// center of the view
		let viewCenter = CGPoint(x: rect.midX, y: rect.midY)

		// the starting angle is -90 degrees (top of the circle, as the context is flipped). By default, 0 is the right hand side of the circle, with the positive angle being in an anti-clockwise direction (same as a unit circle in maths).
		var startAngle = -CGFloat.pi * 0.5

		for segment in self.dataSource.values.enumerated() { // loop through the values array
			context.usingGState { state in

				// set fill color to the segment color
				state.setFillColor(self.palette.cgColorAtOffset(segment.offset))

				// update the end angle of the segment
				let fraEndAngle = startAngle + (2 * .pi * (segment.element / self.dataSource.total)) * fractionComplete

				// move to the center of the pie chart
				state.move(to: viewCenter)

				// add arc from the center for each segment (anticlockwise is specified for the arc, but as the view flips the context, it will produce a clockwise arc)
				state.addArc(center: viewCenter, radius: radius, startAngle: startAngle, endAngle: fraEndAngle, clockwise: false)

				state.drawPath(using: .fill)

				// update starting angle of the next segment to the ending angle of this segment
				startAngle = fraEndAngle // endAngle
			}
		}

		// We draw the strokes AFTER we draw ALL the segment fills to avoid unpleasant rendering

		if let stroke = self.strokeColor {
			var startAngle = -CGFloat.pi * 0.5

			context.setStrokeColor(stroke)
			context.setLineWidth(self.lineWidth)

			for segment in self.dataSource.values.enumerated() { // loop through the values array
				context.usingGState { state in

					// update the end angle of the segment
					let fraEndAngle = startAngle + (2 * .pi * (segment.element / self.dataSource.total)) * fractionComplete

					// move to the center of the pie chart
					state.move(to: viewCenter)

					// add arc from the center for each segment (anticlockwise is specified for the arc, but as the view flips the context, it will produce a clockwise arc)
					state.addArc(center: viewCenter, radius: radius, startAngle: startAngle, endAngle: fraEndAngle, clockwise: false)

					state.drawPath(using: .stroke)

					// update starting angle of the next segment to the ending angle of this segment
					startAngle = fraEndAngle // endAngle
				}
			}
		}
	}
}
