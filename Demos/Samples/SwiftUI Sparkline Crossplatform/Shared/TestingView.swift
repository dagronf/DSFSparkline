//
//  TestingView.swift
//  Demos
//
//  Created by Darren Ford on 14/4/21.
//

import SwiftUI
import DSFSparkline

struct LineDemoCustomMarkersTest: View {

	let source: DSFSparkline.DataSource = {
		let d = DSFSparkline.DataSource(windowSize: 20, range: 0 ... 1, zeroLineValue: 0.5)
		d.push(values: [
			0.72, 0.84, 0.15, 0.16, 0.30, 0.58, 0.87, 0.44, 0.02, 0.27,
			0.48, 0.16, 0.15, 0.14, 0.81, 0.53, 0.67, 0.52, 0.07, 0.50
		])
		return d
	}()

	var customMarkerDrawing: DSFSparklineOverlay.Line.MarkerDrawingFunction = { context, markerFrames in
		let maxV = markerFrames.min { (a, b) -> Bool in a.value > b.value }!
		let minV = markerFrames.min { (a, b) -> Bool in a.value < b.value }!

		// Min

		context.setFillColor(DSFColor.systemRed.cgColor)
		context.fill(minV.rect)

		context.setLineWidth(0.5)
		context.setStrokeColor(DSFColor.white.cgColor)
		context.stroke(minV.rect)

		// Max

		context.setFillColor(DSFColor.systemGreen.cgColor)
		context.fill(maxV.rect)

		context.setLineWidth(0.5)
		context.setStrokeColor(DSFColor.white.cgColor)
		context.stroke(maxV.rect)

	}

	var body: some View {
		HStack {
			DSFSparklineLineGraphView.SwiftUI(
				dataSource: source,
				graphColor: DSFColor.systemGreen,
				lineWidth: 0.5,
				showZeroLine: true,
				centeredAtZeroLine: true,
				lowerGraphColor: DSFColor(red: 0.7, green: 0, blue: 0, alpha: 1.0),
				markerSize: 4
			)
			.frame(height: 40.0)
			.padding(5)
			.border(Color.gray.opacity(0.2), width: 1)

			DSFSparklineLineGraphView.SwiftUI(
				dataSource: source,
				graphColor: DSFColor.systemGreen,
				lineWidth: 0.5,
				showZeroLine: true,
				centeredAtZeroLine: true,
				lowerGraphColor: DSFColor(red: 0.7, green: 0, blue: 0, alpha: 1.0),
				markerSize: 6,
				markerDrawingFunc: self.customMarkerDrawing
			)
			.frame(height: 40.0)
			.padding(5)
			.border(Color.gray.opacity(0.2), width: 1)
		}
		.onAppear(perform: {
			startSomething()
		})
	}

	func startSomething() {
		updateWithNewValues()
	}

	func updateWithNewValues() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			source.push(value: CGFloat.random(in: 0.0 ... 1.0))
			updateWithNewValues()
		}
	}


}

struct TestingView: View {
	var body: some View {
		LineDemoCustomMarkersTest()
	}
}

struct TestingView_Previews: PreviewProvider {
	static var previews: some View {
		TestingView()
	}
}
