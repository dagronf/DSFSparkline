//
//  DSFSparklineOverlay+ZeroLine.swift
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

	@objc(DSFSparklineOverlayZeroLine) class ZeroLine: DSFSparklineOverlay.DataSource {

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

		@objc public init(dataSource: DSFSparkline.DataSource? = nil,
								zeroLineValue: CGFloat = 0.0,
								strokeColor: CGColor = DSFColor.gray.cgColor,
								strokeWidth: CGFloat = 1.0,
								dashStyle: [CGFloat] = [1.0, 1.0]) {
			self.strokeColor = strokeColor
			self.strokeWidth = strokeWidth
			self.dashStyle = dashStyle

			super.init(dataSource: dataSource)
		}

		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}

		internal override func drawGraph(context: CGContext, bounds: CGRect, scale: CGFloat) {
			guard let dataSource = self.dataSource else { return }

			let frac = dataSource.fractionalPosition(for: dataSource.zeroLineValue)
			let zeroPos = bounds.height - (frac * bounds.height) + bounds.minY

			context.setLineWidth(self.strokeWidth)
			context.setStrokeColor(self.strokeColor)
			context.setLineDash(phase: 0.0, lengths: self.dashStyle)
			context.strokeLineSegments(
				between: [CGPoint(x: bounds.minX, y: zeroPos), CGPoint(x: bounds.width + bounds.minX, y: zeroPos)])
		}
	}
}
