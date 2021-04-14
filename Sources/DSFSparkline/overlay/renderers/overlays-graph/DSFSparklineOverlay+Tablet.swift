//
//  DSFSparklineOverlay+Tablet.swift
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
	/// A tablet-style graph.
	@objc(DSFSparklineOverlayTablet) class Tablet: DSFSparklineOverlay.DataSource {

		static let greenStroke = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0, 1, 0, 1])!
		static let redStroke = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1, 0, 0, 1])!

		static let greenFill = DSFSparkline.Fill.Color(CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0, 1, 0, 0.3])!)
		static let redFill = DSFSparkline.Fill.Color(CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1, 0, 0, 0.3])!)


		/// The width of the stroke for the tablet
		@objc public var lineWidth: CGFloat = 1.0 {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The spacing (in pixels) between each tablet
		@objc public var tabletSpacing: CGFloat = 1.0 {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The color to draw the win tablets
		@objc public var winStrokeColor: CGColor = Tablet.greenStroke {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The color to draw the 'win' boxes
		@objc public var winFill: DSFSparklineFillable? = Tablet.greenFill {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The color to draw the win tablets
		@objc public var lossStrokeColor: CGColor = Tablet.redStroke {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The color to draw the 'win' boxes
		@objc public var lossFill: DSFSparklineFillable? {
			didSet {
				self.setNeedsDisplay()
			}
		}

		internal override func drawGraph(context: CGContext, bounds: CGRect, scale: CGFloat) {
			self.drawTabletGraph(context: context, bounds: bounds, scale: scale)
		}
	}
}

private extension DSFSparklineOverlay.Tablet {
	func drawTabletGraph(context: CGContext, bounds: CGRect, scale: CGFloat) {
		guard let dataSource = self.dataSource else {
			return
		}

		let integralRect = bounds.insetBy(dx: 0, dy: 1)
		let windowSize = CGFloat(dataSource.windowSize)

		// The amount of space left in the rect once we've removed the bar spacing for all elements
		let w = integralRect.width - (windowSize * (self.tabletSpacing + self.lineWidth)) - 2*self.lineWidth

		// The size of a circle
		let circleSize = min(w / CGFloat(windowSize), integralRect.height)

		// This represents the _full_ width of a circle, including the spacing.
		let componentWidth = circleSize + self.tabletSpacing + self.lineWidth

		// The left offset in order to center X
		let xOffset: CGFloat = (integralRect.width - (componentWidth * windowSize)) / 2

		// Map the +ve values to true, the -ve (and 0) to false
		let winLoss: [Int] = dataSource.data.map {
			if $0 > 0 { return 1 }
			return -1
		}

		let midPoint = bounds.midY

		context.usingGState { outer in

			if dataSource.counter < dataSource.windowSize {
				let pos = CGFloat(dataSource.counter) * componentWidth
				let clipRect = integralRect.divided(atDistance: CGFloat(pos + xOffset + CGFloat(self.tabletSpacing / 2)), from: .maxXEdge).slice
				outer.clip(to: clipRect.integral)
			}

			let winPath = CGMutablePath()
			let lossPath = CGMutablePath()

			for point in winLoss.enumerated() {
				let x = xOffset + CGFloat(point.offset) * componentWidth
				if point.element == 1 {
					let rect = CGRect(x: x, y: midPoint - (circleSize / 2), width: circleSize, height: circleSize)
					winPath.addEllipse(in: rect.integral)
				}
				else if point.element == -1 {
					let rect = CGRect(x: x, y: midPoint - (circleSize / 2), width: circleSize, height: circleSize)
					lossPath.addEllipse(in: rect.integral)
				}
			}

			if !winPath.isEmpty {
				outer.usingGState { winState in
					if let fill = self.winFill {
						winState.usingGState { (fillCtx) in
							winState.addPath(winPath)
							winState.clip()
							fill.fill(context: fillCtx, bounds: integralRect)
						}
					}
					winState.addPath(winPath)
					winState.setStrokeColor(self.winStrokeColor)
					winState.setLineWidth(self.lineWidth)
					winState.drawPath(using: .stroke)
				}
			}

			if !lossPath.isEmpty {
				outer.usingGState { lossState in
					if let fill = self.lossFill {
						lossState.usingGState { (fillCtx) in
							lossState.addPath(lossPath)
							lossState.clip()
							fill.fill(context: fillCtx, bounds: integralRect)
						}
					}
					lossState.addPath(lossPath)
					lossState.setStrokeColor(self.lossStrokeColor)
					lossState.setLineWidth(self.lineWidth)
					lossState.drawPath(using: .stroke)
				}
			}
		}
	}
}
