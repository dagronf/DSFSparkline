//
//  DSFSparklineOverlay+Stackline.swift
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
	/// A stackline graph
	@objc(DSFSparklineOverlayStackline) class Stackline: Centerable {
		/// The width for the line drawn on the graph
		@objc public var strokeWidth: CGFloat = 1.5 {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// Interpolate a curve between the points
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

		override internal func drawGraph(context: CGContext, bounds: CGRect, scale: CGFloat) {
			if self.centeredAtZeroLine {
				self.drawCenteredStackLineGraph(context: context, bounds: bounds, scale: scale)
			}
			else {
				self.drawStackLineGraph(context: context, bounds: bounds, scale: scale)
			}
		}
	}
}

extension DSFSparklineOverlay.Stackline {
	private func drawStackLineGraph(context: CGContext, bounds: CGRect, scale _: CGFloat) {
		guard let dataSource = self.dataSource else {
			return
		}

		let integralRect = bounds.integral
		let integralHeight: CGFloat = integralRect.height

		// This represents the _full_ width of a bar within the graph, including the spacing.
		let componentWidth = Int(integralRect.width) / Int(dataSource.windowSize)

		// The left offset in order to center X
		let xOffset: Int = (Int(bounds.width) - (componentWidth * Int(dataSource.windowSize))) / 2

		// The available height range
		let range: ClosedRange<CGFloat> = 1 ... max(1, integralRect.maxY)

		// The normalized (0 -> 1) data points
		let normalized = dataSource.normalized

		let points: [CGPoint] = normalized.enumerated().map {
			let xVal = xOffset + ($0.offset * componentWidth)
			let yVal = (integralHeight - ($0.element * integralHeight)).clamped(to: range)
			return CGPoint(x: xVal, y: Int(yVal))
		}

		let ordered = points.enumerated()

		let emptyBuckets = Int(dataSource.emptyValueCount)
		let available = Array(ordered.dropFirst(emptyBuckets))

		if available.count == 0 {
			// Nothing to do!
			return
		}

		context.usingGState { outer in

			outer.setRenderingIntent(.relativeColorimetric)
			outer.interpolationQuality = .none
			outer.setShouldAntialias(false)

			let linePath = CGMutablePath()
			for point in available {
				let currentPoint = point.element

				if linePath.isEmpty {
					// First point
					linePath.move(to: currentPoint)
					linePath.addLine(to: currentPoint.offsettingX(by: CGFloat(componentWidth)))
				}
				else {
					linePath.addLine(to: currentPoint)
					linePath.addLine(to: point.element.offsettingX(by: CGFloat(componentWidth)))
				}
			}

			if linePath.isEmpty {
				return
			}

			outer.usingGState { fillCtx in

				let fillPath = linePath.mutableCopy()!
				let bounds = fillPath.boundingBox

				fillPath.addLine(to: CGPoint(x: bounds.maxX, y: integralRect.maxY))
				fillPath.addLine(to: CGPoint(x: bounds.minX, y: integralRect.maxY))
				fillPath.closeSubpath()

				fillCtx.addPath(fillPath)
				fillCtx.clip()
				self.primaryFill?.fill(context: fillCtx, bounds: integralRect)
			}

			if let stroke = self.primaryStrokeColor {
				outer.addPath(linePath)
				outer.setStrokeColor(stroke)
				outer.setLineWidth(self.strokeWidth)

				if let shadow = self.shadow {
					outer.setShadow(shadow)
				}

				outer.strokePath()
			}
		}
	}

	private func drawCenteredStackLineGraph(context: CGContext, bounds: CGRect, scale _: CGFloat) {
		guard let dataSource = self.dataSource else {
			return
		}

		let integralRect = bounds.integral
		let integralHeight: CGFloat = integralRect.height

		// This represents the _full_ width of a bar within the graph, including the spacing.
		let componentWidth = Int(integralRect.width) / Int(dataSource.windowSize)

		// The left offset in order to center X
		let xOffset: Int = (Int(bounds.width) - (componentWidth * Int(dataSource.windowSize))) / 2

		// The available height range
		let range: ClosedRange<CGFloat> = 1 ... max(1, integralRect.maxY)

		// The normalized (0 -> 1) data points
		let normalized = dataSource.normalized

		let points: [CGPoint] = normalized.enumerated().map {
			let xVal = xOffset + ($0.offset * componentWidth)
			let yVal = (integralHeight - ($0.element * integralHeight)).clamped(to: range)
			return CGPoint(x: xVal, y: Int(yVal))
		}

		let ordered = points.enumerated()

		let emptyBuckets = Int(dataSource.emptyValueCount)
		let available = Array(ordered.dropFirst(emptyBuckets))

		if available.count == 0 {
			// Nothing to do!
			return
		}

		let centroid = (1 - dataSource.normalizedZeroLineValue) * (integralHeight - 1)

		let first = available.first!
		if first.offset != 0 {
			var clip = bounds
			clip.origin.x = first.element.x
			clip.size.width -= first.element.x
			context.clip(to: clip)
		}

		context.usingGState { outer in

			outer.setRenderingIntent(.relativeColorimetric)
			outer.interpolationQuality = .none
			outer.setShouldAntialias(false)

			let linePath = CGMutablePath()
			linePath.move(to: CGPoint(x: integralRect.minX - 1, y: centroid))
			linePath.addLine(to: CGPoint(x: integralRect.minX - 1, y: available.first!.element.y))

			for point in available {
				let currentPoint = point.element
				linePath.addLine(to: currentPoint)
				linePath.addLine(to: point.element.offsettingX(by: CGFloat(componentWidth)))
			}

			linePath.addLine(to: CGPoint(x: integralRect.maxX + 1, y: available.last!.element.y))
			linePath.addLine(to: CGPoint(x: integralRect.maxX + 1, y: centroid))

			if linePath.isEmpty {
				return
			}

			let outerClip = integralRect.insetBy(dx: CGFloat(xOffset), dy: 0)
			outer.clip(to: outerClip)

			outer.usingGState { clipped in

				let split = outerClip.divided(atDistance: centroid, from: .minYEdge)

				for which in 0 ... 1 {
					clipped.usingGState { inner in

						if which == 0 {
							inner.clip(to: split.slice)
						}
						else {
							inner.clip(to: split.remainder)
						}

						let fillItem = (which == 0) ? self.primaryFill : self.secondaryFill

						if let fill = fillItem {
							inner.usingGState { fillCtx in
								fillCtx.addPath(linePath)
								fillCtx.clip()
								fill.fill(context: fillCtx, bounds: integralRect)
							}
						}

						let whichStroke = (which == 0) ? self.primaryStrokeColor : self.secondaryStrokeColor

						if let strokeColor = whichStroke {
							inner.addPath(linePath)
							inner.setStrokeColor(strokeColor)
							inner.setLineWidth(self.strokeWidth)

							if let shadow = self.shadow {
								inner.setShadow(shadow)
							}

							inner.strokePath()
						}
					}
				}
			}
		}
		return
	}
}
