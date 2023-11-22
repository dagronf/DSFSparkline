//
//  LineDemoContentView.swift
//  SwiftUI Demo
//
//  Created by Darren Ford on 27/1/21.
//

import SwiftUI
import DSFSparkline

var LineSource1: DSFSparkline.DataSource = {
	let d = DSFSparkline.DataSource(windowSize: 20, range: 0 ... 1, zeroLineValue: 0.5)
	d.push(values: [
		0.72, 0.84, 0.15, 0.16, 0.30, 0.58, 0.95, 0.44, 0.02, 0.27,
		0.48, 0.16, 0.15, 0.14, 0.81, 0.53, 0.67, 0.52, 0.07, 0.50
	])
	return d
}()

let GraphColor = DSFColor.gray

struct LineDemoBasic: View {
	var body: some View {
		VStack {
			Text("Line")
			HStack {
				DSFSparklineLineGraphView.SwiftUI(
					dataSource: LineSource1,
					graphColor: GraphColor,
					lineWidth: 1,
					lineShading: false,
					shadowed: true
				)
				.frame(height: 40.0)
				.padding(5)
				.border(Color.gray.opacity(0.2), width: 1)
				DSFSparklineLineGraphView.SwiftUI(
					dataSource: LineSource1,
					graphColor: GraphColor,
					lineWidth: 1,
					interpolated: true,
					lineShading: false
				)
				.frame(height: 40.0)
				.padding(5)
				.border(Color.gray.opacity(0.2), width: 1)
			}
		}
	}
}

//struct LineDemoBasic_Previews: PreviewProvider {
//	static var previews: some View {
//		LineDemoBasic()
//	}
//}

struct LineDemoBasicMarkers: View {
	var body: some View {
		VStack {
			Text("Line with markers")
			HStack {
				DSFSparklineLineGraphView.SwiftUI(
					dataSource: LineSource1,
					graphColor: GraphColor,
					lineWidth: 1,
					lineShading: false,
					markerSize: 4
				)
				.frame(height: 40.0)
				.padding(5)
				.border(Color.gray.opacity(0.2), width: 1)

				DSFSparklineLineGraphView.SwiftUI(
					dataSource: LineSource1,
					graphColor: GraphColor,
					lineWidth: 1,
					interpolated: true,
					lineShading: false,
					markerSize: 4
				)
				.frame(height: 40.0)
				.padding(5)
				.border(Color.gray.opacity(0.2), width: 1)
			}
		}
	}
}

//struct LineDemoBasicMarkers_Previews: PreviewProvider {
//	static var previews: some View {
//		LineDemoBasicMarkers()
//	}
//}

struct LineDemoMarkersAndShadow: View {
	var body: some View {
		VStack {
			Text("Line with markers and shadow")
			DSFSparklineLineGraphView.SwiftUI(
				dataSource: LineSource1,
				graphColor: GraphColor,
				lineWidth: 1,
				lineShading: false,
				shadowed: true,
				markerSize: 4
			)
			.frame(height: 40.0)
			.padding(5)
			.border(Color.gray.opacity(0.2), width: 1)
		}
	}
}

//struct LineDemoMarkersAndShadow_Previews: PreviewProvider {
//	static var previews: some View {
//		LineDemoMarkersAndShadow()
//	}
//}

struct LineDemoBasicZeroLine: View {
	var body: some View {
		VStack {
			Text("Line with zero-line added")
			HStack {
				DSFSparklineLineGraphView.SwiftUI(
					dataSource: LineSource1,
					graphColor: GraphColor,
					lineWidth: 1,
					lineShading: false,
					showZeroLine: true
				)
				.frame(height: 40.0)
				.padding(5)
				.border(Color.gray.opacity(0.2), width: 1)

				DSFSparklineLineGraphView.SwiftUI(
					dataSource: LineSource1,
					graphColor: GraphColor,
					lineWidth: 1,
					interpolated: true,
					lineShading: false,
					showZeroLine: true
				)
				.frame(height: 40.0)
				.padding(5)
				.border(Color.gray.opacity(0.2), width: 1)
			}
		}
	}
}

//struct LineDemoBasicZeroLine_Previews: PreviewProvider {
//	static var previews: some View {
//		LineDemoBasicZeroLine()
//	}
//}

struct LineDemoArea: View {
	var body: some View {
		VStack {
			Text("Area")
			HStack {
				DSFSparklineLineGraphView.SwiftUI(
					dataSource: LineSource1,
					graphColor: GraphColor,
					showZeroLine: true
				)
				.frame(height: 40.0)
				.padding(5)
				.border(Color.gray.opacity(0.2), width: 1)

				DSFSparklineLineGraphView.SwiftUI(
					dataSource: LineSource1,
					graphColor: GraphColor,
					interpolated: true,
					showZeroLine: true,
					markerSize: 4
				)
				.frame(height: 40.0)
				.padding(5)
				.border(Color.gray.opacity(0.2), width: 1)
			}
		}
	}
}

//struct LineDemoArea_Previews: PreviewProvider {
//	static var previews: some View {
//		LineDemoArea()
//	}
//}


struct LineDemoAreaCentered: View {
	var body: some View {
		VStack {
			Text("Line centered")
			HStack {
				DSFSparklineLineGraphView.SwiftUI(
					dataSource: LineSource1,
					graphColor: DSFColor.systemGreen,
					lineWidth: 0.5,
					showZeroLine: true,
					centeredAtZeroLine: true,
					lowerGraphColor: DSFColor(red: 0.7, green: 0, blue: 0, alpha: 1.0)
				)
				.frame(height: 40.0)
				.padding(5)
				.border(Color.gray.opacity(0.2), width: 1)

				DSFSparklineLineGraphView.SwiftUI(
					dataSource: LineSource1,
					graphColor: DSFColor.systemGreen,
					interpolated: true,
					showZeroLine: true,
					centeredAtZeroLine: true,
					lowerGraphColor: DSFColor(red: 0.7, green: 0, blue: 0, alpha: 1.0)
				)
				.frame(height: 40.0)
				.padding(5)
				.border(Color.gray.opacity(0.2), width: 1)
			}
		}
	}
}

//struct LineDemoAreaCentered_Previews: PreviewProvider {
//	static var previews: some View {
//		LineDemoAreaCentered()
//	}
//}

struct LineDemoAreaCenteredMarkers: View {
	var body: some View {
		VStack {
			Text("Line centered with markers")
			HStack {
				DSFSparklineLineGraphView.SwiftUI(
					dataSource: LineSource1,
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
					dataSource: LineSource1,
					graphColor: DSFColor.systemGreen,
					interpolated: true,
					showZeroLine: true,
					centeredAtZeroLine: true,
					lowerGraphColor: DSFColor(red: 0.7, green: 0, blue: 0, alpha: 1.0),
					markerSize: 4
				)
				.frame(height: 40.0)
				.padding(5)
				.border(Color.gray.opacity(0.2), width: 1)
			}
		}
	}
}

//struct LineDemoAreaCenteredMarkers_Previews: PreviewProvider {
//	static var previews: some View {
//		LineDemoAreaCenteredMarkers()
//	}
//}

struct LineDemoAreaCenteredMarkersNoLowerColor: View {
	var body: some View {
		VStack {
			Text("Line centered with markers, single color")
			HStack {
				DSFSparklineLineGraphView.SwiftUI(
					dataSource: LineSource1,
					graphColor: DSFColor.systemGreen,
					lineWidth: 0.5,
					showZeroLine: true,
					centeredAtZeroLine: true,
					markerSize: 4
				)
				.frame(height: 40.0)
				.padding(5)
				.border(Color.gray.opacity(0.2), width: 1)
				
				DSFSparklineLineGraphView.SwiftUI(
					dataSource: LineSource1,
					graphColor: DSFColor.systemGreen,
					interpolated: true,
					showZeroLine: true,
					centeredAtZeroLine: true,
					markerSize: 4
				)
				.frame(height: 40.0)
				.padding(5)
				.border(Color.gray.opacity(0.2), width: 1)
			}
		}
	}
}

//struct LineDemoAreaCenteredMarkersNoLowerColor_Previews: PreviewProvider {
//	static var previews: some View {
//		LineDemoAreaCenteredMarkersNoLowerColor()
//	}
//}

struct LineDemoLineRanges: View {
	var body: some View {
		VStack {
			Text("Line with ranges")
			HStack {
				DSFSparklineLineGraphView.SwiftUI(
					dataSource: LineSource1,
					graphColor: GraphColor,
					lineShading: false,
					highlightDefinitions: [
						DSFSparkline.HighlightRangeDefinition(
							range: 0.7 ..< 1.0,
							fillColor: DSFColor.red.withAlphaComponent(0.15).cgColor
						),
						DSFSparkline.HighlightRangeDefinition(
							range: 0.3 ..< 0.7,
							fillColor: DSFColor.yellow.withAlphaComponent(0.15).cgColor
						),
						DSFSparkline.HighlightRangeDefinition(
							range: 0.0 ..< 0.3,
							fillColor: DSFColor.green.withAlphaComponent(0.15).cgColor
						)
					]
				)
				.frame(height: 40.0)
				.padding(5)
				.border(Color.gray.opacity(0.2), width: 1)

				DSFSparklineLineGraphView.SwiftUI(
					dataSource: LineSource1,
					graphColor: GraphColor,
					interpolated: true,
					lineShading: false,
					highlightDefinitions: [
						DSFSparkline.HighlightRangeDefinition(
							range: 0.4 ..< 0.6,
							fillColor: DSFColor.systemGray.withAlphaComponent(0.3).cgColor
						)
					]
				)
				.frame(height: 40.0)
				.padding(5)
				.border(Color.gray.opacity(0.2), width: 1)
			}

			Text("Line with grid lines")
			HStack {
				DSFSparklineLineGraphView.SwiftUI(
					dataSource: LineSource1,
					graphColor: GraphColor,
					lineShading: false,
					gridLines: .init(values: [0, 0.25, 0.5, 0.75, 1.0])
				)
				.frame(height: 40.0)
				.padding(5)
				.border(Color.gray.opacity(0.2), width: 1)

				DSFSparklineLineGraphView.SwiftUI(
					dataSource: LineSource1,
					graphColor: GraphColor,
					interpolated: true,
					lineShading: false,
					gridLines: .init(values: [0, 0.4, 0.7, 0.9, 1.0])
				)
				.frame(height: 40.0)
				.padding(5)
				.border(Color.gray.opacity(0.2), width: 1)
			}
		}
	}
}

//struct LineDemoLineRanges2_Previews: PreviewProvider {
//	static var previews: some View {
//		LineDemoLineRanges2()
//	}
//}

struct LineDemoLineRanges2: View {

	let c0 = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.736,  0.169, 0.264, 1.000])!
	let c1 = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.927,  0.393, 0.265, 1.000])!
	let c2 = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.945,  0.593, 0.257, 1.000])!
	let c3 = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.950,  0.856, 0.373, 1.000])!
	let c4 = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.605,  0.815, 0.249, 1.000])!
	let c5 = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.674,  0.938, 0.561, 1.000])!

	let source: DSFSparkline.DataSource = {
		let d = DSFSparkline.DataSource(windowSize: 12, range: 0 ... 50)
		d.push(values: [
			12, 12, 3, 16, 18, 22, 11, 26, 22, 45, 13, 10
		])
		return d
	}()

	var body: some View {
		HStack {
			DSFSparklineLineGraphView.SwiftUI(
				dataSource: source,
				graphColor: DSFColor.white,
				lineWidth: 4,
				interpolated: true,
				lineShading: false,
				shadowed: true,
				highlightDefinitions: [
					DSFSparkline.HighlightRangeDefinition(
						range: 0 ..< 5,
						fillColor: c0
					),
					DSFSparkline.HighlightRangeDefinition(
						range: 5 ..< 10,
						fillColor: c1
					),
					DSFSparkline.HighlightRangeDefinition(
						range: 10 ..< 15,
						fillColor: c2
					),
					DSFSparkline.HighlightRangeDefinition(
						range: 15 ..< 20,
						fillColor: c3
					),
					DSFSparkline.HighlightRangeDefinition(
						range: 20 ..< 25,
						fillColor: c4
					),
					DSFSparkline.HighlightRangeDefinition(
						range: 25 ..< 50,
						fillColor: c5
					),
				]
			)
			.frame(height: 120.0)
			.padding(5)
			.border(Color.gray.opacity(0.2), width: 1)
		}
	}
}

struct LineDemoCustomMarkers: View {

	let source: DSFSparkline.DataSource = {
		let d = DSFSparkline.DataSource(windowSize: 20, range: 0 ... 1, zeroLineValue: 0.5)
		d.push(values: [
			0.72, 0.84, 0.15, 0.16, 0.30, 0.58, 0.87, 0.44, 0.02, 0.27,
			0.48, 0.16, 0.15, 0.14, 0.81, 0.53, 0.67, 0.52, 0.07, 0.50
		])
		return d
	}()

	var drawCurrentValueMarker: DSFSparklineOverlay.Line.MarkerDrawingBlock = { context, markerFrames in
		let l = markerFrames.last!
		context.setFillColor(l.isPositiveValue ? DSFColor.systemGreen.cgColor : DSFColor.systemRed.cgColor)
		context.fill(l.rect)
	}

	var customMarkerDrawing: DSFSparklineOverlay.Line.MarkerDrawingBlock = { context, markerFrames in

		// Get the frames containing the minimum and maximum values
		if let minMarker = markerFrames.min(by: { (a, b) -> Bool in a.value < b.value }),
			let maxMarker = markerFrames.min(by: { (a, b) -> Bool in a.value > b.value }) {

			// Draw minimum marker

			context.setFillColor(DSFColor.systemRed.cgColor)
			context.fill(minMarker.rect)
			context.setLineWidth(0.5)
			context.setStrokeColor(DSFColor.white.cgColor)
			context.stroke(minMarker.rect)

			// Draw maximum marker

			context.setFillColor(DSFColor.systemGreen.cgColor)
			context.fill(maxMarker.rect)

			context.setLineWidth(0.5)
			context.setStrokeColor(DSFColor.white.cgColor)
			context.stroke(maxMarker.rect)
		}
	}

	var body: some View {
		HStack {
			VStack {
				DSFSparklineLineGraphView.SwiftUI(
					dataSource: source,
					graphColor: DSFColor.systemGreen,
					lineWidth: 0.5,
					showZeroLine: true,
					centeredAtZeroLine: true,
					lowerGraphColor: DSFColor(red: 0.7, green: 0, blue: 0, alpha: 1.0),
					markerSize: 4,
					markerDrawingBlock: self.drawCurrentValueMarker
				)
				.frame(height: 40.0)
				.padding(5)
				.border(Color.gray.opacity(0.2), width: 1)
				Text("Current value marker").font(.footnote)
			}

			VStack {
				DSFSparklineLineGraphView.SwiftUI(
					dataSource: source,
					graphColor: DSFColor.systemGreen,
					lineWidth: 0.5,
					showZeroLine: true,
					centeredAtZeroLine: true,
					lowerGraphColor: DSFColor(red: 0.7, green: 0, blue: 0, alpha: 1.0),
					markerSize: 6,
					markerDrawingBlock: self.customMarkerDrawing
				)
				.frame(height: 40.0)
				.padding(5)
				.border(Color.gray.opacity(0.2), width: 1)
				Text("Min/Max marker").font(.footnote)
			}
		}
		.onAppear(perform: {
			startSomething()
		})
	}

	func startSomething() {
		if !IsRunningInPreviewPane {
			updateWithNewValues()
		}
	}

	func updateWithNewValues() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			source.push(value: CGFloat.random(in: 0.0 ... 1.0))
			updateWithNewValues()
		}
	}
}

struct LineGraphShowingBug13: View {
	let source: DSFSparkline.DataSource = {
		let d = DSFSparkline.DataSource(windowSize: 20, /*range: 0 ... 1,*/ zeroLineValue: 0)
		d.push(values: [
			0, 5, 4.5, 10, 8, 0, 60, 60, -60, -60, 60, 60, -60, -60, 60, 55
		])
		return d
	}()

	let source2: DSFSparkline.DataSource = {
		let d = DSFSparkline.DataSource(windowSize: 20, range: 0 ... 1, zeroLineValue: 0.25)
		d.push(values: [
			0.72, 0.84, 0.15, 0.16, 0.30, 0.58, 0.99, 0.99, 0.02, 0.07,
			0.48, 0.16, 0.15, 0.14, 0.81, 0.53, 0.67, 0.52, 0.07, 0.50
		])
		return d
	}()

	var body: some View {
		VStack {
			Text("Demonstrating interpolated line clipping")
			HStack {
				DSFSparklineLineGraphView.SwiftUI(
					dataSource: self.source,
					graphColor: DSFColor.systemIndigo,
					lineWidth: 1,
					lineShading: true,
					shadowed: true,
					centeredAtZeroLine: true,
					lowerGraphColor: DSFColor.systemRed,
					markerSize: 6,
					gridLines: .init(values: [-60, -30, 0, 30, 60])
				)
				.border(Color.gray.opacity(0.2), width: 1)
				.frame(width: 200, height: 100)

				DSFSparklineLineGraphView.SwiftUI(
					dataSource: self.source,
					graphColor: DSFColor.systemIndigo,
					lineWidth: 1,
					interpolated: true,
					lineShading: true,
					shadowed: true,
					markerSize: 6,
					gridLines: .init(values: [-60, -30, 0, 30, 60])
				)
				.border(Color.gray.opacity(0.2), width: 1)
				.frame(width: 200, height: 100)

				DSFSparklineLineGraphView.SwiftUI(
					dataSource: self.source,
					graphColor: DSFColor.systemIndigo,
					lineWidth: 1,
					interpolated: true,
					lineShading: true,
					shadowed: true,
					centeredAtZeroLine: true,
					lowerGraphColor: DSFColor.systemRed,
					markerSize: 6
				)
				.border(Color.gray.opacity(0.2), width: 1)
				.frame(width: 200, height: 100)
			}

			HStack {
				DSFSparklineSurface.SwiftUI([
					DSFSparklineOverlay.GridLines(
						dataSource: self.source2,
						floatValues: [0, 0.25, 0.5, 0.75, 1.0],
						strokeColor: CGColor(gray: 0.5, alpha: 0.3),
						strokeWidth: 0.5,
						dashStyle: [0.5, 0.5]
					),
					DSFSparklineOverlay.RangeHighlight(
						dataSource: self.source2,
						range: 0.75 ..< 1.0,
						fill: DSFSparkline.Fill.Color(CGColor(red: 1, green: 0, blue: 0, alpha: 0.1))
					),
					DSFSparklineOverlay.RangeHighlight(
						dataSource: self.source2,
						range: 0.5 ..< 0.75,
						fill: DSFSparkline.Fill.Color(CGColor(red: 1, green: 1, blue: 0, alpha: 0.1))
					),
					DSFSparklineOverlay.RangeHighlight(
						dataSource: self.source2,
						range: 0.0 ..< 0.5,
						fill: DSFSparkline.Fill.Color(CGColor(red: 0, green: 1, blue: 0, alpha: 0.1))
					),
					DSFSparklineOverlay.ZeroLine(
						dataSource: self.source2,
						strokeColor: CGColor(red: 1, green: 0, blue: 1, alpha: 1),
						strokeWidth: 1
					),
					{
						let d = DSFSparklineOverlay.Line()
						d.dataSource = self.source2
						d.interpolated = true
						d.primaryStrokeColor = CGColor(srgbRed: 1, green: 0, blue: 0, alpha: 1)
						d.markerSize = 3
						d.strokeWidth = 1.0
						return d
					}()
				])
				.frame(width: 200, height: 50)
				.border(Color.gray.opacity(0.2), width: 1)
			}
		}
	}
}

struct LineGraphShowingBug13_Previews: PreviewProvider {
	static var previews: some View {
		LineGraphShowingBug13()
	}
}

struct LineDemoContentView: View {
	var body: some View {
		ScrollView([.vertical, .horizontal]) {
			VStack(spacing: 8) {
				VStack {
					LineDemoBasic()
					LineDemoBasicMarkers()
					LineDemoMarkersAndShadow()
					LineDemoBasicZeroLine()
					LineDemoArea()
				}
				VStack {
					LineDemoAreaCentered()
					LineDemoAreaCenteredMarkers()
					LineDemoAreaCenteredMarkersNoLowerColor()
					LineDemoLineRanges()
					LineDemoLineRanges2()
				}
				VStack {
					Text("Custom markers").font(.headline)
					LineDemoCustomMarkers()
				}
				VStack {
					LineGraphShowingBug13()
				}
			}
			.frame(width: 400.0)
		}
	}
}


struct LineDemoContentView_Previews: PreviewProvider {
	static var previews: some View {
		LineDemoContentView()
	}
}
