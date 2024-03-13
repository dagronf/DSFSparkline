//
//  DSFSparklineCircularGaugeView+SwiftUI.swift
//
//  Copyright © 2024 Darren Ford. All rights reserved.
//
//  MIT license
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
//  documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial
//  portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
//  WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
//  OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
//  OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#if canImport(SwiftUI)

import SwiftUI

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
public extension DSFSparklineCircularGaugeView {
	/// A SwiftUI wrapper for the Circular Progress sparkline overlay
	struct SwiftUI {
		let value: Double
		let trackStyle: DSFSparklineOverlay.CircularGauge.TrackStyle
		let valueStyle: DSFSparklineOverlay.CircularGauge.TrackStyle

		public init(
			value: Double,
			trackStyle: DSFSparklineOverlay.CircularGauge.TrackStyle,
			valueStyle: DSFSparklineOverlay.CircularGauge.TrackStyle
		) {
			self.value = value
			self.trackStyle = trackStyle
			self.valueStyle = valueStyle
		}

		public init(
			value: Double,
			trackWidth: Double = 10,
			trackFill: DSFSparklineFillable,
			valueWidth: Double = 7,
			valueFill: DSFSparklineFillable
		) {
			self.value = value
			self.trackStyle = .init(width: trackWidth, fillColor: trackFill)
			self.valueStyle = .init(width: valueWidth, fillColor: valueFill)
		}
	}
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
extension DSFSparklineCircularGaugeView.SwiftUI: DSFViewRepresentable {
#if os(macOS)
	public typealias NSViewType = DSFSparklineCircularGaugeView
#else
	public typealias UIViewType = DSFSparklineCircularGaugeView
#endif

	func makeCircularGauge(_: Context) -> DSFSparklineCircularGaugeView {
		let view = DSFSparklineCircularGaugeView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.value = self.value
		view.trackStyle = self.trackStyle
		view.valueStyle = self.valueStyle
		return view
	}
}

// MARK: - iOS/tvOS Specific

@available(iOS 13.0, tvOS 13.0, macOS 9999.0, *)
public extension DSFSparklineCircularGaugeView.SwiftUI {
	func makeUIView(context: Context) -> DSFSparklineCircularGaugeView {
		return self.makeCircularGauge(context)
	}

	func updateUIView(_ view: DSFSparklineCircularGaugeView, context _: Context) {
		self.updateView(view)
	}
}

// MARK: - macOS Specific

@available(macOS 10.15, iOS 9999.0, tvOS 9999.0, *)
public extension DSFSparklineCircularGaugeView.SwiftUI {
	func makeNSView(context: Context) -> DSFSparklineCircularGaugeView {
		return self.makeCircularGauge(context)
	}

	func updateNSView(_ view: DSFSparklineCircularGaugeView, context _: Context) {
		self.updateView(view)
	}
}

// MARK: - Common updates

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
public extension DSFSparklineCircularGaugeView.SwiftUI {
	func updateView(_ view: DSFSparklineCircularGaugeView) {
		UpdateIfNotEqual(result: &view.value, val: self.value)
		if view.trackStyle !== self.trackStyle {
			view.trackStyle = self.trackStyle
		}
		if view.valueStyle !== self.valueStyle {
			view.valueStyle = self.valueStyle
		}
	}
}

#if DEBUG
@available(macOS 10.15, *)
struct DSFSparklineCircularGaugeViewPreviews: PreviewProvider {
	static var previews: some SwiftUI.View {

		let ge = DSFSparkline.Fill.Gradient(
			colors: [
				CGColor(srgbRed: 1, green: 0.000, blue: 0.00, alpha: 1.0),
				CGColor(srgbRed: 0, green: 0.0, blue: 1, alpha: 1.0),
			]
		)

		let vals = [Double](stride(from: 0, through: 1, by: 0.2))
		VStack {
			HStack {
				ForEach(vals, id: \.self) { value in
					DSFSparklineCircularGaugeView.SwiftUI(
						value: value,
						trackStyle: .init(width: 20, fillColor: DSFSparkline.Fill.Color(gray: 0.5, alpha: 0.2)),
						valueStyle: .init(width: 10, fillColor: DSFSparkline.Fill.Color(gray: 0.5, alpha: 1.0))
					)
					.frame(width: 64, height: 64)
				}
			}

			Divider()

			ForEach([0, 1, 2], id: \.self) { isShadowed in
				HStack {
					ForEach(vals, id: \.self) { value in
						DSFSparklineCircularGaugeView.SwiftUI(
							value: value,
							trackStyle: .init(width: 20, fillColor: DSFSparkline.Fill.Color(srgbRed: 1, green: 0, blue: 1, alpha: 0.2), shadow: isShadowed == 1 ? .init(blurRadius: 2, offset: CGSize(width: 1, height: 1), color: .black) : nil),
							valueStyle: .init(width: 10, fillColor: DSFSparkline.Fill.Color(srgbRed: 1, green: 0, blue: 1, alpha: 1), shadow: isShadowed == 2 ? .init(blurRadius: 2, offset: CGSize(width: 1, height: 1), color: .black) : nil)
						)
						.frame(width: 64, height: 64)
					}
				}
			}

			Divider()

			ForEach([0, 1, 2], id: \.self) { isShadowed in
				HStack {
					ForEach(vals, id: \.self) { value in
						DSFSparklineCircularGaugeView.SwiftUI(
							value: value,
							trackStyle: .init(
								width: 20,
								fillColor: DSFSparkline.Fill.Color(gray: 0.5, alpha: 0.2),
								shadow: isShadowed == 1 ? .init(blurRadius: 1, offset: CGSize(width: 1, height: 1), color: .black.copy(alpha: 0.8)!, isInner: true) : nil
							),
							valueStyle: .init(
								width: 10,
								fillColor: ge,
								strokeWidth: 0.2,
								strokeColor: CGColor.commonBlack,
								shadow: isShadowed == 2 ? .init(blurRadius: 1, offset: CGSize(width: 1, height: 1), color: .black.copy(alpha: 0.8)!, isInner: true) : nil
							)
						)
						.frame(width: 64, height: 64)
					}
				}
			}
		}
		.padding()
	}
}
#endif


//@available(macOS 10.15, *)
//struct DSFSparklineCircularGaugeViewPreviews: PreviewProvider {
//	static var previews: some SwiftUI.View {
//		let ge = DSFSparkline.Fill.Gradient(
//			colors: [
//				CGColor(srgbRed: 1, green: 0.000, blue: 0.00, alpha: 1.0),
//				CGColor(srgbRed: 0, green: 0.0, blue: 1, alpha: 1.0),
//			]
//		)
//
//		let g = DSFSparkline.Fill.Gradient(
//			colors: [
//				CGColor(srgbRed: 0.977, green: 0.221, blue: 0.520, alpha: 1.0),
//				CGColor(srgbRed: 0.891, green: 0.000, blue: 0.090, alpha: 1.0),
//			]
//		)
//		let g1 = DSFSparkline.Fill.Gradient(
//			colors: [
//				CGColor(srgbRed: 0.849, green: 1.000, blue: 0.000, alpha: 1.0),
//				CGColor(srgbRed: 0.601, green: 1.000, blue: 0.009, alpha: 1.0),
//			]
//		)
//		let g2 = DSFSparkline.Fill.Gradient(
//			colors: [
//				CGColor(srgbRed: 0.000, green: 1.000, blue: 0.663, alpha: 1.0),
//				CGColor(srgbRed: 0.015, green: 0.847, blue: 1.000, alpha: 1.0),
//			]
//		)
//		let g3 = DSFSparkline.Fill.Gradient(
//			colors: [
//				CGColor(srgbRed: 0.996, green: 0.759, blue: 0.300, alpha: 1.0),
//				CGColor(srgbRed: 0.996, green: 0.459, blue: 0.000, alpha: 1.0),
//			]
//		)
//
//		let i1 = namedImage("arrow.right")
//		let i2 = namedImage("arrow.up")
//		let i3 = namedImage("arrow.triangle.swap")
//		let i4 = namedImage("phone.arrow.right")
//
//		ScrollView([.horizontal, .vertical]) {
//			VStack {
//				HStack(alignment: .center) {
//					DSFSparklineCircularGaugeView.SwiftUI(value: 0, trackWidth: 20)
//						.frame(width: 100, height: 100)
//					DSFSparklineCircularGaugeView.SwiftUI(value: 0.4, trackWidth: 20)
//						.frame(width: 100, height: 100)
//					DSFSparklineCircularGaugeView.SwiftUI(value: 0.8, trackWidth: 20)
//						.frame(width: 100, height: 100)
//					DSFSparklineCircularGaugeView.SwiftUI(value: 1.2, trackWidth: 20)
//						.frame(width: 100, height: 100)
//					DSFSparklineCircularGaugeView.SwiftUI(value: 1.6, trackWidth: 20)
//						.frame(width: 100, height: 100)
//					DSFSparklineCircularGaugeView.SwiftUI(value: 2.0, trackWidth: 20)
//						.frame(width: 100, height: 100)
//				}
//
//				ForEach(0 ..< 2) { which in
//
//					HStack(alignment: .center) {
//						DSFSparklineCircularGaugeView.SwiftUI(value: 0, fillStyle: ge, trackWidth: 25, trackIcon: which == 1 ? i1 : nil)
//							.frame(width: 100, height: 100)
//						DSFSparklineCircularGaugeView.SwiftUI(value: 0.4, fillStyle: ge, trackWidth: 25, trackIcon: which == 1 ? i1 : nil)
//							.frame(width: 100, height: 100)
//						DSFSparklineCircularGaugeView.SwiftUI(value: 0.8, fillStyle: ge, trackWidth: 25, trackIcon: which == 1 ? i1 : nil)
//							.frame(width: 100, height: 100)
//						DSFSparklineCircularGaugeView.SwiftUI(value: 1.2, fillStyle: ge, trackWidth: 25, trackIcon: which == 1 ? i1 : nil)
//							.frame(width: 100, height: 100)
//						DSFSparklineCircularGaugeView.SwiftUI(value: 1.6, fillStyle: ge, trackWidth: 25, trackIcon: which == 1 ? i1 : nil)
//							.frame(width: 100, height: 100)
//						DSFSparklineCircularGaugeView.SwiftUI(value: 2.0, fillStyle: ge, trackWidth: 25, trackIcon: which == 1 ? i1 : nil)
//							.frame(width: 100, height: 100)
//					}
//				}
//
//				HStack(alignment: .center) {
//					ZStack {
//						DSFSparklineCircularGaugeView.SwiftUI(value: 0, fillStyle: g, trackColor: CGColor(srgbRed: 0.977, green: 0.221, blue: 0.520, alpha: 0.1)              , trackIcon: i1)
//						DSFSparklineCircularGaugeView.SwiftUI(value: 0, fillStyle: g1, padding: 12, trackColor: CGColor(srgbRed: 0.849, green: 1.000, blue: 0.000, alpha: 0.1), trackIcon: i2)
//						DSFSparklineCircularGaugeView.SwiftUI(value: 0, fillStyle: g2, padding: 24, trackColor: CGColor(srgbRed: 0.000, green: 1.000, blue: 0.663, alpha: 0.1), trackIcon: i3)
//						DSFSparklineCircularGaugeView.SwiftUI(value: 0, fillStyle: g3, padding: 36, trackColor: CGColor(srgbRed: 0.996, green: 0.759, blue: 0.300, alpha: 0.1), trackIcon: i4)
//					}
//					.frame(width: 150, height: 150)
//					ZStack {
//						DSFSparklineCircularGaugeView.SwiftUI(value: 0.4, fillStyle: g, trackColor: CGColor(srgbRed: 0.977, green: 0.221, blue: 0.520, alpha: 0.1)              , trackIcon: i1)
//						DSFSparklineCircularGaugeView.SwiftUI(value: 0.3, fillStyle: g1, padding: 12, trackColor: CGColor(srgbRed: 0.849, green: 1.000, blue: 0.000, alpha: 0.1), trackIcon: i2)
//						DSFSparklineCircularGaugeView.SwiftUI(value: 0.2, fillStyle: g2, padding: 24, trackColor: CGColor(srgbRed: 0.000, green: 1.000, blue: 0.663, alpha: 0.1), trackIcon: i3)
//						DSFSparklineCircularGaugeView.SwiftUI(value: 0.1, fillStyle: g3, padding: 36, trackColor: CGColor(srgbRed: 0.996, green: 0.759, blue: 0.300, alpha: 0.1), trackIcon: i4)
//					}
//					.frame(width: 150, height: 150)
//					ZStack {
//						DSFSparklineCircularGaugeView.SwiftUI(value: 0.7, fillStyle: g, trackColor: CGColor(srgbRed: 0.977, green: 0.221, blue: 0.520, alpha: 0.1)              , trackIcon: i1)
//						DSFSparklineCircularGaugeView.SwiftUI(value: 0.6, fillStyle: g1, padding: 12, trackColor: CGColor(srgbRed: 0.849, green: 1.000, blue: 0.000, alpha: 0.1), trackIcon: i2)
//						DSFSparklineCircularGaugeView.SwiftUI(value: 0.5, fillStyle: g2, padding: 24, trackColor: CGColor(srgbRed: 0.000, green: 1.000, blue: 0.663, alpha: 0.1), trackIcon: i3)
//						DSFSparklineCircularGaugeView.SwiftUI(value: 0.4, fillStyle: g3, padding: 36, trackColor: CGColor(srgbRed: 0.996, green: 0.759, blue: 0.300, alpha: 0.1), trackIcon: i4)
//					}
//					.frame(width: 150, height: 150)
//					ZStack {
//						DSFSparklineCircularGaugeView.SwiftUI(value: 1.4, fillStyle: g, trackColor: CGColor(srgbRed: 0.977, green: 0.221, blue: 0.520, alpha: 0.1)              , trackIcon: i1)
//						DSFSparklineCircularGaugeView.SwiftUI(value: 1.3, fillStyle: g1, padding: 12, trackColor: CGColor(srgbRed: 0.849, green: 1.000, blue: 0.000, alpha: 0.1), trackIcon: i2)
//						DSFSparklineCircularGaugeView.SwiftUI(value: 1.2, fillStyle: g2, padding: 24, trackColor: CGColor(srgbRed: 0.000, green: 1.000, blue: 0.663, alpha: 0.1), trackIcon: i3)
//						DSFSparklineCircularGaugeView.SwiftUI(value: 1.1, fillStyle: g3, padding: 36, trackColor: CGColor(srgbRed: 0.996, green: 0.759, blue: 0.300, alpha: 0.1), trackIcon: i4)
//					}
//					.frame(width: 150, height: 150)
//					ZStack {
//						DSFSparklineCircularGaugeView.SwiftUI(value: 1.9, fillStyle: g, trackColor: CGColor(srgbRed: 0.977, green: 0.221, blue: 0.520, alpha: 0.1)              , trackIcon: i1)
//						DSFSparklineCircularGaugeView.SwiftUI(value: 1.8, fillStyle: g1, padding: 12, trackColor: CGColor(srgbRed: 0.849, green: 1.000, blue: 0.000, alpha: 0.1), trackIcon: i2)
//						DSFSparklineCircularGaugeView.SwiftUI(value: 1.7, fillStyle: g2, padding: 24, trackColor: CGColor(srgbRed: 0.000, green: 1.000, blue: 0.663, alpha: 0.1), trackIcon: i3)
//						DSFSparklineCircularGaugeView.SwiftUI(value: 1.6, fillStyle: g3, padding: 36, trackColor: CGColor(srgbRed: 0.996, green: 0.759, blue: 0.300, alpha: 0.1), trackIcon: i4)
//					}
//					.frame(width: 150, height: 150)
//				}
//			}
//			.padding()
//		}
//	}
//}
//
//#endif

#endif
