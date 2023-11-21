//
//  TestingView.swift
//  Demos
//
//  Created by Darren Ford on 14/4/21.
//

import SwiftUI
import DSFSparkline

struct ActivityGridView: View {

	@State var currentDate = Date()
	let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

	@State var inputData: [Double] = []

	/// A default palette used when no palette is specified.
	static let DefaultLight = DSFSparkline.Palette([
		DSFColor(red: 0.820, green: 0.830, blue: 0.842, alpha: 1.000),
		DSFColor(red: 0.606, green: 0.914, blue: 0.657, alpha: 1.000),
		DSFColor(red: 0.248, green: 0.768, blue: 0.387, alpha: 1.000),
		DSFColor(red: 0.190, green: 0.633, blue: 0.306, alpha: 1.000),
		DSFColor(red: 0.132, green: 0.432, blue: 0.222, alpha: 1.000),
	])

	let CellLight = DSFSparklineOverlay.ActivityGrid.CellStyle(
		fillStyle: DSFSparkline.ValueBasedFill(palette: ActivityGridView.DefaultLight)
	)

	static let DefaultDark = DSFSparkline.Palette([
		DSFColor(red: 0.086, green: 0.106, blue: 0.132, alpha: 1.000),
		DSFColor(red: 0.055, green: 0.269, blue: 0.159, alpha: 1.000),
		DSFColor(red: 0.000, green: 0.429, blue: 0.194, alpha: 1.000),
		DSFColor(red: 0.148, green: 0.649, blue: 0.257, alpha: 1.000),
		DSFColor(red: 0.219, green: 0.829, blue: 0.323, alpha: 1.000),
	])
	let CellDark = DSFSparklineOverlay.ActivityGrid.CellStyle(
		fillStyle: DSFSparkline.ValueBasedFill(palette: ActivityGridView.DefaultDark)
	)

	let gradient = DSFSparkline.GradientBucket(
		colors: [
			CGColor(srgbRed: 0, green: 0, blue: 1, alpha: 1),
			CGColor(srgbRed: 1, green: 1, blue: 0, alpha: 1),
			CGColor(srgbRed: 1, green: 0, blue: 0, alpha: 1),
		]
	)

	let SmallerFullRange: [Double] = (0 ... 1000).map { _ in Double.random(in: 0 ... 1) }

	@State var isLightMode: Bool = false

	var body: some View {
		VStack(spacing: 4) {
			Toggle("Use Alternate Palette", isOn: $isLightMode)

			Text("Github style").font(.title3)

			DSFSparklineActivityGridView.SwiftUI(
				values: inputData,
				range: 0 ... 1,
				cellStyle: isLightMode ? CellLight : CellDark
			)
			.onReceive(timer) { input in
				self.inputData.insert(Double.random(in: 0 ... 1), at: 0)
			}
			.border(.red)

			Text("Defrag style").font(.title3)

			DSFSparklineActivityGridView.SwiftUI(
				values: inputData,
				range: 0 ... 1,
				cellStyle: isLightMode ? CellLight : CellDark,
				layoutStyle: .defrag
			)
			.border(.red)

			Divider()
				.frame(maxWidth: .infinity)

			VStack {
				Text("Fixed row/column").font(.title3)
				HStack {

					DSFSparklineActivityGridView.SwiftUI(
						values: inputData,
						range: 0 ... 1,
						verticalCellCount: 10,
						horizontalCellCount: 7,
						layoutStyle: .defrag,
						fillStyle: isLightMode ? .init(palette: ActivityGridView.DefaultLight) : .init(palette: ActivityGridView.DefaultDark),
						borderColor: isLightMode ? .black.copy(alpha: 0.2) : .white.copy(alpha: 0.2),
						borderWidth: 0.5
					)
					.border(.red)
					DSFSparklineActivityGridView.SwiftUI(
						values: inputData,
						range: 0 ... 1,
						verticalCellCount: 10,
						horizontalCellCount: 7,
						layoutStyle: .github,
						fillStyle: isLightMode ? .init(palette: ActivityGridView.DefaultLight) : .init(palette: ActivityGridView.DefaultDark),
						borderColor: isLightMode ? .black.copy(alpha: 0.2) : .white.copy(alpha: 0.2),
						borderWidth: 0.5
					)
					.border(.green)

					DSFSparklineActivityGridView.SwiftUI(
						values: SmallerFullRange,
						range: 0 ... 1,
						verticalCellCount: 7,
						horizontalCellCount: 10,
						cellStyle: .init(fillStyle: .init(gradient: gradient), cellDimension: 6, cellSpacing: 3),
						layoutStyle: .defrag
					)
					.border(.blue)
					DSFSparklineActivityGridView.SwiftUI(
						values: SmallerFullRange,
						range: 0 ... 1,
						verticalCellCount: 7,
						horizontalCellCount: 10,
						cellStyle: .init(fillStyle: .init(gradient: gradient), cellDimension: 15, cellSpacing: 1),
						layoutStyle: .github
					)
					.border(.yellow)
				}
			}

			Text("Fixed row/column").font(.title3)
			ZStack {
				DSFSparklineActivityGridView.SwiftUI(
					values: SmallerFullRange,
					range: 0 ... 1,
					verticalCellCount: 0,
					horizontalCellCount: 0,
					cellStyle: .init(fillStyle: .init(gradient: gradient)),
					layoutStyle: .github
				)
				.frame(maxWidth: .infinity, maxHeight: .infinity)
			}
		}
		.padding()
	}
}

struct ActivityGridView_Previews: PreviewProvider {
	static var previews: some View {
		ActivityGridView()
			.frame(height: 1000)
	}
}
