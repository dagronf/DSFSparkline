//
//  LineGraphContentView.swift
//  SwiftUI Demo
//
//  Created by Darren Ford on 27/1/21.
//

import SwiftUI
import DSFSparkline

var LineSource1: DSFSparklineDataSource = {
	let d = DSFSparklineDataSource(windowSize: 30, range: 0 ... 1, zeroLineValue: 0.4)
	d.push(values: [
		0.72, 0.84, 0.15, 0.16, 0.30, 0.58, 0.87, 0.44, 0.02, 0.27,
		0.48, 0.16, 0.15, 0.14, 0.81, 0.53, 0.67, 0.52, 0.07, 0.20,
		0.93, 0.71, 0.08, 0.13, 0.92, 0.02, 0.50, 0.25, 0.44, 0.02
	])
	return d
}()

struct LineGraphContentView_Previews: PreviewProvider {
	static var previews: some View {
		VStack {

			VStack {

				Text("Line")

				HStack {
					DSFSparklineLineGraphView.SwiftUI(
						dataSource: LineSource1,
						graphColor: DSFColor.textColor,
						lineWidth: 1,
						lineShading: false
					)
					.frame(height: 40.0)
					.padding(5)
					.border(Color.gray.opacity(0.2), width: 1)

					DSFSparklineLineGraphView.SwiftUI(
						dataSource: LineSource1,
						graphColor: DSFColor.textColor,
						lineWidth: 1,
						interpolated: true,
						lineShading: false
					)
					.frame(height: 40.0)
					.padding(5)
					.border(Color.gray.opacity(0.2), width: 1)
				}
				.frame(width: 400.0)

				Text("Line with zero-line added")

				HStack {
					DSFSparklineLineGraphView.SwiftUI(
						dataSource: LineSource1,
						graphColor: DSFColor.textColor,
						lineWidth: 1,
						lineShading: false,
						showZeroLine: true
					)
					.frame(height: 40.0)
					.padding(5)
					.border(Color.gray.opacity(0.2), width: 1)

					DSFSparklineLineGraphView.SwiftUI(
						dataSource: LineSource1,
						graphColor: DSFColor.textColor,
						lineWidth: 1,
						interpolated: true,
						lineShading: false,
						showZeroLine: true
					)
					.frame(height: 40.0)
					.padding(5)
					.border(Color.gray.opacity(0.2), width: 1)
				}
				.frame(width: 400.0)

				Text("Area")

				HStack {
					DSFSparklineLineGraphView.SwiftUI(
						dataSource: LineSource1,
						graphColor: DSFColor.textColor,
						showZeroLine: true
					)
					.frame(height: 40.0)
					.padding(5)
					.border(Color.gray.opacity(0.2), width: 1)

					DSFSparklineLineGraphView.SwiftUI(
						dataSource: LineSource1,
						graphColor: DSFColor.textColor,
						interpolated: true,
						showZeroLine: true
					)
					.frame(height: 40.0)
					.padding(5)
					.border(Color.gray.opacity(0.2), width: 1)
				}
				.frame(width: 400.0)

				Text("Line centered")

				HStack {
					DSFSparklineLineGraphView.SwiftUI(
						dataSource: LineSource1,
						graphColor: DSFColor.systemGreen,
						lineWidth: 0.5,
						showZeroLine: true,
						centeredAtZeroLine: true,
						lowerGraphColor: DSFColor(calibratedRed: 0.7, green: 0, blue: 0, alpha: 1.0)
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
						lowerGraphColor: DSFColor(calibratedRed: 0.7, green: 0, blue: 0, alpha: 1.0)
					)
					.frame(height: 40.0)
					.padding(5)
					.border(Color.gray.opacity(0.2), width: 1)
				}
				.frame(width: 400.0)
			}

			VStack {
				Text("Line with ranges")

				HStack {
					DSFSparklineLineGraphView.SwiftUI(
						dataSource: LineSource1,
						graphColor: DSFColor.textColor,
						lineShading: false,
						highlightDefinitions: [
							DSFSparklineHighlightRangeDefinition(
								range: 0.7 ..< 1.0,
								highlightColor: DSFColor.red.withAlphaComponent(0.15)
							),
							DSFSparklineHighlightRangeDefinition(
								range: 0.3 ..< 0.7,
								highlightColor: DSFColor.yellow.withAlphaComponent(0.15)
							),
							DSFSparklineHighlightRangeDefinition(
								range: 0.0 ..< 0.3,
								highlightColor: DSFColor.green.withAlphaComponent(0.15)
							)
						]
					)
					.frame(height: 40.0)
					.padding(5)
					.border(Color.gray.opacity(0.2), width: 1)

					HStack {
						DSFSparklineLineGraphView.SwiftUI(
							dataSource: LineSource1,
							graphColor: DSFColor.textColor,
							interpolated: true,
							lineShading: false,
							highlightDefinitions: [
								DSFSparklineHighlightRangeDefinition(
									range: 0.4 ..< 0.6,
									highlightColor: DSFColor.placeholderTextColor.withAlphaComponent(0.3)
								)
							]
						)
						.frame(height: 40.0)
						.padding(5)
						.border(Color.gray.opacity(0.2), width: 1)
					}
				}
				.frame(width: 400.0)
			}
		}
		.padding(10)
		.frame(height: 600.0)
	}
}
