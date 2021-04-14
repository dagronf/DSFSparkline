//
//  DSFSparklineOverlay+Bar.swift
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

#if os(macOS)
import Cocoa
#else
import UIKit
#endif

public extension DSFSparklineOverlay {

	/// A bar graph overlay
	@objc(DSFSparklineOverlayBar) class Bar: Centerable {

		/// The width for the line drawn on the graph (in pixels)
		@objc public var strokeWidth: UInt = 1 {
			didSet {
				self.setNeedsDisplay()
			}
		}
		/// The spacing between each bar (in pixels)
		@objc public var barSpacing: UInt = 1 {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// Draw a shadow under the line
		@objc public var shadow: NSShadow? {
			didSet {
				self.setNeedsDisplay()
			}
		}

		internal override func edgeInsets(for rect: CGRect) -> DSFEdgeInsets {
			guard let dataSource = self.dataSource else { return .zero }

			let integralRect = bounds.integral
			let componentWidth = Int(integralRect.width) / Int(dataSource.windowSize)

			// The left offset in order to center X the full range
			let intOffset = Int(bounds.minX) + (Int(bounds.width) - (componentWidth * Int(dataSource.windowSize))) / 2
			let xOffset = CGFloat(intOffset)
			let yOffset = CGFloat(self.strokeWidth)

			return DSFEdgeInsets(top: yOffset, left: xOffset, bottom: yOffset, right: xOffset)
		}

		internal override func drawGraph(context: CGContext, bounds: CGRect, scale: CGFloat) {
			if self.centeredAtZeroLine {
				self.drawCenteredBarGraph(context: context, bounds: bounds, scale: scale)
			}
			else {
				self.drawBarGraph(context: context, bounds: bounds, scale: scale)
			}
		}
	}
}

extension DSFSparklineOverlay.Bar {

	private func drawBarGraph(context: CGContext, bounds: CGRect, scale: CGFloat) {

		guard let dataSource = self.dataSource else { return }

		let integralRect = bounds.integral

		// This represents the _full_ width of a bar within the graph, including the spacing.
		let componentWidth = Int(integralRect.width) / Int(dataSource.windowSize)

		// The width of the BAR component
		let barWidth = componentWidth - Int(barSpacing)

		// The left offset in order to center X
		let xOffset: Int = Int(bounds.minX) + (Int(bounds.width) - (componentWidth * Int(dataSource.windowSize))) / 2

		// The available height range
		let range: ClosedRange<CGFloat> = 0 ... integralRect.maxY

		let normy = dataSource.normalized
		let xDiff = bounds.width / CGFloat(normy.count)
		let points = normy.enumerated().map {
			CGPoint(x: CGFloat($0.offset) * xDiff,
					  y: ($0.element * (integralRect.height - 1) + integralRect.minY).clamped(to: range))
		}

		context.usingGState { outer in

			outer.setRenderingIntent(.relativeColorimetric)
			outer.interpolationQuality = .none
			outer.setShouldAntialias(false)

			if dataSource.counter < dataSource.windowSize {
				let pos = xOffset + (Int(dataSource.counter) * componentWidth)
				let clipRect = bounds.divided(atDistance: CGFloat(pos), from: .maxXEdge).slice
				outer.clip(to: clipRect)
			}

			var bars: [CGRect] = []
			for point in points.enumerated() {
				let yVal = Int(point.element.y.rounded(.down))
				let r = CGRect(x: xOffset + point.offset * componentWidth,
									y: Int(integralRect.minY) + Int(integralRect.height) - yVal,
									width: barWidth,
									height: yVal - Int(self.strokeWidth))
				bars.append(r.integral)
			}

			let path = CGMutablePath()
			path.addRects(bars)

			if let primaryFill = self.primaryFill {
				outer.usingGState { fillCtx in
					fillCtx.addPath(path)
					fillCtx.clip()
					primaryFill.fill(context: fillCtx, bounds: bounds)
				}
			}

			if let stroke = self.primaryStrokeColor {
				outer.usingGState { strokeCtx in

					if let shadow = self.shadow {
						strokeCtx.setShadow(shadow)
					}

					strokeCtx.addPath(path)
					strokeCtx.setLineWidth(1.0 / scale * CGFloat(self.strokeWidth))
					strokeCtx.setStrokeColor(stroke)
					strokeCtx.drawPath(using: .stroke)
				}
			}
		}
	}

	private func drawCenteredBarGraph(context: CGContext, bounds: CGRect, scale: CGFloat) {

		guard let dataSource = self.dataSource else { return }

		let drawRect = bounds
		let height = drawRect.height - 1

		let normy = dataSource.normalized
		let xDiff = bounds.width / CGFloat(normy.count)

		let centre = dataSource.normalizedZeroLineValue
		let centroid = (1 - centre) * (drawRect.height - 1)

		context.usingGState { outer in

			outer.setRenderingIntent(.relativeColorimetric)
			outer.interpolationQuality = .none

			if dataSource.counter < dataSource.windowSize {
				let pos = CGFloat(dataSource.counter) * xDiff + 1
				let clipRect = bounds.divided(atDistance: pos, from: .maxXEdge).slice
				outer.clip(to: clipRect)
			}

			var positivePath: [CGRect] = []
			var negativePath: [CGRect] = []

			for value in normy.enumerated() {
				let x = bounds.minX + CGFloat(value.offset) * xDiff
				if value.element >= centre {
					let yy = bounds.minY + ((centre - value.element) * height)
					let r = CGRect(x: x,
										y: centroid,
										width: xDiff - 1 - (CGFloat(self.barSpacing)),
										height: yy) // - CGFloat(self.lineWidth))
					positivePath.append(r.integral)
				}
				else {
					let yy = bounds.minY + ((value.element - centre) * height)
					let r = CGRect(x: x,
										y: centroid + 1,
										width: xDiff - 1 - (CGFloat(self.barSpacing)),
										height: -yy - CGFloat(self.strokeWidth) + 1)
					negativePath.append(r.integral)
				}
			}

			outer.setShouldAntialias(false)

			if !positivePath.isEmpty {
				let path = CGMutablePath()
				path.addRects(positivePath)

				if let primaryFill = self.primaryFill {
					outer.usingGState { fillCtx in
						fillCtx.addPath(path)
						fillCtx.clip()
						primaryFill.fill(context: fillCtx, bounds: bounds)
					}
				}

				if let stroke = self.primaryStrokeColor {
					outer.usingGState { strokeCtx in
						strokeCtx.addPath(path)
						strokeCtx.setLineWidth(1.0 / scale * CGFloat(self.strokeWidth))
						strokeCtx.setStrokeColor(stroke)
						strokeCtx.strokePath()
					}
				}
			}

			if !negativePath.isEmpty {
				let path = CGMutablePath()
				path.addRects(negativePath)

				if let secondaryFill = self.secondaryFill {
					outer.usingGState { fillCtx in
						fillCtx.addPath(path)
						fillCtx.clip()
						secondaryFill.fill(context: fillCtx, bounds: bounds)
					}
				}

				if let stroke = self.secondaryStrokeColor {
					outer.usingGState { strokeCtx in
						strokeCtx.addPath(path)
						strokeCtx.setLineWidth(1.0 / scale * CGFloat(self.strokeWidth))
						strokeCtx.setStrokeColor(stroke)
						strokeCtx.strokePath()
					}
				}
			}
		}
	}
}
