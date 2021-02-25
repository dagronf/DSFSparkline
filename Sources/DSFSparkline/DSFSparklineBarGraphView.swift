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
			self.overlay.lineWidth = self.lineWidth
		}
	}

	/// The spacing (in pixels) between each bar
	@IBInspectable public var barSpacing: UInt = 1 {
		didSet {
			self.overlay.barSpacing = self.barSpacing
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

		self.overlay.lineWidth = self.lineWidth
		self.overlay.barSpacing = self.barSpacing

		self.overlay.primaryStrokeColor = self.graphColor.cgColor
		self.overlay.primaryFillColor = self.graphColor.withAlphaComponent(0.4).cgColor

		self.overlay.secondaryStrokeColor = self.lowerColor.cgColor
		self.overlay.secondaryFillColor = self.lowerColor.withAlphaComponent(0.4).cgColor

		self.overlay.centeredAtZeroLine = self.centeredAtZeroLine
	}
}
