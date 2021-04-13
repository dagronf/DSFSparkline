//
//  DSFSparklineOverlay+RangeHighlight.swift
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

	/// An overlay that draws a color range on the sparkline
	@objc(DSFSparklineOverlayRangeHighlight) class RangeHighlight: DSFSparklineOverlay.DataSource {

		static public let defaultFill =
			DSFSparkline.Fill.Color(CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(),
													  components: [0.5, 0.5, 0.5, 0.5])!)

		/// The color to fill the specified range
		@objc public var fill: DSFSparklineFillable = RangeHighlight.defaultFill {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The highlight range for the graph
		public var highlightRange: Range<CGFloat>? {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// objective-c compatible highlight range setting
		@objc public func setHighlightRange(lowerBound: CGFloat, upperBound: CGFloat) {
			self.highlightRange = lowerBound ..< upperBound
		}

		public init(dataSource: DSFSparkline.DataSource? = nil,
						range: Range<CGFloat>? = nil,
						fill: DSFSparklineFillable = RangeHighlight.defaultFill) {
			self.highlightRange = range
			self.fill = fill

			super.init(dataSource: dataSource)
		}

		@objc public init(lowerBound: CGFloat, upperBound: CGFloat,
								fill: DSFSparklineFillable = RangeHighlight.defaultFill) {
			self.highlightRange = lowerBound ..< upperBound
			self.fill = fill
			super.init()
		}

		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}

		internal override func drawGraph(context: CGContext, bounds: CGRect, scale: CGFloat) {
			guard let dataSource = self.dataSource,
					let range = self.highlightRange else {
				return
			}

			let lb = 1.0 - dataSource.normalize(value: range.lowerBound)
			let ub = 1.0 - dataSource.normalize(value: range.upperBound)

			let r = CGRect(x: bounds.minX, y: ub * bounds.height, width: bounds.width, height: (lb - ub) * bounds.height + bounds.minY)
			context.clip(to: r)
			
			self.fill.fill(context: context, bounds: bounds)
		}
	}
}
