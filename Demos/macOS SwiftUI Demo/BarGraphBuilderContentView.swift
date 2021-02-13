//
//  BarGraphBuilderContentView.swift
//  macOS SwiftUI Demo
//
//  Created by Darren Ford on 13/2/21.
//

import SwiftUI

import DSFSparkline
import DSFStepperView

struct BarGraphBuilderContentView: View {

	var BarDataSource: DSFSparklineDataSource = {
		let d = DSFSparklineDataSource(windowSize: 20, range: 0 ... 1, zeroLineValue: 0.4)
		d.push(values: [
					0.85, 0.04, 0.24, 0.13, 0.51, 0.93, 0.26, 0.69, 0.16, 0.39,
					0.19, 0.12, 0.28, 0.42, 0.42, 0.48, 0.29, 0.05, 0.87, 0.28
		])
		return d
	}()


	@State var showZeroLine: Bool = true
	@State var lineWidth: CGFloat? = 1
	@State var barWidth: CGFloat? = 1

	@State var centerAroundZeroLine: Bool = false

	@State var zeroLineValue: CGFloat? = 0.5

	@State var graphColor: Color = Color(.sRGB, red: 0, green: 1, blue: 0)
	@State var lowerGraphColor: Color = Color(.sRGB, red: 1, green: 0, blue: 0)

	@State var zerolineColor: Color = Color(.sRGB, red: 0.5, green: 0.5, blue: 0.5)
	@State var zerolineWidth: CGFloat? = 1

	@State var zeroLineDashStyle: [CGFloat] = [1, 1]

	var formatter: NumberFormatter = {
		let format = NumberFormatter()
		format.numberStyle = .decimal

		// Always display a single digit fractional value.
		format.allowsFloats = true
		format.minimumFractionDigits = 1
		format.maximumFractionDigits = 1

		return format
	}()

	var body: some View {
		VStack {
			HStack(spacing: 20) {
				Toggle("Show Zero Line", isOn: $showZeroLine)
				Toggle("Center Around Zero Line", isOn: $centerAroundZeroLine)
			}

			HStack(spacing: 4) {
				Text("Zero-line value")
				DSFStepperView.SwiftUI(
					configuration: DSFStepperView.SwiftUI.DisplaySettings(minimum: 0, maximum: 1, increment: 0.1, numberFormatter: formatter),
					floatValue: $zeroLineValue,
					onValueChange: { newVal in
						if let n = newVal {
							BarDataSource.zeroLineValue = n
						}
					}
				)
				.frame(width: 100, height: 24)
			}

			HStack {
				ColorPicker("graphColor", selection: $graphColor)
				ColorPicker("lowerGraphColor", selection: $lowerGraphColor)
			}

			HStack(spacing: 4) {
				Text("Line Width")
				DSFStepperView.SwiftUI(
					configuration: DSFStepperView.SwiftUI.DisplaySettings(minimum: 1, maximum: 10, initialValue: 1),
					floatValue: $lineWidth
				)
				.frame(width: 100, height: 24)
			}

			HStack(spacing: 4) {
				Text("Bar spacing")
				DSFStepperView.SwiftUI(
					configuration: DSFStepperView.SwiftUI.DisplaySettings(minimum: 1, maximum: 10, initialValue: 1),
					floatValue: $barWidth
				)
				.frame(width: 100, height: 24)
			}

			ZeroLineConfigurationView(lineColor: $zerolineColor,
											  lineWidth: $zerolineWidth,
											  lineDashStyle: $zeroLineDashStyle)
				.frame(width: 200)

			DSFSparklineBarGraphView.SwiftUI(
				dataSource: BarDataSource,
				graphColor: DSFColor(cgColor: graphColor.cgColor!)!,
				lineWidth: UInt(lineWidth!),
				barSpacing: UInt(barWidth!),
				showZeroLine: showZeroLine,
				zeroLineDefinition: DSFSparklineZeroLineDefinition(
					color: DSFColor(zerolineColor),
					lineWidth: zerolineWidth ?? 0.5,
					lineDashStyle: zeroLineDashStyle),
				centeredAtZeroLine: centerAroundZeroLine,
				lowerGraphColor: DSFColor(lowerGraphColor)
				//			showHighlightRange: Bool,
				//			highlightDefinitions: [DSFSparklineHighlightRangeDefinition]
			)
			.frame(height: 64)
			.padding(4)
			.border(Color.gray.opacity(0.4))
		}
		.padding(8)
		.frame(minWidth: 400)
	}
}

extension DSFColor {
	convenience init(color: Color) {
		self.init(cgColor: color.cgColor!)!
	}
}

struct BarGraphBuilderContentView_Previews: PreviewProvider {
	static var previews: some View {
		BarGraphBuilderContentView()
	}
}
