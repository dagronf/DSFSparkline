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

	enum Animation {
		case linear(Double)
		case easeInEaseOut(Double)
	}

	/// A SwiftUI wrapper for the Circular Progress sparkline overlay
	struct SwiftUI {
		let value: Double
		let animationStyle: DSFSparkline.AnimationStyle?
		let trackStyle: DSFSparklineOverlay.CircularGauge.TrackStyle
		let lineStyle: DSFSparklineOverlay.CircularGauge.TrackStyle

		/// Create a Circular Gauge view
		/// - Parameters:
		///   - value: The value to display
		///   - animationStyle: The animation style, or nil for no animation
		///   - trackStyle: The style to use when drawing the track (background ring)
		///   - lineStyle: The style to use when drawing the value line
		public init(
			value: Double,
			animationStyle: DSFSparkline.AnimationStyle? = nil,
			trackStyle: DSFSparklineOverlay.CircularGauge.TrackStyle,
			lineStyle: DSFSparklineOverlay.CircularGauge.TrackStyle
		) {
			self.value = value
			self.animationStyle = animationStyle
			self.trackStyle = trackStyle
			self.lineStyle = lineStyle
		}

		/// Create a Circular Gauge view
		/// - Parameters:
		///   - value: The value to display
		///   - animationStyle: The animation style, or nil for no animation
		///   - trackWidth: The width of the track
		///   - trackFill: The fill style to use for the track
		///   - valueWidth: The width of the value line
		///   - valueFill: The fill style to use for the value line
		public init(
			value: Double,
			animationStyle: DSFSparkline.AnimationStyle? = nil,
			trackWidth: Double = 10,
			trackFill: DSFSparklineFillable,
			valueWidth: Double = 7,
			valueFill: DSFSparklineFillable
		) {
			self.value = value
			self.animationStyle = animationStyle
			self.trackStyle = .init(width: trackWidth, fillColor: trackFill)
			self.lineStyle = .init(width: valueWidth, fillColor: valueFill)
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
		view.animationStyle = self.animationStyle
		view.trackStyle = self.trackStyle
		view.lineStyle = self.lineStyle
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
		if view.animationStyle !== self.animationStyle {
			view.animationStyle = self.animationStyle
		}
		if view.trackStyle !== self.trackStyle {
			view.trackStyle = self.trackStyle
		}
		if view.lineStyle !== self.lineStyle {
			view.lineStyle = self.lineStyle
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
						lineStyle: .init(width: 10, fillColor: DSFSparkline.Fill.Color(gray: 0.5, alpha: 1.0))
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
							lineStyle: .init(width: 10, fillColor: DSFSparkline.Fill.Color(srgbRed: 1, green: 0, blue: 1, alpha: 1), shadow: isShadowed == 2 ? .init(blurRadius: 2, offset: CGSize(width: 1, height: 1), color: .black) : nil)
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
							lineStyle: .init(
								width: 10,
								fillColor: ge,
								strokeWidth: 0.2,
								strokeColor: CGColor.standard.black,
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

#endif
