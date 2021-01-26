//
//  DSFSparklineBarGraphView+Private.swift
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

public extension DSFSparklineWinLossGraphView {
	
	#if os(macOS)
	override func draw(_ dirtyRect: NSRect) {
		super.draw(dirtyRect)
		if let ctx = NSGraphicsContext.current?.cgContext {
			self.drawWinLossGraph(primary: ctx)
		}
	}
	#else
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		if let ctx = UIGraphicsGetCurrentContext() {
			self.drawWinLossGraph(primary: ctx)
		}
	}
	#endif

	private func drawWinLossGraph(primary: CGContext) {
		guard let dataSource = self.dataSource else {
			return
		}

		let integralRect = self.bounds.integral

		let windowSize: Int = Int(dataSource.windowSize)

		// This represents the _full_ width of a bar within the graph, including the spacing.
		let componentWidth: Int = Int(integralRect.width) / windowSize

		// The width of the BAR component
		let barWidth: Int = componentWidth - Int(self.barSpacing)

		// The left offset in order to center X
		let xOffset: Int = (Int(integralRect.width) - (componentWidth * windowSize)) / 2

		// Map the +ve values to true, the -ve (and 0) to false
		let winLoss: [Int] = dataSource.data.map {
			if $0 > 0 { return 1 }
			if $0 < 0 { return -1 }
			return 0
		}

		let graphLineWidth: CGFloat = 1 / self.retinaScale() * CGFloat(self.lineWidth)

		let midPoint = Int(bounds.midY.rounded())
		let barHeight = Int(integralRect.midY) - Int(self.lineWidth)

		primary.usingGState { outer in

			outer.setShouldAntialias(false)
			outer.setRenderingIntent(.relativeColorimetric)
			outer.interpolationQuality = .none

			if dataSource.counter < dataSource.windowSize {
				let pos = Int(dataSource.counter) * componentWidth
				let clipRect = integralRect.divided(atDistance: CGFloat(pos + xOffset), from: .maxXEdge).slice
				outer.clip(to: clipRect.integral)
			}

			let winPath = CGMutablePath()
			let lossPath = CGMutablePath()
			let tiePath = CGMutablePath()

			for point in winLoss.enumerated() {
				let x = xOffset + point.offset * componentWidth
				if point.element == 1 {
					let rect = CGRect(x: x, y: 1, width: barWidth, height: barHeight)
					winPath.addRect(rect.integral)
				}
				else if point.element == -1 {
					let rect = CGRect(x: x, y: midPoint + 1, width: barWidth, height: barHeight)
					lossPath.addRect(rect.integral)
				}
				else {
					let rect = CGRect(x: x, y: Int(integralRect.height) / 2 - (barHeight / 4), width: barWidth, height: barHeight / 2)
					tiePath.addRect(rect.integral)
				}
			}

			if !winPath.isEmpty {
				outer.usingGState { winState in
					winState.addPath(winPath)
					winState.setFillColor(self.winColor.withAlphaComponent(0.3).cgColor)
					winState.setStrokeColor(self.winColor.cgColor)
					winState.setLineWidth(graphLineWidth)
					winState.drawPath(using: .fillStroke)
				}
			}

			if !lossPath.isEmpty {
				outer.usingGState { lossState in
					lossState.addPath(lossPath)
					lossState.setFillColor(self.lossColor.withAlphaComponent(0.3).cgColor)
					lossState.setStrokeColor(self.lossColor.cgColor)
					lossState.setLineWidth(graphLineWidth)
					lossState.drawPath(using: .fillStroke)
				}
			}

			if let tieColor = self.tieColor, !tiePath.isEmpty {
				outer.usingGState { tieState in
					tieState.addPath(tiePath)
					tieState.setLineWidth(graphLineWidth)

					let tieAlpha = min(1, tieColor.cgColor.alpha + 0.1)
					tieState.setFillColor(tieColor.cgColor)
					tieState.setStrokeColor(tieColor.withAlphaComponent(tieAlpha).cgColor)
					tieState.drawPath(using: .fillStroke)
				}
			}
		}
	}

	override func prepareForInterfaceBuilder() {

		let e = 0 ..< self.graphWindowSize
		let data = e.map { arg in return Int.random(in: -1 ... 1) }

		let ds = DSFSparklineDataSource(windowSize: self.graphWindowSize)
		self.dataSource = ds
		ds.set(values: data.map { CGFloat($0) })

		#if TARGET_INTERFACE_BUILDER
		/// Need this to hold on to the datasource, or else it disappears due to being weak
		self.ibDataSource = ds
		#endif
	}
}
