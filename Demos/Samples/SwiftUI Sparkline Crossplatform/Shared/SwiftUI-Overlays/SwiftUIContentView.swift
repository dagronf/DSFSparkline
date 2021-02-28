//
//  SwiftUIView.swift
//  Demos
//
//  Created by Darren Ford on 26/2/21.
//

import DSFSparkline
import SwiftUI

// A shared data source
private var lineOverlayDataSource: DSFSparkline.DataSource = {
	let d = DSFSparkline.DataSource(windowSize: 20, range: -0.1 ... 1.1, zeroLineValue: 0.5)
	d.push(values: [
		1.00, 1.00, 0.44, 0.16, 0.30, 0.58, 0.87, 0.44, 0.00, 0.00,
		0.38, 0.16, 0.15, 0.14, 0.81, 0.53, 0.67, 0.52, 0.07, 0.50,
	])
	return d
}()

struct SwiftUIContentView_LineOnly: View {
	// The actual line graph
	fileprivate let lineOverlay1: DSFSparklineOverlay = {
		let lineOverlay = DSFSparklineOverlay.Line()
		lineOverlay.dataSource = lineOverlayDataSource

		lineOverlay.primaryStrokeColor = DSFColor.systemGreen.cgColor
		lineOverlay.primaryFill = DSFSparkline.Fill.Color(DSFColor.systemGreen.withAlphaComponent(0.3).cgColor)

		lineOverlay.secondaryStrokeColor = DSFColor.systemRed.cgColor
		lineOverlay.secondaryFill = DSFSparkline.Fill.Color(DSFColor.systemRed.withAlphaComponent(0.3).cgColor)

		lineOverlay.strokeWidth = 2
		lineOverlay.markerSize = 6
		lineOverlay.centeredAtZeroLine = true

		return lineOverlay
	}()

	var body: some View {
		DSFSparklineSurface.SwiftUI([
			lineOverlay1, // overlay 1 - line graph
		])
	}
}

struct SwiftUIContentView_LineOnly_Previews: PreviewProvider {
	static var previews: some View {
		SwiftUIContentView_LineOnly()
	}
}

//////

struct SwiftUIContentView_LineZeroLine: View {
	// The actual line graph
	fileprivate let lineOverlay2: DSFSparklineOverlay = {
		let lineOverlay = DSFSparklineOverlay.Line()
		lineOverlay.dataSource = lineOverlayDataSource

		lineOverlay.primaryStrokeColor = DSFColor.systemGreen.cgColor
		lineOverlay.primaryFill = DSFSparkline.Fill.Color(DSFColor.systemGreen.withAlphaComponent(0.3).cgColor)

		lineOverlay.secondaryStrokeColor = DSFColor.systemRed.cgColor
		lineOverlay.secondaryFill = DSFSparkline.Fill.Color(DSFColor.systemRed.withAlphaComponent(0.3).cgColor)

		lineOverlay.strokeWidth = 2
		lineOverlay.markerSize = 6
		lineOverlay.centeredAtZeroLine = true

		return lineOverlay
	}()

	// The overlay representing the zero-line for the graph
	fileprivate let lineZeroOverlay2: DSFSparklineOverlay = {
		let zeroLine = DSFSparklineOverlay.ZeroLine()
		zeroLine.dataSource = LineSource1
		zeroLine.dashStyle = []
		return zeroLine
	}()

	var body: some View {
		DSFSparklineSurface.SwiftUI([
			lineZeroOverlay2, // overlay 1 - zero-line
			lineOverlay2, // overlay 2 - line graph
		])
	}
}

struct SwiftUIContentView_LineZeroLine_Previews: PreviewProvider {
	static var previews: some View {
		SwiftUIContentView_LineZeroLine()
	}
}

//////

struct SwiftUIContentView_LineZeroLineGrid: View {
	// The actual line graph
	fileprivate let lineOverlay3: DSFSparklineOverlay = {
		let lineOverlay = DSFSparklineOverlay.Line()
		lineOverlay.dataSource = lineOverlayDataSource

		lineOverlay.primaryStrokeColor = DSFColor.systemGreen.cgColor
		lineOverlay.primaryFill = DSFSparkline.Fill.Color(DSFColor.systemGreen.withAlphaComponent(0.3).cgColor)

		lineOverlay.secondaryStrokeColor = DSFColor.systemRed.cgColor
		lineOverlay.secondaryFill = DSFSparkline.Fill.Color(DSFColor.systemRed.withAlphaComponent(0.3).cgColor)

		lineOverlay.strokeWidth = 2
		lineOverlay.markerSize = 6
		lineOverlay.centeredAtZeroLine = true

		return lineOverlay
	}()

	// The overlay representing the zero-line for the graph
	fileprivate let lineZeroOverlay3: DSFSparklineOverlay = {
		let zeroLine = DSFSparklineOverlay.ZeroLine()
		zeroLine.dataSource = LineSource1
		zeroLine.dashStyle = []
		return zeroLine
	}()

	fileprivate let gridOverlay3: DSFSparklineOverlay = {
		let grid = DSFSparklineOverlay.GridLines()
		grid.dataSource = lineOverlayDataSource

		grid.floatValues = [0.0, 0.2, 0.4, 0.6, 0.8, 1.0]
		grid.strokeColor = DSFColor.systemGray.withAlphaComponent(0.3).cgColor
		grid.strokeWidth = 0.5
		grid.dashStyle = [1, 1]

		return grid
	}()

	var body: some View {
		DSFSparklineSurface.SwiftUI([
			gridOverlay3, // overlay 1 - grid lines
			lineZeroOverlay3, // overlay 2 - zero-line
			lineOverlay3, // overlay 3 - line graph
		])
	}
}

struct SwiftUIContentView_LineZeroLineGrid_Previews: PreviewProvider {
	static var previews: some View {
		SwiftUIContentView_LineZeroLineGrid()
	}
}

struct SwiftUIContentView_LineZeroLineGridRanges: View {
	// The actual line graph
	fileprivate let lineOverlay4: DSFSparklineOverlay = {
		let lineOverlay = DSFSparklineOverlay.Line()
		lineOverlay.dataSource = lineOverlayDataSource

		lineOverlay.primaryStrokeColor = DSFColor.systemGreen.cgColor
		lineOverlay.primaryFill = DSFSparkline.Fill.Color(DSFColor.systemGreen.withAlphaComponent(0.3).cgColor)

		lineOverlay.secondaryStrokeColor = DSFColor.systemRed.cgColor
		lineOverlay.secondaryFill = DSFSparkline.Fill.Color(DSFColor.systemRed.withAlphaComponent(0.3).cgColor)

		lineOverlay.strokeWidth = 2
		lineOverlay.markerSize = 6
		lineOverlay.centeredAtZeroLine = true

		return lineOverlay
	}()

	// The overlay representing the zero-line for the graph
	fileprivate let lineZeroOverlay4: DSFSparklineOverlay = {
		let zeroLine = DSFSparklineOverlay.ZeroLine()
		zeroLine.dataSource = LineSource1
		zeroLine.dashStyle = []
		return zeroLine
	}()

	fileprivate let gridOverlay4: DSFSparklineOverlay = {
		let grid = DSFSparklineOverlay.GridLines()
		grid.dataSource = lineOverlayDataSource

		grid.floatValues = [0.0, 0.2, 0.4, 0.6, 0.8, 1.0]
		grid.strokeColor = DSFColor.systemGray.withAlphaComponent(0.3).cgColor
		grid.strokeWidth = 0.5
		grid.dashStyle = [1, 1]

		return grid
	}()

	fileprivate let rangeOverlay4: DSFSparklineOverlay = {
		let highlight = DSFSparklineOverlay.RangeHighlight()
		highlight.dataSource = lineOverlayDataSource

		highlight.highlightRange = 0.0 ..< 0.2
		highlight.fill = DSFSparkline.Fill.Color(DSFColor.systemRed.withAlphaComponent(0.1).cgColor)

		return highlight
	}()

	fileprivate let rangeOverlay5: DSFSparklineOverlay = {
		let highlight = DSFSparklineOverlay.RangeHighlight()
		highlight.dataSource = lineOverlayDataSource

		highlight.highlightRange = 0.8 ..< 1.0
		highlight.fill = DSFSparkline.Fill.Color(DSFColor.systemGreen.withAlphaComponent(0.1).cgColor)

		return highlight
	}()

	var body: some View {
		DSFSparklineSurface.SwiftUI([
			rangeOverlay4, // overlay 1 - lower highlight
			rangeOverlay5, // overlay 2 - upper highlight
			lineZeroOverlay4, // overlay 3 - zero-line
			gridOverlay4, // overlay 4 - grid
			lineOverlay4, // overlay 5 - line graph
		])
	}
}

struct SwiftUIContentView_LineZeroLineGridRanges_Previews: PreviewProvider {
	static var previews: some View {
		SwiftUIContentView_LineZeroLineGridRanges()
	}
}

/////

struct SwiftUILineGraphContentView: View {

	let shouldAnimate: Bool

	fileprivate let animator = Animator()

	var body: some View {
		VStack {
			Text("A SwiftUI view demonstrating overlays")
				.font(.headline)

			HStack {
				VStack {
					SwiftUIContentView_LineOnly()
						.frame(width: 150, height: 50)
						.padding(4)
						.border(Color.gray.opacity(0.3))

					Text("Line only").font(.footnote)
				}
				VStack {
					SwiftUIContentView_LineZeroLine()
						.frame(width: 150, height: 50)
						.padding(4)
						.border(Color.gray.opacity(0.3))
					Text("Line, zero-line").font(.footnote)
				}
				VStack {
					SwiftUIContentView_LineZeroLineGrid()
						.frame(width: 150, height: 50)
						.padding(4)
						.border(Color.gray.opacity(0.3))
					Text("Line, zero-line, grid").font(.footnote)
				}

				VStack {
					SwiftUIContentView_LineZeroLineGridRanges()
						.frame(width: 150, height: 50)
						.padding(4)
						.border(Color.gray.opacity(0.3))
					Text("Line, zero-line, grid, ranges").font(.footnote)
				}
			}
		}
		.onAppear() {
			if shouldAnimate {
				self.animator.updateWithNewValues()
			}
		}
	}
}

fileprivate class Animator {
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

struct SwiftUIContentView_Previews: PreviewProvider {
	static var previews: some View {
		SwiftUILineGraphContentView(shouldAnimate: false)
	}
}
