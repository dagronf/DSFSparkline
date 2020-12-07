//
//  DSFSparklineBarGraph.swift
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
public extension DSFSparklineBarGraph {
	struct SwiftUI {

		/// Datasource for the graph
		let dataSource: DSFSparklineDataSource
		/// The primary color for the sparkline
		let graphColor: DSFColor
		/// Draw a dotted line at the zero point on the y-axis
		let showZero: Bool

		let lineWidth: CGFloat
		/// The spacing between each bar
		let barSpacing: CGFloat

		public init(dataSource: DSFSparklineDataSource,
					graphColor: DSFColor,
					showZero: Bool = false,
					lineWidth: CGFloat = 0.5,
					barSpacing: CGFloat = 1.0) {
			self.dataSource = dataSource
			self.graphColor = graphColor

			self.showZero = showZero
			self.lineWidth = lineWidth
			self.barSpacing = barSpacing
		}
	}
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
extension DSFSparklineBarGraph.SwiftUI: DSFViewRepresentable {
	#if os(macOS)
	public typealias NSViewType = DSFSparklineBarGraph
	#else
	public typealias UIViewType = DSFSparklineBarGraph
	#endif

	public class Coordinator: NSObject {
		let parent: DSFSparklineBarGraph.SwiftUI
		init(_ sparkline: DSFSparklineBarGraph.SwiftUI) {
			self.parent = sparkline
		}
	}

	public func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	private func makeBarGraph(_ context: Context) -> DSFSparklineBarGraph {
		let view = DSFSparklineBarGraph(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false

		let windowSize = self.dataSource.windowSize
		view.dataSource = self.dataSource
		view.windowSize = windowSize
		view.graphColor = self.graphColor

		view.barSpacing = self.barSpacing
		view.lineWidth = self.lineWidth
		view.showZero = self.showZero
		return view
	}
}

// MARK: - iOS/tvOS Specific

@available(iOS 13.0, tvOS 13.0, macOS 9999.0, *)
extension DSFSparklineBarGraph.SwiftUI {
	public func makeUIView(context: Context) -> DSFSparklineBarGraph {
		return makeBarGraph(context)
	}

	public func updateUIView(_ uiView: DSFSparklineBarGraph, context: Context) {

	}
}

// MARK: - macOS Specific

@available(macOS 10.15, iOS 9999.0, tvOS 9999.0, *)
extension DSFSparklineBarGraph.SwiftUI {
	public func makeNSView(context: Context) -> DSFSparklineBarGraph {
		return makeBarGraph(context)
	}

	public func updateNSView(_ uiView: DSFSparklineBarGraph, context: Context) {

	}
}

#endif
