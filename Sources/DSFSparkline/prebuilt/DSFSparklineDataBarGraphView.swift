//
//  DSFSparklineDataBarGraphView.swift
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

import Foundation
import CoreGraphics

#if os(macOS)
import AppKit
#else
import UIKit
#endif

/// A sparkline that draws a simple pie chart
public class DSFSparklineDataBarGraphView: DSFSparklineSurfaceView {

	let databarOverlay = DSFSparklineOverlay.DataBar()

	/// The data to be displayed in the data bar.
	///
	/// The values become a percentage of the total value stored within the
	/// dataStore, and as such each value ends up being drawn as a fraction of the total.
	/// So for example, if you want the pie chart to represent the number of red cars vs. number of
	/// blue cars, you just set the values directly.
	@objc public var dataSource = DSFSparkline.StaticDataSource() {
		didSet {
			self.databarOverlay.dataSource = self.dataSource
		}
	}

	// MARK: - Maximum Total

	/// The maximum _total_ value. If the datasource values total is greater than this value, it clips the display
	@objc public dynamic var maximumTotalValue: CGFloat = -1 {
		didSet {
			self.databarOverlay.maximumTotalValue = self.maximumTotalValue
		}
	}

	// MARK: Optional background color

	/// The 'undrawn' color for the graph
	@objc public dynamic var unsetColor: DSFColor? {
		didSet {
			self.databarOverlay.unsetColor = self.unsetColor?.cgColor
		}
	}

	// MARK: - Stroke

	/// The stroke color for the pie chart
	@objc public dynamic var strokeColor: DSFColor? {
		didSet {
			self.databarOverlay.strokeColor = self.strokeColor?.cgColor
		}
	}

	/// The width of the stroke line
	@objc public dynamic var lineWidth: CGFloat = 0.5 {
		didSet {
			self.updateDisplay()
		}
	}

	/// The animation style to apply when datasource changes, or nil for no animation
	@objc public var animationStyle: DSFSparkline.AnimationStyle? = nil {
		didSet {
			self.databarOverlay.animationStyle = self.animationStyle
		}
	}

	/// The palette to use when drawing the pie chart
	@objc public var palette = DSFSparkline.Palette.shared {
		didSet {
			self.databarOverlay.palette = self.palette
		}
	}

	// MARK: - Initializers

	public override init(frame: CGRect) {
		super.init(frame: frame)
		self.configure()
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.configure()
	}

	func configure() {
		self.addOverlay(self.databarOverlay)
		self.databarOverlay.setNeedsDisplay()

		self.databarOverlay.unsetColor = self.unsetColor?.cgColor
		self.databarOverlay.strokeColor = self.strokeColor?.cgColor
		self.databarOverlay.lineWidth = self.lineWidth
		self.databarOverlay.maximumTotalValue = self.maximumTotalValue

		self.databarOverlay.animationStyle = self.animationStyle

		self.databarOverlay.dataSource = self.dataSource
	}

	// MARK: - Privates

	internal var animator = ArbitraryAnimator()
	internal var fractionComplete: CGFloat = 0
	internal var total: CGFloat = 0.0
}
