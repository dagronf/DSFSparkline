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
	/// A GitHub-style activity grid.
	@objc(DSFSparklineOverlayActivityGrid) class ActivityGrid: DSFSparklineOverlay.StaticDataSource {
		/// The number of vertical cells in a column
		@objc public var verticalCellCount: Int = 7 {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The cell's drawing style
		@objc public var cellStyle: CellStyle = CellStyle() {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The layout style for the grid
		@objc public var layoutStyle: LayoutStyle = .github {
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
			return (CGFloat(self.verticalCellCount) * (self.cellStyle.cellDimension + self.cellStyle.cellSpacing)) + self.cellStyle.cellSpacing
		}

		/// Minimum width for displaying the current values without padding
		@objc public var intrinsicWidth: CGFloat {
			var columnCount = self.dataSource.values.count / self.verticalCellCount
			if (self.dataSource.values.count % self.verticalCellCount) > 0 {
				columnCount += 1
			}
			return (CGFloat(columnCount) * (self.cellStyle.cellDimension + self.cellStyle.cellSpacing)) + self.cellStyle.cellSpacing
		}

		/// Returns the index within the datasource of the value at the given point
		/// - Parameter point: The point within the activity graph to test
		/// - Returns: The data source index for the point, or -1 if
		///            1. no cell was hit, or
		///            2. the cell hit was outside of bounds of the data source
		@objc public func indexAtPoint(_ point: CGPoint) -> Int {
			self.cells.firstIndex { $0.contains(point) } ?? -1
		}

		/// Return the cell frame for the given index
		/// - Parameter index: The index
		/// - Returns: The cell bounds for the given index
		@objc public func cellFrame(for index: Int) -> CGRect {
			assert(index < self.cells.count)
			return self.cells[index]
		}

		override internal func drawGraph(context: CGContext, bounds: CGRect, scale: CGFloat) {
			self.cells.removeAll()
			if self.layoutStyle == .defrag {
				self.drawDefragStyle(context: context, bounds: bounds, scale: scale)
			}
			else {
				self.drawGithubStyle(context: context, bounds: bounds, scale: scale)
			}
		}

		// private
		private var cells: [CGRect] = []

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
	}
}

extension DSFSparklineOverlay.ActivityGrid {
	private func drawGithubStyle(context: CGContext, bounds: CGRect, scale: CGFloat) {
		var xOffset = bounds.width - self.cellStyle.cellSpacing - self.cellStyle.cellDimension

		var dataOffset = 0
		while xOffset > 0 {
			(0 ..< verticalCellCount).reversed().forEach { index in
				let fracValue = self.dataSource.fractionalValue(at: dataOffset) ?? 0.0

				let color = self.cellStyle.fillStyle.color(atFraction: fracValue)

				let cell = CGRect(
					x: xOffset,
					y: CGFloat(index) * (self.cellStyle.cellDimension + self.cellStyle.cellSpacing) + self.cellStyle.cellSpacing,
					width: self.cellStyle.cellDimension,
					height: self.cellStyle.cellDimension
				)
				context.addPath(CGPath(roundedRect: cell, cornerWidth: 2.5, cornerHeight: 2.5, transform: nil))
				context.setFillColor(color)
				context.fillPath()

				cells.append(cell)

				if let c = self.cellStyle.borderColor {
					let ins = cell.insetBy(dx: 0.25, dy: 0.25)
					context.addPath(CGPath(roundedRect: ins, cornerWidth: 2, cornerHeight: 2, transform: nil))
					context.setFillColor(.clear)
					context.setStrokeColor(c)
					context.setLineWidth(0.5)
					context.strokePath()
				}

				dataOffset += 1
			}
			xOffset -= (self.cellStyle.cellDimension + self.cellStyle.cellSpacing)
		}
	}

	private func drawDefragStyle(context: CGContext, bounds: CGRect, scale: CGFloat) {
		var dataOffset = 0
		var yOffset = self.cellStyle.cellSpacing
		var xOffset = self.cellStyle.cellSpacing

		while yOffset <= (bounds.height - self.cellStyle.cellSpacing - self.cellStyle.cellDimension) {
			while xOffset <= (bounds.width - self.cellStyle.cellSpacing - self.cellStyle.cellDimension) {
				let fracValue = self.dataSource.fractionalValue(at: dataOffset) ?? 0.0
				let color = self.cellStyle.fillStyle.color(atFraction: fracValue)

				let cell = CGRect(x: xOffset, y: yOffset, width: self.cellStyle.cellDimension, height: self.cellStyle.cellDimension)
				context.addPath(CGPath(roundedRect: cell, cornerWidth: 2.5, cornerHeight: 2.5, transform: nil))
				context.setFillColor(color)
				context.fillPath()

				cells.append(cell)

				if let c = self.cellStyle.borderColor {
					let ins = cell.insetBy(dx: 0.25, dy: 0.25)
					context.addPath(CGPath(roundedRect: ins, cornerWidth: 2, cornerHeight: 2, transform: nil))
					context.setFillColor(.clear)
					context.setStrokeColor(c)
					context.setLineWidth(0.5)
					context.strokePath()
				}

				xOffset += self.cellStyle.cellDimension + self.cellStyle.cellSpacing

				dataOffset += 1
			}
			xOffset = self.cellStyle.cellSpacing
			yOffset += self.cellStyle.cellDimension + self.cellStyle.cellSpacing
		}
	}
}

public extension DSFSparklineOverlay.ActivityGrid {
	/// The drawing style for the activity grid
	@objc(DSFSparklineOverlayActivityGridLayoutStyle)
	enum LayoutStyle: Int {
		/// 'Newest' value at bottom right, works up then left
		case github = 0
		/// 'Newest' value at top left, works right then down
		case defrag = 1
	}

	/// The style for drawing cells in the activity grid
	@objc(DSFSparklineOverlayActivityGridCellStyle) 
	class CellStyle: NSObject {
		@objc public let fillStyle: DSFSparkline.ValueBasedFill
		@objc public let borderColor: CGColor?
		@objc public let borderWidth: CGFloat
		@objc public let cellDimension: CGFloat
		@objc public let cellSpacing: CGFloat
		@objc public init(
			fillStyle: DSFSparkline.ValueBasedFill,
			borderColor: CGColor? = nil,
			borderWidth: CGFloat = 1.0,
			cellDimension: CGFloat = 11.0,
			cellSpacing: CGFloat = 2.5
		) {
			self.fillStyle = fillStyle
			self.borderColor = borderColor
			self.borderWidth = borderWidth
			self.cellDimension = cellDimension
			self.cellSpacing = cellSpacing
			super.init()
		}

		/// Default style - dark github
		@objc public convenience override init() {
			self.init(fillStyle: ActivityGrid.DefaultFill)
		}

		/// Return a copy of this cell style changing the specified attribute values
		func copy(
			fillStyle: DSFSparkline.ValueBasedFill? = nil,
			borderColor: CGColor? = nil,
			borderWidth: CGFloat? = nil,
			cellDimension: CGFloat? = nil,
			cellSpacing: CGFloat? = nil
		) -> CellStyle {
			let fs = fillStyle ?? self.fillStyle
			let bc = borderColor ?? self.borderColor
			let bw = borderWidth ?? self.borderWidth
			let cd = cellDimension ?? self.cellDimension
			let cs = cellSpacing ?? self.cellSpacing

			return CellStyle(
				fillStyle: fs,
				borderColor: bc,
				borderWidth: bw,
				cellDimension: cd,
				cellSpacing: cs
			)
		}
	}
}
