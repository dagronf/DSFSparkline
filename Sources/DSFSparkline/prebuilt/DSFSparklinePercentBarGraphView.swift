//
//  DSFSparklinePercentBarGraphView.swift
//  DSFSparklines
//
//  Created by Darren Ford on 16/3/21.
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
import AppKit
#else
import UIKit
#endif

/// A sparkline that draws a percent bar
@objc public class DSFSparklinePercentBarGraphView: DSFSparklineSurfaceView {

	// MARK: - Value

	/// The initial value to display in the percent bar
	@objc public dynamic var value: CGFloat = 0.2 {
		didSet {
			self.overlay.value = self.value
			self.displayUpdate()
		}
	}

	/// The style for presenting the percent bar
	@objc public var displayStyle = DSFSparkline.PercentBar.Style() {
		didSet {
			self.overlay.displayStyle = displayStyle
			self.updateDisplay()
		}
	}

	/// The corner radius for the bar
	@objc public dynamic var cornerRadius: CGFloat = 5 {
		didSet {
			self.displayStyle.cornerRadius = self.cornerRadius
			self.displayUpdate()
		}
	}

	/// Should the control display a text label for the percent bar
	@objc public dynamic var showLabel: Bool = true {
		didSet {
			self.displayStyle.showLabel = self.showLabel
			self.displayUpdate()
		}
	}

	/// The background of the bar color for the percent bar chart
	@objc public dynamic var underBarColor: DSFColor = .clear {
		didSet {
			self.displayStyle.underBarColor = self.underBarColor.cgColor
			self.displayUpdate()
		}
	}

	/// The color for text displayed on the background
	@objc public dynamic var underBarTextColor: DSFColor = .white {
		didSet {
			self.displayStyle.underBarTextColor = self.underBarTextColor.cgColor
			self.displayUpdate()
		}
	}

	// MARK: - Bar Color

	/// The bar color for the percent bar chart
	@objc public dynamic var barColor: DSFColor = .black {
		didSet {
			self.displayStyle.barColor = self.barColor.cgColor
			self.displayUpdate()
		}
	}

	// MARK: - Background Color

	/// The color for text displayed on the bar
	@objc public dynamic var barTextColor: DSFColor = .white {
		didSet {
			self.displayStyle.barTextColor = self.barTextColor.cgColor
			self.displayUpdate()
		}
	}

	// MARK: - Font

	/// The name of the font to use when drawing the percent bar label
	@objc public dynamic var fontName: String? = nil {
		didSet {
			if let f = fontName,
				let font = DSFFont(name: f, size: self.fontSize) {
				self.displayStyle.font = font
			}
			else {
				self.displayStyle.font = DSFFont.systemFont(ofSize: self.fontSize)
			}
			self.displayUpdate()
		}
	}

	/// The size (in points) of the font to use when drawing the percent bar label
	@objc public dynamic var fontSize: CGFloat = 12 {
		didSet {
			let font = self.displayStyle.font

			#if os(macOS)
			if let newFont = DSFFont(descriptor: font.fontDescriptor, size: fontSize) {
				self.displayStyle.font = newFont
			}
			#else
			self.displayStyle.font = DSFFont(descriptor: font.fontDescriptor, size: fontSize)
			#endif

			self.overlay.displayStyle = self.displayStyle
			self.displayUpdate()
		}
	}

	/// The left inset for the bar
	@objc public dynamic var leftInset: CGFloat = 0 {
		didSet {
			self.displayStyle.barEdgeInsets.left = self.leftInset
			self.displayUpdate()
		}
	}

	/// The top inset for the bar
	@objc public dynamic var topInset: CGFloat = 0 {
		didSet {
			self.displayStyle.barEdgeInsets.top = self.topInset
			self.displayUpdate()
		}
	}

	/// The right inset for the bar
	@objc public dynamic var rightInset: CGFloat = 0 {
		didSet {
			self.displayStyle.barEdgeInsets.right = self.rightInset
			self.displayUpdate()
		}
	}

	/// The bottom inset for the bar
	@objc public dynamic var bottomInset: CGFloat = 0 {
		didSet {
			self.displayStyle.barEdgeInsets.bottom = self.bottomInset
			self.displayUpdate()
		}
	}

	// MARK: - Animation

	@objc public var animationStyle: DSFSparkline.AnimationStyle? = nil {
		didSet {
			self.overlay.animationStyle = self.animationStyle
			self.displayUpdate()
		}
	}

	// MARK: - Control

	/// Initializer
	public override init(frame: CGRect) {
		super.init(frame: frame)
		self.configure()
	}

	/// Initializer
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.configure()
	}

	// The overlay
	private let overlay = DSFSparklineOverlay.PercentBar(value: 0)
}

private extension DSFSparklinePercentBarGraphView {
	func configure() {
		self.addOverlay(self.overlay)
		self.overlay.setNeedsDisplay()

		self.displayStyle.underBarColor = self.underBarColor.cgColor
		self.displayStyle.underBarTextColor = self.underBarTextColor.cgColor
		self.displayStyle.barColor = self.barColor.cgColor
		self.displayStyle.barTextColor = self.barTextColor.cgColor

		if let f = fontName,
			let font = DSFFont(name: f, size: self.fontSize) {
			self.displayStyle.font = font
		}
		else {
			self.displayStyle.font = DSFFont.systemFont(ofSize: self.fontSize)
		}

		self.overlay.displayStyle = self.displayStyle
		self.overlay.value = self.value

		self.overlay.setNeedsDisplay()

		self.updateDisplay()
	}

	func displayUpdate() {
		self.overlay.displayStyle = self.displayStyle
	}
}
