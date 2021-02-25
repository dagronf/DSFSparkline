//
//  File.swift
//  
//
//  Created by Darren Ford on 24/2/21.
//

import QuartzCore

public extension DSFSparklineOverlay {
	@objc(DSFSparklineOverlayDot) class Dot: DSFSparklineDataSourceOverlay {

		/// Are the values drawn from the top down?
		@objc public var upsideDown: Bool = false {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The number of vertical buckets to break the input data up into
		@objc public var verticalDotCount: UInt = 10 {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The color to use when a 'dot' within the bar is on
		@objc public var onColor: CGColor = .black {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The color to use when a 'dot' within the bar is off
		@objc public var offColor: CGColor? {
			didSet {
				self.setNeedsDisplay()
			}
		}

		public override func drawGraph(context: CGContext, bounds: CGRect, scale: CGFloat) -> CGRect {
			return self.drawDotGraph(context: context, bounds: bounds, scale: scale)
		}
	}
}

extension DSFSparklineOverlay.Dot {

	private func drawDotGraph(context: CGContext, bounds: CGRect, scale: CGFloat) -> CGRect {

		guard let dataSource = self.dataSource else {
			return bounds
		}

		let drawRect = bounds

		let height = drawRect.height
		let dotHeight = floor(height / CGFloat(self.verticalDotCount))

		let xOffset: CGFloat = self.bounds.width.truncatingRemainder(dividingBy: dotHeight) / 2.0
		let yOffset: CGFloat = self.bounds.height.truncatingRemainder(dividingBy: dotHeight) / 2.0

		var position = drawRect.width - dotHeight - xOffset

		// Map normalized values to box positions
		let normalizedBoxed: [UInt] = dataSource.normalized.reversed().map { dataPoint in
			let floatBoxPos = CGFloat(self.verticalDotCount) * dataPoint
			return UInt(floatBoxPos.rounded(.awayFromZero))
		}

		var pv: [CGRect] = []
		var uv: [CGRect] = []

		for dataPoint in normalizedBoxed {
			let boxCount = dataPoint

			for c in 0 ..< self.verticalDotCount {
				let pos = self.upsideDown
					? (CGFloat(c) * dotHeight) + yOffset
					: height - (CGFloat(c) * dotHeight) - dotHeight - yOffset
				let r = CGRect(x: position, y: pos, width: dotHeight, height: dotHeight)
				let ri = r.insetBy(dx: 0.5, dy: 0.5)

				if c < boxCount {
					pv.append(ri)
				}
				else {
					uv.append(ri)
				}
			}

			// Move left.  If we've hit the lower bound, then stop
			position -= dotHeight
			if position < 0 {
				break
			}
		}

		if pv.count > 0 {
			context.usingGState { (state) in
				let path = CGMutablePath()
				path.addRects(pv)
				state.addPath(path)
				state.setFillColor(self.onColor)
				state.drawPath(using: .fill)
			}
		}

		if uv.count > 0,
			let offColor = self.offColor {
			context.usingGState { (state) in
				let path = CGMutablePath()
				path.addRects(uv)
				state.addPath(path)
				state.setFillColor(offColor)
				state.drawPath(using: .fill)
			}
		}

		return bounds
	}
}

