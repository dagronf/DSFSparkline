//
//  OverlayView.swift
//  Demos
//
//  Created by Darren Ford on 17/2/21.
//

import SwiftUI
import DSFSparkline

extension DSFColor {
	static var primaryTextColor: DSFColor {
		#if os(macOS)
		return NSColor.textColor
		#else
		return UIColor.label
		#endif
	}
}


fileprivate var dataSource1: DSFSparkline.DataSource = {
	let d = DSFSparkline.DataSource(windowSize: 20, range: -55 ... 55, zeroLineValue: 0)
	d.set(values: [
				18, -5, 11, 12, -21, 48, 41, -19, -28, 3,
				28, -27, -21, -45, -48, -39, 33, -4, 35, 37]
	)
	return d
}()


struct OverlayView: View {

	var barGraph: DSFSparklineOverlay = {
		let b = DSFSparklineOverlay.Bar()
		b.dataSource = dataSource1
		b.strokeWidth = 2
		b.primaryStrokeColor = DSFColor.systemPink.cgColor
		b.primaryFill = DSFSparkline.Fill.Color(DSFColor.systemPink.withAlphaComponent(0.5).cgColor)
		return b
	}()

	var lineGraph: DSFSparklineOverlay = {
		let l = DSFSparklineOverlay.Line()
		l.dataSource = dataSource1
		l.strokeWidth = 1
		l.interpolated = true
		l.primaryStrokeColor = DSFColor.primaryTextColor.cgColor
		l.primaryFill = DSFSparkline.Fill.Color(DSFColor.primaryTextColor.withAlphaComponent(0.7).cgColor)
		return l
	}()

	var barGraph2: DSFSparklineOverlay = {
		let b = DSFSparklineOverlay.Bar()
		b.dataSource = dataSource1
		b.strokeWidth = 2
		b.primaryStrokeColor = DSFColor.systemPink.cgColor
		b.primaryFill = DSFSparkline.Fill.Color(DSFColor.systemPink.withAlphaComponent(0.5).cgColor)
		return b
	}()

	var lineGraph2: DSFSparklineOverlay = {
		let l = DSFSparklineOverlay.Line()
		l.dataSource = dataSource1
		l.strokeWidth = 1
		l.interpolated = true
		l.primaryStrokeColor = DSFColor.primaryTextColor.cgColor
		l.primaryFill = DSFSparkline.Fill.Color(DSFColor.primaryTextColor.withAlphaComponent(0.7).cgColor)
		return l
	}()


	var body: some View {
		VStack {
			Text("Overlay two sparklines using the same data")
				.font(.headline)

			HStack {
				VStack {
					DSFSparklineSurface.SwiftUI([
						barGraph,		// bar on the bottom
						lineGraph		// line on the top
					])
					.frame(height: 40)
					Text("Line on top").font(.caption)
				}

				VStack {
					DSFSparklineSurface.SwiftUI([
						lineGraph2,		// line on the bottom
						barGraph2		// bar on the top
					])
					.frame(height: 40)
					Text("Bar on top").font(.caption)
				}
			}
		}
		.frame(width: 500)
		.padding()
	}
}



struct OverlayView_Previews: PreviewProvider {
	static var previews: some View {
		OverlayView()
	}
}
