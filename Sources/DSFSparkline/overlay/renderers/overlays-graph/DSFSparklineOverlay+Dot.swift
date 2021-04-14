//
//  DSFSparklineOverlay+Dot.swift
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
	/// A dot graph
	@objc(DSFSparklineOverlayDot) class Dot: DSFSparklineOverlay.DataSource {
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

		/// Are the values drawn from the top down?
		@objc public var upsideDown: Bool = false {
			didSet {
				self.setNeedsDisplay()
			}
		}

		internal override func drawGraph(context: CGContext, bounds: CGRect, scale: CGFloat) {
			self.drawDotGraph(context: context, bounds: bounds, scale: scale)
		}
	}
}

extension DSFSparklineOverlay.Dot {
	private func drawDotGraph(context: CGContext, bounds: CGRect, scale _: CGFloat) {
		guard let dataSource = self.dataSource else { return }

		let drawRect = bounds

		let height = drawRect.height
		let dotHeight = floor(height / CGFloat(self.verticalDotCount))

		let xOffset: CGFloat = bounds.width.truncatingRemainder(dividingBy: dotHeight) / 2.0
		let yOffset: CGFloat = bounds.height.truncatingRemainder(dividingBy: dotHeight) / 2.0

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
			context.usingGState { state in
				let path = CGMutablePath()
				path.addRects(pv)
				state.addPath(path)
				state.setFillColor(self.onColor)
				state.drawPath(using: .fill)
			}
		}

		if uv.count > 0, let offColor = self.offColor {
			context.usingGState { state in
				let path = CGMutablePath()
				path.addRects(uv)
				state.addPath(path)
				state.setFillColor(offColor)
				state.drawPath(using: .fill)
			}
		}
	}
}
