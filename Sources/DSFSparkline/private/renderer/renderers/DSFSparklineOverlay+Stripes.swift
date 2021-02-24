//
//  File.swift
//
//
//  Created by Darren Ford on 24/2/21.
//

import QuartzCore

public extension DSFSparklineOverlay {
	@objc(DSFSparklineOverlayStripes) class Stripes: DSFSparklineDataSourceOverlay {
		/// The width of the stroke for the tablet
		@objc public var integral: Bool = true {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The spacing (in pixels) between each bar
		@objc public var barSpacing: CGFloat = 1.0 {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The color gradient to use when rendering.
		///
		/// Note that transparent gradients display strangely and not as I would expect them to.
		/// Stick with solid colors in your gradient for the current time.
		@objc public var gradient: DSFGradient? {
			didSet {
				self.setNeedsDisplay()
			}
		}

		override public func drawGraph(context: CGContext, bounds: CGRect, scale: CGFloat) -> CGRect {
			if self.integral {
				return self.drawStripeGraph(context: context, bounds: bounds, scale: scale)
			}
			else {
				return self.drawStripeGraphFloat(context: context, bounds: bounds, scale: scale)
			}
		}
	}
}

private extension DSFSparklineOverlay.Stripes {
	func drawStripeGraph(context: CGContext, bounds: CGRect, scale: CGFloat) -> CGRect {
		guard let dataSource = self.dataSource,
				let gradient = self.gradient else
		{
			return bounds
		}

		let integralRect = bounds.integral

		// This represents the _full_ width of a bar within the graph, including the spacing.
		let componentWidth = Int(integralRect.width) / Int(dataSource.windowSize)

		// The width of the BAR component
		let barWidth = componentWidth - Int(barSpacing)

		// The left offset in order to center X
		let xOffset: Int = (Int(bounds.width) - (componentWidth * Int(dataSource.windowSize))) / 2

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
		return bounds
	}

	private func drawStripeGraphFloat(context: CGContext, bounds: CGRect, scale _: CGFloat) -> CGRect {
		guard let dataSource = self.dataSource,
				let gradient = self.gradient else
		{
			return bounds
		}

		let drawRect = self.bounds

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
						x: CGFloat(value.offset) * componentWidth - (barSpacing == 0 ? 0.5 : 0),
						y: drawRect.minX,
						width: barWidth + (barSpacing == 0 ? 0.5 : 0),
						height: drawRect.height
					)
					inner.addRect(r)
					inner.drawPath(using: .fill)
				}
			}
		}
		return bounds
	}
}
