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

	let cellStyleLight = DSFSparkline.ActivityGrid.CellStyle(fillScheme: DSFSparkline.ActivityGrid.CellStyle.DefaultLight)
	let cellStyleDark = DSFSparkline.ActivityGrid.CellStyle(fillScheme: DSFSparkline.ActivityGrid.CellStyle.DefaultDark)

	let gradient = DSFSparkline.GradientBucket(
		colors: [
			CGColor(srgbRed: 0, green: 0, blue: 1, alpha: 1),
			CGColor(srgbRed: 1, green: 1, blue: 0, alpha: 1),
			CGColor(srgbRed: 1, green: 0, blue: 0, alpha: 1),
		]
	)

	let fiveColorGradient = DSFSparkline.GradientBucket(
		colors: [
			CGColor(red: 0.806, green: 0.164, blue: 0.287, alpha: 1.0),
			CGColor(red: 0.978, green: 0.620, blue: 0.303, alpha: 1.0),
			CGColor(red: 0.954, green: 0.431, blue: 0.221, alpha: 1.0),
			CGColor(red: 0.935, green: 0.280, blue: 0.286, alpha: 1.0),
			CGColor(red: 0.345, green: 0.155, blue: 0.259, alpha: 1.0),
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
				cellStyle: isLightMode ? cellStyleLight : cellStyleDark
			)
			.tooltipStringForCell { index in
				"Index[\(index)]"
			}
			.onReceive(timer) { input in
				self.inputData.insert(Double.random(in: 0 ... 1), at: 0)
			}
			.border(.red)

			Text("Defrag style").font(.title3)

			DSFSparklineActivityGridView.SwiftUI(
				values: inputData,
				range: 0 ... 1,
				cellStyle: isLightMode ? cellStyleLight : cellStyleDark,
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
						fillScheme: isLightMode ? cellStyleLight.fillScheme : cellStyleDark.fillScheme,
						borderColor: isLightMode ? .init(gray: 0, alpha: 0.2) : .init(gray: 1, alpha: 0.2),
						borderWidth: 0.5
					)
					.border(.red)
					DSFSparklineActivityGridView.SwiftUI(
						values: inputData,
						range: 0 ... 1,
						verticalCellCount: 10,
						horizontalCellCount: 7,
						layoutStyle: .github,
						fillScheme: isLightMode ? cellStyleLight.fillScheme : cellStyleDark.fillScheme,
						borderColor: isLightMode ? .init(gray: 0, alpha: 0.2) : .init(gray: 1, alpha: 0.2),
						borderWidth: 0.5
					)
					.border(.green)

					DSFSparklineActivityGridView.SwiftUI(
						values: SmallerFullRange,
						range: 0 ... 1,
						verticalCellCount: 7,
						horizontalCellCount: 10,
						cellStyle: .init(fillScheme: .init(gradient: gradient), cellDimension: 6, cellSpacing: 3),
						layoutStyle: .defrag
					)
					.border(.blue)
					DSFSparklineActivityGridView.SwiftUI(
						values: SmallerFullRange,
						range: 0 ... 1,
						verticalCellCount: 7,
						horizontalCellCount: 10,
						cellStyle: .init(fillScheme: .init(gradient: gradient), cellDimension: 15, cellSpacing: 1),
						layoutStyle: .github
					)
					.border(.yellow)

					VStack(spacing: 0) {
						HStack(spacing: 6) {
							Text("S").font(.system(.caption, design: .monospaced))
							Text("M").font(.system(.caption, design: .monospaced))
							Text("T").font(.system(.caption, design: .monospaced))
							Text("W").font(.system(.caption, design: .monospaced))
							Text("T").font(.system(.caption, design: .monospaced))
							Text("F").font(.system(.caption, design: .monospaced))
							Text("S").font(.system(.caption, design: .monospaced))
						}
						.padding(3)
						DSFSparklineActivityGridView.SwiftUI(
							values: SmallerFullRange,
							range: 0 ... 1,
							verticalCellCount: 30,
							horizontalCellCount: 7,
							cellStyle: .init(fillScheme: .init(gradient: fiveColorGradient)),
							layoutStyle: .github
						)
						.tooltipStringForCell { index in
							"Tooltip[\(SmallerFullRange[index])]"
						}
					}
				}
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
