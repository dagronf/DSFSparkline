//
//  DSFSparklineBarGraphView+SwiftUI.swift
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
public extension DSFSparklineBarGraphView {
	struct SwiftUI {
		/// Datasource for the graph
		let dataSource: DSFSparkline.DataSource

		/// The primary color for the sparkline
		let graphColor: DSFColor
		/// The line width (in pixels) to use when drawing the border of each bar
		let lineWidth: UInt
		/// The spacing (in pixels) between each bar
		let barSpacing: UInt

		/// Draw a dotted line at the zero point on the y-axis
		let showZeroLine: Bool
		/// The drawing definition for the zero line point
		let zeroLineDefinition: DSFSparkline.ZeroLineDefinition


		/// Should the line graph be centered around the zero-line?
		let centeredAtZeroLine: Bool
		/// The color used to draw values lower than the zero-line, or nil for the same as the graph color
		let lowerGraphColor: DSFColor?

		/// Highlight y-ranges within the graph
		let highlightDefinitions: [DSFSparkline.HighlightRangeDefinition]

		/// Create a bar graph sparkline
		/// - Parameters:
		///   - dataSource: The data source for the graph
		///   - graphColor: The color to draw the graph
		///   - lineWidth: The width of the line around each bar
		///   - barSpacing: The spacing between the bars
		///   - showZeroLine: Show or hide a 'zero line' horizontal line
		///   - zeroLineDefinition: the settings for drawing the zero line
		///   - centeredAtZeroLine: Should the line graph be centered around the zero-line?
		///   - lowerGraphColor: The color used to draw values lower than the zero-line, or nil for the same as the graph color
		///   - highlightDefinitions: The style of the y-range highlight
		public init(dataSource: DSFSparkline.DataSource,
						graphColor: DSFColor,
						lineWidth: UInt = 1,
						barSpacing: UInt = 1,
						showZeroLine: Bool = false,
						zeroLineDefinition: DSFSparkline.ZeroLineDefinition = .shared,
						centeredAtZeroLine: Bool = false,
						lowerGraphColor: DSFColor? = nil,
						showHighlightRange: Bool = false,
						highlightDefinitions: [DSFSparkline.HighlightRangeDefinition] = [])
		{
			self.dataSource = dataSource
			self.graphColor = graphColor

			self.showZeroLine = showZeroLine
			self.zeroLineDefinition = zeroLineDefinition

			self.centeredAtZeroLine = centeredAtZeroLine
			self.lowerGraphColor = lowerGraphColor

			self.lineWidth = lineWidth
			self.barSpacing = barSpacing

			self.highlightDefinitions = highlightDefinitions
		}
	}
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
extension DSFSparklineBarGraphView.SwiftUI: DSFViewRepresentable {
	#if os(macOS)
	public typealias NSViewType = DSFSparklineBarGraphView
	#else
	public typealias UIViewType = DSFSparklineBarGraphView
	#endif

	public class Coordinator: NSObject {
		let parent: DSFSparklineBarGraphView.SwiftUI
		init(_ sparkline: DSFSparklineBarGraphView.SwiftUI) {
			self.parent = sparkline
		}
	}

	public func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	private func makeBarGraph(_: Context) -> DSFSparklineBarGraphView {
		let view = DSFSparklineBarGraphView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false

		view.dataSource = self.dataSource
		view.graphColor = self.graphColor

		view.barSpacing = self.barSpacing
		view.lineWidth = self.lineWidth

		view.showZeroLine = self.showZeroLine
		view.setZeroLineDefinition(self.zeroLineDefinition)

		view.centeredAtZeroLine = self.centeredAtZeroLine
		view.lowerGraphColor = self.lowerGraphColor

		if self.highlightDefinitions.count > 0 {
			view.showHighlightRange = true
			view.highlightRangeDefinition = self.highlightDefinitions
		}
		return view
	}
}

// MARK: - iOS/tvOS Specific

@available(iOS 13.0, tvOS 13.0, macOS 9999.0, *)
public extension DSFSparklineBarGraphView.SwiftUI {
	func makeUIView(context: Context) -> DSFSparklineBarGraphView {
		return self.makeBarGraph(context)
	}

	func updateUIView(_ view: DSFSparklineBarGraphView, context _: Context) {
		self.updateView(view)
	}
}

// MARK: - macOS Specific

@available(macOS 10.15, iOS 9999.0, tvOS 9999.0, *)
public extension DSFSparklineBarGraphView.SwiftUI {
	func makeNSView(context: Context) -> DSFSparklineBarGraphView {
		return self.makeBarGraph(context)
	}

	func updateNSView(_ view: DSFSparklineBarGraphView, context _: Context) {
		self.updateView(view)
	}
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
public extension DSFSparklineBarGraphView.SwiftUI {
	func updateView(_ view: DSFSparklineBarGraphView) {

		UpdateIfNotEqual(result: &view.graphColor, val: self.graphColor)
		UpdateIfNotEqual(result: &view.barSpacing, val: self.barSpacing)
		UpdateIfNotEqual(result: &view.lineWidth, val: self.lineWidth)

		UpdateIfNotEqual(result: &view.showZeroLine, val: self.showZeroLine)
		view.setZeroLineDefinition(self.zeroLineDefinition)

		UpdateIfNotEqual(result: &view.centeredAtZeroLine, val: self.centeredAtZeroLine)
		UpdateIfNotEqual(result: &view.lowerGraphColor, val: self.lowerGraphColor)

		if self.highlightDefinitions.count > 0 {
			view.showHighlightRange = true
			view.highlightRangeDefinition = self.highlightDefinitions
		}
		else {
			view.showHighlightRange = false
			view.highlightRangeDefinition = []
		}
	}
}

#endif
