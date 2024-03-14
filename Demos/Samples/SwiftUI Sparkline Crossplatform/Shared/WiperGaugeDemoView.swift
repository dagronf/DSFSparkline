//
//  PieGraphDemoView.swift
//  Demos
//
//  Created by Darren Ford on 16/2/21.
//

import SwiftUI
import DSFSparkline

fileprivate let palette1 = DSFSparkline.Palette([.systemRed, .systemOrange, .systemYellow])
fileprivate let palette2 = DSFSparkline.Palette.shared
fileprivate let grays = DSFSparkline.Palette([.systemGreen, .systemRed])

fileprivate let coldHot = DSFSparkline.GradientBucket(posts: [
	DSFSparkline.GradientBucket.Post(color: CGColor(red: 0, green: 0, blue: 1, alpha: 1), location: 0),
	DSFSparkline.GradientBucket.Post(color: CGColor(red: 0, green: 0, blue: 1, alpha: 1), location: 0.3),
	DSFSparkline.GradientBucket.Post(color: CGColor(red: 1, green: 0.581, blue: 0, alpha: 1), location: 0.6),
	DSFSparkline.GradientBucket.Post(color: CGColor(red: 1, green: 0, blue: 0, alpha: 1), location: 0.8),
	DSFSparkline.GradientBucket.Post(color: CGColor(red: 1, green: 0, blue: 0, alpha: 1), location: 1)
])

struct WiperGraphDemoView: View {
	@State var randomValue: CGFloat = CGFloat.random(in: 0...1)

	@State var sliderValue: CGFloat = 0.75

	@State var animationDuration: Double = 0.5

	var body: some View {
		ScrollView {
			VStack(spacing: 8) {
				Text("Palette colors").font(.title2).bold()
				HStack(spacing: 8) {
					ForEach(0 ..< 7) {
						DSFSparklineWiperGaugeGraphView.SwiftUI(valueColor: DSFSparkline.ValueBasedFill(palette: palette2), value: Double($0) / 7.0 + 0.1)
							.frame(width: 48, height: 24)
					}
				}

				Divider()

				Text("Solid colors").font(.title2).bold()
				HStack(spacing: 8) {
					ForEach(0 ..< 6) {
						DSFSparklineWiperGaugeGraphView.SwiftUI(
							valueColor: DSFSparkline.ValueBasedFill(flatColor: CGColor(srgbRed: 0.1, green: 0.4, blue: 1.0, alpha: 1)),
							value: Double($0) / 6.0 + 0.1
						)
						.frame(width: 48, height: 24)
					}
				}

				Divider()

				VStack {
					Text("Palette colors (discrete)").font(.title2).bold()
					HStack {
						VStack {
							DSFSparklineWiperGaugeGraphView.SwiftUI(valueColor: DSFSparkline.ValueBasedFill(palette: palette2), value: randomValue)
								.frame(width: 64, height: 32)
							Text("default")
						}
						VStack {
							DSFSparklineWiperGaugeGraphView.SwiftUI(
								valueColor: DSFSparkline.ValueBasedFill(palette: palette2),
								value: randomValue,
								animationStyle: .init(duration: animationDuration)
							)
								.frame(width: 64, height: 32)
							Text("animated")
						}
						Divider().frame(height: 60)

						VStack {
							HStack {
								Button("Random") {
									randomValue = CGFloat.random(in: 0...1)
								}
								Button("Min") { randomValue = 0 }
								Button("Max") { randomValue = 1 }
								Slider(value: $animationDuration, in: 0 ... 2)
								.frame(width: 100)
							}
							Text("\(randomValue)")
								.font(.custom("FontNameMono", fixedSize: 12))
						}
					}
					HStack {
						VStack {
							DSFSparklineWiperGaugeGraphView.SwiftUI(
								valueColor: DSFSparkline.ValueBasedFill(palette: palette2),
								value: randomValue
							)
							.frame(width: 128, height: 64)
							Text("default")
						}
						VStack {
							DSFSparklineWiperGaugeGraphView.SwiftUI(
								valueColor: DSFSparkline.ValueBasedFill(palette: palette2),
								value: randomValue,
								animationStyle: .init(duration: animationDuration)
							)
							.frame(width: 128, height: 64)
							Text("animated")
						}
					}
					Divider()
					VStack {
						Text("Value color types").font(.title2).bold()
						HStack {
							VStack {
								DSFSparklineWiperGaugeGraphView.SwiftUI(valueColor: DSFSparkline.ValueBasedFill(flatColor: CGColor(srgbRed: 0.1, green: 0.4, blue: 0.8, alpha: 1)), value: sliderValue)
									.frame(width: 200, height: 100)
								Text("Solid color")
							}
							VStack {
								DSFSparklineWiperGaugeGraphView.SwiftUI(valueColor: DSFSparkline.ValueBasedFill(gradient: coldHot), value: sliderValue)
									.frame(width: 200, height: 100)
								Text("Smooth gradient")
							}
							VStack {
								DSFSparklineWiperGaugeGraphView.SwiftUI(valueColor: DSFSparkline.ValueBasedFill.sharedPalette, value: sliderValue)
									.frame(width: 200, height: 100)
								Text("Bucket Color")
							}
						}
						Slider(value: $sliderValue)
							.frame(width: 200)
					}
					Divider()
					VStack {
						Text("Color components").font(.title2).bold()
						DSFSparklineWiperGaugeGraphView.SwiftUI(
							valueColor: DSFColor(red: 0.1, green: 0.4, blue: 0.8, alpha: 1),
							value: sliderValue,
							valueBackgroundColor: DSFColor.red,
							upperArcColor: DSFColor.yellow,
							pointerColor: DSFColor.green, 
							backgroundColor: DSFColor.purple
						)
						.frame(width: 200, height: 100)
					}
				}
			}
		}
	}
}

struct WiperGraphDemoView_Previews: PreviewProvider {
	static var previews: some View {
		WiperGraphDemoView()
	}
}
