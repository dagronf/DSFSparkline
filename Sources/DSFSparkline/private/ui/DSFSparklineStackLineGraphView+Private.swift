//
//  DSFSparklineLineGraphView+Private.swift
//  DSFSparklines
//
//  Created by Darren Ford on 21/12/19.
//  Copyright © 2019 Darren Ford. All rights reserved.
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

extension DSFSparklineStackLineGraphView {

	#if os(macOS)
	override public func draw(_ dirtyRect: NSRect) {
		super.draw(dirtyRect)
		if let ctx = NSGraphicsContext.current?.cgContext {
			drawGraph(primary: ctx)
		}
	}
	#else
	public override func draw(_ rect: CGRect) {
		super.draw(rect)
		if let ctx = UIGraphicsGetCurrentContext() {
			drawGraph(primary: ctx)
		}
	}
	#endif

	private func drawGraph(primary: CGContext) {

		guard let dataSource = self.dataSource else {
			return
		}

		let integralRect = self.bounds.integral
		let integralHeight: CGFloat = integralRect.height

		// This represents the _full_ width of a bar within the graph, including the spacing.
		let componentWidth = Int(integralRect.width) / Int(dataSource.windowSize)

		// The left offset in order to center X
		let xOffset: Int = (Int(self.bounds.width) - (componentWidth * Int(dataSource.windowSize))) / 2

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

		primary.usingGState { outer in

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

			if self.lineShading, let gradient = self.gradient {
				outer.usingGState { (ctx) in

					let fillPath = linePath.mutableCopy()!
					let bounds = fillPath.boundingBox

					fillPath.addLine(to: CGPoint(x: bounds.maxX, y: integralRect.maxY))
					fillPath.addLine(to: CGPoint(x: bounds.minX, y: integralRect.maxY))
					fillPath.closeSubpath()

					ctx.addPath(fillPath)
					ctx.clip()
					ctx.drawLinearGradient(
						gradient, start: CGPoint(x: bounds.minX, y: integralRect.maxY),
						end: CGPoint(x: bounds.minX, y: integralRect.minY),
						options: [.drawsAfterEndLocation, .drawsBeforeStartLocation])
				}
			}

			outer.addPath(linePath)
			outer.setStrokeColor(self.graphColor.cgColor)
			outer.setLineWidth(self.lineWidth)

			if self.shadowed {

				let yoff: CGFloat
				#if os(macOS)
				yoff = -0.5		// macos is flipped
				#else
				yoff = 0.5
				#endif

				outer.setShadow(offset: CGSize(width: 0.5, height: yoff),
								  blur: 1.0,
								  color: DSFColor.black.withAlphaComponent(0.3).cgColor)
			}

			outer.strokePath()
		}
	}
}


