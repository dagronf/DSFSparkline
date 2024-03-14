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
@objc public class DSFSparklineWiperGaugeGraphView: DSFSparklineSurfaceView {

	// MARK: - Value

	/// The initial value to display in the percent bar
	@objc public dynamic var value: CGFloat = 0.2 {
		didSet {
			self.overlay.value = self.value
		}
	}

	@objc public var valueColor = DSFSparkline.ValueBasedFill.sharedPalette {
		didSet {
			self.overlay.valueColor = valueColor
		}
	}

	@objc public var animationStyle: DSFSparkline.AnimationStyle? = nil {
		didSet {
			self.overlay.animationStyle = animationStyle
		}
	}

#if os(macOS)
	@objc public dynamic var gaugeUpperArcColor: NSColor = .textColor {
		didSet {
			self.overlay.gaugeUpperArcColor = gaugeUpperArcColor.cgColor
		}
	}

	@objc public dynamic var valueBackgroundColor: NSColor = .quaternaryLabelColor {
		didSet {
			self.overlay.valueBackgroundColor = valueBackgroundColor.cgColor
		}
	}

	/// The color of the pointer component of the gauge
	@objc public dynamic var gaugePointerColor: NSColor = .textColor {
		didSet {
			self.overlay.gaugePointerColor = gaugePointerColor.cgColor
		}
	}
	/// The color of the pointer component of the gauge
	@objc public dynamic var gaugeBackgroundColor: NSColor? = nil {
		didSet {
			self.overlay.gaugeBackgroundColor = gaugeBackgroundColor?.cgColor
		}
	}
	#else
	@objc public dynamic var gaugeUpperArcColor: UIColor = .label {
		didSet {
			self.overlay.gaugeUpperArcColor = gaugeUpperArcColor.cgColor
		}
	}

	@objc public dynamic var valueBackgroundColor: UIColor = .quaternaryLabel {
		didSet {
			self.overlay.valueBackgroundColor = valueBackgroundColor.cgColor
		}
	}

	/// The color of the pointer component of the gauge
	@objc public dynamic var gaugePointerColor: UIColor = .label {
		didSet {
			self.overlay.gaugePointerColor = gaugePointerColor.cgColor
		}
	}
	/// The color of the pointer component of the gauge
	@objc public dynamic var gaugeBackgroundColor: UIColor? = nil {
		didSet {
			self.overlay.gaugeBackgroundColor = gaugeBackgroundColor?.cgColor
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

	// The overlay
	private let overlay = DSFSparklineOverlay.WiperGauge()
}

extension DSFSparklineWiperGaugeGraphView {
	#if os(macOS)
	public override func updateLayer() {
		// Captured to handle dark/light mode changes
		super.updateLayer()
		self.updateColors()
	}
	#endif
}

private extension DSFSparklineWiperGaugeGraphView {
	func configure() {
		self.addOverlay(self.overlay)
		self.overlay.value = self.value
		self.overlay.animationStyle = animationStyle
		self.updateColors()
	}
	
	func updateColors() {
		self.overlay.valueColor = self.valueColor
		self.overlay.valueBackgroundColor = valueBackgroundColor.cgColor
		self.overlay.gaugePointerColor = gaugePointerColor.cgColor
		self.overlay.gaugeUpperArcColor = gaugeUpperArcColor.cgColor
		self.overlay.gaugeBackgroundColor = gaugeBackgroundColor?.cgColor
	}
}
