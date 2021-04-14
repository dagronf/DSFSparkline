//
//  DSFSparklineLineGraphView+SwiftUI.swift
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
public extension DSFSparklineLineGraphView {
	struct SwiftUI {
		/// Datasource for the graph
		let dataSource: DSFSparkline.DataSource
		/// The primary color for the sparkline
		let graphColor: DSFColor

		/// Draw a dotted line at the zero point on the y-axis
		let showZeroLine: Bool
		/// The drawing definition for the zero line point
		let zeroLineDefinition: DSFSparkline.ZeroLineDefinition

		/// The width for the line drawn on the graph
		let lineWidth: CGFloat
		/// The number of vertical buckets to break the input data up into
		let interpolated: Bool
		/// The secondary color for the sparkline
		let lineShading: Bool
		/// Draw a shadow under the line
		let shadowed: Bool

		/// Should the line graph be centered around the zero-line?
		let centeredAtZeroLine: Bool
		/// The color used to draw values lower than the zero-line, or nil for the same as the graph color
		let lowerGraphColor: DSFColor?

		/// Highlight y-ranges within the graph
		let highlightDefinitions: [DSFSparkline.HighlightRangeDefinition]

		/// The size of the markers to draw. If the markerSize is less than 0, markers will not draw
		let markerSize: CGFloat

		let markerDrawingBlock: DSFSparklineOverlay.Line.MarkerDrawingBlock?

		/// Create a sparkline graph that displays dots (like the CPU history graph in Activity Monitor)
		/// - Parameters:
		///   - dataSource: The data source for the graph
		///   - graphColor: The color of the dots that are set
		///   - lineWidth: The width of the line
		///   - interpolated: If true, curves the line through the graph points.
		///   - lineShading: If true, shades the underside of the drawn line.
		///   - shadowed: If true, draws a shadow under the line part of the graph.
		///   - showZeroLine: Show or hide a 'zero line' horizontal line
		///   - zeroLineDefinition: the settings for drawing the zero line
		///   - centeredAtZeroLine: Should the line graph be centered around the zero-line?
		///   - lowerGraphColor: The color used to draw values lower than the zero-line, or nil for the same as the graph color
		///   - highlightDefinitions: The style of the y-range highlight
		///   - markerSize: The size of the markers to draw. If the markerSize is less than 0, markers will not draw
		///   - markerDrawingFunc: (optional) function to draw the markers
		public init(dataSource: DSFSparkline.DataSource,
						graphColor: DSFColor,
						lineWidth: CGFloat = 1.5,
						interpolated: Bool = false,
						lineShading: Bool = true,
						shadowed: Bool = false,
						showZeroLine: Bool = false,
						zeroLineDefinition: DSFSparkline.ZeroLineDefinition = .shared,
						centeredAtZeroLine: Bool = false,
						lowerGraphColor: DSFColor? = nil,
						highlightDefinitions: [DSFSparkline.HighlightRangeDefinition] = [],
						markerSize: CGFloat = -1,
						markerDrawingBlock: DSFSparklineOverlay.Line.MarkerDrawingBlock? = nil)
		{
			self.dataSource = dataSource
			self.graphColor = graphColor

			self.showZeroLine = showZeroLine
			self.zeroLineDefinition = zeroLineDefinition

			self.centeredAtZeroLine = centeredAtZeroLine
			self.lowerGraphColor = lowerGraphColor

			self.lineWidth = lineWidth
			self.interpolated = interpolated
			self.lineShading = lineShading
			self.shadowed = shadowed

			self.highlightDefinitions = highlightDefinitions

			self.markerSize = markerSize
			self.markerDrawingBlock = markerDrawingBlock
		}
	}
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
extension DSFSparklineLineGraphView.SwiftUI: DSFViewRepresentable {
	#if os(macOS)
	public typealias NSViewType = DSFSparklineLineGraphView
	#else
	public typealias UIViewType = DSFSparklineLineGraphView
	#endif

	public class Coordinator: NSObject {
		let parent: DSFSparklineLineGraphView.SwiftUI
		init(_ sparkline: DSFSparklineLineGraphView.SwiftUI) {
			self.parent = sparkline
		}
	}

	public func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	func makeLineGraph(_: Context) -> DSFSparklineLineGraphView {
		let view = DSFSparklineLineGraphView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.dataSource = self.dataSource
		view.graphColor = self.graphColor

		view.lineWidth = self.lineWidth
		view.interpolated = self.interpolated
		view.lineShading = self.lineShading
		view.shadowed = self.shadowed

		view.showZeroLine = self.showZeroLine
		view.setZeroLineDefinition(self.zeroLineDefinition)

		view.centeredAtZeroLine = self.centeredAtZeroLine
		view.lowerGraphColor = self.lowerGraphColor

		if self.highlightDefinitions.count > 0 {
			view.showHighlightRange = true
			view.highlightRangeDefinition = self.highlightDefinitions
		}

		view.markerSize = self.markerSize

		return view
	}
}

// MARK: - iOS/tvOS Specific

@available(iOS 13.0, tvOS 13.0, macOS 9999.0, *)
public extension DSFSparklineLineGraphView.SwiftUI {
	func makeUIView(context: Context) -> DSFSparklineLineGraphView {
		return self.makeLineGraph(context)
	}

	func updateUIView(_ view: DSFSparklineLineGraphView, context _: Context) {
		self.updateView(view)
	}
}

// MARK: - macOS Specific

@available(macOS 10.15, iOS 9999.0, tvOS 9999.0, *)
public extension DSFSparklineLineGraphView.SwiftUI {
	func makeNSView(context: Context) -> DSFSparklineLineGraphView {
		return self.makeLineGraph(context)
	}

	func updateNSView(_ view: DSFSparklineLineGraphView, context _: Context) {
		self.updateView(view)
	}
}

// MARK: - Common updates

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
public extension DSFSparklineLineGraphView.SwiftUI {
	func updateView(_ view: DSFSparklineLineGraphView) {

		UpdateIfNotEqual(result: &view.graphColor, val: self.graphColor)

		UpdateIfNotEqual(result: &view.showZeroLine, val: self.showZeroLine)
		view.setZeroLineDefinition(self.zeroLineDefinition)

		UpdateIfNotEqual(result: &view.centeredAtZeroLine, val: self.centeredAtZeroLine)
		UpdateIfNotEqual(result: &view.lowerGraphColor, val: self.lowerGraphColor)

		UpdateIfNotEqual(result: &view.lineWidth, val: self.lineWidth)
		UpdateIfNotEqual(result: &view.interpolated, val: self.interpolated)
		UpdateIfNotEqual(result: &view.lineShading, val: self.lineShading)
		UpdateIfNotEqual(result: &view.shadowed, val: self.shadowed)
		UpdateIfNotEqual(result: &view.markerSize, val: self.markerSize)

		view.markerDrawingBlock = self.markerDrawingBlock

		if self.highlightDefinitions.count > 0 {
			view.showHighlightRange = true
			view.highlightRangeDefinition = self.highlightDefinitions
		}
		else {
			view.showHighlightRange = false
			view.highlightRangeDefinition = []
		}

		UpdateIfNotEqual(result: &view.dataSource, val: self.dataSource)
	}
}

#endif
