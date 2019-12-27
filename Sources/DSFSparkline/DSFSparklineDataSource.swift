//
//  DSFSparklineDataSource.swift
//  DSFSparklines
//
//  Created by Darren Ford on 21/12/19.
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

import CoreGraphics
import Foundation

@objc public class DSFSparklineDataSource: NSObject {

	@objc(DSFSparklineDataSourceDataChangedNotification)
	static let DataChangedNotification = NSNotification.Name("DSFSparklineDataSource.DataChanged")

	private let sparkline = SparklineWindow<CGFloat>(windowSize: 10)

	@objc public override init() {
		super.init()
	}

	public init(windowSize: UInt? = nil, range: ClosedRange<CGFloat>? = nil) {
		self.sparkline.yRange = range
		if let ws = windowSize {
			self.sparkline.windowSize = ws
		}
	}
}

// MARK: - Value handling

public extension DSFSparklineDataSource {

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

	/// Add a new value. If there are more values than the window size, the oldest value is discarded
	@objc func push(value: CGFloat) -> Bool {
		defer {
			self.notifyDataChange()
		}
		return self.sparkline.push(value: value)
	}

	/// Add a vector of new values. Equivalent to push(values[0]), push(values[1]), push(values[2]) etc.
	@objc func push(values: [CGFloat]) {
		defer {
			self.notifyDataChange()
		}
		self.sparkline.push(values: values)
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

public extension DSFSparklineDataSource {

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

public extension DSFSparklineDataSource {

	@objc var lowerBound: CGFloat {
		return self.sparkline.yRange?.lowerBound ?? CGFloat.greatestFiniteMagnitude
	}

	@objc var upperBound: CGFloat {
		return self.sparkline.yRange?.upperBound ?? CGFloat.greatestFiniteMagnitude
	}

	/// Set a range using discrete upper and lower bounds
	@objc func setRange(lowerBound: CGFloat, upperBound: CGFloat) {
		assert(lowerBound < upperBound)
		self.sparkline.yRange = lowerBound ... upperBound
		self.notifyDataChange()
	}

	/// Remove the range restrictions for the data source
	@objc func resetRange() {
		self.range = nil
		self.notifyDataChange()
	}
}

// MARK: - Internal

extension DSFSparklineDataSource {
	var counter: UInt {
		return self.sparkline.counter
	}

	func normalize(value: CGFloat) -> CGFloat {
		return self.sparkline.normalize(value: value)
	}

	fileprivate func notifyDataChange() {
		NotificationCenter.default.post(name: DSFSparklineDataSource.DataChangedNotification, object: self)
	}
}
