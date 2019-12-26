//
//  SparklineData.swift
//  DSFSparklines
//
//  Created by Darren Ford on 22/12/19.
//  Copyright © 2019 Darren Ford. All rights reserved.
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
