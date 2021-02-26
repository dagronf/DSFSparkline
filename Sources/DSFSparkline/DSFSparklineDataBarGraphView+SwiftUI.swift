//
//  DSFSparklineDataBarGraphView+SwiftUI.swift
//  DSFSparklines
//
//  Created by Darren Ford on 12/2/21.
//  Copyright © 2021 Darren Ford. All rights reserved.
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
public extension DSFSparklineDataBarGraphView {
	struct SwiftUI {
		/// Datasource for the graph
		let dataSource: DSFSparkline.StaticDataSource
		/// Maximum total value.  If -1, this value is i
		let maximumTotalValue: CGFloat
		/// The 'undrawn' color for the graph
		let unsetColor: DSFColor?

		/// Palette to use when coloring the chart
		let palette: DSFSparkline.Palette

		/// Stroke Color
		let strokeColor: DSFColor?

		/// Stroke Width
		let lineWidth: CGFloat

		/// Should we animate the dataSource changes
		let animated: Bool
		/// The duration of the animation
		let animationDuration: CGFloat

		/// Create a databar graph
		/// - Parameters:
		///   - dataSource: The data source for the graph
		///   - maximumTotalValue: The maximum _total_ value. If the datasource values total is greater than this value, it clips the display
		///   - palette: The color palette to use when drawing the graph
		///   - unsetColor: (optional) the color to use when drawing the background (useful when the maximumValue is also set)
		///   - strokeColor: The color to draw the separator lines between data points
		///   - lineWidth: The width of the separator lines
		///   - animated: If set, animates any datasource value changes
		///   - animationDuration: The duration for the animate-in animation
		public init(dataSource: DSFSparkline.StaticDataSource,
						maximumTotalValue: CGFloat = -1,
						palette: DSFSparkline.Palette = .shared,
						unsetColor: DSFColor? = nil,
						strokeColor: DSFColor? = nil,
						lineWidth: CGFloat = 1.0,
						animated: Bool = false,
						animationDuration: CGFloat = 0.25)
		{
			self.dataSource = dataSource
			self.maximumTotalValue = maximumTotalValue
			self.unsetColor = unsetColor
			self.strokeColor = strokeColor
			self.lineWidth = lineWidth
			self.palette = palette
			self.animated = animated
			self.animationDuration = animationDuration
		}
	}
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
extension DSFSparklineDataBarGraphView.SwiftUI: DSFViewRepresentable {
	#if os(macOS)
	public typealias NSViewType = DSFSparklineDataBarGraphView
	#else
	public typealias UIViewType = DSFSparklineDataBarGraphView
	#endif

	public class Coordinator: NSObject {
		let parent: DSFSparklineDataBarGraphView.SwiftUI
		init(_ sparkline: DSFSparklineDataBarGraphView.SwiftUI) {
			self.parent = sparkline
		}
	}

	public func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	func makeDataBarGraph(_: Context) -> DSFSparklineDataBarGraphView {
		let view = DSFSparklineDataBarGraphView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.strokeColor = self.strokeColor
		view.unsetColor = self.unsetColor
		view.lineWidth = self.lineWidth
		view.palette = self.palette

		view.animated = self.animated
		view.animationDuration = self.animationDuration

		view.dataSource = self.dataSource
		view.maximumTotalValue = self.maximumTotalValue
		return view
	}
}

// MARK: - iOS/tvOS Specific

@available(iOS 13.0, tvOS 13.0, macOS 9999.0, *)
public extension DSFSparklineDataBarGraphView.SwiftUI {
	func makeUIView(context: Context) -> DSFSparklineDataBarGraphView {
		return self.makeDataBarGraph(context)
	}

	func updateUIView(_ view: DSFSparklineDataBarGraphView, context _: Context) {
		self.updateView(view)
	}
}

// MARK: - macOS Specific

@available(macOS 10.15, iOS 9999.0, tvOS 9999.0, *)
public extension DSFSparklineDataBarGraphView.SwiftUI {
	func makeNSView(context: Context) -> DSFSparklineDataBarGraphView {
		return self.makeDataBarGraph(context)
	}

	func updateNSView(_ view: DSFSparklineDataBarGraphView, context _: Context) {
		self.updateView(view)
	}
}

// MARK: - Common updates

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
public extension DSFSparklineDataBarGraphView.SwiftUI {
	func updateView(_ view: DSFSparklineDataBarGraphView) {
		UpdateIfNotEqual(result: &view.strokeColor, val: self.strokeColor)
		UpdateIfNotEqual(result: &view.unsetColor, val: self.unsetColor)
		
		UpdateIfNotEqual(result: &view.lineWidth, val: self.lineWidth)

		UpdateIfNotEqual(result: &view.palette, val: self.palette)

		UpdateIfNotEqual(result: &view.animated, val: self.animated)
		UpdateIfNotEqual(result: &view.animationDuration, val: self.animationDuration)

		UpdateIfNotEqual(result: &view.dataSource, val: self.dataSource)

		UpdateIfNotEqual(result: &view.maximumTotalValue, val: self.maximumTotalValue)
	}
}

#endif
