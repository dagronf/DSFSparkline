//
//  DSFSparkline+StaticDataSource.swift
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

import CoreGraphics
import Foundation

public extension DSFSparkline {
	/// A simple data source containing an array of values.
	@objc(DSFSparklineStaticDataSource) class StaticDataSource: NSObject {
		/// The datasource values
		let values: [CGFloat]

		/// The minimum value in the data source, excluding .infinite values
		let minValue: CGFloat
		/// The maximum value in the data source, excluding .infinite values
		let maxValue: CGFloat

		/// The total of all the values within the datasource, excluding .infinite values
		@objc public let total: CGFloat

		/// The allowable range of values for this source. If nil, there are no bounds for the source
		public let valueBounds: ClosedRange<CGFloat>?

		/// Create an empty data source
		@objc override public convenience init() {
			self.init([])
		}

		/// Create a data source with the specified values
		/// - Parameter values: The datasource values
		@objc public init(_ values: [CGFloat]) {
			self.values = values
			self.valueBounds = nil

			let nonInfiniteValues = values.filter { !$0.isInfinite }
			self.minValue = nonInfiniteValues.min() ?? 0.0
			self.maxValue = nonInfiniteValues.max() ?? 1.0
			self.total = nonInfiniteValues.reduce(0) { $0 + $1 }

			super.init()
		}

		/// Create a static data source with values and upper/lower bounds values
		/// - Parameters:
		///   - values: The values to be displayed
		///   - lowerBound: The lower bounds of the data
		///   - upperBound: The upper bounds of the data
		@objc public convenience init(_ values: [CGFloat], lowerBound: CGFloat, upperBound: CGFloat) {
			assert(lowerBound < upperBound)
			self.init(values, range: lowerBound ... upperBound)
		}

		/// Create a static data source with values and upper/lower bounds values
		/// - Parameters:
		///   - values: The values to be displayed
		///   - range: The allowable range for each value
		public init(_ values: [CGFloat], range: ClosedRange<CGFloat>) {
			self.valueBounds = range

			let clampedValues = values.map { $0.isInfinite ? .infinity : $0.clamped(to: range) }
			self.values = clampedValues

			let nonInfiniteValues = clampedValues.filter { !$0.isInfinite }
			self.total = nonInfiniteValues.reduce(0) { $0 + $1 }
			self.minValue = nonInfiniteValues.min() ?? 0.0
			self.maxValue = nonInfiniteValues.max() ?? 1.0

			super.init()
		}

		/// Return the fractional (0 ... 1) value for the specified value, or .infinity if the value is infinite
		/// - Parameter value: The value to convert to a fractional value within the range of the datasource
		/// - Returns: A fractional value, or nil when value == .infinity
		@objc public func fractionalValue(for value: CGFloat) -> CGFloat {
			if value == .infinity { return .infinity }
			if let r = valueBounds {
				let v = value.clamped(to: r)
				return (v - r.lowerBound) / (r.upperBound - r.lowerBound)
			}
			else {
				return (value - self.minValue) / (self.maxValue - self.minValue)
			}
		}

		/// Return the fractional (0 ... 1) value for the specified value
		/// - Parameter index: The indexed offset of the datasource to retrieve the fractional value for
		/// - Returns:
		///    * If the index is outside the scope of the data source, returns `.nan`
		///    * If the value at the index is infinite, returns `.infinity`
		///    * If the value at the index is not infinite, returns the fractional value
		public func fractionalValue(at index: Int) -> CGFloat {
			guard index < self.values.count else { return .nan }
			return self.fractionalValue(for: self.values[index])
		}
	}
}

public extension DSFSparkline.StaticDataSource {
	override var description: String {
		"""
		StaticDataSource: count: \(values.count), totalValue: \(self.total)
			values: \(self.values)
		"""
	}
}
