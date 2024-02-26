//
//  CircularProgressView.swift
//  Demos
//
//  Created by Darren Ford on 16/2/24.
//

import SwiftUI
import DSFSparkline

func namedImage(_ name: String) -> CGImage? {
#if os(macOS)
	if #available(macOS 11.0, *) {
		return NSImage(systemSymbolName: name, accessibilityDescription: nil)?.cgImage(forProposedRect: nil, context: nil, hints: nil)
	}
	return nil
#else
	return UIImage(systemName: name)?.cgImage
#endif
}

struct CircularProgressView: View {

	let g = DSFSparkline.Fill.Gradient(
		colors: [
			CGColor(srgbRed: 0.977, green: 0.221, blue: 0.520, alpha: 1.0),
			CGColor(srgbRed: 0.891, green: 0.000, blue: 0.090, alpha: 1.0),
		]
	)
	let g1 = DSFSparkline.Fill.Gradient(
		colors: [
			CGColor(srgbRed: 0.849, green: 1.000, blue: 0.000, alpha: 1.0),
			CGColor(srgbRed: 0.601, green: 1.000, blue: 0.009, alpha: 1.0),
		]
	)
	let g2 = DSFSparkline.Fill.Gradient(
		colors: [
			CGColor(srgbRed: 0.000, green: 1.000, blue: 0.663, alpha: 1.0),
			CGColor(srgbRed: 0.015, green: 0.847, blue: 1.000, alpha: 1.0),
		]
	)
	let g3 = DSFSparkline.Fill.Gradient(
		colors: [
			CGColor(srgbRed: 0.996, green: 0.759, blue: 0.300, alpha: 1.0),
			CGColor(srgbRed: 0.996, green: 0.459, blue: 0.000, alpha: 1.0),
		]
	)

	let i1: CGImage? = namedImage("arrow.right")
	let i2: CGImage? = namedImage("arrow.up")
	let i3: CGImage? = namedImage("arrow.triangle.swap")

	@State var value: Double = 0.25
	@State var padding: Double = 2
	@State var trackWidth: Double = 20
	@State var showIcons: Bool = false

	@State var trackColor: CGColor?

	var body: some View {
		VStack(spacing: 8) {
			HStack(spacing: 16) {
				ZStack {
					DSFSparklineCircularProgressView.SwiftUI(
						value: value,
						fillStyle: g,
						trackWidth: trackWidth,
						trackColor: CGColor(srgbRed: 0.977, green: 0.221, blue: 0.520, alpha: 0.1),
						trackIcon: showIcons ? i1 : nil
					)
					DSFSparklineCircularProgressView.SwiftUI(
						value: value * 0.8,
						fillStyle: g1,
						trackWidth: trackWidth,
						padding: 1 * (trackWidth + padding),
						trackColor: CGColor(srgbRed: 0.849, green: 1.000, blue: 0.000, alpha: 0.1),
						trackIcon: showIcons ? i2 : nil
					)
					DSFSparklineCircularProgressView.SwiftUI(
						value: value * 0.6,
						fillStyle: g2,
						trackWidth: trackWidth,
						padding: 2 * (trackWidth + padding),
						trackColor: CGColor(srgbRed: 0.000, green: 1.000, blue: 0.663, alpha: 0.1),
						trackIcon: showIcons ? i3 : nil
					)
				}
				.frame(width: 200, height: 200)

				ZStack {
					DSFSparklineCircularProgressView.SwiftUI(
						value: value,
						fillStyle: DSFSparkline.Fill.Color(CGColor(srgbRed: 1, green: 0, blue: 0, alpha: 1)),
						trackWidth: trackWidth,
						trackColor: CGColor(srgbRed: 0.977, green: 0.221, blue: 0.520, alpha: 0.1),
						trackIcon: showIcons ? i1 : nil
					)
					DSFSparklineCircularProgressView.SwiftUI(
						value: value * 0.8,
						fillStyle: DSFSparkline.Fill.Color(CGColor(srgbRed: 0, green: 1, blue: 0, alpha: 1)),
						trackWidth: trackWidth,
						padding: 1 * (trackWidth + padding),
						trackColor: CGColor(srgbRed: 0.849, green: 1.000, blue: 0.000, alpha: 0.1),
						trackIcon: showIcons ? i2 : nil
					)
					DSFSparklineCircularProgressView.SwiftUI(
						value: value * 0.6,
						fillStyle: DSFSparkline.Fill.Color(CGColor(srgbRed: 0, green: 0, blue: 1, alpha: 1)),
						trackWidth: trackWidth,
						padding: 2 * (trackWidth + padding),
						trackColor: CGColor(srgbRed: 0.000, green: 1.000, blue: 0.663, alpha: 0.1),
						trackIcon: showIcons ? i3 : nil
					)
				}
				.frame(width: 200, height: 200)
			}

			Form {
				Slider(value: $value, in: 0 ... 2.5) { Text("Value") }
			minimumValueLabel: { Text("0") }
			maximumValueLabel: { Text("2.5") }
				Slider(value: $trackWidth, in: 5 ... 25) { Text("Track Width") }
			minimumValueLabel: { Text("5") }
			maximumValueLabel: { Text("25") }
				Slider(value: $padding, in: 0 ... 10) { Text("Track padding") }
			minimumValueLabel: { Text("0") }
			maximumValueLabel: { Text("10") }
				Toggle(isOn: $showIcons) {
					Text("Show icons")
				}
			}
			#if os(iOS)
			.frame(height: 250)
			#endif

			Divider()

			HStack {
				DSFSparklineCircularProgressView.SwiftUI(
					value: 0.2,
					fillStyle: DSFSparkline.Fill.Color(srgbRed: 1, green: 0, blue: 0, alpha: 1),
					trackWidth: 5,
					trackColor: CGColor(srgbRed: 0.977, green: 0.221, blue: 0.520, alpha: 0.1)
				)
				DSFSparklineCircularProgressView.SwiftUI(
					value: 0.80,
					fillStyle: DSFSparkline.Fill.Color(srgbRed: 1, green: 1, blue: 0, alpha: 1),
					trackWidth: 5,
					trackColor: CGColor(srgbRed: 1.000, green: 1.000, blue: 0, alpha: 0.1)
				)
				DSFSparklineCircularProgressView.SwiftUI(
					value: 0.35,
					fillStyle: DSFSparkline.Fill.Color(srgbRed: 0, green: 1, blue: 0, alpha: 1),
					trackWidth: 5,
					trackColor: CGColor(srgbRed: 0.849, green: 1.000, blue: 0.000, alpha: 0.1)
				)
				DSFSparklineCircularProgressView.SwiftUI(
					value: 0.80,
					fillStyle: DSFSparkline.Fill.Color(srgbRed: 0, green: 0, blue: 1, alpha: 1),
					trackWidth: 5,
					trackColor: CGColor(srgbRed: 0.000, green: 1.000, blue: 0.663, alpha: 0.1)
				)
				DSFSparklineCircularProgressView.SwiftUI(
					value: 1.3,
					fillStyle: DSFSparkline.Fill.Color(gray: 1, alpha: 1),
					trackWidth: 5
				)
				DSFSparklineCircularProgressView.SwiftUI(
					value: 0.65,
					fillStyle: DSFSparkline.Fill.Color(gray: 0, alpha: 1),
					trackWidth: 5,
					trackColor: CGColor(gray: 0, alpha: 0.3)
				)
				DSFSparklineCircularProgressView.SwiftUI(
					value: 0.65,
					fillStyle: DSFSparkline.Fill.Color(srgbRed: 1, green: 0, blue: 1),
					trackWidth: 5,
					trackColor: CGColor(red: 1, green: 1, blue: 0, alpha: 1)
				)
			}
			.frame(height: 32)
		}
		.padding()
	}
}

struct CircularProgressView_Previews: PreviewProvider {
	static var previews: some View {
		CircularProgressView()
	}
}
