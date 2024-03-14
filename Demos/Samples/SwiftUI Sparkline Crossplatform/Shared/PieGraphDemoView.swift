//
//  PieGraphDemoView.swift
//  Demos
//
//  Created by Darren Ford on 16/2/21.
//

import SwiftUI
import DSFSparkline

fileprivate let palette1 = DSFSparkline.Palette([.systemRed, .systemOrange, .systemYellow])
fileprivate let grays = DSFSparkline.Palette([
	DSFColor.init(white: 1.00, alpha: 1),
	DSFColor.init(white: 0.66, alpha: 1),
	DSFColor.init(white: 0.33, alpha: 1)
])

fileprivate let firstDataSource = DSFSparkline.StaticDataSource([10, 40, 25])
fileprivate let secondDataSource = DSFSparkline.StaticDataSource([33, 33, 33])
fileprivate let thirdDataSource = DSFSparkline.StaticDataSource( [85, 10, 19])
fileprivate let fourthDataSource = DSFSparkline.StaticDataSource([3, 4, 5])

struct PieGraphDemoView: View {
    var body: some View {

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
					dataSource: DSFSparkline.StaticDataSource([CGFloat](repeating: 10.0, count: DSFSparkline.Palette.shared.colors.count)),
					strokeColor: DSFColor.black.withAlphaComponent(0.5),
					lineWidth: 1
				)
				.frame(width: 36, height: 36)

				DSFSparklinePieGraphView.SwiftUI(
					dataSource: DSFSparkline.StaticDataSource([CGFloat](repeating: 10.0, count: DSFSparkline.Palette.sharedGrays.colors.count)),
					palette: .sharedGrays,
					strokeColor: DSFColor.black.withAlphaComponent(0.5),
					lineWidth: 1
				)
				.frame(width: 36, height: 36)

				DSFSparklinePieGraphView.SwiftUI(
					dataSource: DSFSparkline.StaticDataSource([5, 2, 4, 8]),
					strokeColor: DSFColor.gray,
					lineWidth: 1
				)
				.frame(width: 36, height: 36)
			}

			HStack(spacing: 8) {
				DSFSparklinePieGraphView.SwiftUI(
					dataSource: fourthDataSource,
					palette: grays,
					animationStyle: .init(duration: 1.0, function: .easeInEaseOut)
				)
				.frame(width: 36, height: 36)

				DSFSparklinePieGraphView.SwiftUI(
					dataSource: DSFSparkline.StaticDataSource([CGFloat](repeating: 10.0, count: DSFSparkline.Palette.shared.colors.count)),
					strokeColor: DSFColor.black,
					lineWidth: 2,
					animationStyle: .init(duration: 1.0, function: .easeInEaseOut)
				)
				.frame(width: 36, height: 36)

				DSFSparklinePieGraphView.SwiftUI(
					dataSource: DSFSparkline.StaticDataSource([CGFloat](repeating: 10.0, count: DSFSparkline.Palette.sharedGrays.colors.count)),
					palette: .sharedGrays,
					strokeColor: DSFColor.black.withAlphaComponent(0.5),
					lineWidth: 1,
					animationStyle: .init(duration: 1.0, function: .easeInEaseOut)
				)
				.frame(width: 36, height: 36)

				DSFSparklinePieGraphView.SwiftUI(
					dataSource: DSFSparkline.StaticDataSource([5, 2, 4, 8]),
					strokeColor: DSFColor.gray,
					lineWidth: 1,
					animationStyle: .init(duration: 1.0, function: .easeInEaseOut)
				)
				.frame(width: 36, height: 36)
			}
		}

		.padding()



    }
}

struct PieGraphDemoView_Previews: PreviewProvider {
    static var previews: some View {
        PieGraphDemoView()
    }
}
