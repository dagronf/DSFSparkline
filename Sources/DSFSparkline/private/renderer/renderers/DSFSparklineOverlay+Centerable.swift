//
//  File.swift
//  
//
//  Created by Darren Ford on 14/2/21.
//

#if os(macOS)
import Cocoa
#else
import UIKit
#endif

public extension DSFSparklineOverlay {
	@objc(DSFSparklineOverlayCenterableGraph) class Centerable: DSFSparklineDataSourceOverlay {

		/// The primary color for the sparkline
		@objc public var primaryLineColor: CGColor = .black {
			didSet {
				self.setNeedsDisplay()
			}
		}

		@objc public var primaryFillColor: CGColor = .black {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The color used to draw lines below the zero line. If nil, is the same as the graph color
		@objc public var secondaryLineColor: CGColor? {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The color used to draw lines below the zero line. If nil, is the same as the graph color
		@objc public var secondaryLineColorReal: CGColor {
			self.secondaryLineColor ?? self.primaryLineColor
		}

		/// The color used to fill below the zero line. If nil, is the same as the graph color
		@objc public var secondaryFillColor: CGColor? {
			didSet {
				self.setNeedsDisplay()
			}
		}

		@objc public var secondaryFillColorReal: CGColor {
			self.secondaryFillColor ?? self.primaryFillColor
		}

		// Optional gradient colors
		@objc public var primaryGradient: CGGradient? {
			didSet {
				self.setNeedsDisplay()
			}
		}

		@objc public var secondaryGradient: CGGradient? {
			didSet {
				self.setNeedsDisplay()
			}
		}

		@objc public var secondaryGradientReal: CGGradient? {
			return self.secondaryGradient ?? self.primaryGradient
		}
	}
}
