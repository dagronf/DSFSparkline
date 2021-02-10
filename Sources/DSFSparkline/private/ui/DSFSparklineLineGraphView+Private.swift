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

extension DSFSparklineLineGraphView {

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
		if self.centeredAtZeroLine {
			self.drawCenteredGraph(primary: primary)
		}
		else {
			self.drawLineGraph(primary: primary)
		}
	}
}

fileprivate extension DSFSparklineLineGraphView {

	func drawLineGraph(primary: CGContext) {

		let drawRect = self.bounds

		let range: ClosedRange<CGFloat> = 2 ... drawRect.maxY - 2

		guard let dataSource = self.dataSource else {
			return
		}

		let normy = dataSource.normalized
		let xDiff = self.bounds.width / CGFloat(normy.count - 1)
		let points = normy.enumerated().map {
			CGPoint(x: CGFloat($0.offset) * xDiff, y: drawRect.height - ($0.element * (drawRect.height-1)).clamped(to: range))
		}

		if points.count < 2 {
			// There's no line if there's either no data or just a single point
			// https://github.com/dagronf/DSFSparkline/issues/3#issuecomment-770324047
			return
		}

		let path = CGPath.pathWithPoints(points, smoothed: self.interpolated).mutableCopy()!
		path.addLine(to: CGPoint(x: drawRect.width + 4, y: points.last!.y))
		path.addLine(to: CGPoint(x: drawRect.width + 4, y: drawRect.maxY + 2.0))
		path.addLine(to: CGPoint(x: -2.0, y: drawRect.maxY + 2.0))
		path.addLine(to: CGPoint(x: -2.0, y: points.first!.y))
		path.closeSubpath()

		primary.usingGState { (outer) in

			if dataSource.counter < dataSource.windowSize {
				let pos = CGFloat(dataSource.counter) * xDiff
				let clipRect = self.bounds.divided(atDistance: pos, from: .maxXEdge).slice
				outer.clip(to: clipRect)
			}

			if self.lineShading, let gradient = self.gradient {
				outer.usingGState { (ctx) in
					ctx.addPath(path)
					ctx.clip()
					ctx.drawLinearGradient(
						gradient, start: CGPoint(x: 0.0, y: self.bounds.maxY),
						end: CGPoint(x: 0.0, y: self.bounds.minY),
						options: [.drawsAfterEndLocation, .drawsBeforeStartLocation])
				}
			}

			outer.usingGState { (ctx) in
				ctx.addPath(path)
				ctx.setStrokeColor(self.graphColor.cgColor)
				ctx.setLineWidth(self.lineWidth)

				let yoff: CGFloat
				#if os(macOS)
				yoff = -0.5		// macos is flipped
				#else
				yoff = 0.5
				#endif

				if shadowed {
					ctx.setShadow(offset: CGSize(width: 0.5, height: yoff),
									  blur: 1.0,
									  color: DSFColor.black.withAlphaComponent(0.3).cgColor)
				}
				ctx.setLineJoin(.round)
				ctx.strokePath()
			}
		}
	}

	func drawCenteredGraph(primary: CGContext) {

		let drawRect = self.bounds

		let range: ClosedRange<CGFloat> = 2 ... drawRect.maxY - 2

		guard let dataSource = self.dataSource else {
			return
		}

		let normy = dataSource.normalized
		let xDiff = self.bounds.width / CGFloat(normy.count - 1)
		let points = normy.enumerated().map {
			CGPoint(x: CGFloat($0.offset) * xDiff, y: drawRect.height - ($0.element * (drawRect.height-1)).clamped(to: range))
		}

		if points.count < 2 {
			// There's no line if there's either no data or just a single point
			// https://github.com/dagronf/DSFSparkline/issues/3#issuecomment-770324047
			return
		}

		let centroid = (1-dataSource.normalizedZeroLineValue) * (drawRect.height - 1)

		//let path = CGMutablePath()

		var pts: [CGPoint] = [CGPoint(x: drawRect.minX - 1, y: centroid)]
		pts.append(CGPoint(x: -1, y: points[0].y))
		pts.append(contentsOf: points)
		pts.append(CGPoint(x: drawRect.maxX + 1, y: points.last!.y))
		pts.append(CGPoint(x: drawRect.maxX + 1, y: centroid))

		let path = CGPath.pathWithPoints(pts, smoothed: self.interpolated).mutableCopy()!
		
		primary.usingGState { (outer) in

			for which in (0 ... 1) {

				if dataSource.counter < dataSource.windowSize {
					let pos = CGFloat(dataSource.counter) * xDiff
					let clipRect = self.bounds.divided(atDistance: pos, from: .maxXEdge).slice
					outer.clip(to: clipRect)
				}

				outer.usingGState { (inner) in

					let split = self.bounds.divided(atDistance: centroid, from: .minYEdge)

					if which == 0 {
						inner.clip(to: split.slice)
					}
					else {
						inner.clip(to: split.remainder)
					}

					if self.lineShading {
						let gradient = (which == 0) ? self.gradient : self.negativeGradient
						if let grad = gradient {
							inner.usingGState { (ctx) in
								ctx.addPath(path)
								ctx.clip()
								ctx.drawLinearGradient(
									grad, start: CGPoint(x: 0.0, y: self.bounds.maxY),
									end: CGPoint(x: 0.0, y: self.bounds.minY),
									options: [.drawsAfterEndLocation, .drawsBeforeStartLocation])
							}
						}
					}

					inner.usingGState { (ctx) in
						ctx.addPath(path)
						ctx.setStrokeColor(which == 0 ? self.graphColor.cgColor : self.negativeColor.cgColor)
						ctx.setLineWidth(self.lineWidth)

						let yoff: CGFloat
						#if os(macOS)
						yoff = -0.5		// macos is flipped
						#else
						yoff = 0.5
						#endif

						if shadowed {
							ctx.setShadow(offset: CGSize(width: 0.5, height: yoff),
											  blur: 1.0,
											  color: DSFColor.black.withAlphaComponent(0.3).cgColor)
						}
						ctx.setLineJoin(.round)
						ctx.strokePath()
					}
				}
			}
		}
	}
}
