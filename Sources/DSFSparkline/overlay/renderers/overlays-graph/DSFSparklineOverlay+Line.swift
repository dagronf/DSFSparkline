//
//  DSFSparklineOverlay+Line.swift
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
	/// A line graph sparkline
	@objc(DSFSparklineOverlayLine) class Line: Centerable {
		/// The width for the line drawn on the graph
		@objc public var strokeWidth: CGFloat = 1.5 {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// Interpolate a curve between the points
		@objc public var interpolated: Bool = false {
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

		/// The size of the markers to draw. If the markerSize is less than 0, markers will not draw
		@objc public var markerSize: CGFloat = -1 {
			didSet {
				self.setNeedsDisplay()
			}
		}

		override public func drawGraph(context: CGContext, bounds: CGRect, scale: CGFloat) -> CGRect {
			if self.centeredAtZeroLine {
				return self.drawCenteredGraph(context: context, bounds: bounds, scale: scale)
			}
			else {
				return self.drawLineGraph(context: context, bounds: bounds, scale: scale)
			}
		}
	}
}

extension CGContext {
	@inlinable func setShadow(_ shadow: NSShadow) {

		#if os(macOS)
		let color = shadow.shadowColor
		#else
		let color = shadow.shadowColor as? UIColor
		#endif

		self.setShadow(offset: shadow.shadowOffset,
							blur: shadow.shadowBlurRadius,
							color: color?.cgColor)
	}
}

private extension DSFSparklineOverlay.Line {
	func drawLineGraph(context: CGContext, bounds: CGRect, scale _: CGFloat) -> CGRect {
		guard let dataSource = self.dataSource,
				dataSource.counter != 0 else
		{
			// There's no line if there's either no data or just a single point
			// https://github.com/dagronf/DSFSparkline/issues/3#issuecomment-770324047
			return bounds
		}

		// Adjust the inset so that markers can draw unclipped if they are asked for

		// If there's a shadow, inset by the maximum shadow offset + blur radius
		let shadowOffset = max(self.shadow?.shadowOffset.width ?? 0,
									  self.shadow?.shadowOffset.height ?? 0) +
									  (self.shadow?.shadowBlurRadius ?? 0)

		let inset = (self.markerSize > 0 ? self.markerSize / 2 : self.strokeWidth) + shadowOffset

		let drawRect = bounds.insetBy(dx: inset, dy: inset)

		let normy = dataSource.normalized
		let xDiff = drawRect.width / CGFloat(normy.count - 1)
		let points = normy.enumerated().map {
			CGPoint(x: CGFloat($0.offset) * xDiff + drawRect.minX,
					  y: drawRect.height + drawRect.minY - ($0.element * drawRect.height))
		}

		let path = CGPath.pathWithPoints(points, smoothed: self.interpolated)

		let allP = CGMutablePath()
		if self.markerSize > 0 {
			points.forEach { point in
				let w = self.markerSize / 2
				let r = CGRect(x: point.x - w, y: point.y - w, width: self.markerSize, height: self.markerSize)
				allP.addPath(CGPath(ellipseIn: r, transform: nil))
			}
		}

		context.usingGState { outer in

			if dataSource.counter < dataSource.windowSize {
				let pos = bounds.minX + (CGFloat(dataSource.counter) * xDiff)
				let clipRect = bounds.divided(atDistance: pos, from: .maxXEdge).slice
				outer.clip(to: clipRect)
			}

			if let fill = self.primaryFill {
				outer.usingGState { ctx in

					let clipper = path.mutableCopy()!
					clipper.addLine(to: CGPoint(x: drawRect.maxX, y: points.last!.y))
					clipper.addLine(to: CGPoint(x: drawRect.maxX, y: drawRect.maxY))
					clipper.addLine(to: CGPoint(x: drawRect.minX, y: drawRect.maxY))
					clipper.addLine(to: CGPoint(x: drawRect.minX, y: points.first!.y))
					clipper.closeSubpath()

					ctx.addPath(clipper)
					ctx.clip()
					fill.fill(context: ctx, bounds: drawRect)
				}
			}

			if let strokeColor = self.primaryStrokeColor {
				outer.usingGState { ctx in
					ctx.addPath(path)
					ctx.setStrokeColor(strokeColor)
					ctx.setLineWidth(self.strokeWidth)

					if let shadow = self.shadow {
						ctx.setShadow(shadow)
					}
					ctx.setLineJoin(.round)
					ctx.strokePath()
				}
			}

			/// Draw the markers the same color as the line for the moment
			if !allP.isEmpty {
				if let strokeColor = self.primaryStrokeColor {
					outer.usingGState { ctx in
						ctx.addPath(allP)
						ctx.setFillColor(strokeColor)
						if let shadow = self.shadow {
							ctx.setShadow(shadow)
						}
						ctx.fillPath()
					}
				}
			}
		}

		return drawRect
	}

	func drawCenteredGraph(context: CGContext, bounds: CGRect, scale _: CGFloat) -> CGRect {
		guard let dataSource = self.dataSource,
				dataSource.counter != 0 else
		{
			// There's no line if there's either no data or just a single point
			// https://github.com/dagronf/DSFSparkline/issues/3#issuecomment-770324047
			return bounds
		}

		// Adjust the inset so that markers can draw unclipped if they are asked for
		let inset = self.markerSize > 0 ? self.markerSize / 2 : self.strokeWidth
		let drawRect = bounds.insetBy(dx: inset, dy: inset)

		let normy = dataSource.normalized
		let xDiff = drawRect.width / CGFloat(normy.count - 1)
		let points = normy.enumerated().map {
			CGPoint(x: CGFloat($0.offset) * xDiff + drawRect.minX,
					  y: drawRect.height + drawRect.minY - ($0.element * drawRect.height))
		}

		let centroid = (1 - dataSource.normalizedZeroLineValue) * (drawRect.height - 1)

		let pPoints = CGMutablePath()
		let nPoints = CGMutablePath()

		if self.markerSize > 0 {
			points.enumerated().forEach { point in
				let w = self.markerSize / 2
				let r = CGRect(x: point.element.x - w, y: point.element.y - w,
									width: self.markerSize, height: self.markerSize)
				if dataSource.valueAtOffsetIsBelowZeroline(point.offset) {
					nPoints.addPath(CGPath(ellipseIn: r, transform: nil))
				}
				else {
					pPoints.addPath(CGPath(ellipseIn: r, transform: nil))
				}
			}
		}

		let path = CGPath.pathWithPoints(points, smoothed: self.interpolated).mutableCopy()!

		for which in 0 ... 1 {
			if dataSource.counter < dataSource.windowSize {
				let pos = CGFloat(dataSource.counter) * xDiff
				let clipRect = drawRect.divided(atDistance: pos, from: .maxXEdge).slice
				context.clip(to: clipRect)
			}

			context.usingGState { inner in

				let split = drawRect.divided(atDistance: centroid, from: .minYEdge)

				if which == 0 {
					inner.clip(to: split.slice)
				}
				else {
					inner.clip(to: split.remainder)
				}

				let fillItem = (which == 0) ? self.primaryFill : self.secondaryFill

				if let fill = fillItem {
					inner.usingGState { ctx in

						let altY = which == 0 ? drawRect.maxY : drawRect.minY

						let clipper = path.mutableCopy()!
						clipper.addLine(to: CGPoint(x: drawRect.maxX, y: points.last!.y))
						clipper.addLine(to: CGPoint(x: drawRect.maxX, y: altY))
						clipper.addLine(to: CGPoint(x: drawRect.minX, y: altY))
						clipper.addLine(to: CGPoint(x: drawRect.minX, y: points.first!.y))
						clipper.closeSubpath()

						ctx.addPath(clipper)
						ctx.clip()
						fill.fill(context: ctx, bounds: drawRect)
					}
				}

				let whichColor = (which == 0) ? self.primaryStrokeColor : self.secondaryStrokeColor

				if let stroke = whichColor {
					inner.usingGState { ctx in
						ctx.addPath(path)
						ctx.setStrokeColor(stroke)
						ctx.setLineWidth(self.strokeWidth)
						if let shadow = self.shadow {
							ctx.setShadow(shadow)
						}
						ctx.setLineJoin(.round)
						ctx.strokePath()
					}
				}
			}
		}

		// Draw the positive markers

		if !pPoints.isEmpty,
			let stroke = self.primaryStrokeColor {
			context.usingGState { ctx in
				ctx.addPath(pPoints)
				if let shadow = self.shadow {
					ctx.setShadow(shadow)
				}
				ctx.setFillColor(stroke)
				ctx.fillPath()
			}
		}

		// Draw the negative markers
		// If the secondary stroke isn't defined, use the primary stroke if it is defined (or else we get markers only
		// on the top part of the graph)

		if !nPoints.isEmpty,
			let stroke = firstNotNil([self.secondaryStrokeColor, self.primaryStrokeColor]) {
			context.usingGState { ctx in
				ctx.addPath(nPoints)
				if let shadow = self.shadow {
					ctx.setShadow(shadow)
				}
				ctx.setFillColor(stroke)
				ctx.fillPath()
			}
		}

		return drawRect
	}
}
