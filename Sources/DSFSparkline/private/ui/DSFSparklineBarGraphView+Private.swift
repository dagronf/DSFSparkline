//
//  DSFSparklineBarGraphView+Private.swift
//  DSFSparklines
//
//  Created by Darren Ford on 16/1/20.
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

//#if os(macOS)
//import Cocoa
//#else
//import UIKit
//#endif
//
//public extension DSFSparklineBarGraphView {
//	#if os(macOS)
//	override func draw(_ dirtyRect: NSRect) {
//		super.draw(dirtyRect)
//		if let ctx = NSGraphicsContext.current?.cgContext {
//			self.drawGraph(primary: ctx)
//		}
//	}
//	#else
//	override func draw(_ rect: CGRect) {
//		super.draw(rect)
//		if let ctx = UIGraphicsGetCurrentContext() {
//			self.drawGraph(primary: ctx)
//		}
//	}
//	#endif
//
//	private func drawGraph(primary: CGContext) {
//		if self.centeredAtZeroLine {
//			self.drawCenteredBarGraph(primary: primary)
//		}
//		else {
//			self.drawBarGraph(primary: primary)
//		}
//	}
//
//	private func drawBarGraph(primary: CGContext) {
//		guard let dataSource = self.dataSource else {
//			return
//		}
//
//		let integralRect = self.bounds.integral
//
//		// This represents the _full_ width of a bar within the graph, including the spacing.
//		let componentWidth = Int(integralRect.width) / Int(dataSource.windowSize)
//
//		// The width of the BAR component
//		let barWidth = componentWidth - Int(barSpacing)
//
//		// The left offset in order to center X
//		let xOffset: Int = (Int(self.bounds.width) - (componentWidth * Int(dataSource.windowSize))) / 2
//
//		// The available height range
//		let range: ClosedRange<CGFloat> = 2 ... max(2, integralRect.maxY - 2)
//
//		let normy = dataSource.normalized
//		let xDiff = self.bounds.width / CGFloat(normy.count)
//		let points = normy.enumerated().map {
//			CGPoint(x: CGFloat($0.offset) * xDiff, y: ($0.element * (integralRect.height - 1)).clamped(to: range))
//		}
//
//		primary.usingGState { outer in
//
//			outer.setRenderingIntent(.relativeColorimetric)
//			outer.interpolationQuality = .none
//			outer.setShouldAntialias(false)
//
//			if dataSource.counter < dataSource.windowSize {
//				let pos = xOffset + (Int(dataSource.counter) * componentWidth)
//				let clipRect = self.bounds.divided(atDistance: CGFloat(pos), from: .maxXEdge).slice
//				outer.clip(to: clipRect)
//			}
//
//			var bars: [CGRect] = []
//			for point in points.enumerated() {
//				let yVal = Int(point.element.y.rounded(.down))
//				let r = CGRect(x: xOffset + point.offset * componentWidth,
//									y: Int(integralRect.height) - yVal,
//									width: barWidth,
//									height: yVal - Int(self.lineWidth))
//				bars.append(r.integral)
//			}
//
//			let path = CGMutablePath()
//			path.addRects(bars)
//
//			outer.addPath(path)
//			outer.setFillColor(self.graphColor.withAlphaComponent(0.3).cgColor)
//			outer.setLineWidth(1 / self.retinaScale() * CGFloat(self.lineWidth))
//			outer.setStrokeColor(self.graphColor.cgColor)
//
//			outer.drawPath(using: .fillStroke)
//		}
//	}
//
//	private func drawCenteredBarGraph(primary: CGContext) {
//
//		guard let dataSource = self.dataSource else {
//			return
//		}
//
//		let drawRect = self.bounds
//		let height = drawRect.height - 1
//
//		let normy = dataSource.normalized
//		let xDiff = self.bounds.width / CGFloat(normy.count)
//
//		let centre = dataSource.normalizedZeroLineValue
//		let centroid = (1 - centre) * (drawRect.height - 1)
//
//		primary.usingGState { outer in
//
//			outer.setRenderingIntent(.relativeColorimetric)
//			outer.interpolationQuality = .none
//
//			if dataSource.counter < dataSource.windowSize {
//				let pos = CGFloat(dataSource.counter) * xDiff + 1
//				let clipRect = self.bounds.divided(atDistance: pos, from: .maxXEdge).slice
//				outer.clip(to: clipRect)
//			}
//
//			var positivePath: [CGRect] = []
//			var negativePath: [CGRect] = []
//
//			for value in normy.enumerated() {
//				let x = CGFloat(value.offset) * xDiff
//				if value.element >= centre {
//					let yy = (centre - value.element) * height
//					let r = CGRect(x: x,
//										y: centroid,
//										width: xDiff - 1 - (CGFloat(self.barSpacing)),
//										height: yy) // - CGFloat(self.lineWidth))
//					positivePath.append(r.integral)
//				}
//				else {
//					let yy = (value.element - centre) * height
//					let r = CGRect(x: x,
//										y: centroid,
//										width: xDiff - 1 - (CGFloat(self.barSpacing)),
//										height: -yy - CGFloat(self.lineWidth))
//					negativePath.append(r.integral)
//				}
//			}
//
//			outer.setShouldAntialias(false)
//
//			if !positivePath.isEmpty {
//				let path = CGMutablePath()
//				path.addRects(positivePath)
//				outer.usingGState { ctx in
//					ctx.addPath(path)
//					ctx.setFillColor(self.graphColor.withAlphaComponent(0.3).cgColor)
//					ctx.setLineWidth(1 / self.retinaScale() * CGFloat(self.lineWidth))
//					ctx.setStrokeColor(self.graphColor.cgColor)
//					ctx.drawPath(using: .fillStroke)
//				}
//			}
//
//			if !negativePath.isEmpty {
//				let path = CGMutablePath()
//				path.addRects(negativePath)
//				outer.usingGState { ctx in
//					ctx.addPath(path)
//					ctx.setFillColor(self.lowerColor.withAlphaComponent(0.3).cgColor)
//					ctx.setLineWidth(1 / self.retinaScale() * CGFloat(self.lineWidth))
//					ctx.setStrokeColor(self.lowerColor.cgColor)
//					ctx.drawPath(using: .fillStroke)
//				}
//			}
//		}
//	}
//
//}
