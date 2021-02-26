//
//  DSFSparklinePieGraphView+SwiftUI.swift
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
public extension DSFSparklinePieGraphView {
	struct SwiftUI {
		/// Datasource for the graph
		let dataSource: DSFSparkline.StaticDataSource
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

		/// Create a sparkline graph that displays dots (like the CPU history graph in Activity Monitor)
		/// - Parameters:
		///   - dataSource: The data source for the graph
		public init(dataSource: DSFSparkline.StaticDataSource,
						palette: DSFSparkline.Palette = .shared,
						strokeColor: DSFColor? = nil,
						lineWidth: CGFloat = 1.0,
						animated: Bool = false,
						animationDuration: CGFloat = 0.25)
		{
			self.dataSource = dataSource
			self.strokeColor = strokeColor
			self.lineWidth = lineWidth
			self.palette = palette
			self.animated = animated
			self.animationDuration = animationDuration
		}
	}
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
extension DSFSparklinePieGraphView.SwiftUI: DSFViewRepresentable {
	#if os(macOS)
	public typealias NSViewType = DSFSparklinePieGraphView
	#else
	public typealias UIViewType = DSFSparklinePieGraphView
	#endif

	public class Coordinator: NSObject {
		let parent: DSFSparklinePieGraphView.SwiftUI
		init(_ sparkline: DSFSparklinePieGraphView.SwiftUI) {
			self.parent = sparkline
		}
	}

	public func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	func makePieGraph(_: Context) -> DSFSparklinePieGraphView {
		let view = DSFSparklinePieGraphView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.strokeColor = self.strokeColor
		view.lineWidth = self.lineWidth
		view.palette = self.palette

		view.animated = self.animated
		view.animationDuration = self.animationDuration

		view.dataSource = self.dataSource
		return view
	}
}

// MARK: - iOS/tvOS Specific

@available(iOS 13.0, tvOS 13.0, macOS 9999.0, *)
public extension DSFSparklinePieGraphView.SwiftUI {
	func makeUIView(context: Context) -> DSFSparklinePieGraphView {
		return self.makePieGraph(context)
	}

	func updateUIView(_ view: DSFSparklinePieGraphView, context _: Context) {
		self.updateView(view)
	}
}

// MARK: - macOS Specific

@available(macOS 10.15, iOS 9999.0, tvOS 9999.0, *)
public extension DSFSparklinePieGraphView.SwiftUI {
	func makeNSView(context: Context) -> DSFSparklinePieGraphView {
		return self.makePieGraph(context)
	}

	func updateNSView(_ view: DSFSparklinePieGraphView, context _: Context) {
		self.updateView(view)
	}
}

// MARK: - Common updates

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
public extension DSFSparklinePieGraphView.SwiftUI {
	func updateView(_ view: DSFSparklinePieGraphView) {
		UpdateIfNotEqual(result: &view.strokeColor, val: self.strokeColor)
		UpdateIfNotEqual(result: &view.lineWidth, val: self.lineWidth)
		UpdateIfNotEqual(result: &view.palette, val: self.palette)

		UpdateIfNotEqual(result: &view.animated, val: self.animated)
		UpdateIfNotEqual(result: &view.animationDuration, val: self.animationDuration)

		UpdateIfNotEqual(result: &view.dataSource, val: self.dataSource)
	}
}


#endif
