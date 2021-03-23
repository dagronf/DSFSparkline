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
@IBDesignable
public class DSFSparklinePercentBarGraphView: DSFSparklineSurfaceView {

	// MARK: - Value

	/// The initial value to display in the percent bar
	@IBInspectable public var value: CGFloat = 0.2 {
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
	@IBInspectable public var cornerRadius: CGFloat = 5 {
		didSet {
			self.displayStyle.cornerRadius = self.cornerRadius
			self.displayUpdate()
		}
	}

	/// Should the control display a text label for the percent bar
	@IBInspectable public var showLabel: Bool = true {
		didSet {
			self.displayStyle.showLabel = self.showLabel
			self.displayUpdate()
		}
	}

	#if os(macOS)
	/// The background of the bar color for the percent bar chart
	@IBInspectable public var underBarColor: NSColor = .clear {
		didSet {
			self.displayStyle.underBarColor = self.underBarColor.cgColor
			self.displayUpdate()
		}
	}
	#else
	/// The background of the bar color for the percent bar chart
	@IBInspectable public var underBarColor: UIColor = .clear {
		didSet {
			self.displayStyle.underBarColor = self.underBarColor.cgColor
			self.displayUpdate()
		}
	}
	#endif

	#if os(macOS)
	/// The color for text displayed on the background
	@IBInspectable public var underBarTextColor: NSColor = .white {
		didSet {
			self.displayStyle.underBarTextColor = self.underBarTextColor.cgColor
			self.displayUpdate()
		}
	}
	#else
	/// The color for text displayed on the background
	@IBInspectable public var underBarTextColor: UIColor = .white {
		didSet {
			self.displayStyle.underBarTextColor = self.underBarTextColor.cgColor
			self.displayUpdate()
		}
	}
	#endif

	// MARK: - Bar Color

	#if os(macOS)
	/// The bar color for the percent bar chart
	@IBInspectable public var barColor: NSColor = .black {
		didSet {
			self.displayStyle.barColor = self.barColor.cgColor
			self.displayUpdate()
		}
	}
	#else
	/// The bar color for the percent bar chart
	@IBInspectable public var barColor: UIColor = .black {
		didSet {
			self.displayStyle.barColor = self.barColor.cgColor
			self.displayUpdate()
		}
	}
	#endif

	// MARK: - Background Color

	#if os(macOS)
	/// The color for text displayed on the bar
	@IBInspectable public var barTextColor: NSColor = .white {
		didSet {
			self.displayStyle.barTextColor = self.barTextColor.cgColor
			self.displayUpdate()
		}
	}
	#else
	/// The color for text displayed on the bar
	@IBInspectable public var barTextColor: UIColor = .white {
		didSet {
			self.displayStyle.barTextColor = self.barTextColor.cgColor
			self.displayUpdate()
		}
	}
	#endif

	// MARK: - Font

	/// The name of the font to use when drawing the percent bar label
	@IBInspectable public var fontName: String? = nil {
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
	@IBInspectable public var fontSize: CGFloat = 12 {
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
	@IBInspectable public var leftInset: CGFloat = 0 {
		didSet {
			self.displayStyle.barEdgeInsets.left = self.leftInset
			self.displayUpdate()
		}
	}

	/// The top inset for the bar
	@IBInspectable public var topInset: CGFloat = 0 {
		didSet {
			self.displayStyle.barEdgeInsets.top = self.topInset
			self.displayUpdate()
		}
	}

	/// The right inset for the bar
	@IBInspectable public var rightInset: CGFloat = 0 {
		didSet {
			self.displayStyle.barEdgeInsets.right = self.rightInset
			self.displayUpdate()
		}
	}

	/// The bottom inset for the bar
	@IBInspectable public var bottomInset: CGFloat = 0 {
		didSet {
			self.displayStyle.barEdgeInsets.bottom = self.bottomInset
			self.displayUpdate()
		}
	}

	// MARK: - Animation

	/// Should the bar animate to new values?
	@IBInspectable public var shouldAnimate: Bool = false {
		didSet {
			self.displayStyle.animated = self.shouldAnimate
			self.displayUpdate()
		}
	}

	/// The animation duration if `shouldAnimate` is set
	@IBInspectable public var animationDuration: CGFloat = 0.25 {
		didSet {
			self.displayStyle.animationDuration = Double(self.animationDuration)
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

extension DSFSparklinePercentBarGraphView {
	public override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()

		#if TARGET_INTERFACE_BUILDER
		self.configure()
		self.overlay.setNeedsDisplay()
		self.updateDisplay()
		#endif
	}
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

		#if TARGET_INTERFACE_BUILDER
		self.displayStyle.animated = false
		#else
		self.displayStyle.animated = self.shouldAnimate
		#endif

		self.overlay.displayStyle = self.displayStyle
		self.overlay.value = self.value

		self.overlay.setNeedsDisplay()

		self.updateDisplay()
	}

	func displayUpdate() {
		self.overlay.displayStyle = self.displayStyle
	}
}
