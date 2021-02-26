//
//  LineDemoContentView.swift
//  SwiftUI Demo
//
//  Created by Darren Ford on 27/1/21.
//

import SwiftUI
import DSFSparkline

var LineSource1: DSFSparklineDataSource = {
	let d = DSFSparklineDataSource(windowSize: 20, range: 0 ... 1, zeroLineValue: 0.5)
	d.push(values: [
		0.72, 0.84, 0.15, 0.16, 0.30, 0.58, 0.87, 0.44, 0.02, 0.27,
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

struct LineDemoBasicMarkers: View {
	var body: some View {
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

struct LineDemoMarkersAndShadow: View {
	var body: some View {
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

struct LineDemoBasicZeroLine: View {
	var body: some View {
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

struct LineDemoArea: View {
	var body: some View {
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

struct LineDemoAreaCentered: View {
	var body: some View {
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

struct LineDemoAreaCenteredMarkers: View {
	var body: some View {
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

struct LineDemoLineRanges: View {
	var body: some View {
		Text("Line with ranges")
		HStack {
			DSFSparklineLineGraphView.SwiftUI(
				dataSource: LineSource1,
				graphColor: GraphColor,
				lineShading: false,
				highlightDefinitions: [
					DSFSparklineHighlightRangeDefinition(
						range: 0.7 ..< 1.0,
						fillColor: DSFColor.red.withAlphaComponent(0.15).cgColor
					),
					DSFSparklineHighlightRangeDefinition(
						range: 0.3 ..< 0.7,
						fillColor: DSFColor.yellow.withAlphaComponent(0.15).cgColor
					),
					DSFSparklineHighlightRangeDefinition(
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
					DSFSparklineHighlightRangeDefinition(
						range: 0.4 ..< 0.6,
						fillColor: DSFColor.systemGray.withAlphaComponent(0.3).cgColor
					)
				]
			)
			.frame(height: 40.0)
			.padding(5)
			.border(Color.gray.opacity(0.2), width: 1)
		}
	}
}

struct LineDemoContentView: View {
	var body: some View {
		ScrollView([.vertical, .horizontal]) {
			VStack {
				LineDemoBasic()
				LineDemoBasicMarkers()
				LineDemoMarkersAndShadow()
				LineDemoBasicZeroLine()
				LineDemoArea()
				LineDemoAreaCentered()
				LineDemoAreaCenteredMarkers()
				LineDemoLineRanges()
			}
			.frame(width: 400.0)
			.padding(10)
		}
	}
}


struct LineDemoContentView_Previews: PreviewProvider {
	static var previews: some View {
		LineDemoContentView()
	}
}
