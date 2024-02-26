//
//  DSFSparkline+FillColor.swift
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

// MARK: - Solid color fill

public extension DSFSparkline.Fill {

	/// The solid color fill
	@objc(DSFSparklineFillColor) class `Color`: NSObject, DSFSparklineFillable {

		/// Black color
		@objc public static var black: DSFSparkline.Fill.Color { .init(gray: 0) }
		/// White color
		@objc public static var white: DSFSparkline.Fill.Color { .init(gray: 1) }
		/// Clear color
		@objc public static var clear: DSFSparkline.Fill.Color { .init(gray: 0, alpha: 0) }

		/// The fill color
		@objc public var color: CGColor

		/// Create a color using a CGColor
		/// - Parameter color: The color
		@objc public init(_ color: CGColor) {
			self.color = color
		}

		/// Create a fill color using an sRGB color
		/// - Parameters:
		///   - red: red component
		///   - green: green component
		///   - blue: blue component
		///   - alpha: alpha component
		@objc public init(srgbRed red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) {
			let cs = CGColorSpace(name: CGColorSpace.sRGB)!
			self.color = CGColor(colorSpace: cs, components: [red, green, blue, alpha]) ?? CGColor.black
		}

		/// Create a fill color using an rgb color
		/// - Parameters:
		///   - red: red component
		///   - green: green component
		///   - blue: blue component
		///   - alpha: alpha component
		@objc public init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) {
			self.color = CGColor(red: red, green: green, blue: blue, alpha: alpha)
		}

		/// Create a fill color using an sRGB color
		/// - Parameters:
		///   - red: red component
		///   - green: green component
		///   - blue: blue component
		///   - alpha: alpha component
		@objc public init(gray: CGFloat, alpha: CGFloat = 1.0) {
			self.color = CGColor(gray: gray, alpha: alpha)
		}

		public func fill(context: CGContext, bounds: CGRect) {
			context.setFillColor(color)
			context.fill(bounds)
		}

		@objc public func copyFill() -> DSFSparklineFillable {
			return Color(self.color.copy() ?? .black)
		}

		@objc public func color(at fractionalValue: CGFloat) -> CGColor {
			self.color
		}
	}
}
