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

		@objc public override init() {
			self.values = []
			self.total = 0
			super.init()
		}

		@objc public init(_ values: [CGFloat]) {
			self.values = values
			self.total = values.reduce(0) { $0 + $1 }
			super.init()
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
