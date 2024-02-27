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

let outputFolder = try! testResultsContainer.subfolder(with: "generation")
private let imagesFolder = try! outputFolder.subfolder(with: "images")
private let imageStore = ImageOutput(imagesFolder)

var markdownText = "# Sparklines\n\n"

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

			let bitmap = surface.image(width: 150, height: 30, scale: 2)!
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


	func testCircularProgress() throws {

		do {
			markdownText += "## Circular Progress\n\n"

			markdownText += "### Inline documentation\n\n"

			try stride(from: 0, through: 1, by: 0.333).forEach { value in
				let b1 = DSFSparklineSurface.Bitmap()
				let a1 = DSFSparklineOverlay.CircularProgress()
				a1.fillStyle = primaryPoke
				a1.trackColor = primaryPoke.color.copy(alpha: 0.3)!
				a1.trackWidth = 3
				a1.value = value
				b1.addOverlay(a1)
				let image = try XCTUnwrap(b1.cgImage(size: CGSize(width: 16, height: 16), scale: 2))
				let filename = "circular-poke-\(value).png"
				let link = try imageStore.store(image.representation.png(scale: 2), filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"16\" /></a>\n"
			}

			markdownText += "\n"

			do {

				markdownText += "### Flat\n\n"

				var count = 1

				try stride(from: 0, through: 2, by: 0.2).forEach { value in
					let b1 = DSFSparklineSurface.Bitmap()
					let a1 = DSFSparklineOverlay.CircularProgress()
					a1.fillStyle = DSFSparkline.Fill.Color(srgbRed: 0.5, green: 0, blue: 1, alpha: 1)
					a1.trackColor = CGColor(srgbRed: 0.5, green: 0, blue: 1, alpha: 0.2)
					a1.value = value
					b1.addOverlay(a1)
					let image = try XCTUnwrap(b1.cgImage(size: CGSize(width: 48, height: 48), scale: 2))
					let filename = "circular-\(count).png"
					let link = try imageStore.store(image.representation.png(scale: 2), filename: filename)
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"32\" /></a>\n"
					count += 1
				}
			}

			markdownText += "\n"

			do {
				markdownText += "### Gradient\n\n"

				let gradient = DSFSparkline.Fill.Gradient(
					colors: [
						CGColor(srgbRed: 0.977, green: 0.221, blue: 0.520, alpha: 1.0),
						CGColor(srgbRed: 0.891, green: 0.000, blue: 0.090, alpha: 1.0),
					]
				)

				var count = 1
				try stride(from: 0, through: 2, by: 0.2).forEach { value in
					let b1 = DSFSparklineSurface.Bitmap()
					let a1 = DSFSparklineOverlay.CircularProgress()
					a1.fillStyle = gradient
					a1.trackColor = CGColor(gray: 0.5, alpha: 0.2)
					a1.value = value
					b1.addOverlay(a1)
					let image = try XCTUnwrap(b1.cgImage(size: CGSize(width: 48, height: 48), scale: 2))
					let filename = "circular-radial-\(count).png"
					let link = try imageStore.store(image.representation.png(scale: 2), filename: filename)
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"32\" /></a>\n"
					count += 1
				}
			}

			markdownText += "\n"

			do {
				markdownText += "### Nested\n\n"

				try [48, 64, 80].forEach { dimension in

					var count = 1
					try stride(from: 0, through: 1, by: 0.2).forEach { value in
						let b1 = DSFSparklineSurface.Bitmap()
						let a1 = DSFSparklineOverlay.CircularProgress()
						a1.fillStyle = DSFSparkline.Fill.Color(srgbRed: 1, green: 0, blue: 0, alpha: 1)
						a1.trackColor = CGColor(gray: 0.5, alpha: 0.2)
						a1.value = value
						a1.trackWidth = 5
						b1.addOverlay(a1)

						let a2 = DSFSparklineOverlay.CircularProgress()
						a2.fillStyle = DSFSparkline.Fill.Color(srgbRed: 0, green: 0, blue: 1, alpha: 1)
						a2.trackColor = CGColor(gray: 0.5, alpha: 0.2)
						a2.trackWidth = 5
						a2.padding = 7
						a2.value = min(value + 0.1, 1.0)
						b1.addOverlay(a2)

						let a3 = DSFSparklineOverlay.CircularProgress()
						a3.fillStyle = DSFSparkline.Fill.Color(srgbRed: 0, green: 1, blue: 0, alpha: 1)
						a3.trackColor = CGColor(gray: 0.5, alpha: 0.2)
						a3.trackWidth = 5
						a3.padding = 14
						a3.value = min(value + 0.05, 1.0)
						b1.addOverlay(a3)

						let image = try XCTUnwrap(b1.cgImage(size: CGSize(width: dimension, height: dimension), scale: 2))
						let filename = "circular-radial-2overlay\(count)-\(dimension).png"
						let link = try imageStore.store(image.representation.png(scale: 2), filename: filename)
						markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"\(dimension / 2)\" /></a>\n"
						count += 1
					}

					markdownText += "\n"
				}
			}

			markdownText += "\n"

			do {
				markdownText += "### Track width\n\n"

				try stride(from: 2, through: 12, by: 2).forEach { width in

					let b1 = DSFSparklineSurface.Bitmap()
					let a1 = DSFSparklineOverlay.CircularProgress()
					a1.fillStyle = DSFSparkline.Fill.Color(srgbRed: 1, green: 0, blue: 0, alpha: 1)
					a1.trackColor = CGColor(gray: 0.5, alpha: 0.2)
					a1.value = 0.65
					a1.trackWidth = CGFloat(width)
					b1.addOverlay(a1)

					let a2 = DSFSparklineOverlay.CircularProgress()
					a2.fillStyle = DSFSparkline.Fill.Color(srgbRed: 0, green: 0, blue: 1, alpha: 1)
					a2.trackColor = CGColor(gray: 0.5, alpha: 0.2)
					a2.trackWidth = width
					a2.padding = 7
					a2.value = 0.25
					b1.addOverlay(a2)

					let image = try XCTUnwrap(b1.cgImage(size: CGSize(width: 48, height: 48), scale: 2))
					let filename = "circular-trackwidth-\(width).png"
					let link = try imageStore.store(image.representation.png(scale: 2), filename: filename)
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"48\" /></a>\n"
				}
			}

			markdownText += "\n"

			do {
				markdownText += "### Track padding\n\n"

				try stride(from: 0, through: 10, by: 2).forEach { padding in

					let b1 = DSFSparklineSurface.Bitmap()
					let a1 = DSFSparklineOverlay.CircularProgress()
					a1.fillStyle = DSFSparkline.Fill.Color(srgbRed: 1, green: 0, blue: 0, alpha: 1)
					a1.trackColor = CGColor(gray: 0.5, alpha: 0.2)
					a1.value = 0.65
					a1.trackWidth = 4
					b1.addOverlay(a1)

					let a2 = DSFSparklineOverlay.CircularProgress()
					a2.fillStyle = DSFSparkline.Fill.Color(srgbRed: 0, green: 0, blue: 1, alpha: 1)
					a2.trackColor = CGColor(gray: 0.5, alpha: 0.2)
					a2.trackWidth = 4
					a2.padding = padding
					a2.value = 0.25
					b1.addOverlay(a2)

					let image = try XCTUnwrap(b1.cgImage(size: CGSize(width: 48, height: 48), scale: 2))
					let filename = "circular-trackpadding-\(padding).png"
					let link = try imageStore.store(image.representation.png(scale: 2), filename: filename)
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"48\" /></a>\n"
				}
			}
		}
	}
}
