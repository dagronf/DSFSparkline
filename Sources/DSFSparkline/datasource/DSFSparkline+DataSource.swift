//
//  DSFSparkline+DataSource.swift
//  DSFSparklines
//
//  Created by Darren Ford on 26/2/21.
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

import Foundation
import CoreGraphics

public extension DSFSparkline {

	/// A datasource for a sparkline
	@objc(DSFSparklineDataSource) class DataSource: NSObject {

		public static let DefaultWindowSize: UInt = 10

		/// Notification sent when the content of the data source changes
		@objc(DSFSparklineDataSourceDataChangedNotification)
		static let DataChangedNotification = NSNotification.Name("DSFSparklineDataSource.DataChanged")

		private let sparkline: SparklineWindow<CGFloat>

		@objc public override init() {
			self.sparkline = SparklineWindow<CGFloat>(windowSize: DataSource.DefaultWindowSize)
			super.init()
		}


		/// Create a data source
		/// - Parameters:
		///   - windowSize: The size of the window to use
		///   - range: (optional) the clamped y-range of data to display. Values outside this range are clamped
		///   - zeroLineValue: the zero-line value for the source. Defaults to zero (0)
		public init(windowSize: UInt = DataSource.DefaultWindowSize,
						range: ClosedRange<CGFloat>? = nil,
						zeroLineValue: CGFloat = 0) {
			self.sparkline = SparklineWindow<CGFloat>(windowSize: windowSize)
			self.sparkline.yRange = range
			self.sparkline.zeroLineValue = zeroLineValue

			super.init()
		}

		/// Create a datasource from a series of values
		/// - Parameters:
		///   - values: The values to initially assign to the datasource
		///   - range: (optional) The maximum range to represent.
		public convenience init(values: [CGFloat], range: ClosedRange<CGFloat>? = nil) {
			self.init(windowSize: UInt(values.count), range: range)
			self.set(values: values)
		}
	}
}

public extension DSFSparkline.DataSource {
	override var description: String {
		"""
		DataSource: windowSize: \(sparkline.windowSize), zeroLine: \(sparkline.zeroLineValue), range: \(String(describing: sparkline.yRange)), emptyCount: \(sparkline.emptyValueCount))
			data: \(sparkline.raw)
			norm: \(sparkline.normalized)
		"""
	}
}

// MARK: - Value handling

public extension DSFSparkline.DataSource {

	/// The series of data points with the most recent being the last array entry
	@objc var data: [CGFloat] {
		self.sparkline.raw
	}

	/// Return the raw values in the data source scaled from 0.0 -> 1.0
	@objc var normalized: [CGFloat] {
		self.sparkline.normalized
	}

	/// The number of data points to display in the sparkline
	@objc var windowSize: UInt {
		get {
			self.sparkline.windowSize
		}
		set {
			self.sparkline.windowSize = newValue
			self.notifyDataChange()
		}
	}

	/// The number of unfilled buckets in the sparkline
	@objc var emptyValueCount: UInt {
		return self.sparkline.emptyValueCount
	}

	/// The 'zero' line for drawing the horizontal line. Should be in the range lowerBound ..< upperBound
	@objc var zeroLineValue: CGFloat {
		get {
			self.sparkline.zeroLineValue
		}
		set {
			self.sparkline.zeroLineValue = newValue
			self.notifyDataChange()
		}
	}

	// Is the value at the specified offset in the data source BELOW the zero-line value?
	@inlinable func valueAtOffsetIsBelowZeroline(_ offset: Int) -> Bool {
		return self.data[offset] < self.zeroLineValue
	}
}


public extension DSFSparkline.DataSource {
	
	/// Add a new value. If there are more values than the window size, the oldest value is discarded
	@discardableResult
	@objc func push(value: CGFloat) -> Bool {
		defer {
			self.notifyDataChange()
		}
		return self.sparkline.push(value: value)
	}

	/// Add a vector of new values. Equivalent to push(values[0]), push(values[1]), push(values[2]) etc.
	@objc func push(values: [CGFloat]) {
		self.sparkline.push(values: values)
		self.notifyDataChange()
	}

	/// Set the sparkline data to the specified values. The window size is changed to reflect the extent of the input data
	@objc func set(values: [CGFloat]) {
		self.sparkline.set(values: values)
		self.notifyDataChange()
	}

	/// Reset the data to the lower bound for all data points in the window
	@objc func reset() {
		self.sparkline.reset()
		self.notifyDataChange()
	}
}

// MARK: - Range support (Swift)

public extension DSFSparkline.DataSource {

	/// The current minimum/maximum range for the values, or nil if there is no range specified
	var range: ClosedRange<CGFloat>? {
		get {
			self.sparkline.yRange
		}
		set {
			self.sparkline.yRange = newValue
			self.notifyDataChange()
		}
	}
}

// MARK: - Range support (Objc)

public extension DSFSparkline.DataSource {

	/// Returns the lower bound for the current set of values.  If no values are present, returns CGFloat.greatestFiniteMagnitude
	@objc var lowerBound: CGFloat {
		return self.sparkline.yRange?.lowerBound ?? CGFloat.greatestFiniteMagnitude
	}

	/// Returns the upper bound for the current set of values.  If no values are present, returns CGFloat.greatestFiniteMagnitude
	@objc var upperBound: CGFloat {
		return self.sparkline.yRange?.upperBound ?? CGFloat.greatestFiniteMagnitude
	}

	/// Set a range using discrete upper and lower bounds
	@objc func setRange(lowerBound: CGFloat, upperBound: CGFloat) {
		assert(lowerBound < upperBound)
		self.sparkline.yRange = lowerBound ... upperBound
		self.notifyDataChange()
	}

	/// Set a range using discrete upper and lower bounds, drawing a line at the 'zero' point within the range
	@objc func setRange(lowerBound: CGFloat, upperBound: CGFloat, zeroLinePoint: CGFloat) {
		assert(lowerBound <= zeroLinePoint && zeroLinePoint <= upperBound)
		self.sparkline.yRange = lowerBound ... upperBound
		self.sparkline.zeroLineValue = zeroLinePoint
		self.notifyDataChange()
	}

	/// Remove the range restrictions for the data source
	@objc func resetRange() {
		self.range = nil
		self.notifyDataChange()
	}
}

// MARK: - Internal

extension DSFSparkline.DataSource {

	/// The number of items added since last reset
	var counter: UInt {
		return self.sparkline.counter
	}

	// Normalize the specified value within 0.0 ... 1.0 for the current data
	func normalize(value: CGFloat) -> CGFloat {
		return self.sparkline.normalize(value: value)
	}

	// Normalize the zero-line value within 0.0 ... 1.0 for the current data
	var normalizedZeroLineValue: CGFloat {
		return self.normalize(value: self.zeroLineValue)
	}

	fileprivate func notifyDataChange() {
		NotificationCenter.default.post(name: DSFSparkline.DataSource.DataChangedNotification, object: self)
	}
}

public extension DSFSparkline.DataSource {

	/// Return the vertical fractional position within the data window that represents
	/// zero for the current set of data.
	func fractionalZeroPosition() -> CGFloat {
		return fractionalPosition(for: 0.0)
	}

	/// Return the vertical fractional position within the data window that represents
	/// the zero line value for the current set of data.
	func fractionalPosition(for value: CGFloat) -> CGFloat {
		let result: CGFloat
		if let r = self.range {
			// If a fixed range is specified, calculate the zero line from the specified range
			let full = r.upperBound - r.lowerBound		// full range width
			result = abs(value - r.lowerBound) / full
		}
		else {
			// If no fixed range is specified, calculate the zero line position using the current range of the data.
			result = self.normalize(value: value)
		}

		// Clamp to 0.0 -> 1.0
		return min(max(result, 0.0), 1.0)
	}
}

// In order to clean up some of the code, I've moved the declaration of the data source into a
// DSFSparkline 'namespace' to match with the new DSFSparkline.StaticDataSource type
//
// A simple name change (DSFSparklineDataSource -> DSFSparkline.DataSource) in your code will fix this issue
@available(*, deprecated, message: "Move to using DSFSparkline.DataSource instead (simple name change)")
public typealias DSFSparklineDataSource = DSFSparkline.DataSource
