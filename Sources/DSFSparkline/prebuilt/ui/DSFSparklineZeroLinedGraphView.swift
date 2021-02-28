//
//  DSFSparklineZeroLinedGraphView.swift
//  DSFSparklines
//
//  Created by Darren Ford on 20/12/19.
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

import SwiftUI

#if os(macOS)
import Cocoa
#else
import UIKit
#endif

/// A view that can draw a zero-point line. Should never be used directly, just to inherit from for other graph types
@IBDesignable
public class DSFSparklineZeroLineGraphView: DSFSparklineDataSourceView {

	// The zero-line overlay
	let zerolineOverlay = DSFSparklineOverlay.ZeroLine()

	// A fixed interface-builder defined highlight
	let ibHighlightOverlay = DSFSparklineOverlay.RangeHighlight()

	// An array of additional highlights
	var highlightOverlay: [DSFSparklineOverlay.RangeHighlight] = []

	/// Draw a dotted line at the zero point on the y-axis
	@IBInspectable public var showZeroLine: Bool = false {
		didSet {
			self.zerolineOverlay.isHidden = !self.showZeroLine
			self.updateDisplay()
		}
	}

	/// The color of the dotted line at the zero point on the y-axis
	#if os(macOS)
	@IBInspectable public var zeroLineColor = NSColor.gray {
		didSet {
			self.zerolineOverlay.strokeColor = self.zeroLineColor.cgColor
		}
	}
	#else
	@IBInspectable public var zeroLineColor: UIColor = .systemGray {
		didSet {
			self.zerolineOverlay.strokeColor = self.zeroLineColor.cgColor
		}
	}
	#endif

	// MARK: Zero-line display

	/// The width of the dotted line at the zero point on the y-axis
	@IBInspectable public var zeroLineWidth: CGFloat = 1.0 {
		didSet {
			self.zerolineOverlay.strokeWidth = zeroLineWidth
		}
	}

	/// The line style for the dotted line. Use [] to specify a solid line.
	@objc public var zeroLineDashStyle: [CGFloat] = [1.0, 1.0] {
		didSet {
			self.zerolineOverlay.dashStyle = zeroLineDashStyle
		}
	}

	/// A string representation of the line dash lengths for the zero line, eg. "1,3,4,2". If you want a solid line, specify "-"
	///
	/// Primarily used for Interface Builder integration
	@IBInspectable public var zeroLineDashStyleString: String = "1,1" {
		didSet {
			if self.zeroLineDashStyleString == "-" {
				// Solid line
				self.zeroLineDashStyle = []
			}
			else {
				let components = self.zeroLineDashStyleString.extractCGFloats()
				if components.count >= 2 {
					self.zeroLineDashStyle = components
				}
				else {
					Swift.print("ERROR: Zero Line Style string format is incompatible (\(self.zeroLineDashStyleString) -> \(components))")
				}
			}
			self.updateDisplay()
		}
	}

	// MARK: Zero-line centering

//	/// Should the graph be centered at the zero line?
//	@IBInspectable public var centeredAtZeroLine: Bool = false {
//		didSet {
//			self.
//		}
//	}

	/// The color used to draw values below the zero line. If nil, is the same as the graph color
	#if os(macOS)
	@IBInspectable public var lowerGraphColor: NSColor? {
		didSet {
			self.colorDidChange()
		}
	}
	#else
	@IBInspectable public var lowerGraphColor: UIColor? {
		didSet {
			self.colorDidChange()
		}
	}
	#endif

	/// The 'lowerColor' represents the 'negativeColor' if it is set, otherwise its the same as the graphColor
	internal var lowerColor: DSFColor {
		return self.lowerGraphColor ?? self.graphColor
	}

	/// Draw a dotted line at the zero point on the y-axis
	@IBInspectable public var showHighlightRange: Bool = false {
		didSet {
			self.ibHighlightOverlay.isHidden = !self.showHighlightRange
		}
	}

	/// The color of the highlight to be used
	#if os(macOS)
	@IBInspectable public var highlightColor = NSColor.gray {
		didSet {
			self.ibHighlightOverlay.fill = DSFSparkline.Fill.Color(self.highlightColor.cgColor)
		}
	}
	#else
	@IBInspectable public var highlightColor: UIColor = .systemGray {
		didSet {
			self.ibHighlightOverlay.fill = DSFSparkline.Fill.Color(self.highlightColor.cgColor)
		}
	}
	#endif

	/// A string of the format "0.1,0.7"
	@IBInspectable public var highlightRangeString: String? = nil {
		didSet {
			let floats = self.highlightRangeString?.extractCGFloats() ?? []
			if floats.count == 2, floats[0] < floats[1] {
				self.ibHighlightOverlay.highlightRange = floats[0] ..< floats[1]
			}
			else {
				self.highlightRangeDefinition = []
				Swift.print("ERROR: Highlight range string format is incompatible (\(self.zeroLineDashStyleString) -> \(floats))")
			}
		}
	}

	public override init(frame: CGRect) {
		super.init(frame: frame)
		self.configureZeroLine()
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.configureZeroLine()
	}

	func configureZeroLine() {
		self.addOverlay(self.zerolineOverlay)
		self.zerolineOverlay.zPosition = -5
		self.addOverlay(self.ibHighlightOverlay)
		self.ibHighlightOverlay.zPosition = -10
		self.ibHighlightOverlay.dataSource = self.dataSource

		//self.addOverlay(self.highlightOverlay)
	}

	@objc public var highlightRangeDefinition: [DSFSparkline.HighlightRangeDefinition] = [] {
		willSet {
			self.highlightOverlay.forEach { $0.removeFromSuperlayer() }
			self.highlightOverlay = []
		}

		didSet {
			self.highlightRangeDefinition.forEach { r in
				let item = DSFSparklineOverlay.RangeHighlight()
				item.highlightRange = r.range
				item.dataSource = self.dataSource
				item.fill = r.fill
				item.zPosition = -10
				self.addOverlay(item)
				self.highlightOverlay.append(item)
			}
			self.updateDisplay()
		}
	}

	public override func prepareForInterfaceBuilder() {
		if self.showHighlightRange {
			self.highlightRangeDefinition = [
				DSFSparkline.HighlightRangeDefinition(
					range: -3 ..< 3,
					fill: DSFSparkline.Fill.Color(self.highlightColor.cgColor))
			]
		}
		super.prepareForInterfaceBuilder()
	}

}

public extension DSFSparklineZeroLineGraphView {

	/// Configure the zero line using the ZeroLineDefinition 
	func setZeroLineDefinition(_ definition: DSFSparkline.ZeroLineDefinition) {
		self.zeroLineWidth = definition.lineWidth
		self.zeroLineColor = definition.color
		self.zeroLineDashStyle = definition.lineDashStyle
	}
}
