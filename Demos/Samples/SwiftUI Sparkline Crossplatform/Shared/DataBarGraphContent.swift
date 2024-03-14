//
//  DataBarGraphContent.swift
//  Demos
//
//  Created by Darren Ford on 16/2/21.
//

import SwiftUI
import DSFSparkline

fileprivate let firstDataSourceDataBar = DSFSparkline.StaticDataSource([10, 40, 25])
fileprivate let secondDataSourceDataBar = DSFSparkline.StaticDataSource([33, 33, 33])
fileprivate let thirdDataSourceDataBar = DSFSparkline.StaticDataSource([85, 10, 19])
fileprivate let fourthDataSourceDataBar = DSFSparkline.StaticDataSource([3, 4, 5])

fileprivate let palette1 = DSFSparkline.Palette([.systemRed, .systemOrange, .systemYellow])
fileprivate let grays = DSFSparkline.Palette([
	DSFColor.init(white: 0.80, alpha: 1),
	DSFColor.init(white: 0.60, alpha: 1),
	DSFColor.init(white: 0.40, alpha: 1)
])

struct DataBarGraphContent: View {
	var body: some View {
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
					dataSource: DSFSparkline.StaticDataSource([CGFloat](repeating: 10.0, count: DSFSparkline.Palette.shared.colors.count)),
					strokeColor: DSFColor.black.withAlphaComponent(0.5),
					lineWidth: 1
				)
				.frame(width: 96, height: 36)

				DSFSparklineDataBarGraphView.SwiftUI(
					dataSource: DSFSparkline.StaticDataSource([CGFloat](repeating: 10.0, count: DSFSparkline.Palette.sharedGrays.colors.count)),
					palette: .sharedGrays,
					strokeColor: DSFColor.black.withAlphaComponent(0.5),
					lineWidth: 1
				)
				.frame(width: 96, height: 36)

				DSFSparklineDataBarGraphView.SwiftUI(
					dataSource: DSFSparkline.StaticDataSource([5, 2, 4, 8]),
					strokeColor: DSFColor.gray,
					lineWidth: 1
				)
				.frame(width: 96, height: 36)
			}

			HStack(spacing: 8) {
				DSFSparklineDataBarGraphView.SwiftUI(
					dataSource: fourthDataSourceDataBar,
					palette: grays,
					animationStyle: DSFSparkline.AnimationStyle(duration: 1, function: .easeInEaseOut)
				)
				.frame(width: 96, height: 36)

				DSFSparklineDataBarGraphView.SwiftUI(
					dataSource: DSFSparkline.StaticDataSource([CGFloat](repeating: 10.0, count: DSFSparkline.Palette.shared.colors.count)),
					strokeColor: DSFColor.black.withAlphaComponent(0.5),
					lineWidth: 1,
					animationStyle: .init(duration: 1, function: .easeInEaseOut)
				)
				.frame(width: 96, height: 36)

				DSFSparklineDataBarGraphView.SwiftUI(
					dataSource: DSFSparkline.StaticDataSource([CGFloat](repeating: 10.0, count: DSFSparkline.Palette.sharedGrays.colors.count)),
					palette: .sharedGrays,
					strokeColor: DSFColor.black.withAlphaComponent(0.5),
					lineWidth: 1,
					animationStyle: .init(duration: 1, function: .easeInEaseOut)
				)
				.frame(width: 96, height: 36)

				DSFSparklineDataBarGraphView.SwiftUI(
					dataSource: DSFSparkline.StaticDataSource([5, 2, 4, 8]),
					strokeColor: DSFColor.gray,
					lineWidth: 1,
					animationStyle: .init(duration: 1, function: .easeInEaseOut)
				)
				.frame(width: 96, height: 36)
			}

			Text("Data Bar with maximum value defined")

			VStack{
				HStack(spacing: 20) {
					VStack(spacing: 8) {
						Text("No Background Color")
						DSFSparklineDataBarGraphView.SwiftUI(
							dataSource: DSFSparkline.StaticDataSource([2, 4, 8]),
							maximumTotalValue: 20,
							palette: palette1,
							lineWidth: 1,
							animationStyle: .init(duration: 0.5, function: .linear)
						)
						.frame(height: 24)
						.padding(3)
						.border(Color.gray.opacity(0.3), width: 0.5)

						DSFSparklineDataBarGraphView.SwiftUI(
							dataSource: DSFSparkline.StaticDataSource([5, 10, 5]),
							maximumTotalValue: 20,
							palette: palette1,
							lineWidth: 1,
							animationStyle: .init(duration: 0.5, function: .linear)
						)
						.frame(height: 24)
						.padding(3)
						.border(Color.gray.opacity(0.3), width: 0.5)

						DSFSparklineDataBarGraphView.SwiftUI(
							dataSource: DSFSparkline.StaticDataSource([1, 3, 5]),
							maximumTotalValue: 20,
							palette: palette1,
							lineWidth: 1,
							animationStyle: .init(duration: 0.5, function: .linear)
						)
						.frame(height: 24)
						.padding(3)
						.border(Color.gray.opacity(0.3), width: 0.5)
					}
					.frame(width: 192)

					VStack(spacing: 8) {
						Text("Background color defined")

						DSFSparklineDataBarGraphView.SwiftUI(
							dataSource: DSFSparkline.StaticDataSource([3, 3, 5]),
							maximumTotalValue: 14,
							palette: palette1,
							unsetColor: DSFColor.black,
							strokeColor: DSFColor.black,
							lineWidth: 1,
							animationStyle: .init(duration: 0.5, function: .easeInEaseOut)
						)
						.frame(height: 24)
						.padding(3)
						.border(Color.gray.opacity(0.3), width: 0.5)

						DSFSparklineDataBarGraphView.SwiftUI(
							dataSource: DSFSparkline.StaticDataSource([12, 2, 5]),
							maximumTotalValue: 20,
							palette: palette1,
							unsetColor: DSFColor.black,
							strokeColor: DSFColor.black,
							lineWidth: 1,
							animationStyle: .init(duration: 0.5, function: .easeInEaseOut)
						)
						.frame(height: 24)
						.padding(3)
						.border(Color.gray.opacity(0.3), width: 0.5)

						DSFSparklineDataBarGraphView.SwiftUI(
							dataSource: DSFSparkline.StaticDataSource([1, 10, 5]),
							maximumTotalValue: 20,
							palette: palette1,
							unsetColor: DSFColor.black,
							strokeColor: DSFColor.black,
							lineWidth: 1,
							animationStyle: .init(duration: 0.5, function: .easeInEaseOut)
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



struct DataBarGraphContent_Previews: PreviewProvider {
    static var previews: some View {
        DataBarGraphContent()
    }
}
