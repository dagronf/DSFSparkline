//
//  File.swift
//  
//
//  Created by Darren Ford on 24/2/21.
//

import QuartzCore

public extension DSFSparklineOverlay {

	@objc(DSFSparklineOverlayPie) class Pie: DSFSparklineOverlay {

		/// The data to be displayed in the pie.
		///
		/// The values become a percentage of the total value stored within the
		/// dataStore, and as such each value ends up being drawn as a fraction of the total.
		/// So for example, if you want the pie chart to represent the number of red cars vs. number of
		/// blue cars, you just set the values directly.
		@objc public var dataSource: [CGFloat] = [] {
			didSet {
				self.dataDidChange()
			}
		}

		/// The stroke color for the pie chart
		@objc public var strokeColor: DSFColor? {
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

		/// The palette to use when drawing the pie chart
		@objc public var palette = DSFSparklinePalette.shared {
			didSet {
				self.setNeedsDisplay()
			}
		}

		public override func drawGraph(context: CGContext, bounds: CGRect, scale: CGFloat) -> CGRect {
			self.drawPieGraph(context: context, bounds: bounds, scale: scale)
		}

		// MARK: - Privates

		internal var animator = ArbitraryAnimator()
		internal var fractionComplete: CGFloat = 0
		internal var total: CGFloat = 0.0
	}
}

private extension DSFSparklineOverlay.Pie {

	func dataDidChange() {
		// Precalculate the total.
		self.total = self.dataSource.reduce(0) { $0 + $1 }

		if self.animated {
			self.startAnimateIn()
		}
		else {
			self.fractionComplete = 1.0
			self.setNeedsDisplay()
		}
	}

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
	func drawPieGraph(context: CGContext, bounds: CGRect, scale: CGFloat) -> CGRect {
		if fractionComplete == 0 {
			return bounds
		}

		let rect = bounds.insetBy(dx: 1, dy: 1)

		// radius is the half the frame's width or height (whichever is smallest)
		let radius = min(rect.width, rect.height) * 0.5

		// center of the view
		let viewCenter = CGPoint(x: rect.midX, y: rect.midY)

		// the starting angle is -90 degrees (top of the circle, as the context is flipped). By default, 0 is the right hand side of the circle, with the positive angle being in an anti-clockwise direction (same as a unit circle in maths).
		var startAngle = -CGFloat.pi * 0.5

		for segment in self.dataSource.enumerated() { // loop through the values array

			context.usingGState { state in

				// set fill color to the segment color
				state.setFillColor(self.palette.cgColorAtOffset(segment.offset))

				// update the end angle of the segment
				let fraEndAngle = startAngle + (2 * .pi * (segment.element / total)) * fractionComplete

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

		if let stroke = self.strokeColor?.cgColor {

			var startAngle = -CGFloat.pi * 0.5

			context.setStrokeColor(stroke)
			context.setLineWidth(self.lineWidth)

			for segment in self.dataSource.enumerated() { // loop through the values array

				context.usingGState { state in

					// update the end angle of the segment
					let fraEndAngle = startAngle + (2 * .pi * (segment.element / total)) * fractionComplete

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
		return bounds
	}

}
