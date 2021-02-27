//
//  SwiftUIView.swift
//  Demos
//
//  Created by Darren Ford on 26/2/21.
//

import SwiftUI
import DSFSparkline

fileprivate var lineOverlayDataSource: DSFSparkline.DataSource = {
	let d = DSFSparkline.DataSource(windowSize: 20, range: -0.1 ... 1.1, zeroLineValue: 0.5)
	d.push(values: [
		0.72, 0.84, 0.15, 0.16, 0.30, 0.58, 0.87, 0.44, 0.02, 0.27,
		0.48, 0.16, 0.15, 0.14, 0.81, 0.53, 0.67, 0.52, 0.07, 0.50
	])
	return d
}()

// The overlay representing the zero-line for the graph
fileprivate let lineZeroOverlay: DSFSparklineOverlay = {
	let zeroLine = DSFSparklineOverlay.ZeroLine()
	zeroLine.dataSource = LineSource1
	return zeroLine
}()

// A simple grid.
fileprivate let gridOverlay: DSFSparklineOverlay = {
	let grid = DSFSparklineOverlay.GridLines()
	grid.dataSource = lineOverlayDataSource

	grid.floatValues = [0,0, 0.2, 0.4, 0.6, 0.8, 1.0]
	grid.strokeColor = DSFColor.systemGray.withAlphaComponent(0.3).cgColor
	grid.strokeWidth = 0.5
	grid.dashStyle = [1, 1]

	return grid
}()


// The actual line graph
fileprivate let lineOverlay: DSFSparklineOverlay = {
	let lineOverlay = DSFSparklineOverlay.Line()
	lineOverlay.dataSource = lineOverlayDataSource

	lineOverlay.primaryStrokeColor = DSFColor.systemGreen.cgColor
	lineOverlay.primaryFill = DSFSparkline.Fill(flatColor: DSFColor.systemGreen.withAlphaComponent(0.3).cgColor)

	lineOverlay.secondaryStrokeColor = DSFColor.systemRed.cgColor
	lineOverlay.secondaryFill = DSFSparkline.Fill(flatColor: DSFColor.systemRed.withAlphaComponent(0.3).cgColor)

	lineOverlay.lineWidth = 1
	lineOverlay.markerSize = 4
	lineOverlay.centeredAtZeroLine = true

	return lineOverlay
}()



struct SwiftUIContentView: View {

	let animator = Animator()

	var body: some View {
		VStack {

			Text("A SwiftUI view using overlays")

			// Add the surface
			DSFSparklineSurface.SwiftUI([
				lineZeroOverlay,            // overlay 1 - zero-line
				gridOverlay,                // overlay 2 - grid
				lineOverlay                 // overlay 3 - line graph
			])
			.frame(width: 300, height: 50)
			.onAppear {
				self.animator.updateWithNewValues()
			}
			.padding(4)
			.border(Color.gray.opacity(0.3))
		}
	}
}

class Animator {
	func updateWithNewValues() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
			guard let `self` = self else {
				return
			}

			// push a new value into the graph's data source
			let cr2 = CGFloat.random(in: lineOverlayDataSource.range!) // -1 ... 1)
			_ = lineOverlayDataSource.push(value: cr2)

			self.updateWithNewValues()
		}
	}
}



struct SwiftUIView_Previews: PreviewProvider {
	static var previews: some View {
		SwiftUIContentView()
	}
}
