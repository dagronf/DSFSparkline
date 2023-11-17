//
//  TestingView.swift
//  Demos
//
//  Created by Darren Ford on 14/4/21.
//

import SwiftUI
import DSFSparkline

struct TestingView: View {

	@State var currentDate = Date()
	let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

	@State var inputData: [Double] = []

	/// A default palette used when no palette is specified.
	let DefaultLight = DSFSparkline.Palette([
		DSFColor(red: 0.920, green: 0.930, blue: 0.942, alpha: 1.000),
		DSFColor(red: 0.606, green: 0.914, blue: 0.657, alpha: 1.000),
		DSFColor(red: 0.248, green: 0.768, blue: 0.387, alpha: 1.000),
		DSFColor(red: 0.190, green: 0.633, blue: 0.306, alpha: 1.000),
		DSFColor(red: 0.132, green: 0.432, blue: 0.222, alpha: 1.000),
	])

	let DefaultDark = DSFSparkline.Palette([
		DSFColor(red: 0.086, green: 0.106, blue: 0.132, alpha: 1.000),
		DSFColor(red: 0.055, green: 0.269, blue: 0.159, alpha: 1.000),
		DSFColor(red: 0.000, green: 0.429, blue: 0.194, alpha: 1.000),
		DSFColor(red: 0.148, green: 0.649, blue: 0.257, alpha: 1.000),
		DSFColor(red: 0.219, green: 0.829, blue: 0.323, alpha: 1.000),
	])
	@State var isLightMode: Bool = false

	var body: some View {
		VStack(spacing: 4) {
			Toggle("Use Alternate Palette", isOn: $isLightMode)
			DSFSparklineActivityGridView.SwiftUI(
				values: inputData,
				verticalCellCount: 7,
				range: 0 ... 1, 
				colorScheme: isLightMode ? .init(palette: DefaultLight) : .init(palette: DefaultDark)
			)
			.onReceive(timer) { input in
				self.inputData.insert(Double.random(in: 0 ... 1), at: 0)
			}
			.frame(height: 100)
			.frame(maxWidth: .infinity)
			.border(Color.black)
			.padding()
		}
	}
}

struct TestingView_Previews: PreviewProvider {
	static var previews: some View {
		TestingView()
	}
}
