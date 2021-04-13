//
//  DSFSparklineOverlay+GridLines.swift
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
	/// An overlay that draws grid lines at specified vertical points on the sparkline
	@objc(DSFSparklineOverlayGridLines) class GridLines: DSFSparklineOverlay.DataSource {
		/// The color of the dotted line at the zero point on the y-axis
		@objc public var strokeColor: CGColor {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The width of the dotted line at the zero point on the y-axis
		@objc public var strokeWidth: CGFloat {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The line style for the dotted line. Use [] to specify a solid line.
		@objc public var dashStyle: [CGFloat] = [1, 1] {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The y-values within the range of the datasource for the lines
		@objc public var floatValues: [CGFloat] = [] {
			didSet {
				self.setNeedsDisplay()
			}
		}

		@objc public init(dataSource: DSFSparkline.DataSource? = nil,
								floatValues: [CGFloat] = [],
								strokeColor: CGColor = DSFColor.gray.cgColor,
								strokeWidth: CGFloat = 1.0,
								dashStyle: [CGFloat] = [1.0, 1.0])
		{
			self.floatValues = floatValues
			self.strokeColor = strokeColor
			self.strokeWidth = strokeWidth
			self.dashStyle = dashStyle

			super.init(dataSource: dataSource)
		}

		@available(*, unavailable)
		required init?(coder _: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}

		internal override func drawGraph(context: CGContext, bounds: CGRect, scale: CGFloat) {
			self.drawGridLines(context: context, bounds: bounds, scale: scale)
		}
	}
}

extension DSFSparklineOverlay.GridLines {
	func drawGridLines(context: CGContext, bounds: CGRect, scale _: CGFloat) {
		guard let dataSource = self.dataSource else { return }

		context.setLineWidth(self.strokeWidth)
		context.setStrokeColor(self.strokeColor)
		context.setLineDash(phase: 0.0, lengths: self.dashStyle)

		self.floatValues.forEach { value in
			let fractional = dataSource.fractionalPosition(for: value)
			let zeroPos = bounds.minY + bounds.height - (fractional * bounds.height).rounded(.towardZero)
			context.strokeLineSegments(between: [CGPoint(x: bounds.minX, y: zeroPos),
															 CGPoint(x: bounds.maxX, y: zeroPos)])
		}
	}
}
