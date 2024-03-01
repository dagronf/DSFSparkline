//
//  LineGraphTests.swift
//
//
//  Created by Darren Ford on 1/3/2024.
//

import XCTest
@testable import DSFSparkline
import SwiftImageReadWrite

private let outputFolder = try! testResultsContainer.subfolder(with: "line-graph")
private let imagesFolder = try! outputFolder.subfolder(with: "images")
private let imageStore = ImageOutput(imagesFolder)
private var markdownText = "# Line Graph\n\n"

final class LineGraphTests: XCTestCase {

	override class func tearDown() {
		try! outputFolder.write(markdownText, to: "line-graph.md", encoding: .utf8)
	}

	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}

	func testBasic() throws {

		markdownText += "## Inline documentation\n\n"

		let source = DSFSparkline.DataSource(values: [4, 1, 8, 7, 5, 9, 3], range: 0 ... 10)

		try [0, 5].forEach { zeroline in

			source.zeroLineValue = zeroline

			markdownText += "| line | interpolated | line with markers | line with markers interpolated |\n"
			markdownText += "|------|------|------|------|\n"

			try [false, true].forEach { interpolated in

				markdownText += "|"

				let bitmap = DSFSparklineSurface.Bitmap()   // Create a bitmap surface
				let line = DSFSparklineOverlay.Line()       // Create a line overlay
				line.interpolated = interpolated
				line.strokeWidth = 1
				line.primaryStrokeColor = primaryStroke
				line.primaryFill = primaryFill
				line.dataSource = source
				bitmap.addOverlay(line)
				if zeroline != 0 {
					bitmap.addOverlay(DSFSparklineOverlay.ZeroLine(dataSource: source))
				}

				// Generate an image with retina scale
				let image = try XCTUnwrap(bitmap.cgImage(size: CGSize(width: 50, height: 25), scale: 2))
				let filename = "line-simple-small-interpolated(\(interpolated))-zeroline(\(zeroline)).png"
				let link = try imageStore.store(image.representation.png(scale: 2), filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" /></a>"
			}

			try [false, true].forEach { interpolated in

				markdownText += "|"

				let bitmap = DSFSparklineSurface.Bitmap()   // Create a bitmap surface
				let line = DSFSparklineOverlay.Line()       // Create a line overlay
				line.strokeWidth = 1
				line.primaryStrokeColor = primaryStroke
				line.primaryFill = primaryFill
				line.markerSize = 3
				line.interpolated = interpolated
				line.dataSource = source                    // Assign the datasource to the overlay
				bitmap.addOverlay(line)                     // And add the overlay to the surface.
				
				if zeroline != 0 {
					bitmap.addOverlay(DSFSparklineOverlay.ZeroLine(dataSource: source))
				}

				// Generate an image with retina scale
				let image3 = try XCTUnwrap(bitmap.cgImage(size: CGSize(width: 50, height: 25), scale: 2))
				let filename3 = "line-simple-attributed-string-inline-interpolated(\(interpolated))-zeroline(\(zeroline)).png"
				let link3 = try imageStore.store(image3.representation.png(scale: 2), filename: filename3)
				markdownText += "<a href=\"\(link3)\"><img src=\"\(link3)\" /></a>"
			}

			markdownText += "|\n\n"
		}
	}

}
