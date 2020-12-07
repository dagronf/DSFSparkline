//
//  DSFSparklineBarGraph+Private.swift
//  DSFSparklines
//
//  Created by Darren Ford on 16/1/20.
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

public extension DSFSparklineBarGraph {
	#if os(macOS)
	override func draw(_ dirtyRect: NSRect) {
		super.draw(dirtyRect)
		if let ctx = NSGraphicsContext.current?.cgContext {
			self.drawBarGraph(primary: ctx)
		}
	}
	#else
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		if let ctx = UIGraphicsGetCurrentContext() {
			self.drawBarGraph(primary: ctx)
		}
	}
	#endif

	#if os(macOS)
	func retinaScale() -> CGFloat {
		return self.window?.screen?.backingScaleFactor ?? 1.0
	}
	#else
	func retinaScale() -> CGFloat {
		return self.window?.screen.scale ?? 1.0
	}
	#endif

	private func drawBarGraph(primary: CGContext) {
		let drawRect = self.bounds

		let range: ClosedRange<CGFloat> = 2 ... max(2, drawRect.maxY - 2)

		guard let dataSource = self.dataSource else {
			return
		}

		let normy = dataSource.normalized
		let xDiff = self.bounds.width / CGFloat(normy.count)
		let points = normy.enumerated().map {
			CGPoint(x: CGFloat($0.offset) * xDiff, y: ($0.element * (drawRect.height - 1)).clamped(to: range))
		}

		primary.usingGState { outer in

			outer.setRenderingIntent(.relativeColorimetric)
			outer.interpolationQuality = .none

			if dataSource.counter < dataSource.windowSize {
				let pos = CGFloat(dataSource.counter) * xDiff + 1
				let clipRect = self.bounds.divided(atDistance: pos, from: .maxXEdge).slice
				outer.clip(to: clipRect)
			}

			let path = CGMutablePath()
			for point in points.enumerated() {
				let r = CGRect(x: CGFloat(point.offset) * xDiff,
							   y: drawRect.height - point.element.y,
							   width: xDiff - 1 - (CGFloat(self.barSpacing) * self.retinaScale()),
							   height: point.element.y - CGFloat(self.lineWidth))
				path.addRect(r.integral)
			}
			path.closeSubpath()

			outer.addPath(path)

			outer.setShouldAntialias(false)

			outer.setFillColor(self.graphColor.withAlphaComponent(0.3).cgColor)
			outer.setLineWidth(1 / self.retinaScale() * CGFloat(self.lineWidth))
			outer.setStrokeColor(self.graphColor.cgColor)


			outer.drawPath(using: .fillStroke)
		}

		let color: SLColor
		#if os(macOS)
		color = SLColor.disabledControlTextColor
		#else
		color = SLColor.systemGray
		#endif

		if self.showZero {
			let frac = self.dataSource?.fractionalZeroPosition() ?? 1
			let zeroPos = self.bounds.height - (frac * self.bounds.height)
			primary.usingGState { ctx in
				ctx.setLineWidth(1 / self.retinaScale())
				ctx.setStrokeColor(color.cgColor)
				ctx.setLineDash(phase: 0.0, lengths: [1, 1])
				ctx.strokeLineSegments(between: [CGPoint(x: 0.0, y: zeroPos), CGPoint(x: drawRect.width, y: zeroPos)])
			}
		}
	}
}
