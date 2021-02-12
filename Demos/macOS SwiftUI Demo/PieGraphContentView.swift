//
//  PieGraphContentView.swift
//  SwiftUI Demo
//
//  Created by Darren Ford on 26/1/21.
//

import SwiftUI
import DSFSparkline

let palette1 = DSFSparklinePieGraphView.Palette([.systemRed, .systemOrange, .systemYellow])
let grays = DSFSparklinePieGraphView.Palette([
																DSFColor.init(deviceWhite: 1.00, alpha: 1),
																DSFColor.init(deviceWhite: 0.66, alpha: 1),
																DSFColor.init(deviceWhite: 0.33, alpha: 1)
])


let firstDataSource: [CGFloat] = [10, 40, 25]
let secondDataSource: [CGFloat] = [33, 33, 33]
let thirdDataSource: [CGFloat] = [85, 10, 19]
let fourthDataSource: [CGFloat] = [3, 4, 5]


struct PieGraphContentView_Previews: PreviewProvider {
	static var previews: some View {

		VStack(spacing: 8) {

			HStack(spacing: 8) {
				Text("No stroke").frame(width: 70, alignment: Alignment.trailing)
				DSFSparklinePieGraphView.SwiftUI(
					dataSource: firstDataSource,
					palette: palette1
				)
				.frame(width: 24, height: 24)

				DSFSparklinePieGraphView.SwiftUI(
					dataSource: secondDataSource,
					palette: palette1
				)
				.frame(width: 24, height: 24)

				DSFSparklinePieGraphView.SwiftUI(
					dataSource: thirdDataSource,
					palette: palette1
				)
				.frame(width: 24, height: 24)
			}

			HStack(spacing: 8) {
				Text("Stroke").frame(width: 70, alignment: Alignment.trailing)
				DSFSparklinePieGraphView.SwiftUI(
					dataSource: firstDataSource,
					strokeColor: DSFColor.black.withAlphaComponent(0.5),
					lineWidth: 1
				)
				.frame(width: 24, height: 24)

				DSFSparklinePieGraphView.SwiftUI(
					dataSource: secondDataSource,
					strokeColor: DSFColor.black.withAlphaComponent(0.5),
					lineWidth: 1
				)
				.frame(width: 24, height: 24)

				DSFSparklinePieGraphView.SwiftUI(
					dataSource: thirdDataSource,
					strokeColor: DSFColor.black.withAlphaComponent(0.5),
					lineWidth: 1
				)
				.frame(width: 24, height: 24)
			}

			HStack(spacing: 8) {
				DSFSparklinePieGraphView.SwiftUI(
					dataSource: fourthDataSource,
					palette: grays
				)
				.frame(width: 36, height: 36)

				DSFSparklinePieGraphView.SwiftUI(
					dataSource: [CGFloat](repeating: 10.0, count: DSFSparklinePieGraphView.Palette.shared.colors.count),
					strokeColor: DSFColor.black.withAlphaComponent(0.5),
					lineWidth: 1
				)
				.frame(width: 36, height: 36)

				DSFSparklinePieGraphView.SwiftUI(
					dataSource: [CGFloat](repeating: 10.0, count: DSFSparklinePieGraphView.Palette.sharedGrays.colors.count),
					palette: .sharedGrays,
					strokeColor: DSFColor.black.withAlphaComponent(0.5),
					lineWidth: 1
				)
				.frame(width: 36, height: 36)

				DSFSparklinePieGraphView.SwiftUI(
					dataSource: [5, 2, 4, 8],
					strokeColor: DSFColor.textColor,
					lineWidth: 1
				)
				.frame(width: 36, height: 36)
			}

			HStack(spacing: 8) {
				DSFSparklinePieGraphView.SwiftUI(
					dataSource: fourthDataSource,
					palette: grays,
					animated: true,
					animationDuration: 1.0
				)
				.frame(width: 36, height: 36)

				DSFSparklinePieGraphView.SwiftUI(
					dataSource: [CGFloat](repeating: 10.0, count: DSFSparklinePieGraphView.Palette.shared.colors.count),
					strokeColor: DSFColor.black.withAlphaComponent(0.5),
					lineWidth: 1,
					animated: true,
					animationDuration: 1.0
				)
				.frame(width: 36, height: 36)

				DSFSparklinePieGraphView.SwiftUI(
					dataSource: [CGFloat](repeating: 10.0, count: DSFSparklinePieGraphView.Palette.sharedGrays.colors.count),
					palette: .sharedGrays,
					strokeColor: DSFColor.black.withAlphaComponent(0.5),
					lineWidth: 1,
					animated: true,
					animationDuration: 1.0
				)
				.frame(width: 36, height: 36)

				DSFSparklinePieGraphView.SwiftUI(
					dataSource: [5, 2, 4, 8],
					strokeColor: DSFColor.textColor,
					lineWidth: 1,
					animated: true,
					animationDuration: 1.0
				)
				.frame(width: 36, height: 36)
			}
		}

		.padding()
	}
}
