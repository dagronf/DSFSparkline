//
//  ContentView.swift
//  Shared
//
//  Created by Darren Ford on 27/1/21.
//

import DSFSparkline
import SwiftUI

struct UserResults {
	let name: String
	var values: [Int]
	
	let dataSource = DSFSparklineDataSource(windowSize: 5)
	
	init(name: String, values: [Int]) {
		self.name = name
		self.values = values
		self.dataSource.set(values: self.values.map { CGFloat($0) })
	}
}

struct SalesResult {
	let name: String
	var values: [CGFloat]
	var maximumTotal: CGFloat

	init(name: String, values: [CGFloat], maximumTotal: CGFloat) {
		self.name = name
		self.values = values
		self.maximumTotal = maximumTotal
	}
}

struct ReportView: View {

	static func Make() -> ReportView {
		return ReportView()
	}

	var gridItems1: [GridItem] = [
		GridItem(.fixed(35), spacing: 2),
		GridItem(.fixed(35), spacing: 2),
		GridItem(.fixed(35), spacing: 2),
		GridItem(.fixed(35), spacing: 2),
		GridItem(.fixed(35), spacing: 2),
		GridItem(.fixed(35), spacing: 2),
	]
	
	let userItems1: [UserResults] = [
		UserResults(name: "Aiden", values: [90, 120, 110, 130, 115]),
		UserResults(name: "Ethan", values: [100, 95, 115, 120, 118]),
		UserResults(name: "Jackson", values: [120, 125, 140, 130, 135]),
		UserResults(name: "Lucas", values: [118, 120, 125, 128, 135]),
		UserResults(name: "Noah", values: [130, 130, 125, 120, 90]),
	]
	
	var gridItems2: [GridItem] = [
		GridItem(.fixed(35), spacing: 2),
		GridItem(.fixed(35), spacing: 2),
		GridItem(.fixed(35), spacing: 2),
		GridItem(.fixed(35), spacing: 2),
		GridItem(.fixed(35), spacing: 2),
		GridItem(.fixed(35), spacing: 2),
	]
	
	let userItems2: [UserResults] = [
		UserResults(name: "Aiden", values: [1, 1, -1, 1, -1, 1, 1, 1]),
		UserResults(name: "Ethan", values: [1, 1, -1, 1, 1, -1, 1, -1]),
		UserResults(name: "Jackson", values: [-1, 1, 1, -1, -1, 1, 1, 1]),
		UserResults(name: "Lucas", values: [1, -1, -1, 1, 1, -1, -1, 1]),
		UserResults(name: "Noah", values: [-1, 1, 1, 1, -1, 1, 1, 1]),
	]

	let salesItems: [SalesResult] = [
		SalesResult(name: "Aiden", values: [120, 200, 0, 270], maximumTotal: 1000),
		SalesResult(name: "Ethan", values: [300, 400, 100, 90], maximumTotal: 1000),
		SalesResult(name: "Jackson", values: [100, 140, 90, 110], maximumTotal: 1000),
		SalesResult(name: "Lucas", values: [250, 250, 100, 100], maximumTotal: 1000),
		SalesResult(name: "Noah", values: [300, 100, 200, 270], maximumTotal: 1000),
	]

	var body: some View {
		ScrollView([.vertical, .horizontal]) {
			VStack {
				Text("Exam Results")
				
				LazyHGrid(rows: gridItems1) {
					ForEach(0 ..< 5, id: \.self) { number in
						HStack {
							Text(userItems1[number].name)
								.frame(width: 80, alignment: .leading)
							ForEach(0 ..< 5, id: \.self) { count in
								Text("\(userItems1[number].values[count])")
									.frame(width: 30, alignment: .center)
							}
							DSFSparklineLineGraphView.SwiftUI(
								dataSource: userItems1[number].dataSource,
								graphColor: DSFColor.systemBlue,
								lineShading: false
							)
							.frame(width: 120)
						}
						.padding(8)
						.background(number % 2 == 0 ? Color(Color.RGBColorSpace.sRGB, red: 0, green: 0, blue: 0, opacity: 0.1) : Color.clear)
					}
				}
				.frame(maxWidth: .infinity)
				
				Text("Team Wins/Losses")
				
				LazyHGrid(rows: gridItems2) {
					ForEach(0 ..< 5, id: \.self) { number in
						HStack {
							Text(userItems2[number].name)
								.frame(width: 80, alignment: .leading)
							ForEach(0 ..< 8, id: \.self) { count in
								Text("\(userItems2[number].values[count])")
									.frame(width: 25, alignment: .center)
							}
							DSFSparklineWinLossGraphView.SwiftUI(
								dataSource: userItems2[number].dataSource,
								barSpacing: 3,
								showZeroLine: true,
								zeroLineDefinition: .init(color: .systemGray,
																  lineWidth: 1,
																  lineDashStyle: [1, 1])
							)
							.frame(width: 120)
							DSFSparklineTabletGraphView.SwiftUI(
								dataSource: userItems2[number].dataSource,
								barSpacing: 2
							)
							.frame(width: 200, height: 12)
						}
						.padding(4)
						.background(number % 2 == 0 ? Color(Color.RGBColorSpace.sRGB, red: 0, green: 0, blue: 0, opacity: 0.1) : Color.clear)
					}
				}
				.frame(maxWidth: .infinity)

				Text("Team Sales")

				LazyHGrid(rows: gridItems2) {
					ForEach(0 ..< 5, id: \.self) { number in
						HStack(spacing: 10) {
							Text(salesItems[number].name)
								.frame(width: 80, alignment: .leading)
							ForEach(0 ..< 4, id: \.self) { count in
								Text("\(salesItems[number].values[count], specifier: "%.2f")")
									.frame(width: 60, alignment: .trailing)
							}

							DSFSparklineLineGraphView.SwiftUI(
								dataSource: DSFSparklineDataSource(values: salesItems[number].values),
								graphColor: DSFColor.systemBlue,
								lineShading: false,
								markerSize: 6
							)
							.frame(width: 120)

							DSFSparklinePieGraphView.SwiftUI(
								dataSource: salesItems[number].values
							)
							.frame(width: 28, height: 28)

							DSFSparklineDataBarGraphView.SwiftUI(
								dataSource: salesItems[number].values,
								maximumTotalValue: salesItems[number].maximumTotal,
								unsetColor: DSFColor.black.withAlphaComponent(0.2)
							)
							.frame(width: 120)

						}
						.padding(4)
						.background(number % 2 == 0 ? Color(Color.RGBColorSpace.sRGB, red: 0, green: 0, blue: 0, opacity: 0.1) : Color.clear)
					}
				}
				.frame(maxWidth: .infinity)
			}
		}
	}
}

struct ReportView_Previews: PreviewProvider {
	static var previews: some View {
		ReportView()
	}
}

