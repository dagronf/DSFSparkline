//
//  DSFSparklineCircularGaugeView.swift
//
//  Copyright © 2024 Darren Ford. All rights reserved.
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

/// A circular gauge
public class DSFSparklineCircularGaugeView: DSFSparklineSurfaceView {
	/// The value to display (0 ... 1)
	@objc public dynamic var value: CGFloat = 0.0 {
		didSet {
			self.overlay.value = self.value
		}
	}

	/// The style to use when drawing the gauge's track
	@objc public var trackStyle = DSFSparklineOverlay.CircularGauge.DefaultTrackStyle {
		didSet {
			self.overlay.trackStyle = self.trackStyle
		}
	}

	/// The width of the track
	@objc public dynamic var trackWidth: CGFloat {
		get { self.overlay.trackStyle.width }
		set { self.overlay.trackStyle.width = newValue }
	}

	/// Track color
	@objc public dynamic var trackColor: DSFColor = .black.withAlphaComponent(0.1) {
		didSet {
			self.overlay.trackStyle.fillColor = DSFSparkline.Fill.Color(trackColor.cgColor)
		}
	}

	/// The style to use when drawing the gauge's value
	@objc public var lineStyle = DSFSparklineOverlay.CircularGauge.DefaultLineStyle {
		didSet {
			self.overlay.lineStyle = self.lineStyle
		}
	}

	/// The width of the track
	@objc public dynamic var lineWidth: CGFloat {
		get { self.overlay.lineStyle.width }
		set { self.overlay.lineStyle.width = newValue }
	}

	/// Line color
	@objc public dynamic var lineColor: DSFColor = .black {
		didSet {
			self.overlay.lineStyle.fillColor = DSFSparkline.Fill.Color(lineColor.cgColor)
		}
	}

	/// The animation style to use when the value changes
	@objc public var animationStyle: DSFSparkline.AnimationStyle? = nil {
		didSet {
			self.overlay.animationStyle = animationStyle
		}
	}

	// MARK: - Initializers
	
	/// Create
	public override init(frame: CGRect) {
		super.init(frame: frame)
		self.configure()
	}

	/// Create
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.configure()
	}

	private let overlay = DSFSparklineOverlay.CircularGauge()
}

extension DSFSparklineCircularGaugeView {
	func configure() {
		self.addOverlay(self.overlay)
		self.clipsToBounds = false
		self.setNeedsDisplay()
	}
}
