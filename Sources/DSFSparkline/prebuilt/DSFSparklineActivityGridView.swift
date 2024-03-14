//
//  DSFSparklineActivityGridView.swift
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

@objc public class DSFSparklineActivityGridView: DSFSparklineSurfaceView {
	/// The view's data source
	@objc public var dataSource: DSFSparkline.StaticDataSource {
		get { self.activityLayer.dataSource }
		set {
			self.activityLayer.dataSource = newValue
			self.setNeedsDisplay()
		}
	}

	/// Set the values for the data source
	/// - Parameters:
	///   - values: The values
	@objc public func setValues(_ values: [CGFloat]) {
		self.dataSource = DSFSparkline.StaticDataSource(values)
	}

	/// Set the values and supported range for the data source
	/// - Parameters:
	///   - values: The values
	///   - range: The acceptable range for the input data
	public func setValues(_ values: [CGFloat], range: ClosedRange<CGFloat>) {
		self.dataSource = DSFSparkline.StaticDataSource(values, range: range)
	}

	/// Set the values and supported range for the data source
	/// - Parameters:
	///   - values: The values
	///   - lowerBound: The acceptable lower bounds for the input data
	///   - upperBound: The acceptable upper bounds for the input data
	@objc public func setValues(_ values: [CGFloat], lowerBound: CGFloat, upperBound: CGFloat) {
		self.activityLayer.dataSource = DSFSparkline.StaticDataSource(
			values,
			lowerBound: lowerBound,
			upperBound: upperBound
		)
	}

	/// The layout style for the grid
	@objc public var cellStyle: DSFSparkline.ActivityGrid.CellStyle {
		get { self.activityLayer.cellStyle }
		set { self.activityLayer.cellStyle = newValue }
	}

	/// The layout style for the grid
	@objc public var layoutStyle: DSFSparkline.ActivityGrid.LayoutStyle {
		get { self.activityLayer.layoutStyle }
		set { self.activityLayer.layoutStyle = newValue }
	}

	/// The number of vertical cells in a column
	@objc public var verticalCellCount: UInt {
		get { UInt(self.activityLayer.verticalCellCount) }
		set { self.activityLayer.verticalCellCount = Int(newValue) }
	}

	/// The number of horizontal cells in a column.
	@objc public var horizontalCellCount: UInt {
		get { UInt(self.activityLayer.horizontalCellCount) }
		set { self.activityLayer.horizontalCellCount = Int(newValue) }
	}

	/// The color scheme to use when filling cells
	@objc public var cellFillScheme: DSFSparkline.ValueBasedFill {
		get { self.activityLayer.cellFillScheme }
		set { self.activityLayer.cellFillScheme = newValue }
	}

	/// The dimension of each cell
	@objc public var cellDimension: CGFloat {
		get { self.activityLayer.cellDimension }
		set { self.activityLayer.cellDimension = newValue }
	}

	/// The spacing between each of the cells
	@objc public var cellSpacing: CGFloat {
		get { self.activityLayer.cellSpacing }
		set { self.activityLayer.cellSpacing = newValue }
	}

	/// The border color for each individual cell
	@objc public var cellBorderColor: DSFColor? {
		get {
			if let c = self.activityLayer.borderColor { return DSFColor(cgColor: c) }
			return nil
		}
		set { self.activityLayer.cellBorderColor = newValue?.cgColor }
	}

	/// The cell's border width
	@objc public var cellBorderWidth: CGFloat {
		get { self.activityLayer.borderWidth }
		set { self.activityLayer.borderWidth = newValue }
	}

	/// The cell's corner radius
	@objc public var cellCornerRadius: CGFloat {
		get { self.activityLayer.cellCornerRadius }
		set { self.activityLayer.cellCornerRadius = newValue }
	}

	/// A block called to retrieve the tooltip text for a specific cell index
	@objc public var cellTooltipString: ((Int) -> String?)? {
		didSet {
			self.cellsDidUpdate()
		}
	}

	/// Initializer
	public override init(frame: CGRect) {
		super.init(frame: frame)
		self.configure()
	}

	/// Initializer
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.configure()
	}

	func configure() {
		self.addOverlay(self.activityLayer)
		self.activityLayer.cellsDidUpdateBlock = cellsDidUpdate

		#if os(macOS)
		self.updateTooltips()
		#endif
	}

	public override var intrinsicContentSize: CGSize { self.activityLayer.intrinsicSize }

	#if os(macOS)
	public override func layout() {
		super.layout()
		self.activityLayer.frame = self.bounds
		self.updateTooltips()
	}
	#else
	public override func layoutSubviews() {
		super.layoutSubviews()
		self.activityLayer.frame = self.bounds
	}
	#endif

	// private
	internal let activityLayer = DSFSparklineOverlay.ActivityGrid()

	#if os(macOS)
	private var tooltipTags: [NSView.ToolTipTag] = []
	#endif
}

internal extension DSFSparklineActivityGridView {
	// Called when the activity grid layer updates
	func cellsDidUpdate() {
		#if os(macOS)
		if let _ = self.cellTooltipString, self.tooltipTags.count == 0 {
			self.updateTooltips()
		}
		#endif
	}
}

#if os(macOS)

extension DSFSparklineActivityGridView: NSViewToolTipOwner {

	func updateTooltips() {
		guard let _ = self.cellTooltipString else { return }

		if !Thread.isMainThread {
			// Must be called on the main thread
			DispatchQueue.main.async { [weak self] in self?.updateTooltips() }
			return
		}

		self.tooltipTags.forEach { self.removeToolTip($0) }
		self.tooltipTags.removeAll()
		
		self.activityLayer.cells.enumerated().forEach { item in
			let t = self.addToolTip(item.element, owner: self, userData: nil)
			self.tooltipTags.append(t)
		}
	}

	public func view(_ view: NSView, stringForToolTip tag: NSView.ToolTipTag, point: NSPoint, userData data: UnsafeMutableRawPointer?) -> String {
		assert(Thread.isMainThread)
		guard
			let block = self.cellTooltipString,
			let index = self.tooltipTags.firstIndex(where: { $0 == tag })
		else {
			return ""
		}
		return block(index) ?? ""
	}
}

#endif
