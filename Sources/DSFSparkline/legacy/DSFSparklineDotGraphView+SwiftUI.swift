//
//  DSFSparklineDotGraphView+SwiftUI.swift
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
public extension DSFSparklineDotGraphView {
	struct SwiftUI {
		/// Datasource for the graph
		let dataSource: DSFSparkline.DataSource
		/// The primary color for the sparkline
		let graphColor: DSFColor

		/// Are the values drawn from the top down?
		let upsideDown: Bool
		/// The number of vertical buckets to break the input data up into
		let verticalDotCount: UInt
		/// The secondary color for the sparkline
		let unsetGraphColor: DSFColor

		/// Create a sparkline graph that displays dots (like the CPU history graph in Activity Monitor)
		/// - Parameters:
		///   - dataSource: The data source for the graph
		///   - graphColor: The color of the dots that are set
		///   - unsetGraphColor: The color of the dots that are not set
		///   - verticalDotCount: The number of dots vertically
		///   - upsideDown: Draw the graph upside down
		public init(dataSource: DSFSparkline.DataSource,
						graphColor: DSFColor,
						unsetGraphColor: DSFColor = DSFColor.clear,
						verticalDotCount: UInt = 10,
						upsideDown: Bool = false)
		{
			self.dataSource = dataSource
			self.graphColor = graphColor
			self.verticalDotCount = verticalDotCount
			self.upsideDown = upsideDown
			self.unsetGraphColor = unsetGraphColor
		}
	}
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
extension DSFSparklineDotGraphView.SwiftUI: DSFViewRepresentable {
	#if os(macOS)
	public typealias NSViewType = DSFSparklineDotGraphView
	#else
	public typealias UIViewType = DSFSparklineDotGraphView
	#endif

	public class Coordinator: NSObject {
		let parent: DSFSparklineDotGraphView.SwiftUI
		init(_ sparkline: DSFSparklineDotGraphView.SwiftUI) {
			self.parent = sparkline
		}
	}

	public func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	private func makeDotGraph(_: Context) -> DSFSparklineDotGraphView {
		let view = DSFSparklineDotGraphView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.dataSource = self.dataSource

		view.graphColor = self.graphColor
		view.verticalDotCount = self.verticalDotCount
		view.unsetGraphColor = self.unsetGraphColor
		view.upsideDown = self.upsideDown
		return view
	}
}

// MARK: - iOS/tvOS Specific

@available(iOS 13.0, tvOS 13.0, macOS 99.0, *)
public extension DSFSparklineDotGraphView.SwiftUI {
	func makeUIView(context: Context) -> DSFSparklineDotGraphView {
		return self.makeDotGraph(context)
	}

	func updateUIView(_ view: DSFSparklineDotGraphView, context _: Context) {
		self.updateView(view)
	}
}

// MARK: - macOS Specific

@available(macOS 10.15, iOS 9999.0, tvOS 9999.0, *)
public extension DSFSparklineDotGraphView.SwiftUI {
	func makeNSView(context: Context) -> DSFSparklineDotGraphView {
		return self.makeDotGraph(context)
	}

	func updateNSView(_ view: DSFSparklineDotGraphView, context _: Context) {
		self.updateView(view)
	}
}

// MARK: - Common updates

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
public extension DSFSparklineDotGraphView.SwiftUI {
	func updateView(_ view: DSFSparklineDotGraphView) {
		UpdateIfNotEqual(result: &view.graphColor, val: self.graphColor)
		UpdateIfNotEqual(result: &view.upsideDown, val: self.upsideDown)
		UpdateIfNotEqual(result: &view.verticalDotCount, val: self.verticalDotCount)
		UpdateIfNotEqual(result: &view.unsetGraphColor, val: self.unsetGraphColor)
		UpdateIfNotEqual(result: &view.dataSource, val: self.dataSource)
	}
}

#endif
