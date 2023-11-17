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


import Foundation
import CoreGraphics

public extension DSFSparkline {

	/// A simple data source containing an array of values.
	@objc(DSFSparklineStaticDataSource) class StaticDataSource: NSObject {
		@objc let values: [CGFloat]

		/// The total of all the values within the datasource
		@objc public let total: CGFloat

		/// The allowable range of values for this source
		public let valueBounds: ClosedRange<CGFloat>?

		/// Create an empty data source
		@objc convenience public override init() {
			self.init([])
		}

		@objc public init(_ values: [CGFloat]) {
			self.values = values
			self.total = values.reduce(0) { $0 + $1 }
			self.valueBounds = nil
			super.init()
		}

		/// Create a static data source with values and upper/lower bounds values
		/// - Parameters:
		///   - values: The values to be displayed
		///   - lowerBound: The lower bounds of the data
		///   - upperBound: The upper bounds of the data
		@objc convenience public init(_ values: [CGFloat], lowerBound: CGFloat, upperBound: CGFloat) {
			self.init(values, range: lowerBound ... upperBound)
		}

		/// Create a static data source with values and upper/lower bounds values
		/// - Parameters:
		///   - values: The values to be displayed
		///   - range: The allowable range for each value
		public init(_ values: [CGFloat], range: ClosedRange<CGFloat>) {
			self.values = values.map { $0.clamped(to: range) }
			self.total = values.reduce(0) { $0 + $1 }
			self.valueBounds = range
			super.init()
		}

		/// Return the fractional (0 ... 1) value for the specified value
		/// - Parameter value: The value to convert to a fractional value within the range of the datasource
		/// - Returns: A fractional value
		@objc public func fractionalValue(for value: CGFloat) -> CGFloat {
			if let r = valueBounds {
				let v = value.clamped(to: r)
				return (v - r.lowerBound) / (r.upperBound - r.lowerBound)
			}
			else {
				return (value - self.min) / (self.max - self.min)
			}
		}

		/// Return the fractional (0 ... 1) value for the specified value
		/// - Parameter index: The indexed offset of the datasource to retrieve the fractional value for
		/// - Returns: The fractional value, or -1 if index is out of bounds
		public func fractionalValue(at index: Int) -> CGFloat? {
			guard index < self.values.count else { return nil }
			let valueAtIndex = self.values[index]
			if let r = valueBounds {
				return (valueAtIndex - r.lowerBound) / (r.upperBound - r.lowerBound)
			}
			else {
				return (valueAtIndex - self.min) / (self.max - self.min)
			}
		}

		/// The minimum value in the datasource
		@objc public private(set) lazy var min: CGFloat = { self.values.min() ?? 0 }()
		/// The maximum value in the datasource
		@objc public private(set) lazy var max: CGFloat = { self.values.max() ?? 0 }()
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
