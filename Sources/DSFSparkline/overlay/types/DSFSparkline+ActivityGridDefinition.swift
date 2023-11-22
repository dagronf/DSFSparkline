//
//  DSFSparkline+ActivityGridDefinition.swift
//
//  Created by Darren Ford on 26/2/21.
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

#if os(macOS)
import AppKit
#else
import UIKit
#endif

public extension DSFSparkline {

	class ActivityGrid {
		private init() { }
	}
}

public extension DSFSparkline.ActivityGrid {
	/// The drawing style for the activity grid
	@objc(DSFSparklineActivityGridLayoutStyle)
	enum LayoutStyle: Int {
		/// 'Newest' value at bottom right, works up then left
		case github = 0
		/// 'Newest' value at top left, works right then down
		case defrag = 1
	}
}

public extension DSFSparkline.ActivityGrid {
	/// The style for drawing cells in the activity grid
	@objc(DSFSparklineActivityGridCellStyle)
	class CellStyle: NSObject {
		@objc public let fillScheme: DSFSparkline.ValueBasedFill
		@objc public let borderColor: CGColor?
		@objc public let borderWidth: CGFloat
		@objc public let cellDimension: CGFloat
		@objc public let cellSpacing: CGFloat
		@objc public let cornerRadius: CGFloat
		@objc public init(
			fillScheme: DSFSparkline.ValueBasedFill,
			borderColor: CGColor? = nil,
			borderWidth: CGFloat = 1.0,
			cellDimension: CGFloat = 11.0,
			cellSpacing: CGFloat = 2.5,
			cornerRadius: CGFloat = 2.5
		) {
			self.fillScheme = fillScheme
			self.borderColor = borderColor
			self.borderWidth = borderWidth
			self.cellDimension = cellDimension
			self.cellSpacing = cellSpacing
			self.cornerRadius = cornerRadius
			super.init()
		}

		/// Default style - dark github
		@objc public convenience override init() {
			self.init(fillScheme: CellStyle.DefaultDark)
		}

		/// Return a copy of this cell style changing the specified attribute values
		public func modify(
			fillScheme: DSFSparkline.ValueBasedFill? = nil,
			borderColor: CGColor? = nil,
			borderWidth: CGFloat? = nil,
			cellDimension: CGFloat? = nil,
			cellSpacing: CGFloat? = nil,
			cornerRadius: CGFloat? = nil
		) -> CellStyle {
			let fs = fillScheme ?? self.fillScheme
			let bc = borderColor ?? self.borderColor
			let bw = borderWidth ?? self.borderWidth
			let cd = cellDimension ?? self.cellDimension
			let cs = cellSpacing ?? self.cellSpacing
			let cr = cornerRadius ?? self.cornerRadius

			return CellStyle(
				fillScheme: fs,
				borderColor: bc,
				borderWidth: bw,
				cellDimension: cd,
				cellSpacing: cs,
				cornerRadius: cr
			)
		}

		/// A default palette used when no palette is specified.
		public static let DefaultLight = DSFSparkline.ValueBasedFill(colors: [
			DSFColor(red: 0.820, green: 0.830, blue: 0.842, alpha: 1.000),
			DSFColor(red: 0.606, green: 0.914, blue: 0.657, alpha: 1.000),
			DSFColor(red: 0.248, green: 0.768, blue: 0.387, alpha: 1.000),
			DSFColor(red: 0.190, green: 0.633, blue: 0.306, alpha: 1.000),
			DSFColor(red: 0.132, green: 0.432, blue: 0.222, alpha: 1.000),
		])

		public static let DefaultDark = DSFSparkline.ValueBasedFill(colors: [
			DSFColor(red: 0.086, green: 0.106, blue: 0.132, alpha: 1.000),
			DSFColor(red: 0.055, green: 0.269, blue: 0.159, alpha: 1.000),
			DSFColor(red: 0.000, green: 0.429, blue: 0.194, alpha: 1.000),
			DSFColor(red: 0.148, green: 0.649, blue: 0.257, alpha: 1.000),
			DSFColor(red: 0.219, green: 0.829, blue: 0.323, alpha: 1.000),
		])
	}
}
