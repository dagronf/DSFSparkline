//
//  DSFSparklineDataSource.swift
//  DSFSparklines
//
//  Created by Darren Ford on 16/1/20.
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

/// A sparkline graph that displays dots (like the CPU history graph in Activity Monitor)
@IBDesignable
public class DSFSparklineDotGraphView: DSFSparklineDataSourceView {

	let overlay = DSFSparklineOverlay.Dot()

	/// Are the values drawn from the top down?
	@IBInspectable public var upsideDown: Bool = false {
		didSet {
			self.overlay.upsideDown = self.upsideDown
			self.updateDisplay()
		}
	}

	/// The number of vertical buckets to break the input data up into
	@IBInspectable public var verticalDotCount: UInt = 10 {
		didSet {
			self.overlay.verticalDotCount = self.verticalDotCount
			self.updateDisplay()
		}
	}

	/// The secondary color for the sparkline
	#if os(macOS)
	@IBInspectable public var unsetGraphColor: NSColor = NSColor.clear {
		didSet {
			self.colorDidChange()
		}
	}
	#else
	@IBInspectable public var unsetGraphColor: UIColor = UIColor.clear {
		didSet {
			self.colorDidChange()
		}
	}
	#endif

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

		self.overlay.upsideDown = self.upsideDown
		self.overlay.verticalDotCount = self.verticalDotCount

		self.overlay.onColor = self.graphColor.cgColor
		self.overlay.offColor = self.unsetGraphColor.cgColor
	}
}
