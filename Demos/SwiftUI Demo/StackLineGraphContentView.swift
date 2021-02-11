//
//  StackLineGraphContentView.swift
//  SwiftUI Demo
//
//  Created by Darren Ford on 27/1/21.
//

import SwiftUI
import DSFSparkline

var UpDataSource1: DSFSparklineDataSource = {
	let d = DSFSparklineDataSource(windowSize: 20, range: 0 ... 1, zeroLineValue: 0.4)
	//d.push(values: [0.0, 0.3, 0.2, 0.1, 0.8, 0.7, 0.5, 0.6, 0.1, 0.9, 1])

	d.push(values: [
				0.85, 0.04, 0.24, 0.13, 0.51, 0.93, 0.26, 0.69, 0.16, 0.39,
				0.19, 0.12, 0.28, 0.42, 0.42, 0.48, 0.29, 0.05, 0.87, 0.28
	])


	return d
}()

var UpDataSource2: DSFSparklineDataSource = {
	let d = DSFSparklineDataSource(windowSize: 8, range: 0 ... 100)
	d.push(values: [100, 0, 25, 50, 75, 10, 10, 88])
	return d
}()

var UpDataSource3: DSFSparklineDataSource = {
	let d = DSFSparklineDataSource(windowSize: 21, range: -1 ... 1)

	var sins: CGFloat = 0.0
	let r: Range<Int> = 0 ..< 21
	let vars: [CGFloat] = r.map { sin(CGFloat($0)) }
	d.push(values: vars)
	return d
}()

var UpDataSource4: DSFSparklineDataSource = {
	let d = DSFSparklineDataSource(windowSize: 21, range: 0 ... 1)
	d.zeroLineValue = 0.5
	d.push(values: [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1, 0.0])
	return d
}()


struct StackLineGraphContentView_Previews: PreviewProvider {
	static var previews: some View {
		VStack {

			VStack {
				Text("Stackline")

				DSFSparklineStackLineGraphView.SwiftUI(
					dataSource: UpDataSource1,
					graphColor: DSFColor.textColor,
					lineWidth: 1
				)
				.frame(height: 40.0)
				.padding(5)
				.border(Color.gray.opacity(0.2), width: 1)

				Text("Stackline with zero-line")

				DSFSparklineStackLineGraphView.SwiftUI(
					dataSource: UpDataSource1,
					graphColor: DSFColor.controlAccentColor,
					lineWidth: 1,
					showZeroLine: true
				)
				.frame(height: 40.0)
				.padding(5)
				.border(Color.gray.opacity(0.2), width: 1)

				Text("Stackline centered around zero-line")

				DSFSparklineStackLineGraphView.SwiftUI(
					dataSource: UpDataSource1,
					graphColor: DSFColor.linkColor,
					lineWidth: 1,
					showZeroLine: true,
					centeredAtZeroLine: true
				)
				.frame(height: 40.0)
				.padding(5)
				.border(Color.gray.opacity(0.2), width: 1)

				Text("Stackline centered around zero-line, lower color")

				DSFSparklineStackLineGraphView.SwiftUI(
					dataSource: UpDataSource1,
					graphColor: DSFColor.systemGreen,
					lineWidth: 1,
					//showZeroLine: true,
					centeredAtZeroLine: true,
					lowerGraphColor: DSFColor.systemRed
				)
				.frame(height: 60.0)
				.padding(5)
				.border(Color.gray.opacity(0.2), width: 1)
			}
			.frame(width: 330.0)

			Text("Stackline with range")

			DSFSparklineStackLineGraphView.SwiftUI(
				dataSource: UpDataSource2,
				graphColor: DSFColor.green,
				lineWidth: 1,
				showZeroLine: true,
				highlightDefinitions: [
					DSFSparklineHighlightRangeDefinition(
						range: 20 ..< 80,
						highlightColor: DSFColor.placeholderTextColor.withAlphaComponent(0.2)
					)
				]
			)
			.frame(width: 250.0, height: 59.0)
			.padding(5)
			.border(Color.gray.opacity(0.2), width: 1)

			Text("Stackline no fill")

			DSFSparklineStackLineGraphView.SwiftUI(
				dataSource: UpDataSource3,
				graphColor: DSFColor.yellow,
				lineWidth: 3,
				lineShading: false,
				shadowed: false
			)
			.frame(width: 330.0, height: 59.0)
			.padding(5)
			.border(Color.gray.opacity(0.2), width: 1)

			Text("StackLine with range")

			DSFSparklineStackLineGraphView.SwiftUI(
				dataSource: UpDataSource4,
				graphColor: DSFColor.red,
				lineWidth: 0.5,
				shadowed: false,
				showZeroLine: true,
				highlightDefinitions: [
					DSFSparklineHighlightRangeDefinition(
						range: 0.3 ..< 0.7,
						highlightColor: DSFColor.systemPink.withAlphaComponent(0.1)
					)
				]
			)
			.frame(width: 330.0, height: 59.0)
			.padding(5)
			.border(Color.gray.opacity(0.2), width: 1)

			Text("StackLine centered around zero-line")

			DSFSparklineStackLineGraphView.SwiftUI(
				dataSource: UpDataSource4,
				graphColor: DSFColor.green,
				lineWidth: 0.5,
				shadowed: false,
				showZeroLine: true,
				zeroLineDefinition: DSFSparklineZeroLineDefinition(color: .textColor, lineWidth: 1, lineDashStyle: []),
				centeredAtZeroLine: true,
				lowerGraphColor: DSFColor.systemPink
			)
			.frame(width: 330.0, height: 59.0)
			.padding(5)
			.border(Color.gray.opacity(0.2), width: 1)
		}
		.padding(10)
		.frame(height: 900.0)
	}
}
