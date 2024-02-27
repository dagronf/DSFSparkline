//
//  DSFSparklinesTests.swift
//  DSFSparklinesTests
//
//  Created by Darren Ford on 20/6/19.
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

import XCTest
@testable import DSFSparkline

// A temporary file container to hold results
internal let testResultsContainer = try! TestFilesContainer(named: "DSFSparkline_Tests")

class DSFSparklineTests: XCTestCase {

	override func setUp() {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}

	func testFixForWindowSizeSmallerThanInitialDataIssues() {

		// Testing for https://github.com/dagronf/DSFSparkline/issues/3

		let ds = SparklineWindow<CGFloat>(windowSize: 5, dataRange: (-10 ... 10))

		ds.push(values: [-5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5])
		XCTAssertEqual(ds.raw.count, 5)
	}

	func testBlah() {

		let dd = SparklineWindow<CGFloat>(windowSize: 10, dataRange: (-100 ... 100))

		// Default values for the initializer
		XCTAssertEqual(dd.raw.count, 10)
		XCTAssertEqual(dd.normalized.count, 10)

		XCTAssertEqual(dd.raw, [-100, -100, -100, -100, -100, -100, -100, -100, -100, -100])
		XCTAssertEqual(dd.normalized, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0])

		XCTAssertTrue(dd.push(value: 0))
		XCTAssertTrue(dd.push(value: 1))

		XCTAssertEqual(dd.raw.count, 10)
		XCTAssertEqual(dd.normalized.count, 10)

		XCTAssertEqual(dd.normalized, [0, 0, 0, 0, 0, 0, 0, 0, 0.5, 0.505])
		XCTAssertTrue(dd.push(value: 100))
	}

	func testDynamicallyRanged() {
		let dd = SparklineWindow<CGFloat>(windowSize: 10)

		// Default values for the initializer
		XCTAssertEqual(dd.raw.count, 10)
		XCTAssertEqual(dd.normalized.count, 10)

		XCTAssertEqual(dd.raw, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
		XCTAssertEqual(dd.normalized, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0])

		XCTAssertTrue(dd.push(value: 10))
		XCTAssertEqual(dd.normalized, [0, 0, 0, 0, 0, 0, 0, 0, 0, 1])

		XCTAssertTrue(dd.push(value: 20))
		XCTAssertEqual(dd.normalized, [0, 0, 0, 0, 0, 0, 0, 0, 0.5, 1])

		XCTAssertTrue(dd.push(value: -20))
		XCTAssertEqual(dd.normalized, [0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.75, 1.0, 0.0])

		XCTAssertTrue(dd.push(value: -10))
		XCTAssertEqual(dd.normalized, [0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.75, 1.0, 0.0, 0.25])
	}

	func testResizing() {
		let dd = SparklineWindow<CGFloat>(windowSize: 10)
		XCTAssertEqual(dd.raw.count, 10)

		dd.set(values: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
		XCTAssertEqual(dd.normalized, [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0])

		dd.set(values: [-5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5])
		XCTAssertEqual(dd.normalized, [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0])

		/// Resizing
		dd.set(values: [-5, -4, -3, -2, -1, 0])
		XCTAssertEqual(dd.normalized, [0.0, 0.2, 0.4, 0.6, 0.8, 1.0])

		dd.set(values: [-5, -4, -3, -2, -1, 0, 1, 2])
		XCTAssertEqual(dd.normalized, [0.0, 0.14285714285714285, 0.2857142857142857, 0.42857142857142855,
									   0.5714285714285714, 0.7142857142857143, 0.8571428571428571, 1.0])

		dd.reset()
		dd.windowSize = 3
		XCTAssertEqual(0, dd.counter)
		XCTAssertTrue(dd.push(value: 1))
		XCTAssertEqual(dd.raw, [0.0, 0.0, 1.0])
		XCTAssertEqual(dd.normalized, [0.0, 0.0, 1.0])
		XCTAssertEqual(1, dd.counter)
		XCTAssertTrue(dd.push(value: 2))
		XCTAssertEqual(dd.raw, [0.0, 1.0, 2.0])
		XCTAssertEqual(dd.normalized, [0.0, 0.5, 1.0])
		XCTAssertEqual(2, dd.counter)
		XCTAssertTrue(dd.push(value: 3))
		XCTAssertEqual(dd.raw, [1.0, 2.0, 3.0])
		XCTAssertEqual(dd.normalized, [0.0, 0.5, 1.0])
		XCTAssertEqual(3, dd.counter)
		XCTAssertTrue(dd.push(value: 4))
		XCTAssertEqual(dd.raw, [2.0, 3.0, 4.0])
		XCTAssertEqual(dd.normalized, [0.0, 0.5, 1.0])
		XCTAssertEqual(4, dd.counter)
	}

	func testWindowSizeChanging() {
		let dd = SparklineWindow<CGFloat>(windowSize: 20)
		dd.set(values: [1.0, 2.0, 3.0, 4.0])

		dd.windowSize = 7
		XCTAssertEqual([0.0, 0.0, 0.0, 1.0, 2.0, 3.0, 4.0], dd.raw)

		dd.windowSize = 3
		XCTAssertEqual([2.0, 3.0, 4.0], dd.raw)
	}

	func testDataSource() {

		// Check that truncating to range works
		let ds = DSFSparkline.DataSource(windowSize: 10, range: -10 ... 10)
		XCTAssertTrue(ds.push(value: 5))
		XCTAssertTrue(ds.push(value: 50))
		XCTAssertEqual(ds.data, [0, 0, 0, 0, 0, 0, 0, 0, 5, 10])
		XCTAssertEqual(ds.normalized, [0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.75, 1.0])

		// With no range, adding 5 here makes the implicit range to 0 ... 5
		let ds2 = DSFSparkline.DataSource(windowSize: 5)
		XCTAssertTrue(ds2.push(value: 5))
		XCTAssertEqual(ds2.data, [0, 0, 0, 0, 5])
		XCTAssertEqual(ds2.normalized, [0, 0, 0, 0, 1])

		// With no range, adding -5 here makes the implicit range to -5 ... 5
		XCTAssertTrue(ds2.push(value: -5))
		XCTAssertEqual(ds2.data, [0, 0, 0, 5, -5])
		XCTAssertEqual(ds2.normalized, [0.5, 0.5, 0.5, 1, 0])

		// With no range, adding -5 here makes the implicit range to -5 ... 5
		XCTAssertTrue(ds2.push(value: 10))
		XCTAssertTrue(ds2.push(value: -3))
		XCTAssertEqual(ds2.data, [0, 5, -5, 10, -3])
		XCTAssertEqual(ds2.normalized, [0.3333333333333333, 0.6666666666666666, 0.0, 1.0, 0.13333333333333333])

		ds2.windowSize = 3
		XCTAssertEqual(ds2.data, [-5, 10, -3])
		XCTAssertEqual(ds2.normalized, [0.0, 1.0, 0.13333333333333333])

		ds2.windowSize = 10
		XCTAssertEqual(ds2.data, [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -5.0, 10.0, -3.0])
		XCTAssertEqual(ds2.normalized,
							[0.3333333333333333, 0.3333333333333333, 0.3333333333333333, 0.3333333333333333, 0.3333333333333333,
							 0.3333333333333333, 0.3333333333333333, 0.0, 1.0, 0.13333333333333333])

		ds2.reset()
		XCTAssertEqual(ds2.data, [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0])

		ds2.set(values: [0, 1, 2, 3, 4, 5, 6])
		XCTAssertEqual(7, ds2.windowSize)
		XCTAssertEqual(ds2.data, [0, 1, 2, 3, 4, 5, 6])
	}


	func testAddValues() {
		let ds = DSFSparkline.DataSource(windowSize: 5)
		ds.push(values: [1.1, 2.2, 3.3])
		XCTAssertEqual(ds.data, [0, 0, 1.1, 2.2, 3.3])
		XCTAssertTrue(ds.push(value: 1.2))
		XCTAssertEqual(ds.data, [0, 1.1, 2.2, 3.3, 1.2])

		ds.push(values: [10, 11, 12])
		XCTAssertEqual(ds.data, [3.3, 1.2, 10.0, 11.0, 12.0])

		// Check what happens if greater than window.  Should truncate to the last 5 values in the array
		// Equivalent to push 1, push 2, push 3, push 4 etc.
		ds.push(values: [1, 2, 3, 4, 5, 6, 7, 8])
		XCTAssertEqual(ds.data, [4, 5, 6, 7, 8])
	}

	func testCircularProgress() throws {

		let l1 = DSFSparklineOverlay.CircularProgress()
		l1.value = 1.8
		l1.trackWidth = 10

		let l2 = DSFSparklineOverlay.CircularProgress()
		l2.value = 1.4
		l2.trackWidth = 10
		l2.padding = 12
		l2.fillStyle = DSFSparkline.Fill.Gradient(colors: [
			CGColor.init(red: 1, green: 0, blue: 0, alpha: 1),
			CGColor.init(red: 0, green: 1, blue: 0, alpha: 1),
			CGColor.init(red: 0, green: 0, blue: 1, alpha: 1),
		])

		// Solid white
		let l3 = DSFSparklineOverlay.CircularProgress()
		l3.value = 0.35
		l3.trackWidth = 10
		l3.padding = 24
		l3.fillStyle = DSFSparkline.Fill.Gradient(colors: [
			CGColor.init(red: 1, green: 0, blue: 0, alpha: 1),
			CGColor.init(red: 0, green: 1, blue: 0, alpha: 1),
			CGColor.init(red: 0, green: 0, blue: 1, alpha: 1),
		])

		let bitmap = DSFSparklineSurface.Bitmap()   // Create a bitmap surface
		bitmap.addOverlay(l1)                    // And add the overlay to the surface.
		bitmap.addOverlay(l2)                    // And add the overlay to the surface.
		bitmap.addOverlay(l3)                    // And add the overlay to the surface.

		let image = bitmap.image(width: 100, height: 100, scale: 2)
		Swift.print(image)
	}

	func testGradientPeek() throws {

		let gr = CGGradient(
			colorsSpace: nil,
			colors: [
				CGColor(red: 1, green: 0, blue: 0, alpha: 1),
				CGColor(red: 0, green: 0, blue: 1, alpha: 1),
			] as CFArray,
			locations: [0.0, 1.0]
		)!

		let f1 = DSFSparkline.Fill.Gradient(gradient: gr)
		let c1 = f1.color(at: 0)
		let c2 = f1.color(at: 0.5)
		let c3 = f1.color(at: 1)
		
		Swift.print([c1, c2, c3])
	}
}
