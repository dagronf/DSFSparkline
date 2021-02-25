//
//  BitmapGenerationView.swift
//  Demos
//
//  Created by Darren Ford on 25/2/21.
//

import SwiftUI

import DSFSparkline

let b1: DSFSparklineSurfaceBitmap = {
	let b = DSFSparklineSurfaceBitmap()

	let dataSource = DSFSparklineDataSource(values: [1, 5, 3, 4], range: 0 ... 6)

	let li = DSFSparklineOverlay.GridLines()
	li.dataSource = dataSource
	li.floatValues = [1, 3, 5]
	li.strokeWidth = 0.5
	li.dashStyle = [0.5, 0.5]
	li.strokeColor = DSFColor.gray.withAlphaComponent(0.3).cgColor
	b.addOverlay(li)

	let l = DSFSparklineOverlay.Line()
	l.primaryStrokeColor = DSFColor.primaryTextColor.cgColor
	l.primaryFillColor = DSFColor.primaryTextColor.withAlphaComponent(0.3).cgColor
	l.dataSource = dataSource
	b.addOverlay(l)

	return b
}()

let b2: DSFSparklineSurfaceBitmap = {
	let b = DSFSparklineSurfaceBitmap()

	let dataSource = DSFSparklineDataSource(values: [1, 5, 3, 4], range: 0 ... 6)

	let l = DSFSparklineOverlay.Line()
	l.primaryStrokeColor = DSFColor.black.cgColor
	l.strokeWidth = 1.0
	l.dataSource = dataSource
	b.addOverlay(l)

	return b
}()

struct BitmapGenerationView: View {

	#if os(macOS)
	func makeImage(_ nsImage: NSImage) -> Image {
		return Image(nsImage: nsImage)
	}
	func generate(_ bitmap: DSFSparklineSurfaceBitmap) -> NSImage {
		guard let image = bitmap.image(size: CGSize(width: 200, height: 40), scale: 2) else {
			return NSImage(systemSymbolName: "exclamationmark.triangle.fill", accessibilityDescription: nil)!
		}
		return image
	}
	#else
	func makeImage(_ uiImage: UIImage) -> Image {
		return Image(uiImage: uiImage)
	}

	func generate(_ bitmap: DSFSparklineSurfaceBitmap) -> UIImage {
		guard let image = bitmap.image(size: CGSize(width: 200, height: 40), scale: 2) else {
			return UIImage(systemName: "exclamationmark.triangle.fill")!
		}
		return image
	}
	#endif



	var body: some View {
		VStack {
			makeImage(self.generate(b1))
				.padding(4)
				.border(Color.gray)

			makeImage(self.generate(b2))
				.padding(4)
				.border(Color.gray)
		}
	}
}

struct BitmapGenerationView_Previews: PreviewProvider {
	static var previews: some View {
		BitmapGenerationView()
	}
}
