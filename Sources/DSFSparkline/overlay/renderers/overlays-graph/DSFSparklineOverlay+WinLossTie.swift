//
//  DSFSparklineOverlay+WinLossTie.swift
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

import QuartzCore

public extension DSFSparklineOverlay {
	@objc(DSFSparklineOverlayWinLossTie) class WinLossTie: DSFSparklineOverlay.DataSource {

		static let greenStroke = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0, 1, 0, 1])!
		static let greenFill = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0, 1, 0, 0.3])!
		static let redStroke = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1, 0, 0, 1])!
		static let redFill = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1, 0, 0, 0.3])!

		/// The width of the stroke for the tablet
		@objc public var lineWidth: UInt = 1 {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The spacing (in pixels) between each bar
		@objc public var barSpacing: UInt = 1 {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The color to draw the 'win' boxes
		@objc public var winStroke: CGColor = WinLossTie.greenStroke {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The color to draw the 'win' boxes
		@objc public var winFill: CGColor = WinLossTie.greenFill {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The color to draw the 'loss' boxes
		@objc public var lossStroke: CGColor = WinLossTie.redStroke {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The color to draw the 'loss' boxes
		@objc public var lossFill: CGColor = WinLossTie.redFill {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The color to draw the 'tie' boxes
		@objc public var tieStroke: CGColor? {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The color to draw the 'tie' boxes
		@objc public var tieFill: CGColor? {
			didSet {
				self.setNeedsDisplay()
			}
		}


		public override func drawGraph(context: CGContext, bounds: CGRect, scale: CGFloat) -> CGRect {
			self.drawWinLossGraph(context: context, bounds: bounds, scale: scale)
		}
	}
}

private extension DSFSparklineOverlay.WinLossTie {
	 func drawWinLossGraph(context: CGContext, bounds: CGRect, scale: CGFloat) -> CGRect {
		guard let dataSource = self.dataSource else {
			return bounds
		}

		let integralRect = bounds.integral

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

		let graphLineWidth: CGFloat = 1 / scale * CGFloat(self.lineWidth)

		let midPoint = Int(bounds.midY.rounded())
		let barHeight = Int(integralRect.midY) - Int(self.lineWidth)

		context.usingGState { outer in

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
					winState.setFillColor(self.winFill)
					winState.setStrokeColor(self.winStroke)
					winState.setLineWidth(graphLineWidth)
					winState.drawPath(using: .fillStroke)
				}
			}

			if !lossPath.isEmpty {
				outer.usingGState { lossState in
					lossState.addPath(lossPath)
					lossState.setFillColor(self.lossFill)
					lossState.setStrokeColor(self.lossStroke)
					lossState.setLineWidth(graphLineWidth)
					lossState.drawPath(using: .fillStroke)
				}
			}

			if !tiePath.isEmpty,
				self.tieFill != nil || self.tieStroke != nil {

				if let fill = self.tieFill {
					outer.usingGState { tieState in
						tieState.addPath(tiePath)
						tieState.setFillColor(fill)
						tieState.drawPath(using: .fill)
					}
				}

				if let stroke = self.tieStroke {
					outer.usingGState { tieState in
						tieState.addPath(tiePath)
						tieState.setLineWidth(graphLineWidth)
						tieState.setStrokeColor(stroke)
						tieState.drawPath(using: .stroke)
					}
				}
			}
		}
		return bounds
	}
}
