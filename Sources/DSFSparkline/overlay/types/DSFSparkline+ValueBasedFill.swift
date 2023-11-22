//
//  DSFSparkline+FillColor.swift
//
//  Copyright © 2023 Darren Ford. All rights reserved.
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

import Foundation
import QuartzCore

#if os(macOS)
import AppKit
#else
import UIKit
#endif

public extension DSFSparkline {
	/// A fill color that can change depending on a value
	@objc(DSFSparklineValueBasedFill) class ValueBasedFill: NSObject {
		/// Is this a simple flat color?
		@objc public var isFlatColor: Bool { self.flatColor != nil }
		/// Is this a color palette?
		@objc public var isPalette: Bool { self.palette != nil }
		/// Is this a gradient?
		@objc public var isGradient: Bool { self.gradient != nil }

		@objc public static let sharedPalette = ValueBasedFill(palette: DSFSparkline.Palette.shared)

		private var flatColor: CGColor? = nil
		private var palette: DSFSparkline.Palette? = nil
		private var gradient: DSFSparkline.GradientBucket? = nil

		@objc public init(flatColor: CGColor) {
			self.flatColor = flatColor
		}

		@objc public init(palette: DSFSparkline.Palette) {
			self.palette = palette
			super.init()
		}

		/// Create a fill object containing an array of colors
		/// - Parameter colors: The colors
		@objc public convenience init(colors: [DSFColor]) {
			self.init(palette: DSFSparkline.Palette(colors))
		}

		@objc public init(gradient: DSFSparkline.GradientBucket) {
			self.gradient = gradient
		}

		init(flatColor: CGColor?, palette: DSFSparkline.Palette?, gradient: DSFSparkline.GradientBucket?) {
			self.flatColor = flatColor?.copy()
			self.palette = palette?.copyPalette()
			self.gradient = gradient?.copyGradientBucket()
		}

		func copyColorContainer() -> ValueBasedFill {
			return .init(flatColor: self.flatColor, palette: self.palette, gradient: self.gradient)
		}

		func color(atFraction fraction: CGFloat) -> CGColor {
			let f = max(0, min(1 - CGFloat.ulpOfOne, fraction))
			if let flatColor = self.flatColor {
				return flatColor
			}
			else if let gradient = self.gradient {
				return gradient.color(at: f)
			}
			else if let palette = self.palette {
				let div = 1.0 / CGFloat(palette.colors.count)
				let indexed = Int((f / div).rounded(.towardZero))
				return palette.cgColorAtOffset(indexed)
			}
			return CGColor(red: 1, green: 0, blue: 0, alpha: 1)
		}
	}
}
