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
public class DSFSparklineZeroLineGraphView: DSFSparklineView {

	let zerolineOverlay = DSFSparklineOverlay.ZeroLine()

	/// Draw a dotted line at the zero point on the y-axis
	@IBInspectable public var showZeroLine: Bool = false {
		didSet {
			self.updateDisplay()
		}
	}

	/// The color of the dotted line at the zero point on the y-axis
	#if os(macOS)
	@IBInspectable public var zeroLineColor = NSColor.gray {
		didSet {
			self.colorDidChange()
		}
	}
	#else
	@IBInspectable public var zeroLineColor: UIColor = .systemGray {
		didSet {
			self.colorDidChange()
		}
	}
	#endif

	// MARK: Zero-line display

	/// The width of the dotted line at the zero point on the y-axis
	@IBInspectable public var zeroLineWidth: CGFloat = 1.0

	/// The line style for the dotted line. Use [] to specify a solid line.
	@objc public var zeroLineDashStyle: [CGFloat] = [1.0, 1.0]

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
				let components = self.zeroLineDashStyleString.split(separator: ",")
				let floats: [CGFloat] = components
					.map { String($0) } // Convert to string array
					.compactMap { Float($0) } // Convert to float array if possible
					.compactMap { CGFloat($0) } // Convert to CGFloat array
				if components.count == floats.count {
					self.zeroLineDashStyle = floats
				}
				else {
					Swift.print("ERROR: Zero Line Style string format is incompatible (\(self.zeroLineDashStyleString) -> \(components))")
				}
			}
			self.updateDisplay()
		}
	}

	// MARK: Zero-line centering

	/// Should the graph be centered at the zero line?
	@IBInspectable public var centeredAtZeroLine: Bool = false

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
			self.updateDisplay()
		}
	}

	/// The color of the dotted line at the zero point on the y-axis
	#if os(macOS)
	@IBInspectable public var highlightColor = NSColor.gray {
		didSet {
			self.creatableHighlightRangeDefinition.highlightColor = self.highlightColor
			self.colorDidChange()
		}
	}
	#else
	@IBInspectable public var highlightColor: UIColor = .systemGray {
		didSet {
			self.creatableHighlightRangeDefinition.highlightColor = self.highlightColor
			self.colorDidChange()
		}
	}
	#endif

	/// A string of the format "0.1,0.7"
	@IBInspectable public var highlightRangeString: String? = nil {
		didSet {
			if let rangeStr = highlightRangeString {
				let components = rangeStr.split(separator: ",")
				let floats: [CGFloat] = components
					.map { String($0) } // Convert to string array
					.compactMap { Float($0) } // Convert to float array if possible
					.compactMap { CGFloat($0) } // Convert to CGFloat array
				if floats.count == 2, floats[0] < floats[1] {
					self.creatableHighlightRangeDefinition.range = floats[0] ..< floats[1]
				}
				else {
					self.highlightRangeDefinition = []
					Swift.print("ERROR: Highlight range string format is incompatible (\(self.zeroLineDashStyleString) -> \(components))")
				}
			}
			else {
				self.highlightRangeDefinition = []
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
	}



	private var creatableHighlightRangeDefinition: DSFSparklineHighlightRangeDefinition {
		if let item = self.highlightRangeDefinition.first {
			return item
		}

		let new = DSFSparklineHighlightRangeDefinition(lowerBound: 0, upperBound: 1)
		self.highlightRangeDefinition = [new]
		return new
	}

	@objc public var highlightRangeDefinition: [DSFSparklineHighlightRangeDefinition] = [] {
		didSet {
			self.updateDisplay()
		}
	}

	public override func prepareForInterfaceBuilder() {
		if self.showHighlightRange {
			self.highlightRangeDefinition = [DSFSparklineHighlightRangeDefinition(range: -3 ..< 3, highlightColor: self.highlightColor)]
		}
		super.prepareForInterfaceBuilder()
	}

}

public extension DSFSparklineZeroLineGraphView {

	/// Configure the zero line using the ZeroLineDefinition 
	func setZeroLineDefinition(_ definition: DSFSparklineZeroLineDefinition) {
		self.zeroLineWidth = definition.lineWidth
		self.zeroLineColor = definition.color
		self.zeroLineDashStyle = definition.lineDashStyle
	}
}

// MARK: - Drawing

public extension DSFSparklineZeroLineGraphView {

	#if os(macOS)
	override func draw(_ dirtyRect: NSRect) {
		super.draw(dirtyRect)
		if let ctx = NSGraphicsContext.current?.cgContext {
			self.drawAdditional(primary: ctx)
		}
	}
	#else
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		if let ctx = UIGraphicsGetCurrentContext() {
			self.drawAdditional(primary: ctx)
		}
	}
	#endif

	func drawAdditional(primary: CGContext) {

		guard let dataSource = self.dataSource else { return }

		let integ = self.bounds.integral
		for def in self.highlightRangeDefinition {

			let lb = 1.0 - dataSource.normalize(value: def.range.lowerBound)
			let ub = 1.0 - dataSource.normalize(value: def.range.upperBound)

			primary.usingGState { ctx in
				ctx.setFillColor(def.highlightColor.cgColor)
				let r = CGRect(x: 0, y: ub * integ.height, width: integ.width, height: (lb - ub) * integ.height)
				ctx.addRect(r)
				ctx.fillPath()
			}
		}

		// Show the zero point if wanted
		if self.showZeroLine {
			let frac = dataSource.fractionalPosition(for: dataSource.zeroLineValue)
			let zeroPos = self.bounds.height - (frac * self.bounds.height)

			primary.usingGState { ctx in
				let color = self.zeroLineColor
				ctx.setLineWidth(self.zeroLineWidth / self.retinaScale())
				ctx.setStrokeColor(color.cgColor)
				ctx.setLineDash(phase: 0.0, lengths: self.zeroLineDashStyle)
				ctx.strokeLineSegments(between: [CGPoint(x: 0.0, y: zeroPos), CGPoint(x: self.bounds.width, y: zeroPos)])
			}
		}
	}
}
