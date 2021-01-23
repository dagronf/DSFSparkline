//
//  SparklineData.swift
//  DSFSparklines
//
//  Created by Darren Ford on 22/12/19.
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

class SparklineData<T> where T: BinaryFloatingPoint {

	var yRange: ClosedRange<T>? = nil {
		didSet {
			self.normalized = self.normalize()
		}
	}

	var yMin: T? { return self.yRange?.lowerBound ?? self.yData.min() }
	var yMax: T? { return self.yRange?.upperBound ?? self.yData.max() }

	var yData: [T] = [] {
		didSet {
			self.normalized = self.normalize()
		}
	}

	public private(set) var normalized: [T] = []

	init(range: ClosedRange<T>? = nil) {
		self.yRange = range
	}

	/// Return a normalized (scaled 0.0 -> 1.0) of the supplied value
	func normalize(value: T) -> T {
		guard let min = yMin, let max = self.yMax else {
			return 0.0
		}
		let diff = (max - min)
		if diff == 0 {
			return 0.0
		}

		return ((value - min) / diff)
	}

	/// Return a normalized (scaled 0.0 -> 1.0) of the current set of data
	private func normalize() -> [T] {

		guard let min = yMin, let max = self.yMax else {
			return []
		}

		// Move the data to 0.0 -> 1.0 scale
		let diff = (max - min)
		if diff == 0 {
			return Array<T>(repeating: 0.0, count: yData.count)
		}

		return yData.map { val in
			((val - min) / diff)
		}
	}
}
