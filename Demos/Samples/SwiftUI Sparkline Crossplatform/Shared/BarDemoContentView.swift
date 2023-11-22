//
//  StackLineDemoContentView.swift
//  Demos
//
//  Created by Darren Ford on 16/2/21.
//

import SwiftUI
import DSFSparkline

struct BarBasic: View {
	var body: some View {
		Text("Bar")
		DSFSparklineBarGraphView.SwiftUI(
			dataSource: BarDataSource1,
			graphColor: DSFColor.systemGray,
			lineWidth: 2,
			barSpacing: 2
		)
		.frame(height: 40.0)
		.padding(5)
		.border(Color.gray.opacity(0.2), width: 1)
	}
}

struct BarZeroLine: View {
	var body: some View {
		Text("Bar with zero-line")
		DSFSparklineBarGraphView.SwiftUI(
			dataSource: BarDataSource1,
			graphColor: DSFColor.systemPink,
			lineWidth: 1,
			barSpacing: 0,
			showZeroLine: true
		)
		.frame(height: 40.0)
		.padding(5)
		.border(Color.gray.opacity(0.2), width: 1)
	}
}

struct BarCenteredZeroLine: View {
	var body: some View {
		Text("Bar centered around zero-line")
		DSFSparklineBarGraphView.SwiftUI(
			dataSource: BarDataSource1,
			graphColor: DSFColor.systemBlue,
			lineWidth: 2,
			barSpacing: 4,
			showZeroLine: true,
			centeredAtZeroLine: true
		)
		.frame(height: 40.0)
		.padding(5)
		.border(Color.gray.opacity(0.2), width: 1)
	}
}


struct BarCenteredZeroLineColored: View {
	var body: some View {
		Text("Bar centered around zero-line, lower color")
		DSFSparklineBarGraphView.SwiftUI(
			dataSource: BarDataSource1,
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
}

struct BarRange: View {
	var body: some View {
		Text("Bar with range")
		DSFSparklineBarGraphView.SwiftUI(
			dataSource: BarDataSource2,
			graphColor: DSFColor.systemGreen,
			lineWidth: 1,
			showZeroLine: true,
			highlightDefinitions: [
				DSFSparkline.HighlightRangeDefinition(
					range: 20 ..< 80,
					fillColor: DSFColor.systemGray.withAlphaComponent(0.2).cgColor
				)
			],
			gridLines: .init(values: [0, 25, 50, 75, 100])
		)
		.frame(width: 250.0, height: 59.0)
		.padding(5)
		.border(Color.gray.opacity(0.2), width: 1)
	}
}

struct BarNofill: View {
	var body: some View {
		Text("Bar no fill")
		DSFSparklineBarGraphView.SwiftUI(
			dataSource: BarDataSource3,
			graphColor: DSFColor.systemYellow,
			lineWidth: 3
		)
		.frame(width: 330.0, height: 59.0)
		.padding(5)
		.border(Color.gray.opacity(0.2), width: 1)
	}
}

struct BarRange2: View {
	var body: some View {
		Text("Bar with range")
		DSFSparklineBarGraphView.SwiftUI(
			dataSource: BarDataSource4,
			graphColor: DSFColor.systemRed,
			lineWidth: 1,
			showZeroLine: true,
			highlightDefinitions: [
				DSFSparkline.HighlightRangeDefinition(
					range: 0.3 ..< 0.7,
					fillColor: DSFColor.systemPink.withAlphaComponent(0.1).cgColor
				)
			]
		)
		.frame(width: 330.0, height: 59.0)
		.padding(5)
		.border(Color.gray.opacity(0.2), width: 1)
	}
}

struct BarCenteredZeroLine2: View {
	var body: some View {
		Text("Bar centered around zero-line")
		DSFSparklineBarGraphView.SwiftUI(
			dataSource: BarDataSource4,
			graphColor: DSFColor.systemGreen,
			lineWidth: 1,
			showZeroLine: true,
			zeroLineDefinition: DSFSparkline.ZeroLineDefinition(
				color: DSFColor.systemGray,
				lineWidth: 1,
				lineDashStyle: []),
			centeredAtZeroLine: true,
			lowerGraphColor: DSFColor.systemPink
		)
		.frame(width: 100.0, height: 59.0)
		.padding(5)
		.border(Color.gray.opacity(0.2), width: 1)
	}
}


struct BarDemoContentView: View {
	var body: some View {
		ScrollView {
			VStack {
				BarBasic()
				BarZeroLine()
				BarCenteredZeroLine()
				BarCenteredZeroLineColored()
				BarRange()
				BarNofill()
				BarRange2()
				BarCenteredZeroLine2()
			}
		}
	}
}

struct BarDemoContentView_Previews: PreviewProvider {
    static var previews: some View {
		BarDemoContentView()
    }
}





fileprivate var BarDataSource1: DSFSparkline.DataSource = {
	let d = DSFSparkline.DataSource(windowSize: 20, range: 0 ... 1, zeroLineValue: 0.4)
	//d.push(values: [0.0, 0.3, 0.2, 0.1, 0.8, 0.7, 0.5, 0.6, 0.1, 0.9, 1])

	d.push(values: [
				0.85, 0.04, 0.24, 0.13, 0.51, 0.93, 0.26, 0.69, 0.16, 0.39,
				0.19, 0.12, 0.28, 0.42, 0.42, 0.48, 0.29, 0.05, 0.87, 0.28
	])

	return d
}()

fileprivate var BarDataSource2: DSFSparkline.DataSource = {
	let d = DSFSparkline.DataSource(windowSize: 8, range: 0 ... 100)
	d.push(values: [100, 0, 25, 50, 75, 10, 10, 88])
	return d
}()

fileprivate var BarDataSource3: DSFSparkline.DataSource = {
	let d = DSFSparkline.DataSource(windowSize: 21, range: -1 ... 1)

	var sins: CGFloat = 0.0
	let r: Range<Int> = 0 ..< 21
	let vars: [CGFloat] = r.map { sin(CGFloat($0)) }
	d.push(values: vars)
	return d
}()

fileprivate var BarDataSource4: DSFSparkline.DataSource = {
	let d = DSFSparkline.DataSource(windowSize: 21, range: 0 ... 1)
	d.zeroLineValue = 0.5
	d.push(values: [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1, 0.0])
	return d
}()
