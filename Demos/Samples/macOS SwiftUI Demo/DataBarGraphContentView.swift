//
//  PieGraphContentView.swift
//  SwiftUI Demo
//
//  Created by Darren Ford on 26/1/21.
//

import SwiftUI
import DSFSparkline

fileprivate let firstDataSourceDataBar: [CGFloat] = [10, 40, 25]
fileprivate let secondDataSourceDataBar: [CGFloat] = [33, 33, 33]
fileprivate let thirdDataSourceDataBar: [CGFloat] = [85, 10, 19]
fileprivate let fourthDataSourceDataBar: [CGFloat] = [3, 4, 5]

fileprivate let palette1 = DSFSparklinePalette([.systemRed, .systemOrange, .systemYellow])
fileprivate let grays = DSFSparklinePalette([
	DSFColor.init(deviceWhite: 1.00, alpha: 1),
	DSFColor.init(deviceWhite: 0.66, alpha: 1),
	DSFColor.init(deviceWhite: 0.33, alpha: 1)
])

struct DataBarGraphContentView_Previews: PreviewProvider {
	static var previews: some View {

		VStack(spacing: 8) {

			HStack(spacing: 8) {
				Text("No stroke").frame(width: 70, alignment: Alignment.trailing)
				DSFSparklineDataBarGraphView.SwiftUI(
					dataSource: firstDataSourceDataBar,
					palette: palette1
				)
				.frame(width: 96, height: 24)

				DSFSparklineDataBarGraphView.SwiftUI(
					dataSource: secondDataSourceDataBar,
					palette: palette1
				)
				.frame(width: 96, height: 24)

				DSFSparklineDataBarGraphView.SwiftUI(
					dataSource: thirdDataSourceDataBar,
					palette: palette1
				)
				.frame(width: 96, height: 24)
			}

			HStack(spacing: 8) {
				Text("Stroke").frame(width: 70, alignment: Alignment.trailing)
				DSFSparklineDataBarGraphView.SwiftUI(
					dataSource: firstDataSourceDataBar,
					strokeColor: DSFColor.black,
					lineWidth: 1
				)
				.frame(width: 96, height: 24)

				DSFSparklineDataBarGraphView.SwiftUI(
					dataSource: secondDataSourceDataBar,
					strokeColor: DSFColor.black,
					lineWidth: 1
				)
				.frame(width: 96, height: 24)

				DSFSparklineDataBarGraphView.SwiftUI(
					dataSource: thirdDataSourceDataBar,
					strokeColor: DSFColor.black,
					lineWidth: 1
				)
				.frame(width: 96, height: 24)
			}

			HStack(spacing: 8) {
				DSFSparklineDataBarGraphView.SwiftUI(
					dataSource: fourthDataSourceDataBar,
					palette: grays
				)
				.frame(width: 96, height: 36)

				DSFSparklineDataBarGraphView.SwiftUI(
					dataSource: [CGFloat](repeating: 10.0, count: DSFSparklinePalette.shared.colors.count),
					strokeColor: DSFColor.black.withAlphaComponent(0.5),
					lineWidth: 1
				)
				.frame(width: 96, height: 36)

				DSFSparklineDataBarGraphView.SwiftUI(
					dataSource: [CGFloat](repeating: 10.0, count: DSFSparklinePalette.sharedGrays.colors.count),
					palette: .sharedGrays,
					strokeColor: DSFColor.black.withAlphaComponent(0.5),
					lineWidth: 1
				)
				.frame(width: 96, height: 36)

				DSFSparklineDataBarGraphView.SwiftUI(
					dataSource: [5, 2, 4, 8],
					strokeColor: DSFColor.textColor,
					lineWidth: 1
				)
				.frame(width: 96, height: 36)
			}

			HStack(spacing: 8) {
				DSFSparklineDataBarGraphView.SwiftUI(
					dataSource: fourthDataSourceDataBar,
					palette: grays,
					animated: true,
					animationDuration: 1.0
				)
				.frame(width: 96, height: 36)

				DSFSparklineDataBarGraphView.SwiftUI(
					dataSource: [CGFloat](repeating: 10.0, count: DSFSparklinePalette.shared.colors.count),
					strokeColor: DSFColor.black.withAlphaComponent(0.5),
					lineWidth: 1,
					animated: true,
					animationDuration: 1.0
				)
				.frame(width: 96, height: 36)

				DSFSparklineDataBarGraphView.SwiftUI(
					dataSource: [CGFloat](repeating: 10.0, count: DSFSparklinePalette.sharedGrays.colors.count),
					palette: .sharedGrays,
					strokeColor: DSFColor.black.withAlphaComponent(0.5),
					lineWidth: 1,
					animated: true,
					animationDuration: 1.0
				)
				.frame(width: 96, height: 36)

				DSFSparklineDataBarGraphView.SwiftUI(
					dataSource: [5, 2, 4, 8],
					strokeColor: DSFColor.textColor,
					lineWidth: 1,
					animated: true,
					animationDuration: 1.0
				)
				.frame(width: 96, height: 36)
			}

			Text("Data Bar with maximum value defined")

			VStack{
				HStack(spacing: 20) {
					VStack(spacing: 8) {
						Text("No Background Color")
						DSFSparklineDataBarGraphView.SwiftUI(
							dataSource: [2, 4, 8],
							maximumTotalValue: 20,
							palette: palette1,
							lineWidth: 1,
							animated: true,
							animationDuration: 0.5
						)
						.frame(height: 24)
						.padding(3)
						.border(Color.gray.opacity(0.3), width: 0.5)

						DSFSparklineDataBarGraphView.SwiftUI(
							dataSource: [5, 10, 5],
							maximumTotalValue: 20,
							palette: palette1,
							lineWidth: 1,
							animated: true,
							animationDuration: 0.5
						)
						.frame(height: 24)
						.padding(3)
						.border(Color.gray.opacity(0.3), width: 0.5)

						DSFSparklineDataBarGraphView.SwiftUI(
							dataSource: [1, 3, 5],
							maximumTotalValue: 20,
							palette: palette1,
							lineWidth: 1,
							animated: true,
							animationDuration: 0.5
						)
						.frame(height: 24)
						.padding(3)
						.border(Color.gray.opacity(0.3), width: 0.5)
					}
					.frame(width: 192)

					VStack(spacing: 8) {
						Text("Background color defined")

						DSFSparklineDataBarGraphView.SwiftUI(
							dataSource: [3, 3, 5],
							maximumTotalValue: 14,
							palette: palette1,
							unsetColor: DSFColor.windowBackgroundColor,
							strokeColor: DSFColor.black,
							lineWidth: 1,
							animated: true,
							animationDuration: 0.5
						)
						.frame(height: 24)
						.padding(3)
						.border(Color.gray.opacity(0.3), width: 0.5)

						DSFSparklineDataBarGraphView.SwiftUI(
							dataSource: [12, 2, 5],
							maximumTotalValue: 20,
							palette: palette1,
							unsetColor: DSFColor.windowBackgroundColor,
							strokeColor: DSFColor.black,
							lineWidth: 1,
							animated: true,
							animationDuration: 0.5
						)
						.frame(height: 24)
						.padding(3)
						.border(Color.gray.opacity(0.3), width: 0.5)

						DSFSparklineDataBarGraphView.SwiftUI(
							dataSource: [1, 10, 5],
							maximumTotalValue: 20,
							palette: palette1,
							unsetColor: DSFColor.windowBackgroundColor,
							strokeColor: DSFColor.black,
							lineWidth: 1,
							animated: true,
							animationDuration: 0.5
						)
						.frame(height: 24)
						.padding(3)
						.border(Color.gray.opacity(0.3), width: 0.5)
					}
					.frame(width: 192)
				}
			}
		}

		.padding()
	}
}
