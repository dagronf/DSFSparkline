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
public class DSFSparklineWinLossGraphView: DSFSparklineDataSourceView {

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

	// MARK: - Centerline Definitions

	/// The centerline color. If nil, then no centerline is drawn
	#if os(macOS)
	@IBInspectable public var centerlineColor: NSColor? = nil {
		didSet {
			self.colorDidChange()
		}
	}
	#else
	@IBInspectable public var centerlineColor: UIColor? = nil {
		didSet {
			self.colorDidChange()
		}
	}
	#endif

	// The width of the zero line
	@IBInspectable public var centerlineWidth: CGFloat = 1 {
		didSet {
			self.colorDidChange()
		}
	}

	/// The pattern for drawing the line
	var centerlineDashStyle: [CGFloat] = [1,1]

	/// A string representation of the line dash lengths for the center line, eg. "1,3,4,2".
	/// If you want a solid line, specify "-"
	///
	/// Primarily used for Interface Builder integration
	@IBInspectable public var centerlineDashStyleString: String = "1,1" {
		didSet {
			if self.centerlineDashStyleString == "-" {
				// Solid line
				self.centerlineDashStyle = []
			}
			else {
				let components = self.centerlineDashStyleString.extractCGFloats()
				if components.count >= 2 {
					self.centerlineDashStyle = components
				}
				else {
					Swift.print("ERROR: Zero Line Style string format is incompatible (\(self.centerlineDashStyleString) -> \(components))")
					self.centerlineDashStyle = []
				}
			}
			self.colorDidChange()
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
		self.addOverlay(self.overlay)
		self.overlay.setNeedsDisplay()
	}

	override func colorDidChange() {
		super.colorDidChange()

		self.overlay.lineWidth = self.lineWidth
		self.overlay.barSpacing = self.barSpacing

		self.overlay.winFill = DSFSparkline.Fill.Color(self.winColor.withAlphaComponent(0.3).cgColor)
		self.overlay.winStroke = self.winColor.cgColor

		self.overlay.lossFill = DSFSparkline.Fill.Color(self.lossColor.withAlphaComponent(0.3).cgColor)
		self.overlay.lossStroke = self.lossColor.cgColor

		self.overlay.tieStroke = self.tieColor?.cgColor
		if let tc = self.tieColor {
			self.overlay.tieFill = DSFSparkline.Fill.Color(tc.withAlphaComponent(0.3).cgColor)
		}

		if let color = self.centerlineColor {
			self.overlay.centerLine = .init(color: color,
													  lineWidth: self.centerlineWidth,
													  lineDashStyle: self.centerlineDashStyle)
		}
		else {
			self.overlay.centerLine = nil
		}

		self.updateDisplay()
	}
}

extension DSFSparklineWinLossGraphView {

	public override func prepareForInterfaceBuilder() {

		let e = 0 ..< self.graphWindowSize
		let data = e.map { arg in return Int.random(in: -1 ... 1) }

		let ds = DSFSparkline.DataSource(windowSize: self.graphWindowSize)
		self.dataSource = ds
		ds.set(values: data.map { CGFloat($0) })

		#if TARGET_INTERFACE_BUILDER
		/// Need this to hold on to the datasource, or else it disappears due to being weak
		self.ibDataSource = ds
		#endif
	}

}
