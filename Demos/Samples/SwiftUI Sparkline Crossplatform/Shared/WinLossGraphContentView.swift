//
//  WinLossGraphContentView.swift
//  SwiftUI Demo
//
//  Created by Darren Ford on 26/1/21.
//

import SwiftUI
import DSFSparkline

func WinLossCreate() -> some View {
	return WinLossGraphContentView(
		leftDataSource: WinLossDataSource1,
		rightDataSource: WinLossDataSource2,
		upDataSource: WinLossDataSource3,
		tablet1: TabletDataSource1)
}

struct WinLossGraphContentView: View {

	let leftDataSource: DSFSparklineDataSource
	let rightDataSource: DSFSparklineDataSource
	let upDataSource: DSFSparklineDataSource
	let tablet1: DSFSparklineDataSource

	var body: some View {
		VStack(spacing: 8) {

			Text("Win/Loss")

			DSFSparklineWinLossGraphView.SwiftUI(
				dataSource: leftDataSource
			)
			.padding(5)
			.border(Color.gray.opacity(0.2), width: 1)

			Text("Win/Loss/Tie")

			DSFSparklineWinLossGraphView.SwiftUI(
				dataSource: rightDataSource,
				winColor: .systemIndigo,
				lossColor: .systemTeal,
				tieColor: DSFColor.systemGray.withAlphaComponent(0.1),
				lineWidth: 3,
				barSpacing: 6
			)
			.padding(5)
			.border(Color.gray.opacity(0.2), width: 1)

			Text("Win/Loss/Tie with zero-line")

			DSFSparklineWinLossGraphView.SwiftUI(
				dataSource: upDataSource,
				winColor: .systemGreen,
				lossColor: .systemRed,
				tieColor: DSFColor.systemYellow.withAlphaComponent(0.2),
				barSpacing: 3,
				showZeroLine: true,
				zeroLineDefinition: DSFSparklineZeroLineDefinition(color: .systemGray)
			)
			.frame(width: 330.0, height: 34.0)
			.padding(5)
			.border(Color.gray.opacity(0.2), width: 1)

			Text("Tablet")

			VStack {
				DSFSparklineTabletGraphView.SwiftUI(
					dataSource: TabletDataSource1,
					winColor: .systemTeal,
					lossColor: DSFColor.systemGray.withAlphaComponent(0.2),
					barSpacing: 2
				)
				.padding(5)
				.border(Color.gray.opacity(0.2), width: 1)

				DSFSparklineTabletGraphView.SwiftUI(
					dataSource: TabletDataSource1,
					lineWidth: 0.5,
					barSpacing: 2
				)
				.padding(5)
				.border(Color.gray.opacity(0.2), width: 1)
				.frame(width: 200, height: 20)
			}
			.frame(height: 60)
		}
		.frame(height: 400)
		.padding()
	}
}

var WinLossDataSource1: DSFSparklineDataSource = {
	let d = DSFSparklineDataSource(windowSize: 10, range: -1.0 ... 1)
	d.push(values: [1, -1, 0, 1, -1, -1, 1, -1, 0, 1])
	return d
}()

var WinLossDataSource2: DSFSparklineDataSource = {
	let d = DSFSparklineDataSource(windowSize: 10, range: -1.0 ... 1.0)
	d.push(values: [20, 10, 0, -10, -20, -30, 40, 50, 0, 70])
	return d
}()

var WinLossDataSource3: DSFSparklineDataSource = {
	let d = DSFSparklineDataSource(windowSize: 20, range: -1 ... 1)
	d.push(values: [1, 1, 1, -1, 1, 0, -1, -1, 1, 1, 1, -1, -1, 1, 1, 0, -1, 1, 1, 1])
	return d
}()

var TabletDataSource1: DSFSparklineDataSource = {
	let d = DSFSparklineDataSource(windowSize: 20, range: -1 ... 1)
	d.push(values: [1, 1, 1, -1, 1, 0, -1, -1, 1, 1, 1, -1, -1, 1, 1, 0, -1, 1, 1, 1])
	return d
}()

struct WinLossGraphContentView_Previews: PreviewProvider {
	static var previews: some View {
		WinLossGraphContentView(leftDataSource: WinLossDataSource1,
										rightDataSource: WinLossDataSource2,
										upDataSource: WinLossDataSource3,
										tablet1: TabletDataSource1)
	}
}
