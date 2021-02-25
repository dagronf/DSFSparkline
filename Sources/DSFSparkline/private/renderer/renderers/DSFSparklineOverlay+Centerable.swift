//
//  File.swift
//  
//
//  Created by Darren Ford on 14/2/21.
//

import QuartzCore

public extension DSFSparklineOverlay {

	/// A graph that can be centered around the datasource's zero-line
	@objc(DSFSparklineOverlayCenterableGraph) class Centerable: DSFSparklineOverlay.ZeroLine {

		/// Should the graph be centered at the zero line?
		@objc public var centeredAtZeroLine: Bool = false {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The value of the 'zero line' for this graph.
		@objc public var zeroLineValue: CGFloat = 0.0 {
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

		@objc public var primaryFillColor: CGColor? = .black {
			didSet {
				self.setNeedsDisplay()
			}
		}

		// Optional gradient colors
		@objc public var primaryGradient: CGGradient? {
			didSet {
				self.setNeedsDisplay()
			}
		}

		@inlinable var wantsPrimaryFill: Bool {
			return self.primaryFillColor != nil || self.primaryGradient != nil
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

		@objc public var secondaryGradient: CGGradient? {
			didSet {
				self.setNeedsDisplay()
			}
		}

		@inlinable var wantsSecondaryFill: Bool {
			return self.secondaryGradient != nil || self.secondaryFillColor != nil
		}

		@inlinable var wantsSecondaryStroke: Bool {
			return self.secondaryStrokeColor != nil
		}

	}
}
