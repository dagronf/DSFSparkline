//
//  BitmapGenerationView.swift
//  Demos
//
//  Created by Darren Ford on 25/2/21.
//

import SwiftUI

import DSFSparkline

fileprivate let b1: DSFSparklineSurface.Bitmap = {
	let b = DSFSparklineSurface.Bitmap()

	let dataSource = DSFSparkline.DataSource(values: [1, 5, 3, 4], range: 0 ... 6)

	let li = DSFSparklineOverlay.GridLines()
	li.dataSource = dataSource
	li.floatValues = [1, 3, 5]
	li.strokeWidth = 0.5
	li.dashStyle = [0.5, 0.5]
	li.strokeColor = DSFColor.gray.withAlphaComponent(0.3).cgColor
	b.addOverlay(li)

	let l = DSFSparklineOverlay.Line()
	l.primaryStrokeColor = DSFColor.primaryTextColor.cgColor
	l.primaryFill = DSFSparkline.Fill.Gradient(colors: [
		DSFColor.systemRed.cgColor,
		DSFColor.systemBlue.cgColor,
	])
	l.dataSource = dataSource
	b.addOverlay(l)

	return b
}()

fileprivate let b200: DSFSparklineSurface.Bitmap = {
	let b = DSFSparklineSurface.Bitmap()

	let dataSource = DSFSparkline.DataSource(values: [1, 5, 3, 4], range: 0 ... 6)

	let li = DSFSparklineOverlay.GridLines()
	li.dataSource = dataSource
	li.floatValues = [1, 3, 5]
	li.strokeWidth = 0.5
	li.dashStyle = [0.5, 0.5]
	li.strokeColor = DSFColor.gray.withAlphaComponent(0.3).cgColor
	b.addOverlay(li)

	let l = DSFSparklineOverlay.Line()
	l.primaryStrokeColor = DSFColor.primaryTextColor.cgColor
	l.primaryFill = DSFSparkline.Fill.Gradient(colors: [
		DSFColor.systemRed.cgColor,
		DSFColor.systemBlue.cgColor,
	], isHorizontal: true)
	l.dataSource = dataSource
	b.addOverlay(l)

	return b
}()

fileprivate let b2: DSFSparklineSurface.Bitmap = {
	let b = DSFSparklineSurface.Bitmap()

	let dataSource = DSFSparkline.DataSource(values: [1, 5, 3, 4], range: 0 ... 6)

	let l = DSFSparklineOverlay.Line()
	l.primaryStrokeColor = DSFColor.black.cgColor
	l.strokeWidth = 1.0
	l.dataSource = dataSource
	b.addOverlay(l)

	return b
}()

fileprivate let b3: DSFSparklineSurface.Bitmap = {
	let b = DSFSparklineSurface.Bitmap()

	let dataSource = DSFSparkline.DataSource(values: [1, 5, 3, 4])

	let l = DSFSparklineOverlay.Line()
	l.primaryStrokeColor = DSFColor.systemPink.cgColor
	l.strokeWidth = 1.0
	l.shadow = NSShadow(blurRadius: 2.0, offset: CGSize(width: 1, height: -1), color: DSFColor.gray.withAlphaComponent(0.5))
	l.markerSize = 6
	l.dataSource = dataSource
	b.addOverlay(l)

	return b
}()

fileprivate let b4: DSFSparklineSurface.Bitmap = {
	let b = DSFSparklineSurface.Bitmap()

	let dataSource = DSFSparkline.DataSource(values: [1, 5, 3, 4])

	let l = DSFSparklineOverlay.Line()
	l.primaryStrokeColor = DSFColor.systemPink.cgColor
	l.primaryFill = DSFSparkline.Fill.Color(DSFColor.systemPink.withAlphaComponent(0.3).cgColor)
	l.strokeWidth = 3.0
	l.interpolated = true
	l.markerSize = 6
	l.dataSource = dataSource
	b.addOverlay(l)

	return b
}()

fileprivate let b5: DSFSparklineSurface.Bitmap = {
	let b = DSFSparklineSurface.Bitmap()

	let dataSource = DSFSparkline.DataSource(values: [4, 2, 9, 9, 0, 9, 0, 4])

	let l = DSFSparklineOverlay.Line()
	l.primaryStrokeColor = DSFColor.systemIndigo.cgColor
	l.primaryFill = DSFSparkline.Fill.Color(DSFColor.systemIndigo.withAlphaComponent(0.3).cgColor)
	l.strokeWidth = 3.0
	l.interpolated = true
	l.markerSize = 6
	l.dataSource = dataSource
	b.addOverlay(l)

	return b
}()

fileprivate let b6: DSFSparklineSurface.Bitmap = {
	let b = DSFSparklineSurface.Bitmap()

	let dataSource = DSFSparkline.DataSource(values: [4, 2, 9, 9, 0, 9, 0, 4])

	let l = DSFSparklineOverlay.Line()
	l.primaryStrokeColor = DSFColor.systemIndigo.cgColor
	l.primaryFill = DSFSparkline.Fill.Color(DSFColor.systemIndigo.withAlphaComponent(0.3).cgColor)
	l.strokeWidth = 3.0
	l.interpolated = true
	l.centeredAtZeroLine = true

	l.markerSize = 6

	dataSource.zeroLineValue = 5
	l.dataSource = dataSource

	l.secondaryStrokeColor = DSFColor.systemTeal.cgColor
	l.secondaryFill = DSFSparkline.Fill.Color(DSFColor.systemTeal.withAlphaComponent(0.3).cgColor)

	b.addOverlay(l)

	return b
}()

fileprivate let tablet1: DSFSparklineSurface.Bitmap = {
	let b = DSFSparklineSurface.Bitmap()

	let l = DSFSparklineOverlay.Tablet()

	l.winStrokeColor = DSFColor.systemGreen.withAlphaComponent(0.5).cgColor
	l.winFill = DSFSparkline.Fill.Gradient(colors: [
		DSFColor.systemGreen.withAlphaComponent(0.8).cgColor,
		DSFColor.systemGreen.withAlphaComponent(0.2).cgColor
	])

	l.lossStrokeColor = DSFColor.systemRed.withAlphaComponent(0.5).cgColor
	l.lossFill = DSFSparkline.Fill.Gradient(colors: [
		DSFColor.systemRed.withAlphaComponent(0.2).cgColor,
		DSFColor.systemRed.withAlphaComponent(0.6).cgColor
	])

	let dataSource = DSFSparkline.DataSource(
		values: [-1, 5, 3, -7, -2, 2, 5, -1, 5, 3, -7, -2, 2, 5, -1, 5, 3, -7, -2, 2, 5])
	l.dataSource = dataSource
	b.addOverlay(l)

	return b
}()


fileprivate let percentBar: DSFSparklineSurface.Bitmap = {
	let bitmap = DSFSparklineSurface.Bitmap()
	let percentbar = DSFSparklineOverlay.PercentBar(value: 0.42)
	bitmap.addOverlay(percentbar)

	// Generate an image with retina scale
	return bitmap
}()

fileprivate let wiperGauge: DSFSparklineSurface.Bitmap = {
	let bitmap = DSFSparklineSurface.Bitmap()
	let wiperGauge = DSFSparklineOverlay.WiperGauge()
	wiperGauge.value = 0.35
	bitmap.addOverlay(wiperGauge)

	// Generate an image with retina scale
	return bitmap
}()

fileprivate let wiperGauge2: DSFSparklineSurface.Bitmap = {
	let bitmap = DSFSparklineSurface.Bitmap()
	let wiperGauge = DSFSparklineOverlay.WiperGauge()
	wiperGauge.value = 0.8
	wiperGauge.valueColor = .init(flatColor: CGColor(srgbRed: 0.3, green: 1, blue: 0.3, alpha: 1))
	wiperGauge.valueBackgroundColor = CGColor(srgbRed: 1, green: 0.3, blue: 0.3, alpha: 1)
	wiperGauge.gaugeUpperArcColor = CGColor(gray: 0, alpha: 1)
	wiperGauge.gaugePointerColor = CGColor(gray: 0.3, alpha: 1)
	wiperGauge.gaugeBackgroundColor = CGColor(srgbRed: 1, green: 1, blue: 0.4, alpha: 1)
	bitmap.addOverlay(wiperGauge)

	// Generate an image with retina scale
	return bitmap
}()

struct BitmapGenerationView: View {

	#if os(macOS)
	func makeImage(_ nsImage: NSImage) -> Image {
		return Image(nsImage: nsImage)
	}
	func generate(_ bitmap: DSFSparklineSurface.Bitmap, size: CGSize) -> NSImage {
		guard let image = bitmap.image(size: size, scale: 2) else {
			return NSImage(systemSymbolName: "exclamationmark.triangle.fill", accessibilityDescription: nil)!
		}
		return image
	}
	#else
	func makeImage(_ uiImage: UIImage) -> Image {
		return Image(uiImage: uiImage)
	}

	func generate(_ bitmap: DSFSparklineSurface.Bitmap, size: CGSize) -> UIImage {
		guard let image = bitmap.image(size: size, scale: 2) else {
			return UIImage(systemName: "exclamationmark.triangle.fill")!
		}
		return image
	}
	#endif

	var body: some View {
		VStack {

			Text("Sparkline images created using DSFSparklineSurface.Bitmap")

			VStack {
				makeImage(self.generate(b1, size: CGSize(width: 200, height: 40)))
					.padding(4)
					.border(Color.gray)

				makeImage(self.generate(b200, size: CGSize(width: 200, height: 40)))
					.padding(4)
					.border(Color.gray)

				makeImage(self.generate(b2, size: CGSize(width: 200, height: 40)))
					.padding(4)
					.border(Color.gray)
			}

			Divider()

			VStack {
				makeImage(self.generate(b3, size: CGSize(width: 200, height: 40)))
					.padding(4)
					.border(Color.gray)

				makeImage(self.generate(b4, size: CGSize(width: 200, height: 40)))
					.padding(4)
					.border(Color.gray)
			}

			Divider()

			HStack {
				makeImage(self.generate(b5, size: CGSize(width: 100, height: 30)))
					.padding(4)
					.border(Color.gray)
				makeImage(self.generate(b6, size: CGSize(width: 100, height: 30)))
					.padding(4)
					.border(Color.gray)
			}

			Divider()

			makeImage(self.generate(tablet1, size: CGSize(width: 400, height: 20)))
				.padding(4)
				.border(Color.gray)

			Divider()

			HStack {
				makeImage(self.generate(percentBar, size: CGSize(width: 200, height: 20)))
					.padding(4)
					.border(Color.gray)

				makeImage(self.generate(wiperGauge, size: CGSize(width: 80, height: 40)))
					.padding(4)
					.border(Color.gray)

				makeImage(self.generate(wiperGauge2, size: CGSize(width: 80, height: 40)))
					.padding(4)
					.border(Color.gray)
			}
		}
	}
}

struct BitmapGenerationView_Previews: PreviewProvider {
	static var previews: some View {
		BitmapGenerationView()
	}
}
