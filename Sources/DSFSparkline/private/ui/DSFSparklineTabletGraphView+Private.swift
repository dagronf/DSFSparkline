////
////  DSFSparklineTabletGraphView+Private.swift
////  DSFSparklines
////
////  Created by Darren Ford on 16/1/20.
////  Copyright © 2019 Darren Ford. All rights reserved.
////
////  MIT license
////
////  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
////  documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
////  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
////  permit persons to whom the Software is furnished to do so, subject to the following conditions:
////
////  The above copyright notice and this permission notice shall be included in all copies or substantial
////  portions of the Software.
////
////  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
////  WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
////  OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
////  OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
////
//
//#if os(macOS)
//import Cocoa
//#else
//import UIKit
//#endif
//
//public extension DSFSparklineTabletGraphView {
//	
//	#if os(macOS)
//	override func draw(_ dirtyRect: NSRect) {
//		super.draw(dirtyRect)
//		if let ctx = NSGraphicsContext.current?.cgContext {
//			self.drawTabletGraph(primary: ctx)
//		}
//	}
//	#else
//	override func draw(_ rect: CGRect) {
//		super.draw(rect)
//		if let ctx = UIGraphicsGetCurrentContext() {
//			self.drawTabletGraph(primary: ctx)
//		}
//	}
//	#endif
//
//	private func drawTabletGraph(primary: CGContext) {
//		guard let dataSource = self.dataSource else {
//			return
//		}
//
//		let integralRect = self.bounds.insetBy(dx: 0, dy: 1)
//		let windowSize = CGFloat(dataSource.windowSize)
//
//		// The amount of space left in the rect once we've removed the bar spacing for all elements
//		let w = integralRect.width - (windowSize * (self.barSpacing + self.lineWidth))
//
//		// The size of a circle
//		let circleSize = min(w / CGFloat(windowSize), integralRect.height)
//
//		// This represents the _full_ width of a circle, including the spacing.
//		let componentWidth = circleSize + self.barSpacing + self.lineWidth
//
//		// The left offset in order to center X
//		let xOffset: CGFloat = (integralRect.width - (componentWidth * windowSize)) / 2
//
//		// Map the +ve values to true, the -ve (and 0) to false
//		let winLoss: [Int] = dataSource.data.map {
//			if $0 > 0 { return 1 }
//			return -1
//		}
//
//		let midPoint = bounds.midY
//
//		primary.usingGState { outer in
//
//			if dataSource.counter < dataSource.windowSize {
//				let pos = CGFloat(dataSource.counter) * componentWidth
//				let clipRect = integralRect.divided(atDistance: CGFloat(pos + xOffset + CGFloat(self.barSpacing / 2)), from: .maxXEdge).slice
//				outer.clip(to: clipRect.integral)
//			}
//
//			let winPath = CGMutablePath()
//			let lossPath = CGMutablePath()
//
//			for point in winLoss.enumerated() {
//				let x = xOffset + CGFloat(point.offset) * componentWidth
//				if point.element == 1 {
//					let rect = CGRect(x: x, y: midPoint - (circleSize / 2), width: circleSize, height: circleSize)
//					winPath.addEllipse(in: rect.integral)
//				}
//				else if point.element == -1 {
//					let rect = CGRect(x: x, y: midPoint - (circleSize / 2), width: circleSize, height: circleSize)
//					lossPath.addEllipse(in: rect.integral)
//				}
//			}
//
//			if !winPath.isEmpty {
//				outer.usingGState { winState in
//					winState.addPath(winPath)
//					winState.setFillColor(self.winColor.withAlphaComponent(0.3).cgColor)
//					winState.setStrokeColor(self.winColor.cgColor)
//					winState.setLineWidth(self.lineWidth)
//					winState.drawPath(using: .fillStroke)
//				}
//			}
//
//			if !lossPath.isEmpty {
//				outer.usingGState { lossState in
//					lossState.addPath(lossPath)
//					lossState.setStrokeColor(self.lossColor.cgColor)
//					lossState.setLineWidth(self.lineWidth)
//					lossState.drawPath(using: .stroke)
//				}
//			}
//		}
//	}
//
//
//	override func prepareForInterfaceBuilder() {
//
//		let e = 0 ..< self.graphWindowSize
//		let data = e.map { arg in return Int.random(in: -1 ... 1) }
//
//		let ds = DSFSparklineDataSource(windowSize: self.graphWindowSize)
//		self.dataSource = ds
//		ds.set(values: data.map { CGFloat($0) })
//
//		#if TARGET_INTERFACE_BUILDER
//		/// Need this to hold on to the datasource, or else it disappears due to being weak
//		self.ibDataSource = ds
//		#endif
//	}
//}
