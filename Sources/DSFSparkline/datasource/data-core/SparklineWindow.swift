//
//  SparklineWindow.swift
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

import Foundation

/// The sparkline 'window' represents the data window to be displayed in the graph
/// It is meant to represent the _data_ for the graph, not the way that the graph draws.
class SparklineWindow<T> where T: BinaryFloatingPoint {

	private let NormalizedRange: ClosedRange<T> = 0.0 ... 1.0
	private let data: SparklineData<T>

	/// Optional fixed range for the data being displayed
	public var yRange: ClosedRange<T>? {
		get {
			self.data.yRange
		}
		set {
			self.data.yRange = newValue
		}
	}

	/// The number of items added since last reset
	var counter: UInt = 0

	/// Raw values
	var raw: [T] { return self.data.yData }

	/// The normalized data (range 0.0 -> 1.0) depending on the range
	var normalized: [T] { return self.data.normalized }

	/// The size of the sparkline data window
	var windowSize: UInt {
		get {
			return UInt(self.data.yData.count)
		}
		set {
			let sz = self.data.yData.count
			if newValue > sz {
				let inserter = Array<T>(repeating: self.data.yRange?.lowerBound ?? 0.0, count: Int(newValue) - sz)
				self.data.yData.insert(contentsOf: inserter, at: 0)
			}
			else if newValue < sz {
				self.data.yData.removeSubrange(0 ..< sz - Int(newValue))
			}
		}
	}

	/// The number if of 'empty' buckets in the current window
	var emptyValueCount: UInt {
		if self.counter > self.windowSize {
			return 0
		}
		return self.windowSize - self.counter
	}

	/// The 'zero' line for drawing the horizontal line.
	var zeroLineValue: T = 0.0

	/// Create a sparkline data window with an optional data range
	/// - Parameters:
	///   - windowSize: The number of data points to be kept in the spark line
	///   - dataRange: The max/min values
	init(windowSize: UInt, dataRange: ClosedRange<T>? = nil) {
		assert(windowSize > 0)
		self.data = SparklineData<T>(range: dataRange)
		self.data.yData = Array<T>(repeating: dataRange?.lowerBound ?? 0.0, count: Int(windowSize))
	}

	/// Normalize a value to the current range of the sparkline
	/// - Parameter value: the value to normalize
	/// - Return a value 0.0 -> 1.0
	public func normalize(value: T) -> T {
		return self.data.normalize(value: value).clamped(to: NormalizedRange)
	}

	/// Push a new value into the sparkline. If the value is outside a specified range, then
	/// - Parameter value: The value to push into the sparkline
	/// - Return whether the
	@discardableResult
	public func push(value: T) -> Bool {
		let plotValue: T
		if let r = self.data.yRange, !r.contains(value) {
			plotValue = min(r.upperBound, max(r.lowerBound, value))
			Swift.print("WARN: Value \(value) outside specified range \(r), truncating to \(plotValue)")
		}
		else {
			plotValue = value
		}

		var temp = self.data.yData
		temp.removeFirst()
		temp.append(plotValue)
		self.data.yData = temp

		self.counter += 1

		return true
	}

	public func push(values: [T]) {

		self.counter += UInt(values.count)

		var temp = self.data.yData

		// The difference between
		let diff = temp.count - values.count
		if diff < 0 {
			// There are more data points than the window size
			temp = values
			temp.removeFirst(abs(diff))
		}
		else if diff == 0 {
			temp = values
		}
		else {
			temp.removeFirst(min(values.count, temp.count))
			temp.append(contentsOf: values)
		}
		self.data.yData = temp
	}

	public func set(values: [T]) {
		if let yRange = self.data.yRange {
			self.data.yData = values.map { $0.clamped(to: yRange) }
		}
		else {
			self.data.yData = values
		}
		self.counter = UInt(values.count)
	}

	public func reset() {
		self.counter = 0
		self.data.yData = Array<T>(repeating: self.data.yRange?.lowerBound ?? 0.0,
											count: Int(self.windowSize))
	}
}

