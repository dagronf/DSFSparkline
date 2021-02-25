//
//  DSFSparklineWinLossGraphView.swift
//  DSFSparklines
//
//  Created by Darren Ford on 20/12/19.
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
import Cocoa
#else
import UIKit
#endif

@IBDesignable
public class DSFSparklineWinLossGraphView: DSFSparklineZeroLineGraphView {

	let overlay = DSFSparklineOverlay.WinLossTie()

	/// The line width (in pixels) to use when drawing the border of each bar
	@IBInspectable public var lineWidth: UInt = 1 {
		didSet {
			self.updateDisplay()
		}
	}

	/// The spacing (in pixels) between each bar
	@IBInspectable public var barSpacing: UInt = 1 {
		didSet {
			self.updateDisplay()
		}
	}

	#if os(macOS)
	/// The color to draw the 'win' boxes
	@IBInspectable public var winColor: NSColor = NSColor.systemGreen {
		didSet {
			self.colorDidChange()
		}
	}
	/// The color to draw the 'loss' boxes
	@IBInspectable public var lossColor: NSColor = NSColor.systemRed {
		didSet {
			self.colorDidChange()
		}
	}
	/// The color to draw the 'tie' boxes
	@IBInspectable public var tieColor: NSColor? = nil {
		didSet {
			self.colorDidChange()
		}
	}
	#else
	/// The color to draw the 'win' boxes
	@IBInspectable public var winColor: UIColor = UIColor.systemGreen {
		didSet {
			self.colorDidChange()
		}
	}
	/// The color to draw the 'loss' boxes
	@IBInspectable public var lossColor: UIColor = UIColor.systemRed {
		didSet {
			self.colorDidChange()
		}
	}
	/// The color to draw the 'tie' boxes
	@IBInspectable public var tieColor: UIColor? = nil {
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

		self.overlay.lineWidth = self.lineWidth
		self.overlay.barSpacing = self.barSpacing

		self.overlay.winColor = self.winColor.cgColor
		self.overlay.lossColor = self.lossColor.cgColor
		self.overlay.tieColor = self.tieColor?.cgColor
	}
}
