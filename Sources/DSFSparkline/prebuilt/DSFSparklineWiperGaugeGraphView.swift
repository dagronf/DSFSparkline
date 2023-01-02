//
//  DSFSparklineWiperGaugeGraphView.swift
//
//  Copyright © 2023 Darren Ford. All rights reserved.
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
@available(iOS 13.0, *)
@IBDesignable
public class DSFSparklineWiperGaugeGraphView: DSFSparklineSurfaceView {

	// MARK: - Value

	/// The initial value to display in the percent bar
	@IBInspectable public var value: CGFloat = 0.2 {
		didSet {
			self.overlay.value = self.value
			//self.overlay.setNeedsDisplay()
		}
	}

	@objc public var valueColor = DSFSparkline.FillContainer.sharedPalette {
		didSet {
			self.overlay.valueColor = valueColor
			//self.setNeedsDisplay()
		}
	}

	@objc public var animated: Bool = false {
		didSet {
			self.overlay.animated = animated
		}
	}

#if os(macOS)
	@objc public var strokeColor: NSColor = .textColor {
		didSet {
			self.overlay.strokeColor = strokeColor.cgColor
		}
	}

	@objc public var arcBackgroundColor: NSColor = .quaternaryLabelColor {
		didSet {
			self.overlay.arcBackgroundColor = arcBackgroundColor.cgColor
		}
	}
	#else
	@objc public var strokeColor: UIColor = .label {
		didSet {
			self.overlay.strokeColor = strokeColor.cgColor
		}
	}

	@objc public var arcBackgroundColor: UIColor = .quaternaryLabel {
		didSet {
			self.overlay.arcBackgroundColor = arcBackgroundColor.cgColor
		}
	}
	#endif

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

	#if os(macOS)
	public override func updateLayer() {
		super.updateLayer()

		self.overlay.strokeColor = strokeColor.cgColor
		self.overlay.arcBackgroundColor = arcBackgroundColor.cgColor
	}
	#endif

	// The overlay
	private let overlay = DSFSparklineOverlay.WiperGauge()
}

@available(iOS 13.0, *)
extension DSFSparklineWiperGaugeGraphView {
	public override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()

		#if TARGET_INTERFACE_BUILDER
		self.configure()
		self.overlay.setNeedsDisplay()
		self.updateDisplay()
		#endif
	}
}

@available(iOS 13.0, *)
private extension DSFSparklineWiperGaugeGraphView {
	func configure() {
		self.addOverlay(self.overlay)
		self.overlay.value = self.value

		self.overlay.animated = animated
		self.overlay.strokeColor = strokeColor.cgColor
		self.overlay.arcBackgroundColor = arcBackgroundColor.cgColor
	}
}
