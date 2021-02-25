//
//  DSFSparklineOverlay+Centerable.swift
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
	/// A graph that can be centered around the datasource's zero-line
	@objc(DSFSparklineOverlayCenterableGraph) class Centerable: DSFSparklineOverlay.ZeroLine {
		/// Should the graph be centered at the zero line defined in the datasource?
		@objc public var centeredAtZeroLine: Bool = false {
			didSet {
				self.setNeedsDisplay()
			}
		}

		// MARK: - Primary

		/// The primary color for the sparkline
		@objc public var primaryStrokeColor: CGColor? = .black {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The primary fill color for the sparkline
		@objc public var primaryFillColor: CGColor? {
			didSet {
				self.setNeedsDisplay()
			}
		}

		// Optional primary gradient
		@objc public var primaryGradient: CGGradient? {
			didSet {
				self.setNeedsDisplay()
			}
		}

		// MARK: - Secondary

		/// The color used to draw lines below the zero line. If nil, is the same as the graph color
		@objc public var secondaryStrokeColor: CGColor? {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The color used to fill below the zero line. If nil, is the same as the graph color
		@objc public var secondaryFillColor: CGColor? {
			didSet {
				self.setNeedsDisplay()
			}
		}

		// Optional secondary gradient
		@objc public var secondaryGradient: CGGradient? {
			didSet {
				self.setNeedsDisplay()
			}
		}

		// NARK: - Utilities

		// Flag to determine whether the primary should be filled (either with a plain color or a gradient)
		@inlinable internal var wantsPrimaryFill: Bool {
			return self.primaryFillColor != nil || self.primaryGradient != nil
		}

		// Flag to determine whether the secondary should be filled (either with a plain color or a gradient)
		@inlinable internal var wantsSecondaryFill: Bool {
			return self.secondaryGradient != nil || self.secondaryFillColor != nil
		}

		// Flag to determine whether the secondary have a stroke color
		@inlinable internal var wantsSecondaryStroke: Bool {
			return self.secondaryStrokeColor != nil
		}
	}
}
