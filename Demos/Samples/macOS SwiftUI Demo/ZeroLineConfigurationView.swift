//
//  ZeroLineConfigurationView.swift
//  macOS SwiftUI Demo
//
//  Created by Darren Ford on 13/2/21.
//

import SwiftUI
import DSFStepperView

struct ZeroLineConfigurationView: View {

	@Binding var lineColor: Color
	@Binding var lineWidth: CGFloat?

	@State var onWidth: CGFloat? {
		didSet {
			lineDashStyle[0] = self.onWidth!
		}
	}
	@State var offWidth: CGFloat? {
		didSet {
			lineDashStyle[1] = self.offWidth!
		}
	}

	@Binding var lineDashStyle: [CGFloat]

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

			ColorPicker("Zero-line color", selection: $lineColor)

			HStack {
				Text("Width")
				DSFStepperView.SwiftUI(
					configuration: DSFStepperView.SwiftUI.DisplaySettings(minimum: 0.5, maximum: 5.0, increment: 0.5,
																							initialValue: lineWidth!,
																							numberFormatter: formatter),
					floatValue: $lineWidth
				)
				.frame(width: 96)
				DSFStepperView.SwiftUI(
					configuration: DSFStepperView.SwiftUI.DisplaySettings(minimum: 0.5, maximum: 5.0, increment: 0.5,
																							initialValue: lineDashStyle[0],
																							numberFormatter: formatter),
					floatValue: $onWidth
				)
				.frame(width: 96)
				DSFStepperView.SwiftUI(
					configuration: DSFStepperView.SwiftUI.DisplaySettings(minimum: 0.5, maximum: 5.0, increment: 0.5,
																							initialValue: lineDashStyle[1],
																							numberFormatter: formatter),
					floatValue: $offWidth
				)
				.frame(width: 96)
			}
			.frame(height: 26)
		}
	}
}

struct ZeroLineConfigurationView_Previews: PreviewProvider {

	static var lineColor: Color = Color(.sRGB, red: 0.5, green: 0.5, blue: 0.5)
	static var lineWidth: CGFloat = 1
	//@State var lineDashStyle: [CGFloat]

	static var previews: some View {
		//Text("fish")
		ZeroLineConfigurationView(
			lineColor: .constant(lineColor),
			lineWidth: .constant(lineWidth),
			lineDashStyle: .constant([1, 1])
		)
	}
}
