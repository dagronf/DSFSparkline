//
//  File.swift
//  
//
//  Created by Darren Ford on 24/2/21.
//

import QuartzCore

public extension DSFSparklineOverlay {

	@objc(DSFSparklineOverlayDataBar) class DataBar: DSFSparklineOverlay {

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

		/// The maximum _total_ value. If the datasource values total is greater than this value, it clips the display
		@objc public var maximumTotalValue: CGFloat = -1 {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The 'undrawn' color for the graph
		@objc public var unsetColor: DSFColor? {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The stroke color for the chart
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


		// MARK: - Privates

		internal var animator = ArbitraryAnimator()
		internal var fractionComplete: CGFloat = 0
		internal var total: CGFloat = 0.0
	}
}

private extension DSFSparklineOverlay.DataBar {

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

private extension DSFSparklineOverlay.DataBar {
	func drawDataBarGraph(context: CGContext, bounds: CGRect, scale: CGFloat) -> CGRect {
		if fractionComplete == 0 {
			return bounds
		}

		let total = self.maximumTotalValue > 0 ? self.maximumTotalValue : self.total

		let rect = bounds.integral
		var position: CGFloat = rect.minX
		let delta: CGFloat = (rect.width / total) * self.fractionComplete

		context.clip(to: rect)

		if self.maximumTotalValue > 0, let unsetColor = self.unsetColor?.cgColor {
			let cbheight = max(2, rect.height / 6)
			let center = rect.midY
			let centerBar = CGRect(x: rect.minX, y: center - (cbheight / 2), width: rect.width, height: cbheight)
			let pth = CGPath(roundedRect: centerBar,
								  cornerWidth: cbheight / 2, cornerHeight: cbheight / 2, transform: nil)

			context.usingGState { state in
				state.addPath(pth)
				state.setFillColor(unsetColor)
				state.fillPath()
			}
		}

		for segment in self.dataSource.enumerated() {
			context.usingGState { state in

				state.setFillColor(self.palette.cgColorAtOffset(segment.offset))

				let width = segment.element * delta

				let path = CGPath(rect: CGRect(x: position, y: rect.minY, width: width, height: rect.height), transform: nil)
				state.addPath(path)
				state.fillPath()

				if segment.offset > 0, let strokeColor = self.strokeColor {
					state.usingGState { separator in
						separator.setStrokeColor(strokeColor.cgColor)
						separator.setLineWidth(self.lineWidth)
						separator.move(to: CGPoint(x: position, y: rect.minY))
						separator.addLine(to: CGPoint(x: position, y: rect.maxY))

						separator.strokePath()
					}
				}

				position = position + width
			}
		}
		return bounds
	}
}
