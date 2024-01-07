//
//  DSFSparklineOverlay+ActivityGrid.swift
//  DSFSparklines
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

import Foundation

#if os(macOS)
import AppKit
#else
import UIKit
#endif

public extension DSFSparklineOverlay {
	/// A GitHub-style activity grid.
	@objc(DSFSparklineOverlayActivityGrid) class ActivityGrid: DSFSparklineOverlay.StaticDataSource {
		/// The number of vertical cells in a column
		@objc @LayerInvalidating(.display) public var verticalCellCount: Int = 7

		/// The number of horizontal cells in the grid.
		///
		/// If `horizontalCellCount` == 0, cells will be added to fill the entire width of the view
		@objc @LayerInvalidating(.display) public var horizontalCellCount: Int = 0

		/// The layout style for the grid
		@objc @LayerInvalidating(.display) public var layoutStyle: DSFSparkline.ActivityGrid.LayoutStyle = .github

		// MARK: Cell style

		/// The cell's drawing style
		@objc @LayerInvalidating(.display) public var cellStyle: DSFSparkline.ActivityGrid.CellStyle = .init()

		// MARK: Individual cell style setters/getters

		/// The color scheme to use when fill cells
		@objc public var cellFillScheme: DSFSparkline.ValueBasedFill {
			get { self.cellStyle.fillScheme }
			set { self.cellStyle = self.cellStyle.modify(fillScheme: newValue) }
		}

		/// The dimension of each cell
		@objc public var cellDimension: CGFloat {
			get { self.cellStyle.cellDimension }
			set { self.cellStyle = self.cellStyle.modify(cellDimension: newValue) }
		}

		/// The spacing between each of the cells
		@objc public var cellSpacing: CGFloat {
			get { self.cellStyle.cellSpacing }
			set { self.cellStyle = self.cellStyle.modify(cellSpacing: newValue) }
		}

		/// The color for the border of the cell
		@objc public var cellBorderColor: CGColor? {
			get { self.cellStyle.borderColor }
			set { self.cellStyle = self.cellStyle.modify(borderColor: newValue) }
		}

		/// The cell's border width
		@objc public var cellBorderWidth: CGFloat {
			get { self.cellStyle.borderWidth }
			set { self.cellStyle = self.cellStyle.modify(borderWidth: newValue) }
		}

		/// The cell's corner radius
		@objc public var cellCornerRadius: CGFloat {
			get { self.cellStyle.cornerRadius }
			set { self.cellStyle = self.cellStyle.modify(cornerRadius: newValue) }
		}

		/// Called when the activity cells are updated
		@objc public var cellsDidUpdateBlock: (() -> Void)?

		// MARK: Drawing and updates

		/// Called when the content of the data source changes
		override func staticDataSourceDidChange() {
			super.staticDataSourceDidChange()
			self.setNeedsDisplay()
		}

		/// Draws the graph
		override internal func drawGraph(context: CGContext, bounds: CGRect, scale: CGFloat) {
			self._cells.removeAll()
			switch self.layoutStyle {
			case .github:
				self.drawGithubStyle(context: context, bounds: bounds, scale: scale)
			case .defrag:
				self.drawDefragStyle(context: context, bounds: bounds, scale: scale)
			}

			self.cellsDidUpdateBlock?()
		}

		public var cells: [CGRect] { _cells }

		// MARK: Private
		private var _cells: [CGRect] = []
	}
}

public extension DSFSparklineOverlay.ActivityGrid {
	/// Returns the index within the datasource of the value at the given point
	/// - Parameter point: The point within the activity grid to test
	/// - Returns: The data source index for the point, or -1 if
	///            1. no cell was hit, or
	///            2. The cell was a skip cell (ie. its value is `.infinity`, or
	///            3. the cell hit was outside of bounds of the data source
	@objc func indexAtPoint(_ point: CGPoint) -> Int {
		if let index: Int = self._cells.firstIndex(where: { $0.contains(point) }) {
			if index < self.dataSource.values.count,
				self.dataSource.values[index] == .infinity
			{
				// It's an existing cell, but it's a skip cell
				return -1
			}
			return index
		}
		return -1
	}

	/// Return the cell frame for the given index
	/// - Parameter index: The index
	/// - Returns: The cell bounds for the given index
	@objc func cellFrame(for index: Int) -> CGRect {
		if index < self._cells.count {
			return self._cells[index]
		}

		// If we get here, the indexed cell was not visible on screen
		return .zero
	}
}

// MARK: - Sizing

extension DSFSparklineOverlay.ActivityGrid {
	/// The expected height given the current settings
	@objc public var intrinsicHeight: CGFloat {
		if verticalCellCount <= 0 {
			return DSFView.noIntrinsicMetric
		}
		return (CGFloat(self.verticalCellCount) * (self.cellStyle.cellDimension + self.cellStyle.cellSpacing)) + self.cellStyle.cellSpacing
	}

	/// Minimum width for displaying the current values without padding
	@objc public var intrinsicWidth: CGFloat {
		if horizontalCellCount <= 0 {
			if verticalCellCount <= 0 {
				return DSFView.noIntrinsicMetric
			}
			var columnCount = self.dataSource.values.count / self.verticalCellCount
			if (self.dataSource.values.count % self.verticalCellCount) > 0 {
				columnCount += 1
			}
			return (CGFloat(columnCount) * (self.cellStyle.cellDimension + self.cellStyle.cellSpacing)) + self.cellStyle.cellSpacing
		}
		else {
			// Fixed horizontal count
			return (CGFloat(horizontalCellCount) * (self.cellStyle.cellDimension + self.cellStyle.cellSpacing)) + self.cellStyle.cellSpacing
		}
	}

	/// Intrinsic size for the grid
	@objc public var intrinsicSize: CGSize { CGSize(width: self.intrinsicWidth, height: self.intrinsicHeight) }
}

extension DSFSparklineOverlay.ActivityGrid {
	private func drawGithubStyle(context: CGContext, bounds: CGRect, scale: CGFloat) {
		let style = self.cellStyle
		var xOffset = bounds.width - style.cellSpacing - style.cellDimension
		var dataOffset = 0
		while xOffset > 0 {
			(0 ..< verticalCellCount).reversed().forEach { index in
				let cell = CGRect(
					x: xOffset,
					y: CGFloat(index) * (style.cellDimension + style.cellSpacing) + style.cellSpacing,
					width: style.cellDimension,
					height: style.cellDimension
				)
				self.drawCell(context: context, inRect: cell, index: dataOffset)
				dataOffset += 1
			}
			xOffset -= (self.cellStyle.cellDimension + self.cellStyle.cellSpacing)
		}
	}

	private func drawDefragStyle(context: CGContext, bounds: CGRect, scale: CGFloat) {
		var dataOffset = 0
		var yOffset = self.cellStyle.cellSpacing
		let style = self.cellStyle
		let sp = Int((bounds.width - style.cellSpacing) / (style.cellSpacing + style.cellDimension))
		let horizontalCellCount = self.horizontalCellCount == 0 ? sp : self.horizontalCellCount

		var xOffset = 0
		while yOffset <= (bounds.height - style.cellSpacing - style.cellDimension) {
			while xOffset < horizontalCellCount {
				let cell = CGRect(
					x: style.cellSpacing + (CGFloat(xOffset) * (style.cellSpacing + style.cellDimension)),
					y: yOffset,
					width: style.cellDimension,
					height: style.cellDimension
				)
				self.drawCell(context: context, inRect: cell, index: dataOffset)

				xOffset += 1
				dataOffset += 1
			}
			xOffset = 0
			yOffset += self.cellStyle.cellDimension + self.cellStyle.cellSpacing
		}
	}
}

private extension DSFSparklineOverlay.ActivityGrid {
	func drawCell(context: CGContext, inRect cell: CGRect, index: Int) {
		let style = self.cellStyle

		// Store the cell information so we can access it later
		self._cells.append(cell)

		// The fractional value for the index
		let fracValue = self.dataSource.fractionalValue(at: index)

		if fracValue.isInfinite {
			// Treat an infinite value as a skip cell. Draw nothing
			return
		}
		
		let fraction = fracValue.isNaN ? 0.0 : fracValue
		let color = style.fillScheme.color(atFraction: fraction)

		context.addPath(
			CGPath(
				roundedRect: cell,
				cornerWidth: style.cornerRadius,
				cornerHeight: style.cornerRadius,
				transform: nil
			)
		)
		context.setFillColor(color)
		context.fillPath()

		if let c = self.cellStyle.borderColor {
			context.addPath(
				CGPath(
					roundedRect: cell,
					cornerWidth: style.cornerRadius,
					cornerHeight: style.cornerRadius,
					transform: nil
				)
			)
			context.setFillColor(.clear)
			context.setStrokeColor(c)
			context.setLineWidth(style.borderWidth)
			context.strokePath()
		}
	}
}
