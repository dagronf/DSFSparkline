//
//  DSFSparklineBarGraphView.swift
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

/// A sparkline graph that displays bars
@IBDesignable
public class DSFSparklineBarGraphView: DSFSparklineZeroLineGraphView {

	let overlay = DSFSparklineOverlay.Bar()

	/// The line width (in pixels) to use when drawing the border of each bar
	@IBInspectable public var lineWidth: UInt = 1 {
		didSet {
			self.overlay.strokeWidth = self.lineWidth
		}
	}

	/// The spacing (in pixels) between each bar
	@IBInspectable public var barSpacing: UInt = 1 {
		didSet {
			self.overlay.barSpacing = self.barSpacing
		}
	}

	/// Draw a shadow under the line
	@IBInspectable public var shadowed: Bool = false {
		didSet {
			self.overlay.shadow = self.shadowed ? NSShadow.sparklineDefault : nil
		}
	}

	/// Should the graph be centered at the zero line?
	@IBInspectable public var centeredAtZeroLine: Bool = false {
		didSet {
			self.overlay.centeredAtZeroLine = self.centeredAtZeroLine
		}
	}

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
		self.overlay.setNeedsDisplay()
	}

	override func colorDidChange() {
		super.colorDidChange()

		self.overlay.strokeWidth = self.lineWidth
		self.overlay.barSpacing = self.barSpacing

		self.overlay.primaryStrokeColor = self.graphColor.cgColor
		self.overlay.secondaryStrokeColor = self.lowerColor.cgColor

		self.overlay.centeredAtZeroLine = self.centeredAtZeroLine

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
