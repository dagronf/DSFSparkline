//
//  DSFSparkline+Palette.swift
//  DSFSparklines
//
//  Created by Darren Ford on 12/2/21.
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

#if os(macOS)
import Cocoa
#else
import UIKit
#endif

public extension DSFSparkline {

	/// The palette to use when drawing the pie. The first value in the datasource uses the first color,
	/// the second the second color etc.  If there are more datapoints than colors (you shouldn't do this!) then
	/// the chart will start back at the start of the palette.
	///
	/// These palettes can be safely shared between multiple pie views
	@objc(DSFSparklinePalette) class Palette: NSObject {
		/// The colors to be used when drawing segments
		@objc public let colors: [DSFColor]
		@objc public let cgColors: NSArray

		/// A default palette used when no palette is specified.
		@objc public static let shared = DSFSparkline.Palette([
			DSFColor.systemRed,
			DSFColor.systemOrange,
			DSFColor.systemYellow,
			DSFColor.systemGreen,
			DSFColor.systemBlue,
			DSFColor.systemPurple,
			DSFColor.systemPink,
		])

		/// A default palette used when no palette is specified
		@objc public static let sharedGrays = DSFSparkline.Palette([
			DSFColor(white: 0.9, alpha: 1),
			DSFColor(white: 0.7, alpha: 1),
			DSFColor(white: 0.5, alpha: 1),
			DSFColor(white: 0.3, alpha: 1),
			DSFColor(white: 0.1, alpha: 1),
		])

		@objc public init(_ colors: [DSFColor]) {
			self.colors = colors
			self.cgColors = NSArray(array: colors.map { $0.cgColor })
			super.init()
		}

		@inlinable func colorAtOffset(_ offset: Int) -> DSFColor {
			return self.colors[offset % self.colors.count]
		}
		@inlinable func cgColorAtOffset(_ offset: Int) -> CGColor {
			return self.cgColors[offset % self.colors.count] as! CGColor
		}
	}
}
