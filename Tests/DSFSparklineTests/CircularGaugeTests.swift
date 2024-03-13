//
//  CircularGaugeTests.swift
//
//
//  Created by Darren Ford on 12/3/2024.
//

import XCTest
@testable import DSFSparkline
import SwiftImageReadWrite

private let outputFolder = try! testResultsContainer.subfolder(with: "circular-gauge")
private let imagesFolder = try! outputFolder.subfolder(with: "images")
private let imageStore = ImageOutput(imagesFolder)
private var markdownText = "# Circular Gauge\n\n"

final class CircularGaugeTests: XCTestCase {

	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDownWithError() throws {
		try! outputFolder.write(markdownText, to: "circular-gauge.md", encoding: .utf8)
	}

	func testSizing() throws {
		markdownText += "## Sizing\n\n"

		try [16, 32, 48].forEach { sz in
			try stride(from: 0, through: 1, by: 0.1).forEach { value in
				let b1 = DSFSparklineSurface.Bitmap()
				let a1 = DSFSparklineOverlay.CircularGauge()
				a1.value = value
				b1.addOverlay(a1)
				let image = try XCTUnwrap(b1.cgImage(size: CGSize(width: sz, height: sz), scale: 2))
				let filename = "circular-gauge-ex-\(sz)-\(value).png"
				let link = try imageStore.store(image.representation.png(), filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"\(sz)\" /></a>\n"
			}
			markdownText += "\n"
		}
	}

	func testTrackInset() throws {
		markdownText += "## Track inset\n\n"

		let tfc = DSFSparklineOverlay.CircularGauge.TrackStyle(
			width: 10, 
			fillColor: DSFSparkline.Fill.Color(srgbRed: 0, green: 0, blue: 1, alpha: 0.1)
		)
		let vfc = DSFSparklineOverlay.CircularGauge.TrackStyle(
			width: 6,
			fillColor: DSFSparkline.Fill.Color(srgbRed: 0.2, green: 0.2, blue: 0.9),
			strokeColor: CGColor.sRGBA(0, 0, 1)
		)

		try [false, true].forEach { hasShadow in
			if hasShadow {
				markdownText += "### Shadowed\n\n"
			}
			else {
				markdownText += "### No Shadow\n\n"
			}
			try [10, 8, 6, 4].forEach { tw in
				try stride(from: 0, through: 1, by: 0.1).forEach { value in
					let b1 = DSFSparklineSurface.Bitmap()
					let a1 = DSFSparklineOverlay.CircularGauge()
					a1.value = value
					a1.trackStyle = tfc
					vfc.width = CGFloat(tw)
					a1.lineStyle = vfc

					if hasShadow {
						vfc.shadow = .init(blurRadius: 3, offset: CGSize(width: 2, height: -3), color: .black)
					}

					b1.addOverlay(a1)
					let image = try XCTUnwrap(b1.cgImage(size: CGSize(width: 48, height: 48), scale: 2))
					let filename = "circular-gauge-inset-\(hasShadow)-\(tw)-\(value).png"
					let link = try imageStore.store(image.representation.png(), filename: filename)
					markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"\(48)\" /></a>\n"
				}
				markdownText += "\n"
			}
		}
	}

	func testTrackShadow() throws {
		markdownText += "## Shadowing\n\n"

		markdownText += "\n### Track/Value shadows\n\n"

		markdownText += "| none    |  track only  |  value only  |  both   |\n"
		markdownText += "|---------|--------------|--------------|---------|\n"
		markdownText += "|"

		try [false, true].forEach { (lineShadow: Bool) in
			try [false, true].forEach { (trackShadow: Bool) in
				let b1 = DSFSparklineSurface.Bitmap()
				let a1 = DSFSparklineOverlay.CircularGauge()
				a1.value = 0.65

				a1.trackStyle.width = 10
				a1.lineStyle.width = 4

				if trackShadow {
					a1.trackStyle.shadow = .init(blurRadius: 2, offset: CGSize(width: 1, height: -1), color: CGColor.sRGBA(0, 0, 1))
				}
				if lineShadow {
					a1.lineStyle.shadow = .init(blurRadius: 2, offset: CGSize(width: 1, height: -1), color: CGColor.sRGBA(1, 0, 0))
				}

				b1.addOverlay(a1)
				let image = try XCTUnwrap(b1.cgImage(size: CGSize(width: 48, height: 48), scale: 2))
				let filename = "circular-gauge-inset-\(trackShadow)-\(lineShadow).png"
				let link = try imageStore.store(image.representation.png(), filename: filename)
				markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"\(48)\" /></a>|"
			}
		}

		markdownText += "|\n\n"

		markdownText += "### Shadow Offset\n\n"

		markdownText += "| -2, -2  |  -2, 2  |  2, -2  |  2, 2   |  4, 0  |  0, 4  |\n"
		markdownText += "|---------|---------|---------|---------|--------|--------|\n"
		markdownText += "|"

		try [(-2, -2), (-2, 2), (2, -2), (2, 2), (4, 0), (0, 4)].forEach { offset in
			let b1 = DSFSparklineSurface.Bitmap()
			let a1 = DSFSparklineOverlay.CircularGauge()

			let sh = DSFSparkline.Shadow(blurRadius: 3, offset: CGSize(width: offset.0, height: offset.1), color: .black)

			a1.value = 0.65
			a1.trackStyle.width = 20
			a1.trackStyle.shadow = sh

			a1.lineStyle.width = 10
			a1.lineStyle.fillColor = DSFSparkline.Fill.Color(srgbRed: 1, green: 1, blue: 0)
			a1.lineStyle.shadow = sh

			b1.addOverlay(a1)
			let image = try XCTUnwrap(b1.cgImage(size: CGSize(width: 64, height: 64), scale: 2))
			let filename = "circular-gauge-offset-standardshadow-\(offset).png"
			let link = try imageStore.store(image.representation.png(), filename: filename)
			markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"64\" /></a>"
			markdownText += "|"
		}
		markdownText += "|\n\n"
	}

	func testTrackShadowInset() throws {
		markdownText += "## Inner Shadows\n\n"

		let innerShadow = DSFSparkline.Shadow(blurRadius: 3, offset: CGSize(width: 2, height: -2), color: .black, isInner: true)
		let outerShadow = DSFSparkline.Shadow(blurRadius: 3, offset: CGSize(width: 2, height: -2), color: .black, isInner: false)

		markdownText += "\n### Track/Value shadows\n\n"

		markdownText += "| none  |  track only  |  value only  |  both   |  in/out |\n"
		markdownText += "|---------|---------|---------|---------|---------|\n"
		markdownText += "|"

		enum OTS: CaseIterable {
			case none
			case track
			case value
			case all
		}

		try OTS.allCases.forEach { useTrackInner in

			let b1 = DSFSparklineSurface.Bitmap()
			let a1 = DSFSparklineOverlay.CircularGauge()

			a1.value = 0.65
			a1.trackStyle.width = 20

			if useTrackInner == .track || useTrackInner == .all {
				a1.trackStyle.shadow = innerShadow
			}

			a1.lineStyle.width = 10
			a1.lineStyle.fillColor = DSFSparkline.Fill.Color(srgbRed: 1, green: 1, blue: 0)
			a1.lineStyle.strokeColor = CGColor.standard.yellow
			a1.lineStyle.strokeWidth = 0.1

			if useTrackInner == .value || useTrackInner == .all {
				a1.lineStyle.shadow = innerShadow
			}

			b1.addOverlay(a1)
			let image = try XCTUnwrap(b1.cgImage(size: CGSize(width: 64, height: 64), scale: 2))
			let filename = "circular-gauge-inner-\(useTrackInner).png"
			let link = try imageStore.store(image.representation.png(), filename: filename)
			markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"64\" /></a>|"
		}

		do {
			let b1 = DSFSparklineSurface.Bitmap()
			let a1 = DSFSparklineOverlay.CircularGauge()

			a1.value = 0.65
			a1.trackStyle.width = 20
			a1.trackStyle.shadow = innerShadow

			a1.lineStyle.width = 10
			a1.lineStyle.fillColor = DSFSparkline.Fill.Color(srgbRed: 1, green: 1, blue: 0)
			a1.lineStyle.shadow = outerShadow

			b1.addOverlay(a1)
			let image = try XCTUnwrap(b1.cgImage(size: CGSize(width: 64, height: 64), scale: 2))
			let filename = "circular-gauge-inner-inout.png"
			let link = try imageStore.store(image.representation.png(), filename: filename)
			markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"64\" /></a>|\n\n"
		}

		markdownText += "\n### Shadow Offset\n\n"

		markdownText += "| -2, -2  |  -2, 2  |  2, -2  |  2, 2   |\n"
		markdownText += "|---------|---------|---------|---------|\n"
		markdownText += "|"

		try [(-2, -2), (-2, 2), (2, -2), (2, 2)].forEach { offset in
			let b1 = DSFSparklineSurface.Bitmap()
			let a1 = DSFSparklineOverlay.CircularGauge()

			let sh = DSFSparkline.Shadow(blurRadius: 3, offset: CGSize(width: offset.0, height: offset.1), color: .black, isInner: true)

			a1.value = 0.65
			a1.trackStyle.width = 20
			a1.trackStyle.shadow = sh

			a1.lineStyle.width = 10
			a1.lineStyle.fillColor = DSFSparkline.Fill.Color(srgbRed: 1, green: 1, blue: 0)
			a1.lineStyle.shadow = sh

			b1.addOverlay(a1)
			let image = try XCTUnwrap(b1.cgImage(size: CGSize(width: 64, height: 64), scale: 2))
			let filename = "circular-gauge-offset-\(offset).png"
			let link = try imageStore.store(image.representation.png(), filename: filename)
			markdownText += "<a href=\"\(link)\"><img src=\"\(link)\" width=\"64\" /></a>"
			markdownText += "|"
		}
		markdownText += "|\n\n"


	}

	func testTrackShadowInset2() throws {
		let b1 = DSFSparklineSurface.Bitmap()
		let a1 = DSFSparklineOverlay.CircularGauge()
		let innerShadow = DSFSparkline.Shadow(blurRadius: 3, offset: CGSize(width: 2, height: -2), color: .black, isInner: true)

		a1.value = 0.65
		a1.trackStyle.width = 20
		a1.lineStyle.width = 15
		a1.lineStyle.fillColor = DSFSparkline.Fill.Color(srgbRed: 1, green: 1, blue: 0)
		a1.lineStyle.shadow = innerShadow

		b1.addOverlay(a1)
		let image = try XCTUnwrap(b1.cgImage(size: CGSize(width: 64, height: 64), scale: 2))
		Swift.print(image)
	}
}
