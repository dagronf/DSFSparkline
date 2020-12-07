//
//  DSFSparklineDotGraph+SwiftUI.swift
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
public extension DSFSparklineDotGraph {
	struct SwiftUI {

		/// Datasource for the graph
		let dataSource: DSFSparklineDataSource
		/// The primary color for the sparkline
		let graphColor: DSFColor

		/// Are the values drawn from the top down?
		let upsideDown: Bool
		/// The number of vertical buckets to break the input data up into
		let verticalDotCount: UInt
		/// The secondary color for the sparkline
		let unsetGraphColor: DSFColor

		public init(dataSource: DSFSparklineDataSource,
					graphColor: DSFColor,
					unsetGraphColor: DSFColor = DSFColor.clear,
					verticalDotCount: UInt = 10,
					upsideDown: Bool = false) {
			self.dataSource = dataSource
			self.graphColor = graphColor
			self.verticalDotCount = verticalDotCount
			self.upsideDown = upsideDown
			self.unsetGraphColor = unsetGraphColor
		}
	}
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
extension DSFSparklineDotGraph.SwiftUI: DSFViewRepresentable {
	#if os(macOS)
	public typealias NSViewType = DSFSparklineDotGraph
	#else
	public typealias UIViewType = DSFSparklineDotGraph
	#endif

	public class Coordinator: NSObject {
		let parent: DSFSparklineDotGraph.SwiftUI
		init(_ sparkline: DSFSparklineDotGraph.SwiftUI) {
			self.parent = sparkline
		}
	}

	public func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	private func makeDotGraph(_ context: Context) -> DSFSparklineDotGraph {
		let view = DSFSparklineDotGraph(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false
		let windowSize = self.dataSource.windowSize
		view.dataSource = self.dataSource
		view.windowSize = windowSize

		view.graphColor = self.graphColor
		view.verticalDotCount = self.verticalDotCount
		view.unsetGraphColor = self.unsetGraphColor
		view.upsideDown = self.upsideDown
		return view
	}
}

// MARK: - iOS/tvOS Specific

@available(iOS 13.0, tvOS 13.0, macOS 99.0, *)
extension DSFSparklineDotGraph.SwiftUI {
	public func makeUIView(context: Context) -> DSFSparklineDotGraph {
		return self.makeDotGraph(context)
	}

	public func updateUIView(_ uiView: DSFSparklineDotGraph, context: Context) {

	}
}

// MARK: - macOS Specific

@available(macOS 10.15, iOS 9999.0, tvOS 9999.0, *)
extension DSFSparklineDotGraph.SwiftUI {
	public func makeNSView(context: Context) -> DSFSparklineDotGraph {
		return self.makeDotGraph(context)
	}

	public func updateNSView(_ uiView: DSFSparklineDotGraph, context: Context) {

	}
}

#endif
