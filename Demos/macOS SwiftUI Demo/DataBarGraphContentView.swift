//
//  PieGraphContentView.swift
//  SwiftUI Demo
//
//  Created by Darren Ford on 26/1/21.
//

import SwiftUI
import DSFSparkline

//let palette1 = DSFSparklinePalette([.systemRed, .systemOrange, .systemYellow])
//let grays = DSFSparklinePalette([
//	DSFColor.init(deviceWhite: 1.00, alpha: 1),
//	DSFColor.init(deviceWhite: 0.66, alpha: 1),
//	DSFColor.init(deviceWhite: 0.33, alpha: 1)
//])


let firstDataSourceDataBar: [CGFloat] = [10, 40, 25]
let secondDataSourceDataBar: [CGFloat] = [33, 33, 33]
let thirdDataSourceDataBar: [CGFloat] = [85, 10, 19]
let fourthDataSourceDataBar: [CGFloat] = [3, 4, 5]


struct DataBarGraphContentView_Previews: PreviewProvider {
	static var previews: some View {

		VStack(spacing: 8) {

			HStack(spacing: 8) {
				Text("No stroke").frame(width: 70, alignment: Alignment.trailing)
				DSFSparklineDataBarGraphView.SwiftUI(
					dataSource: firstDataSource,
					palette: palette1
				)
				.frame(width: 72, height: 24)

				DSFSparklineDataBarGraphView.SwiftUI(
					dataSource: secondDataSource,
					palette: palette1
				)
				.frame(width: 72, height: 24)

				DSFSparklineDataBarGraphView.SwiftUI(
					dataSource: thirdDataSource,
					palette: palette1
				)
				.frame(width: 72, height: 24)
			}

			HStack(spacing: 8) {
				Text("Stroke").frame(width: 70, alignment: Alignment.trailing)
				DSFSparklineDataBarGraphView.SwiftUI(
					dataSource: firstDataSource,
					strokeColor: DSFColor.black,
					lineWidth: 1
				)
				.frame(width: 72, height: 24)

				DSFSparklineDataBarGraphView.SwiftUI(
					dataSource: secondDataSource,
					strokeColor: DSFColor.black,
					lineWidth: 1
				)
				.frame(width: 72, height: 24)

				DSFSparklineDataBarGraphView.SwiftUI(
					dataSource: thirdDataSource,
					strokeColor: DSFColor.black,
					lineWidth: 1
				)
				.frame(width: 72, height: 24)
			}

			HStack(spacing: 8) {
				DSFSparklineDataBarGraphView.SwiftUI(
					dataSource: fourthDataSource,
					palette: grays
				)
				.frame(width: 72, height: 36)

				DSFSparklineDataBarGraphView.SwiftUI(
					dataSource: [CGFloat](repeating: 10.0, count: DSFSparklinePalette.shared.colors.count),
					strokeColor: DSFColor.black.withAlphaComponent(0.5),
					lineWidth: 1
				)
				.frame(width: 72, height: 36)

				DSFSparklineDataBarGraphView.SwiftUI(
					dataSource: [CGFloat](repeating: 10.0, count: DSFSparklinePalette.sharedGrays.colors.count),
					palette: .sharedGrays,
					strokeColor: DSFColor.black.withAlphaComponent(0.5),
					lineWidth: 1
				)
				.frame(width: 72, height: 36)

				DSFSparklineDataBarGraphView.SwiftUI(
					dataSource: [5, 2, 4, 8],
					strokeColor: DSFColor.textColor,
					lineWidth: 1
				)
				.frame(width: 72, height: 36)
			}

			HStack(spacing: 8) {
				DSFSparklineDataBarGraphView.SwiftUI(
					dataSource: fourthDataSource,
					palette: grays,
					animated: true,
					animationDuration: 1.0
				)
				.frame(width: 72, height: 36)

				DSFSparklineDataBarGraphView.SwiftUI(
					dataSource: [CGFloat](repeating: 10.0, count: DSFSparklinePalette.shared.colors.count),
					strokeColor: DSFColor.black.withAlphaComponent(0.5),
					lineWidth: 1,
					animated: true,
					animationDuration: 1.0
				)
				.frame(width: 72, height: 36)

				DSFSparklineDataBarGraphView.SwiftUI(
					dataSource: [CGFloat](repeating: 10.0, count: DSFSparklinePalette.sharedGrays.colors.count),
					palette: .sharedGrays,
					strokeColor: DSFColor.black.withAlphaComponent(0.5),
					lineWidth: 1,
					animated: true,
					animationDuration: 1.0
				)
				.frame(width: 72, height: 36)

				DSFSparklineDataBarGraphView.SwiftUI(
					dataSource: [5, 2, 4, 8],
					strokeColor: DSFColor.textColor,
					lineWidth: 1,
					animated: true,
					animationDuration: 1.0
				)
				.frame(width: 72, height: 36)
			}
		}

		.padding()
	}
}
