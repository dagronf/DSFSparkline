//
//  DSFSparklineLineGraph+SwiftUI.swift
//  DSFSparklines
//
//  Created by Darren Ford on 7/12/20.
//  Copyright © 2020 Darren Ford. All rights reserved.
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
public extension DSFSparklineLineGraph {
	struct SwiftUI {

		/// Datasource for the graph
		let dataSource: DSFSparklineDataSource
		/// The primary color for the sparkline
		let graphColor: DSFColor
		/// Draw a dotted line at the zero point on the y-axis
		let showZero: Bool

		/// The width for the line drawn on the graph
		let lineWidth: CGFloat
		/// The number of vertical buckets to break the input data up into
		let interpolated: Bool
		/// The secondary color for the sparkline
		let lineShading: Bool
		/// Draw a shadow under the line
		let shadowed: Bool

		public init(dataSource: DSFSparklineDataSource,
					graphColor: DSFColor,
					showZero: Bool = false,
					lineWidth: CGFloat = 1.5,
					interpolated: Bool = false,
					lineShading: Bool = true,
					shadowed: Bool = false) {
			self.dataSource = dataSource
			self.graphColor = graphColor
			self.showZero = showZero

			self.lineWidth = lineWidth
			self.interpolated = interpolated
			self.lineShading = lineShading
			self.shadowed = shadowed
		}
	}
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
extension DSFSparklineLineGraph.SwiftUI: DSFViewRepresentable {

	#if os(macOS)
	public typealias NSViewType = DSFSparklineLineGraph
	#else
	public typealias UIViewType = DSFSparklineLineGraph
	#endif

	public class Coordinator: NSObject {
		let parent: DSFSparklineLineGraph.SwiftUI
		init(_ sparkline: DSFSparklineLineGraph.SwiftUI) {
			self.parent = sparkline
		}
	}

	public func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	func makeLineGraph(_ context: Context) -> DSFSparklineLineGraph {
		let view = DSFSparklineLineGraph(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false
		let windowSize = self.dataSource.windowSize
		view.dataSource = self.dataSource
		view.windowSize = windowSize
		view.graphColor = self.graphColor
		view.showZero = self.showZero

		view.lineWidth = self.lineWidth
		view.interpolated = self.interpolated
		view.lineShading = self.lineShading
		view.shadowed = self.shadowed

		return view
	}
}

// MARK: - iOS/tvOS Specific

@available(iOS 13.0, tvOS 13.0, macOS 9999.0, *)
extension DSFSparklineLineGraph.SwiftUI {
	public func makeUIView(context: Context) -> DSFSparklineLineGraph {
		return self.makeLineGraph(context)
	}

	public func updateUIView(_ uiView: DSFSparklineLineGraph, context: Context) {

	}
}

// MARK: - macOS Specific

@available(macOS 10.15, iOS 9999.0, tvOS 9999.0, *)
extension DSFSparklineLineGraph.SwiftUI {
	public func makeNSView(context: Context) -> DSFSparklineLineGraph {
		return self.makeLineGraph(context)
	}

	public func updateNSView(_ uiView: DSFSparklineLineGraph, context: Context) {

	}
}

#endif
