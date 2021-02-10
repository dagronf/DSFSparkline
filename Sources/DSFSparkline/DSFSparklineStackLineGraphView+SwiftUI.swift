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
public extension DSFSparklineStackLineGraphView {
	struct SwiftUI {
		/// Datasource for the graph
		let dataSource: DSFSparklineDataSource
		/// The primary color for the sparkline
		let graphColor: DSFColor

		/// Draw a dotted line at the zero point on the y-axis
		let showZeroLine: Bool
		/// The drawing definition for the zero line point
		let zeroLineDefinition: DSFSparklineZeroLineDefinition

		/// The width for the line drawn on the graph
		let lineWidth: CGFloat
		/// Should the area below the line be shaded?
		let lineShading: Bool
		/// Draw a shadow under the line
		let shadowed: Bool

		/// Should the line graph be centered around the zero-line?
		let centeredAtZeroLine: Bool
		/// The color used to draw values lower than the zero-line, or nil for the same as the graph color
		let lowerGraphColor: DSFColor?

		/// The style of the y-range highlight
		let highlightDefinition: DSFSparklineHighlightRangeDefinition?

		/// Create a sparkline graph that displays dots (like the CPU history graph in Activity Monitor)
		/// - Parameters:
		///   - dataSource: The data source for the graph
		///   - graphColor: The color of the dots that are set
		///   - lineWidth: The width of the line
		///   - lineShading: If true, shades the underside of the drawn line.
		///   - shadowed: If true, draws a shadow under the line part of the graph.
		///   - showZeroLine: Show or hide a 'zero line' horizontal line
		///   - zeroLineDefinition: the settings for drawing the zero line
		///   - centeredAtZeroLine: Should the line graph be centered around the zero-line?
		///   - lowerGraphColor: The color used to draw values lower than the zero-line, or nil for the same as the graph color
		///   - highlightDefinition: The style of the y-range highlight
		public init(dataSource: DSFSparklineDataSource,
						graphColor: DSFColor,
						lineWidth: CGFloat = 1.5,
						lineShading: Bool = true,
						shadowed: Bool = false,
						showZeroLine: Bool = false,
						zeroLineDefinition: DSFSparklineZeroLineDefinition = .shared,
						centeredAtZeroLine: Bool = false,
						lowerGraphColor: DSFColor? = nil,
						highlightDefinition: DSFSparklineHighlightRangeDefinition? = nil)
		{
			self.dataSource = dataSource
			self.graphColor = graphColor

			self.showZeroLine = showZeroLine
			self.zeroLineDefinition = zeroLineDefinition

			self.centeredAtZeroLine = centeredAtZeroLine
			self.lowerGraphColor = lowerGraphColor

			self.lineWidth = lineWidth
			self.lineShading = lineShading
			self.shadowed = shadowed

			self.highlightDefinition = highlightDefinition
		}
	}
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
extension DSFSparklineStackLineGraphView.SwiftUI: DSFViewRepresentable {
	#if os(macOS)
	public typealias NSViewType = DSFSparklineStackLineGraphView
	#else
	public typealias UIViewType = DSFSparklineStackLineGraphView
	#endif

	public class Coordinator: NSObject {
		let parent: DSFSparklineStackLineGraphView.SwiftUI
		init(_ sparkline: DSFSparklineStackLineGraphView.SwiftUI) {
			self.parent = sparkline
		}
	}

	public func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	func makeLineGraph(_: Context) -> DSFSparklineStackLineGraphView {
		let view = DSFSparklineStackLineGraphView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.dataSource = self.dataSource
		view.graphColor = self.graphColor

		view.lineWidth = self.lineWidth
		view.lineShading = self.lineShading
		view.shadowed = self.shadowed

		view.showZeroLine = self.showZeroLine
		view.setZeroLineDefinition(self.zeroLineDefinition)

		view.centeredAtZeroLine = self.centeredAtZeroLine
		view.lowerGraphColor = self.lowerGraphColor

		if let hr = self.highlightDefinition {
			view.showHighlightRange = true
			view.highlightRangeDefinition = hr
		}
		
		return view
	}
}

// MARK: - iOS/tvOS Specific

@available(iOS 13.0, tvOS 13.0, macOS 9999.0, *)
public extension DSFSparklineStackLineGraphView.SwiftUI {
	func makeUIView(context: Context) -> DSFSparklineStackLineGraphView {
		return self.makeLineGraph(context)
	}

	func updateUIView(_: DSFSparklineStackLineGraphView, context _: Context) {}
}

// MARK: - macOS Specific

@available(macOS 10.15, iOS 9999.0, tvOS 9999.0, *)
public extension DSFSparklineStackLineGraphView.SwiftUI {
	func makeNSView(context: Context) -> DSFSparklineStackLineGraphView {
		return self.makeLineGraph(context)
	}

	func updateNSView(_: DSFSparklineStackLineGraphView, context _: Context) {}
}

#endif

//struct DSFSparklineStackLineGraphViewSwiftUI_Previews: PreviewProvider {
//	static var previews: some View {
//		/*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
//	}
//}
