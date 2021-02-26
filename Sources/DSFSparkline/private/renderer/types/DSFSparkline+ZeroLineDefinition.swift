//
//  DSFSparkline+ZeroLineDefinition.swift
//  DSFSparklines
//
//  Created by Darren Ford on 25/01/21.
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

	/// Drawing definition for the zero-line operations
	@objc(DSFSparklineZeroLineDefinition) class ZeroLineDefinition: NSObject {
		#if os(macOS)
		public static let DefaultColor = DSFColor.disabledControlTextColor
		#else
		public static let DefaultColor = DSFColor.systemGray
		#endif

		/// A shared 'default' drawing pattern
		public static let shared = DSFSparkline.ZeroLineDefinition()

		/// The color to draw the zero line
		let color: DSFColor

		/// The width of the zero line
		let lineWidth: CGFloat

		/// The pattern for drawing the line
		let lineDashStyle: [CGFloat]

		/// Drawing definition for the zero-line for a graph
		/// - Parameters:
		///   - color: The color to draw the zero line
		///   - lineWidth: The width of the zero line
		///   - lineDashStyle: The pattern for drawing the line. An array of values that specify the lengths, in user space coordinates, of the painted and unpainted segments of the dash pattern. For example, the array [2,3] sets a dash pattern that alternates between a 2-unit-long painted segment and a 3-unit-long unpainted segment. The array [1,3,4,2] sets the pattern to a 1-unit painted segment, a 3-unit unpainted segment, a 4-unit painted segment, and a 2-unit unpainted segment. Pass an empty array to clear the dash pattern so that all stroke drawing in the context uses solid lines.
		public init(color: DSFColor = DefaultColor,
						lineWidth: CGFloat = 1.0,
						lineDashStyle: [CGFloat] = [1, 1])
		{
			self.color = color
			self.lineWidth = lineWidth
			self.lineDashStyle = lineDashStyle
		}
	}
}
