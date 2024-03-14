//
//  DSFSparklineWiperGaugeGraphView+SwiftUI.swift
//
//  Copyright © 2023 Darren Ford. All rights reserved.
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
public extension DSFSparklineWiperGaugeGraphView {

	/// The SwiftUI percent bar graph
	struct SwiftUI {

		/// Palette to use when coloring the chart
		let valueColor: DSFSparkline.ValueBasedFill
		/// The 'background' color for the value
		let valueBackgroundColor: DSFColor?
		/// The color of the upper arc for the control
		let upperArcColor: DSFColor?
		/// The color of the pointer
		let pointerColor: DSFColor?
		/// The background color for the gauge
		let backgroundColor: DSFColor?
		/// The value to display in the chart
		let value: Double
		/// Should changes to value be animated?
		let animationStyle: DSFSparkline.AnimationStyle?

		/// Create a sparkline graph that displays a 0 ... 1 value as a gauge
		public init(
			valueColor: DSFSparkline.ValueBasedFill,
			value: Double,
			valueBackgroundColor: DSFColor? = nil,
			upperArcColor: DSFColor? = nil,
			pointerColor: DSFColor? = nil,
			backgroundColor: DSFColor? = nil,
			animationStyle: DSFSparkline.AnimationStyle? = nil
		) {
			self.valueColor = valueColor
			self.valueBackgroundColor = valueBackgroundColor
			self.upperArcColor = upperArcColor
			self.pointerColor = pointerColor
			self.backgroundColor = backgroundColor
			self.value = value
			self.animationStyle = animationStyle
		}

		/// Create a sparkline graph that displays a 0 ... 1 value as a gauge
		public init(
			valueColor: DSFColor,
			value: Double,
			valueBackgroundColor: DSFColor? = nil,
			upperArcColor: DSFColor? = nil,
			pointerColor: DSFColor? = nil,
			backgroundColor: DSFColor? = nil,
			animationStyle: DSFSparkline.AnimationStyle? = nil
		) {
			self.valueColor = DSFSparkline.ValueBasedFill(flatColor: valueColor.cgColor)
			self.valueBackgroundColor = valueBackgroundColor
			self.upperArcColor = upperArcColor
			self.pointerColor = pointerColor
			self.backgroundColor = backgroundColor
			self.value = value
			self.animationStyle = animationStyle
		}
	}
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
extension DSFSparklineWiperGaugeGraphView.SwiftUI: DSFViewRepresentable {
	#if os(macOS)
	public typealias NSViewType = DSFSparklineWiperGaugeGraphView
	#else
	public typealias UIViewType = DSFSparklineWiperGaugeGraphView
	#endif
	
	public class Coordinator: NSObject {
		let parent: DSFSparklineWiperGaugeGraphView.SwiftUI
		init(_ sparkline: DSFSparklineWiperGaugeGraphView.SwiftUI) {
			self.parent = sparkline
		}
	}
	
	public func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}
	
	func makeWiperGauge(_: Context) -> DSFSparklineWiperGaugeGraphView {
		let view = DSFSparklineWiperGaugeGraphView(frame: .zero)
		self.updateView(view)
		return view
	}
}

// MARK: - iOS/tvOS Specific

@available(iOS 13.0, tvOS 13.0, macOS 9999.0, *)
public extension DSFSparklineWiperGaugeGraphView.SwiftUI {
	func makeUIView(context: Context) -> DSFSparklineWiperGaugeGraphView {
		return self.makeWiperGauge(context)
	}
	
	func updateUIView(_ view: DSFSparklineWiperGaugeGraphView, context _: Context) {
		self.updateView(view)
	}
}

// MARK: - macOS Specific

@available(macOS 10.15, iOS 9999.0, tvOS 9999.0, *)
public extension DSFSparklineWiperGaugeGraphView.SwiftUI {
	func makeNSView(context: Context) -> DSFSparklineWiperGaugeGraphView {
		return self.makeWiperGauge(context)
	}
	
	func updateNSView(_ view: DSFSparklineWiperGaugeGraphView, context _: Context) {
		self.updateView(view)
	}
}

// MARK: - Common updates

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
public extension DSFSparklineWiperGaugeGraphView.SwiftUI {
	func updateView(_ view: DSFSparklineWiperGaugeGraphView) {
		view.valueColor = self.valueColor
		if let c = self.valueBackgroundColor {
			view.valueBackgroundColor = c
		}
		if let c = self.upperArcColor {
			view.gaugeUpperArcColor = c
		}
		if let c = self.pointerColor {
			view.gaugePointerColor = c
		}
		if view.animationStyle != self.animationStyle {
			view.animationStyle = self.animationStyle
		}
		view.value = CGFloat(self.value)
	}
}

#endif
