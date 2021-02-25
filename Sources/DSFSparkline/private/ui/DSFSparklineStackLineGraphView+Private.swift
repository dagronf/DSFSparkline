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

//#if os(macOS)
//import Cocoa
//#else
//import UIKit
//#endif
//
//extension DSFSparklineStackLineGraphView {
//	#if os(macOS)
//	override public func draw(_ dirtyRect: NSRect) {
//		super.draw(dirtyRect)
//		if let ctx = NSGraphicsContext.current?.cgContext {
//			self.drawGraph(primary: ctx)
//		}
//	}
//	#else
//	override public func draw(_ rect: CGRect) {
//		super.draw(rect)
//		if let ctx = UIGraphicsGetCurrentContext() {
//			self.drawGraph(primary: ctx)
//		}
//	}
//	#endif
//
//	override public func colorDidChange() {
//		// Update the gradients to match the color change
//
//		self.gradient = CGGradient(
//			colorsSpace: nil,
//			colors: [self.graphColor.withAlphaComponent(0.4).cgColor,
//						self.graphColor.withAlphaComponent(0.2).cgColor] as CFArray,
//			locations: [1.0, 0.0]
//		)!
//
//		let lc = self.lowerColor
//		self.lowerGradient = CGGradient(
//			colorsSpace: nil,
//			colors: [lc.withAlphaComponent(0.4).cgColor,
//						lc.withAlphaComponent(0.2).cgColor] as CFArray,
//			locations: [1.0, 0.0]
//		)!
//	}
//
//	private func drawGraph(primary: CGContext) {
//		if self.centeredAtZeroLine {
//			self.drawCenteredStackLineGraph(primary: primary)
//		}
//		else {
//			self.drawStackLineGraph(primary: primary)
//		}
//	}
//
//	private func drawStackLineGraph(primary: CGContext) {
//		guard let dataSource = self.dataSource else {
//			return
//		}
//
//		let integralRect = self.bounds.integral
//		let integralHeight: CGFloat = integralRect.height
//
//		// This represents the _full_ width of a bar within the graph, including the spacing.
//		let componentWidth = Int(integralRect.width) / Int(dataSource.windowSize)
//
//		// The left offset in order to center X
//		let xOffset: Int = (Int(self.bounds.width) - (componentWidth * Int(dataSource.windowSize))) / 2
//
//		// The available height range
//		let range: ClosedRange<CGFloat> = 1 ... max(1, integralRect.maxY)
//
//		// The normalized (0 -> 1) data points
//		let normalized = dataSource.normalized
//
//		let points: [CGPoint] = normalized.enumerated().map {
//			let xVal = xOffset + ($0.offset * componentWidth)
//			let yVal = (integralHeight - ($0.element * integralHeight)).clamped(to: range)
//			return CGPoint(x: xVal, y: Int(yVal))
//		}
//
//		let ordered = points.enumerated()
//
//		let emptyBuckets = Int(dataSource.emptyValueCount)
//		let available = Array(ordered.dropFirst(emptyBuckets))
//
//		if available.count == 0 {
//			// Nothing to do!
//			return
//		}
//
//		primary.usingGState { outer in
//
//			outer.setRenderingIntent(.relativeColorimetric)
//			outer.interpolationQuality = .none
//			outer.setShouldAntialias(false)
//
//			let linePath = CGMutablePath()
//			for point in available {
//				let currentPoint = point.element
//
//				if linePath.isEmpty {
//					// First point
//					linePath.move(to: currentPoint)
//					linePath.addLine(to: currentPoint.offsettingX(by: CGFloat(componentWidth)))
//				}
//				else {
//					linePath.addLine(to: currentPoint)
//					linePath.addLine(to: point.element.offsettingX(by: CGFloat(componentWidth)))
//				}
//			}
//
//			if linePath.isEmpty {
//				return
//			}
//
//			if self.lineShading, let gradient = self.gradient {
//				outer.usingGState { ctx in
//
//					let fillPath = linePath.mutableCopy()!
//					let bounds = fillPath.boundingBox
//
//					fillPath.addLine(to: CGPoint(x: bounds.maxX, y: integralRect.maxY))
//					fillPath.addLine(to: CGPoint(x: bounds.minX, y: integralRect.maxY))
//					fillPath.closeSubpath()
//
//					ctx.addPath(fillPath)
//					ctx.clip()
//					ctx.drawLinearGradient(
//						gradient, start: CGPoint(x: bounds.minX, y: integralRect.maxY),
//						end: CGPoint(x: bounds.minX, y: integralRect.minY),
//						options: [.drawsAfterEndLocation, .drawsBeforeStartLocation]
//					)
//				}
//			}
//
//			outer.addPath(linePath)
//			outer.setStrokeColor(self.graphColor.cgColor)
//			outer.setLineWidth(self.lineWidth)
//
//			if self.shadowed {
//				let yoff: CGFloat
//				#if os(macOS)
//				yoff = -0.5 // macos is flipped
//				#else
//				yoff = 0.5
//				#endif
//
//				outer.setShadow(offset: CGSize(width: 0.5, height: yoff),
//									 blur: 1.0,
//									 color: DSFColor.black.withAlphaComponent(0.3).cgColor)
//			}
//
//			outer.strokePath()
//		}
//	}
//
//	private func drawCenteredStackLineGraph(primary: CGContext) {
//		guard let dataSource = self.dataSource else {
//			return
//		}
//
//		let integralRect = self.bounds.integral
//		let integralHeight: CGFloat = integralRect.height
//
//		// This represents the _full_ width of a bar within the graph, including the spacing.
//		let componentWidth = Int(integralRect.width) / Int(dataSource.windowSize)
//
//		// The left offset in order to center X
//		let xOffset: Int = (Int(self.bounds.width) - (componentWidth * Int(dataSource.windowSize))) / 2
//
//		// The available height range
//		let range: ClosedRange<CGFloat> = 1 ... max(1, integralRect.maxY)
//
//		// The normalized (0 -> 1) data points
//		let normalized = dataSource.normalized
//
//		let points: [CGPoint] = normalized.enumerated().map {
//			let xVal = xOffset + ($0.offset * componentWidth)
//			let yVal = (integralHeight - ($0.element * integralHeight)).clamped(to: range)
//			return CGPoint(x: xVal, y: Int(yVal))
//		}
//
//		let ordered = points.enumerated()
//
//		let emptyBuckets = Int(dataSource.emptyValueCount)
//		let available = Array(ordered.dropFirst(emptyBuckets))
//
//		if available.count == 0 {
//			// Nothing to do!
//			return
//		}
//
//		let centroid = (1 - dataSource.normalizedZeroLineValue) * (integralHeight - 1)
//
//		let first = available.first!
//		if first.offset != 0 {
//			var clip = self.bounds
//			clip.origin.x = first.element.x
//			clip.size.width -= first.element.x
//			primary.clip(to: clip)
//		}
//
//		primary.usingGState { outer in
//
//			outer.setRenderingIntent(.relativeColorimetric)
//			outer.interpolationQuality = .none
//			outer.setShouldAntialias(false)
//
//			let linePath = CGMutablePath()
//			linePath.move(to: CGPoint(x: integralRect.minX - 1, y: centroid))
//			linePath.addLine(to: CGPoint(x: integralRect.minX - 1, y: available.first!.element.y))
//
//			for point in available {
//				let currentPoint = point.element
//				linePath.addLine(to: currentPoint)
//				linePath.addLine(to: point.element.offsettingX(by: CGFloat(componentWidth)))
//			}
//
//			linePath.addLine(to: CGPoint(x: integralRect.maxX + 1, y: available.last!.element.y))
//			linePath.addLine(to: CGPoint(x: integralRect.maxX + 1, y: centroid))
//
//			if linePath.isEmpty {
//				return
//			}
//
//			let outerClip = integralRect.insetBy(dx: CGFloat(xOffset), dy: 0)
//			outer.clip(to: outerClip)
//
//			outer.usingGState { clipped in
//
//				let split = outerClip.divided(atDistance: centroid, from: .minYEdge)
//
//				for which in 0 ... 1 {
//					clipped.usingGState { inner in
//
//						if which == 0 {
//							inner.clip(to: split.slice)
//						}
//						else {
//							inner.clip(to: split.remainder)
//						}
//
//						if self.lineShading {
//							let gradient = (which == 0) ? self.gradient : self.lowerGradient
//							if let grad = gradient {
//								inner.usingGState { ctx in
//									ctx.addPath(linePath)
//									ctx.clip()
//									ctx.drawLinearGradient(
//										grad, start: CGPoint(x: bounds.minX, y: integralRect.maxY),
//										end: CGPoint(x: bounds.minX, y: integralRect.minY),
//										options: [.drawsAfterEndLocation, .drawsBeforeStartLocation]
//									)
//								}
//							}
//						}
//
//						inner.addPath(linePath)
//						inner.setStrokeColor(which == 0 ? self.graphColor.cgColor : self.lowerColor.cgColor)
//						inner.setLineWidth(self.lineWidth)
//
//						if self.shadowed {
//							let yoff: CGFloat
//							#if os(macOS)
//							yoff = -0.5 // macos is flipped
//							#else
//							yoff = 0.5
//							#endif
//
//							inner.setShadow(
//								offset: CGSize(width: 0.5, height: yoff),
//								blur: 1.0,
//								color: DSFColor.black.withAlphaComponent(0.3).cgColor)
//						}
//
//						inner.strokePath()
//					}
//				}
//			}
//		}
//	}
//}
