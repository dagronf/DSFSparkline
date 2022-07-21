//
//  DSFSparkline+FillGradient.swift
//  DSFSparklines
//
//  Copyright © 2022 Darren Ford. All rights reserved.
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

import CoreGraphics
import Foundation

// MARK: - Gradient fill

public extension DSFSparkline.Fill {

	/// The gradient fill (vertical only at the moment)
	@objc(DSFSparklineFillGradient) class `Gradient`: NSObject, DSFSparklineFillable {

		/// The gradient to use when filling
		@objc public var gradient: CGGradient

		/// Is the gradient horizontal or vertical
		@objc public var isHorizontal: Bool

		/// Create a fill gradient
		@objc public init(gradient: CGGradient, isHorizontal: Bool = false) {
			self.gradient = gradient
			self.isHorizontal = isHorizontal
		}

		/// Create a fill gradient
		public init(colors: [CGColor], isHorizontal: Bool = false) {
			assert(colors.count >= 2)

			self.isHorizontal = isHorizontal

			let locations: [CGFloat] = {
				if colors.count == 2 { return [1, 0] }

				var tmp: [CGFloat] = []
				let divisor: CGFloat = 1.0 / CGFloat((colors.count - 2) + 1)
				var tmpVal: CGFloat = 1.0
				while tmpVal >= 0 {
					tmp.append(tmpVal)
					tmpVal -= divisor
				}
				return tmp
			}()

			let gradient = CGGradient(
				colorsSpace: nil,
				colors: colors as CFArray,
				locations: locations)

			self.gradient = gradient!
		}

		/// Make a copy of a gradient
		@objc public func copyFill() -> DSFSparklineFillable {
			Gradient(gradient: self.gradient, isHorizontal: isHorizontal)
		}

		@objc public func fill(context: CGContext, bounds: CGRect) {
			if isHorizontal {
				context.drawLinearGradient(
					gradient,
					start: CGPoint(x: bounds.minX, y: bounds.maxY),
					end: CGPoint(x: bounds.maxX, y: bounds.maxY),
					options: [.drawsAfterEndLocation, .drawsBeforeStartLocation]
				)
			}
			else {
				context.drawLinearGradient(
					gradient,
					start: CGPoint(x: 0.0, y: bounds.maxY),
					end: CGPoint(x: 0.0, y: bounds.minY),
					options: [.drawsAfterEndLocation, .drawsBeforeStartLocation]
				)
			}
		}
	}
}
