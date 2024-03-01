//
//  PresentationTests.swift
//  
//
//  Created by Darren Ford on 27/2/2024.
//

import XCTest
@testable import DSFSparkline
import SwiftImageReadWrite

class ImageOutput {

	let _imagesFolder: TestFilesContainer.Subfolder

	init(_ folder: TestFilesContainer.Subfolder) {
		_imagesFolder = folder
	}

	func store(_ data: Data, filename: String) throws -> String {
		try _imagesFolder.write(data, to: filename)
		return "./images/\(filename)"
	}

	func store(_ string: String, filename: String) throws -> String {
		try _imagesFolder.write(string, to: filename)
		return "./images/\(filename)"
	}
}

private let outputFolder = try! testResultsContainer.subfolder(with: "generation")
private let imagesFolder = try! outputFolder.subfolder(with: "images")
private let imageStore = ImageOutput(imagesFolder)
private var markdownText = "# Sparklines\n\n"

final class PresentationTests: XCTestCase {

	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}

	override class func tearDown() {
		try! outputFolder.write(markdownText, to: "sparklines.md", encoding: .utf8)
	}
}

let primaryPoke = DSFSparkline.Fill.Color(srgbRed: 0.934, green: 0.000, blue: 0.000, alpha: 1.0)


let baseColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.033,  0.277, 0.650, 1.000])!
let primaryStroke = baseColor // (gray: 0.0, alpha: 0.3))
let primaryFill = DSFSparkline.Fill.Color(baseColor.copy(alpha: 0.3)!)


extension PresentationTests {
	func testActivityGrid() throws {
		markdownText += "## Activity Grid\n\n"

		do {
			markdownText += "### Inline documentation\n\n"

			let surface = DSFSparklineSurface.Bitmap()
			let grid = DSFSparklineOverlay.ActivityGrid()
			grid.dataSource = DSFSparkline.StaticDataSource((0 ... 1000).map { _ in CGFloat.random(in: 0 ... 1) }, range: 0 ... 1)
			grid.verticalCellCount = 3
			grid.cellStyle = .init(
				fillScheme: DSFSparkline.ActivityGrid.CellStyle.DefaultLight,
				borderColor: .black,
				borderWidth: 0.5,
				cellDimension: 5,
				cellSpacing: 0.5,
				cornerRadius: 1
			)
			surface.addOverlay(grid)

			let bitmap = surface.image(width: 150, height: 17, scale: 2)!
			// Generate an image with retina scale
			let filename = "activity-grid-mini.png"
			let link = try imageStore.store(bitmap.representation.png(scale: 2), filename: filename)
			markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"150\" /></a>\n"
		}

		markdownText += "\n"

		do {
			let bitmap = DSFSparklineSurface.Bitmap()          // Create a bitmap surface
			let activity = DSFSparklineOverlay.ActivityGrid()
			let data: [CGFloat] = (0 ... 100).map { _ in CGFloat.random(in: 0...100) }
			activity.dataSource = .init(data)

			bitmap.addOverlay(activity)                       // And add the overlay to the surface.

			// Generate an image with retina scale
			let image = bitmap.image(width: 300, height: 100, scale: 2)!
			let filename = "activity-basic-1.png"
			let link = try imageStore.store(image.representation.png(scale: 2), filename: filename)
			markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"300\" /></a>\n"

			activity.verticalCellCount = 10
			activity.cellDimension = 6
			activity.cellSpacing = 1
			activity.cellFillScheme = DSFSparkline.ActivityGrid.CellStyle.DefaultLight
			let image2 = bitmap.image(width: 300, height: 100, scale: 2)!
			let filename2 = "activity-basic-2.png"
			let link2 = try imageStore.store(image2.representation.png(scale: 2), filename: filename2)
			markdownText += "<a href=\"\(link2)\"><img src=\"\(link2)\" width=\"300\" /></a>\n"
		}
	}
}
