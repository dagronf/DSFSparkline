//
//  DSFSparklineLineGraphView.swift
//  DSFSparklines
//
//  Created by Darren Ford on 20/12/19.
//  Copyright © 2019 Darren Ford. All rights reserved.
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

/// A sparkline that draws a line graph
@IBDesignable
public class DSFSparklineLineGraphView: DSFSparklineZeroLineGraphView {

	let overlay = DSFSparklineOverlay.Line()

	/// The width for the line drawn on the graph
	@IBInspectable public var lineWidth: CGFloat = 1.5 {
		didSet {
			self.overlay.strokeWidth = self.lineWidth
		}
	}
	
	/// Interpolate a curve between the points
	@IBInspectable public var interpolated: Bool = false {
		didSet {
			self.overlay.interpolated = self.interpolated
		}
	}
	
	/// Shade the area under the line
	@IBInspectable public var lineShading: Bool = true {
		didSet {
			if lineShading == true {
				self.overlay.primaryFill = DSFSparkline.Fill.Color(self.graphColor.withAlphaComponent(0.4).cgColor)
			}
			else {
				self.overlay.primaryFill = nil
			}
		}
	}
	
	/// Draw a shadow under the line
	@IBInspectable public var shadowed: Bool = false {
		didSet {
			self.overlay.shadow = self.shadowed ? NSShadow.sparklineDefault : nil
		}
	}

	/// The size of the markers to draw. If the markerSize is less than 0, markers will not draw
	@IBInspectable public var markerSize: CGFloat = -1 {
		didSet {
			self.overlay.markerSize = self.markerSize
		}
	}

	/// An optional drawing function for custom drawing markers. When nil, uses the standard circle for each marker
	///
	/// The `markerSize` value is used to determine the frameSize of each marker.
	/// If `markerSize` is less than 1, this block will not be called.
	///
	/// Note that this function is called very frequently so make sure its performant!
	@objc public var markerDrawingBlock: DSFSparklineOverlay.Line.MarkerDrawingBlock? = nil {
		didSet {
			self.overlay.markerDrawingBlock = self.markerDrawingBlock
		}
	}

	/// Should the graph be centered at the zero line?
	@IBInspectable public var centeredAtZeroLine: Bool = false {
		didSet {
			self.overlay.centeredAtZeroLine = self.centeredAtZeroLine
		}
	}

	// Optional gradient colors
	internal var gradient: CGGradient?
	internal var lowerGradient: CGGradient?


	public override init(frame: CGRect) {
		super.init(frame: frame)
		self.configure()
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.configure()
	}

	func configure() {
		self.addOverlay(self.overlay)
		self.colorDidChange()
	}

	override func colorDidChange() {
		super.colorDidChange()

		self.overlay.strokeWidth = self.lineWidth
		self.overlay.interpolated = self.interpolated
		self.overlay.shadow = self.shadowed ? NSShadow.sparklineDefault : nil
		self.overlay.markerSize = self.markerSize

		self.overlay.centeredAtZeroLine = self.centeredAtZeroLine

		self.overlay.primaryStrokeColor = self.graphColor.cgColor
		self.overlay.secondaryStrokeColor = self.lowerColor.cgColor

		// Backwards compatibility
		let color = self.graphColor
		let fill = DSFSparkline.Fill.Gradient(colors: [
			color.withAlphaComponent(0.4).cgColor,
			color.withAlphaComponent(0.2).cgColor
		])
		self.overlay.primaryFill = fill

		if let lowerColor = self.lowerGraphColor {
			let fill = DSFSparkline.Fill.Gradient(colors: [
				lowerColor.withAlphaComponent(0.4).cgColor,
				lowerColor.withAlphaComponent(0.2).cgColor
			])
			self.overlay.secondaryFill = fill
		}
		else {
			// Fallback - if secondary fill not defined the compatibility view is to use the primary fill view
			self.overlay.secondaryFill = self.overlay.primaryFill
		}
	}
}
