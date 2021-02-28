//
//  DSFSparkline+HighlightRangeDefinition.swift
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

	/// A highlight range definition
	@objc(DSFSparklineHighlightRangeDefinition) class HighlightRangeDefinition: NSObject {
		public static let DefaultFill = DSFSparkline.Fill.Color(DSFColor.systemGray.cgColor)

		/// The range in the sparkline to highlight
		public var range: Range<CGFloat>

		/// The highlight fill to use
		@objc public var fill: DSFSparklineFillable

		public init(range: Range<CGFloat>, fill: DSFSparklineFillable = DefaultFill) {
			self.range = range
			self.fill = fill
			super.init()
		}

		public init(range: Range<CGFloat>, fillColor: CGColor) {
			self.range = range
			self.fill = DSFSparkline.Fill.Color(fillColor)
			super.init()
		}

		/// Objective-C compatible initializer. Lowerbound MUST be less than upperbound!
		@objc public init(lowerBound: CGFloat, upperBound: CGFloat, fill: DSFSparklineFillable = DefaultFill) {
			assert(lowerBound < upperBound)
			self.range = lowerBound ..< upperBound
			self.fill = fill
			super.init()
		}

		/// Objective-C compatible initializer. Lowerbound MUST be less than upperbound!
		@objc public init(lowerBound: CGFloat, upperBound: CGFloat, fillColor: CGColor) {
			assert(lowerBound < upperBound)
			self.range = lowerBound ..< upperBound
			self.fill = DSFSparkline.Fill.Color(fillColor)
			super.init()
		}
	}
}

// MARK: - Objective-C helpers

public extension DSFSparkline.HighlightRangeDefinition {
	@objc var lowerBound: CGFloat {
		get {
			return self.range.lowerBound
		}
		set {
			self.range = newValue ..< self.range.upperBound
		}
	}
	@objc var upperBound: CGFloat {
		get {
			return self.range.upperBound
		}
		set {
			self.range = self.range.lowerBound ..< newValue
		}
	}
}
