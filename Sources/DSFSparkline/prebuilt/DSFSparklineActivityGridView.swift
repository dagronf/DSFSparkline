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

@IBDesignable
public class DSFSparklineActivityGridView: DSFSparklineSurfaceView {

	/// The view's data source
	@objc public var dataSource: DSFSparkline.StaticDataSource {
		get { self.activityLayer.dataSource }
		set { self.activityLayer.dataSource = newValue }
	}

	/// Set the values for the data source
	/// - Parameters:
	///   - values: The values
	@objc public func setValues(_ values: [CGFloat]) {
		self.activityLayer.dataSource = DSFSparkline.StaticDataSource(values)
	}

	/// Set the values and supported range for the data source
	/// - Parameters:
	///   - values: The values
	///   - range: The acceptable range for the input data
	public func setValues(_ values: [CGFloat], range: ClosedRange<CGFloat>) {
		self.activityLayer.dataSource = DSFSparkline.StaticDataSource(values, range: range)
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
	@objc public var cellStyle: DSFSparklineOverlay.ActivityGrid.CellStyle {
		get { self.activityLayer.cellStyle }
		set { self.activityLayer.cellStyle = newValue }
	}

	/// The layout style for the grid
	@objc public var layoutStyle: DSFSparklineOverlay.ActivityGrid.LayoutStyle {
		get { self.activityLayer.layoutStyle }
		set { self.activityLayer.layoutStyle = newValue }
	}

	/// The color scheme to use when drawing the cells
	@objc public var colorScheme: DSFSparkline.ValueBasedFill {
		get { self.activityLayer.cellStyle.fillStyle }
		set { self.activityLayer.cellStyle = self.activityLayer.cellStyle.copy(fillStyle: newValue) }
	}

	/// The number of vertical cells in a column
	@objc public var verticalCellCount: UInt {
		get { UInt(self.activityLayer.verticalCellCount) }
		set { self.activityLayer.verticalCellCount = Int(newValue) }
	}

	/// The dimension of each cell
	@objc public var cellDimension: CGFloat {
		get { self.activityLayer.cellStyle.cellDimension }
		set { self.activityLayer.cellStyle = self.activityLayer.cellStyle.copy(cellDimension: newValue) }
	}

	/// The spacing between each of the cells
	@objc public var cellSpacing: CGFloat {
		get { self.activityLayer.cellStyle.cellSpacing }
		set { self.activityLayer.cellStyle = self.activityLayer.cellStyle.copy(cellSpacing: newValue) }
	}

	/// The border color for each individual cell
	@objc public var cellBorderColor: DSFColor? {
		get {
			guard let c = self.activityLayer.cellStyle.borderColor else { return nil }
			return DSFColor(cgColor: c)
		}
		set { self.activityLayer.cellStyle = self.activityLayer.cellStyle.copy(borderColor: newValue?.cgColor) }
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
	}

	#if os(macOS)
	public override func layout() {
		super.layout()
		self.activityLayer.frame = self.bounds
	}
	public override var intrinsicContentSize: NSSize {
		NSSize(width: NSView.noIntrinsicMetric, height: self.activityLayer.intrinsicHeight)
	}
	#else
	public override func layoutSubviews() {
		super.layoutSubviews()
		self.activityLayer.frame = self.bounds
	}
	public override var intrinsicContentSize: CGSize {
		CGSize(width: UIView.noIntrinsicMetric, height: self.activityLayer.intrinsicHeight)
	}
	#endif

	// private
	internal let activityLayer = DSFSparklineOverlay.ActivityGrid()
}
