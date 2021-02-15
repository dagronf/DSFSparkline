//
//  DSFSparklineStripesGraphView+Private.swift
//  DSFSparklines
//
//  Created by Darren Ford on 15/2/21.
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

public extension DSFSparklineStripesGraphView {
	#if os(macOS)
	override func draw(_ dirtyRect: NSRect) {
		super.draw(dirtyRect)
		if let ctx = NSGraphicsContext.current?.cgContext {
			self.drawGraph(primary: ctx)
		}
	}
	#else
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		if let ctx = UIGraphicsGetCurrentContext() {
			self.drawGraph(primary: ctx)
		}
	}
	#endif

	private func drawGraph(primary: CGContext) {
		if self.integral {
			drawStripeGraph(primary: primary)
		}
		else {
			self.drawStripeGraphFloat(primary: primary)
		}
	}

	private func drawStripeGraph(primary: CGContext) {
		guard let dataSource = self.dataSource,
				let _ = self.gradient else {
			return
		}

		let integralRect = self.bounds.integral

		// This represents the _full_ width of a bar within the graph, including the spacing.
		let componentWidth = Int(integralRect.width) / Int(dataSource.windowSize)

		// The width of the BAR component
		let barWidth = componentWidth - Int(barSpacing)

		// The left offset in order to center X
		let xOffset: Int = (Int(self.bounds.width) - (componentWidth * Int(dataSource.windowSize))) / 2

		// The available height range
		//let range: ClosedRange<CGFloat> = 2 ... max(2, integralRect.maxY - 2)

		let normalizedPoints = dataSource.normalized
		//let xDiff = self.bounds.width / CGFloat(normy.count)

		primary.usingGState { outer in

			outer.setRenderingIntent(.relativeColorimetric)
			outer.interpolationQuality = .none
			outer.setShouldAntialias(false)

			if dataSource.counter < dataSource.windowSize {
				let pos = xOffset + (Int(dataSource.counter) * componentWidth)
				let clipRect = self.bounds.divided(atDistance: CGFloat(pos), from: .maxXEdge).slice
				outer.clip(to: clipRect)
			}

			for value in normalizedPoints.enumerated() {
				outer.usingGState { inner in
					let color = self.helper.color(at: value.element)
					inner.setFillColor(color)
					let r = CGRect(x: CGFloat(xOffset + value.offset * componentWidth),
										y: integralRect.minX,
										width: CGFloat(barWidth) + (1.0 / self.retinaScale()),
										height: integralRect.height)
					inner.fill(r)
				}
			}
		}
	}

	private func drawStripeGraphFloat(primary: CGContext) {
		guard let dataSource = self.dataSource,
				let _ = self.gradient else {
			return
		}

		let drawRect = self.bounds

		// This represents the _full_ width of a bar within the graph, including the spacing.
		let componentWidth = drawRect.width / CGFloat(dataSource.windowSize)

		// The width of the BAR component
		let barWidth = componentWidth - CGFloat(barSpacing)

		let normalizedPoints = dataSource.normalized

		primary.usingGState { outer in

			if dataSource.counter < dataSource.windowSize {
				let pos = CGFloat(dataSource.counter) * componentWidth
				let clipRect = self.bounds.divided(atDistance: CGFloat(pos), from: .maxXEdge).slice
				outer.clip(to: clipRect)
			}

			for value in normalizedPoints.enumerated() {
				outer.usingGState { inner in
					let color = self.helper.color(at: value.element)
					inner.setFillColor(color)
					let r = CGRect(x: CGFloat(value.offset) * componentWidth - (barSpacing == 0 ? 0.5 : 0),
										y: drawRect.minX,
										width: barWidth + (barSpacing == 0 ? 0.5 : 0),
										height: drawRect.height)
					inner.addRect(r)
					inner.drawPath(using: .fill)
				}
			}
		}
	}

}
