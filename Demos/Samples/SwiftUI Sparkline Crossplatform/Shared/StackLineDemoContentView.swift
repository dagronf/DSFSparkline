//
//  StackLineDemoContentView.swift
//  Demos
//
//  Created by Darren Ford on 16/2/21.
//

import DSFSparkline
import SwiftUI

struct StackLineBasic: View {
	var body: some View {
		Text("Stackline")
		DSFSparklineStackLineGraphView.SwiftUI(
			dataSource: UpDataSource1,
			graphColor: DSFColor.systemGray,
			lineWidth: 1,
			shadowed: true
		)
		.frame(height: 40.0)
		.padding(5)
		.border(Color.gray.opacity(0.2), width: 1)
	}
}

struct StackLineZeroLine: View {
	var body: some View {
		Text("Stackline with zero-line")
		DSFSparklineStackLineGraphView.SwiftUI(
			dataSource: UpDataSource1,
			graphColor: DSFColor.systemPink,
			lineWidth: 1,
			showZeroLine: true
		)
		.frame(height: 40.0)
		.padding(5)
		.border(Color.gray.opacity(0.2), width: 1)
	}
}

struct StackLineCenteredZeroLine: View {
	var body: some View {
		Text("Stackline centered around zero-line")
		DSFSparklineStackLineGraphView.SwiftUI(
			dataSource: UpDataSource1,
			graphColor: DSFColor.systemBlue,
			lineWidth: 1,
			showZeroLine: true,
			centeredAtZeroLine: true
		)
		.frame(height: 40.0)
		.padding(5)
		.border(Color.gray.opacity(0.2), width: 1)
	}
}

struct StackLineCenteredZeroLineColored: View {
	var body: some View {
		Text("Stackline centered around zero-line, lower color, grid lines")
		DSFSparklineStackLineGraphView.SwiftUI(
			dataSource: UpDataSource1,
			graphColor: DSFColor.systemGreen,
			lineWidth: 1,
			shadowed: true,
			centeredAtZeroLine: true,
			lowerGraphColor: DSFColor.systemRed,
			gridLines: .init(width: 0.5, values: [0, 0.1, 0.2, 0.3, 0.4 ,0.5, 0.6, 0.7, 0.8, 0.9, 1.0])
		)
		.frame(height: 60.0)
		.padding(5)
		.border(Color.gray.opacity(0.2), width: 1)
	}
}

struct StackLineRange: View {
	var body: some View {
		Text("Stackline with range")
		DSFSparklineStackLineGraphView.SwiftUI(
			dataSource: UpDataSource2,
			graphColor: DSFColor.systemGreen,
			lineWidth: 1,
			showZeroLine: true,
			highlightDefinitions: [
				DSFSparkline.HighlightRangeDefinition(
					range: 20 ..< 80,
					fillColor: DSFColor.systemGray.withAlphaComponent(0.2).cgColor
				),
			]
		)
		.frame(width: 250.0, height: 59.0)
		.padding(5)
		.border(Color.gray.opacity(0.2), width: 1)
	}
}

struct StackLineNofill: View {
	var body: some View {
		Text("Stackline no fill")
		DSFSparklineStackLineGraphView.SwiftUI(
			dataSource: UpDataSource3,
			graphColor: DSFColor.systemYellow,
			lineWidth: 3,
			lineShading: false,
			shadowed: false
		)
		.frame(width: 330.0, height: 59.0)
		.padding(5)
		.border(Color.gray.opacity(0.2), width: 1)
	}
}

struct StackLineRange2: View {
	var body: some View {
		Text("StackLine with range")
		DSFSparklineStackLineGraphView.SwiftUI(
			dataSource: UpDataSource4,
			graphColor: DSFColor.systemRed,
			lineWidth: 0.5,
			shadowed: false,
			showZeroLine: true,
			highlightDefinitions: [
				DSFSparkline.HighlightRangeDefinition(
					range: 0.3 ..< 0.7,
					fillColor: DSFColor.systemPink.withAlphaComponent(0.1).cgColor
				),
			]
		)
		.frame(width: 330.0, height: 59.0)
		.padding(5)
		.border(Color.gray.opacity(0.2), width: 1)
	}
}

struct StackLineCenteredZeroLine2: View {
	var body: some View {
		Text("StackLine centered around zero-line")
		DSFSparklineStackLineGraphView.SwiftUI(
			dataSource: UpDataSource4,
			graphColor: DSFColor.systemGreen,
			lineWidth: 0.5,
			shadowed: false,
			showZeroLine: true,
			zeroLineDefinition: DSFSparkline.ZeroLineDefinition(
				color: DSFColor.systemGray,
				lineWidth: 1,
				lineDashStyle: []
			),
			centeredAtZeroLine: true,
			lowerGraphColor: DSFColor.systemPink
		)
		.frame(width: 100.0, height: 59.0)
		.padding(5)
		.border(Color.gray.opacity(0.2), width: 1)
	}
}

struct StackLineDemoContentView: View {
	var body: some View {
		ScrollView {
			VStack {
				StackLineBasic()
				StackLineZeroLine()
				StackLineCenteredZeroLine()
				StackLineCenteredZeroLineColored()
				StackLineRange()
				StackLineNofill()
				StackLineRange2()
				StackLineCenteredZeroLine2()
			}
		}
	}
}

struct StackLineDemoContentView_Previews: PreviewProvider {
	static var previews: some View {
		StackLineDemoContentView()
	}
}

private var UpDataSource1: DSFSparkline.DataSource = {
	let d = DSFSparkline.DataSource(windowSize: 20, range: 0 ... 1, zeroLineValue: 0.4)
	// d.push(values: [0.0, 0.3, 0.2, 0.1, 0.8, 0.7, 0.5, 0.6, 0.1, 0.9, 1])
	
	d.push(values: [
		0.85, 0.04, 0.24, 0.13, 0.51, 0.93, 0.26, 0.69, 0.16, 0.39,
		0.19, 0.12, 0.28, 0.42, 0.42, 0.48, 0.29, 0.05, 0.87, 0.28,
	])
	
	return d
}()

private var UpDataSource2: DSFSparkline.DataSource = {
	let d = DSFSparkline.DataSource(windowSize: 8, range: 0 ... 100)
	d.push(values: [100, 0, 25, 50, 75, 10, 10, 88])
	return d
}()

private var UpDataSource3: DSFSparkline.DataSource = {
	let d = DSFSparkline.DataSource(windowSize: 21, range: -1 ... 1)
	
	var sins: CGFloat = 0.0
	let r: Range<Int> = 0 ..< 21
	let vars: [CGFloat] = r.map { sin(CGFloat($0)) }
	d.push(values: vars)
	return d
}()

private var UpDataSource4: DSFSparkline.DataSource = {
	let d = DSFSparkline.DataSource(windowSize: 21, range: 0 ... 1)
	d.zeroLineValue = 0.5
	d.push(values: [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1, 0.0])
	return d
}()
