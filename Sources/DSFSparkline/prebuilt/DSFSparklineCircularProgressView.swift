//
//  DSFSparklineCircularProgressView.swift
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

@objc public class DSFSparklineCircularProgressView: DSFSparklineSurfaceView {

	@objc public dynamic var value: CGFloat = 0.0 {
		didSet {
			self.overlay.value = self.value
		}
	}

	@objc public dynamic var trackWidth: CGFloat = 10 {
		didSet {
			self.overlay.trackWidth = self.trackWidth
		}
	}

	/// The padding (inset) for drawing the ring
	@objc public dynamic var padding: CGFloat = 0.0 {
		didSet {
			self.overlay.padding = self.padding
		}
	}

	/// The stroke color for the pie chart
	@objc public dynamic var trackColor: DSFColor? {
		didSet {
			if let t = self.trackColor?.cgColor {
				self.overlay.trackColor = t
			}
		}
	}

	/// The stroke color for the pie chart
	@objc public dynamic var progressColor: DSFColor? {
		didSet {
			if let t = self.progressColor?.cgColor {
				self.overlay.fillStyle = DSFSparkline.Fill.Color(t)
			}
		}
	}

	/// The track's icon
	@objc public dynamic var trackIcon: CGImage? {
		didSet {
			self.overlay.icon = self.trackIcon
		}
	}

	/// The fill color for the value ring
	@objc public var fillStyle: DSFSparklineFillable = DSFSparkline.Fill.Color.white {
		didSet {
			self.overlay.fillStyle = fillStyle
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

	private let overlay = DSFSparklineOverlay.CircularProgress()
}

extension DSFSparklineCircularProgressView {
	func configure() {
		self.addOverlay(self.overlay)
		self.setNeedsDisplay()
	}
}

