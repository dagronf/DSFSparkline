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
@objc public class DSFSparklineZeroLineGraphView: DSFSparklineDataSourceView {

	// MARK: Zero-line display

	// The zero-line overlay
	let zerolineOverlay = DSFSparklineOverlay.ZeroLine()

	/// Draw a dotted line at the zero point on the y-axis
	@objc public dynamic var zeroLineVisible: Bool = false {
		didSet {
			self.updateZeroLineSettings()
		}
	}

	/// The color of the dotted line at the zero point on the y-axis
	#if os(macOS)
	@objc public dynamic var zeroLineColor = NSColor.gray {
		didSet {
			self.updateZeroLineSettings()
		}
	}
	#else
	@objc public dynamic var zeroLineColor: UIColor = .systemGray {
		didSet {
			self.updateZeroLineSettings()
		}
	}
	#endif

	/// The width of the dotted line at the zero point on the y-axis
	@objc public dynamic var zeroLineWidth: CGFloat = 1.0 {
		didSet {
			self.updateZeroLineSettings()
		}
	}

	/// The line style for the dotted line. Use [] to specify a solid line.
	@objc public var zeroLineDashStyle: [CGFloat] = [1.0, 1.0] {
		didSet {
			self.updateZeroLineSettings()
		}
	}

	/// A string representation of the line dash lengths for the zero line, eg. "1,3,4,2". If you want a solid line, specify "-"
	///
	/// Primarily used for Interface Builder integration
	@objc public dynamic var zeroLineDashStyleString: String = "1,1" {
		didSet {
			self.handleZeroLineString()
		}
	}

	// MARK: Zero-line centering

	/// The color used to draw values below the zero line. If nil, is the same as the graph color
	@objc public dynamic var lowerGraphColor: DSFColor? {
		didSet {
			self.colorDidChange()
		}
	}

	/// The 'lowerColor' represents the 'negativeColor' if it is set, otherwise its the same as the graphColor
	internal var lowerColor: DSFColor {
		return self.lowerGraphColor ?? self.graphColor
	}

	// MARK: - Highlight ranges

	// A fixed interface-builder defined highlight
	let ibHighlightOverlay = DSFSparklineOverlay.RangeHighlight()

	// An array of additional highlights
	var highlightOverlay: [DSFSparklineOverlay.RangeHighlight] = []

	/// Draw a highlight for a range on the graph
	@objc public dynamic var highlightRangeVisible: Bool = false {
		didSet {
			self.updateHighlightSettings()
		}
	}

	/// The color of the highlight to be used
	#if os(macOS)
	@objc public dynamic var highlightRangeColor = NSColor.gray {
		didSet {
			self.updateHighlightSettings()
		}
	}
	#else
	@objc public dynamic var highlightRangeColor: UIColor = .systemGray {
		didSet {
			self.updateHighlightSettings()
		}
	}
	#endif

	/// A string of the format "0.1,0.7"
	@objc public dynamic var highlightRangeString: String? = nil {
		didSet {
			self.updateHighlightSettings()
		}
	}

	// MARK: - Grid lines support

	// A fixed interface-builder defined highlight
	let ibGridLinesOverlay = DSFSparklineOverlay.GridLines()

	/// Draw a dotted line at the zero point on the y-axis
	@objc public dynamic var gridLinesVisible: Bool = false {
		didSet {
			self.updateGridLinesSettings()
		}
	}

	/// The y-values on the graph with a grid line
	@objc public var gridLinesValues: [CGFloat] = [] {
		didSet {
			self.updateGridLinesSettings()
		}
	}

	/// A string of the format "0.1,0.7"
	@objc public dynamic var gridLinesValuesString: String? = nil {
		didSet {
			// Dash style
			let floats = self.gridLinesValuesString?.extractCGFloats() ?? []
			self.gridLinesValues = floats
		}
	}

	#if os(macOS)
	@objc public dynamic var gridLinesColor = NSColor.systemGray.withAlphaComponent(0.5) {
		didSet {
			self.updateGridLinesSettings()
		}
	}
	#else
	@objc public dynamic var gridLinesColor: UIColor = .systemGray.withAlphaComponent(0.5) {
		didSet {
			self.updateGridLinesSettings()
		}
	}
	#endif

	/// The width of the dotted line at the zero point on the y-axis
	@objc public dynamic var gridLinesWidth: CGFloat = 1.0 {
		didSet {
			self.updateGridLinesSettings()
		}
	}

	/// The line style for the dotted line. Use [] to specify a solid line.
	@objc public dynamic var gridLinesDashStyle: [CGFloat] = [1.0, 1.0] {
		didSet {
			self.updateGridLinesSettings()
		}
	}

	/// A string representation of the line dash lengths for grid lines, eg. "1,3,4,2". If you want a solid line, specify "-"
	///
	/// Primarily used for Interface Builder integration
	@objc public dynamic var gridLinesDashStyleString: String = "1.0,1.0" {
		didSet {
			self.updateGridLinesSettings()
		}
	}

	/// Set the grid line definition for the graph
	@objc public func setGridLineDefinition(_ gridLineDefinition: DSFSparkline.GridLinesDefinition) {
		self.gridLinesVisible = true
		self.gridLinesColor = gridLineDefinition.color
		self.gridLinesWidth = gridLineDefinition.width
		self.gridLinesDashStyle = gridLineDefinition.dashStyle
		self.gridLinesValues = gridLineDefinition.values
	}

	// MARK: - Init

	public override init(frame: CGRect) {
		super.init(frame: frame)
		self.setup()
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.setup()
	}

	private func setup() {

		// The Zero line overlay
		self.addOverlay(self.zerolineOverlay)
		self.zerolineOverlay.zPosition = -5
		self.updateZeroLineSettings()

		// Highlight
		self.addOverlay(self.ibHighlightOverlay)
		self.ibHighlightOverlay.zPosition = -10
		self.ibHighlightOverlay.dataSource = self.dataSource
		self.updateHighlightSettings()

		// Grid lines
		self.addOverlay(self.ibGridLinesOverlay)
		self.ibGridLinesOverlay.isHidden = self.gridLinesVisible
		self.ibGridLinesOverlay.zPosition = -10
		self.ibGridLinesOverlay.dataSource = self.dataSource
		self.updateGridLinesSettings()
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
}

public extension DSFSparklineZeroLineGraphView {
	/// Configure the zero line using the ZeroLineDefinition 
	func setZeroLineDefinition(_ definition: DSFSparkline.ZeroLineDefinition) {
		self.zeroLineWidth = definition.lineWidth
		self.zeroLineColor = definition.color
		self.zeroLineDashStyle = definition.lineDashStyle
	}
}

private extension DSFSparklineZeroLineGraphView {
	func updateGridLinesSettings() {
		self.ibGridLinesOverlay.isHidden = !self.gridLinesVisible
		self.ibGridLinesOverlay.strokeWidth = self.gridLinesWidth
		self.ibGridLinesOverlay.strokeColor = self.gridLinesColor.cgColor
		self.ibGridLinesOverlay.dashStyle = self.gridLinesDashStyle

		self.ibGridLinesOverlay.floatValues = self.gridLinesValues

		self.updateDisplay()
	}

	///
	private func handleZeroLineString() {
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
	}

	private func updateZeroLineSettings() {
		self.zerolineOverlay.isHidden = !self.zeroLineVisible
		self.zerolineOverlay.strokeColor = self.zeroLineColor.cgColor
		self.zerolineOverlay.strokeWidth = self.zeroLineWidth
		self.zerolineOverlay.dashStyle = self.zeroLineDashStyle
		self.updateDisplay()
	}

	private func updateHighlightSettings() {
			self.ibHighlightOverlay.isHidden = !self.highlightRangeVisible
			self.ibHighlightOverlay.fill = DSFSparkline.Fill.Color(self.highlightRangeColor.cgColor)

			let floats = self.highlightRangeString?.extractCGFloats() ?? []
			if floats.count == 2, floats[0] < floats[1] {
				self.ibHighlightOverlay.highlightRange = floats[0] ..< floats[1]
			}
			else if floats.count == 0 {
				// No ranges. This is fine
				self.highlightRangeDefinition = []
			}
			else {
				self.highlightRangeDefinition = []
				Swift.print("ERROR: Highlight range string format is incompatible (\(self.zeroLineDashStyleString) -> \(floats))")
			}
			self.updateDisplay()
	}
}
