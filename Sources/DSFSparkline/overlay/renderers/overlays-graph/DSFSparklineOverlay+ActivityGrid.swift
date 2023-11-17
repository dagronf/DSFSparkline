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
import QuartzCore

#if os(macOS)
import AppKit
#else
import UIKit
#endif

public extension DSFSparklineOverlay {

	/// A GitHub-style activity grid
	@objc(DSFSparklineOverlayActivityGrid) class ActivityGrid: DSFSparklineOverlay.StaticDataSource {

		/// A default palette used when no palette is specified.
		static let DefaultLight = DSFSparkline.Palette([
			DSFColor(red: 0.920, green: 0.930, blue: 0.942, alpha: 1.000),
			DSFColor(red: 0.606, green: 0.914, blue: 0.657, alpha: 1.000),
			DSFColor(red: 0.248, green: 0.768, blue: 0.387, alpha: 1.000),
			DSFColor(red: 0.190, green: 0.633, blue: 0.306, alpha: 1.000),
			DSFColor(red: 0.132, green: 0.432, blue: 0.222, alpha: 1.000),
		])

		static let DefaultDark = DSFSparkline.Palette([
			DSFColor(red: 0.086, green: 0.106, blue: 0.132, alpha: 1.000),
			DSFColor(red: 0.055, green: 0.269, blue: 0.159, alpha: 1.000),
			DSFColor(red: 0.000, green: 0.429, blue: 0.194, alpha: 1.000),
			DSFColor(red: 0.148, green: 0.649, blue: 0.257, alpha: 1.000),
			DSFColor(red: 0.219, green: 0.829, blue: 0.323, alpha: 1.000),
		])

		static let DefaultFill = DSFSparkline.ValueBasedFill(palette: ActivityGrid.DefaultDark)

		/// The number of vertical cells in a column
		@objc public var verticalCellCount: Int = 7

		/// The dimension of each cell
		@objc public var cellDimension: CGFloat = 11.0 {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The spacing between each of the cells
		@objc public var cellSpacing: CGFloat = 2.5 {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The color scheme to use when drawing the cells
		@objc public var colorScheme: DSFSparkline.ValueBasedFill = ActivityGrid.DefaultFill {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The border color for each individual cell
		@objc public var cellBorderColor: CGColor? {
			didSet {
				self.setNeedsDisplay()
			}
		}

		override func staticDataSourceDidChange() {
			super.staticDataSourceDidChange()
			self.setNeedsDisplay()
		}

		/// The expected height given the current settings
		@objc public var intrinsicHeight: CGFloat {
			(CGFloat(self.verticalCellCount) * (self.cellDimension + self.cellSpacing)) + self.cellSpacing
		}

		/// Minimum width for displaying the current values without padding
		@objc public var intrinsicWidth: CGFloat {
			var columnCount = self.dataSource.values.count / self.verticalCellCount
			if (self.dataSource.values.count % self.verticalCellCount) > 0 {
				columnCount += 1
			}
			return (CGFloat(columnCount) * (self.cellDimension + self.cellSpacing)) + self.cellSpacing
		}

		/// Returns the index within the datasource of the value at the given point
		/// - Parameter point: The point within the activity graph to test
		/// - Returns: The data source index for the point, or -1 if
		///            1. no cell was hit, or
		///            2. the cell hit was outside of bounds of the data source
		@objc public func indexAtPoint(_ point: CGPoint) -> Int {
			self.cells.firstIndex { $0.contains(point) } ?? -1
		}

		/// Return the cell bounds for the given index
		/// - Parameter index: The index
		/// - Returns: The cell bounds for the given index
		@objc public func cellPosition(for index: Int) -> CGRect {
			assert(index < self.cells.count)
			return self.cells[index]
		}

		override internal func drawGraph(context: CGContext, bounds: CGRect, scale: CGFloat) {

			self.cells.removeAll()

			var xOffset = bounds.width - self.cellSpacing - self.cellDimension

			var dataOffset = 0
			while xOffset > 0 {
				(0 ..< verticalCellCount).reversed().forEach { index in
					let fracValue = self.dataSource.fractionalValue(at: dataOffset) ?? 0.0

					let color = colorScheme.color(atFraction: fracValue)

					let cell = CGRect(
						x: xOffset,
						y: CGFloat(index) * (self.cellDimension + self.cellSpacing) + self.cellSpacing,
						width: self.cellDimension,
						height: self.cellDimension
					)
					context.addPath(CGPath(roundedRect: cell, cornerWidth: 2.5, cornerHeight: 2.5, transform: nil))
					context.setFillColor(color)
					context.fillPath()

					cells.append(cell)

					if let c = cellBorderColor {
						let ins = cell.insetBy(dx: 0.25, dy: 0.25)
						context.addPath(CGPath(roundedRect: ins, cornerWidth: 2, cornerHeight: 2, transform: nil))
						context.setFillColor(.clear)
						context.setStrokeColor(c)
						context.setLineWidth(0.5)
						context.strokePath()
					}

					dataOffset += 1
				}
				xOffset -= (self.cellDimension + self.cellSpacing)
			}
		}

		// private
		private var cells: [CGRect] = []
	}
}
