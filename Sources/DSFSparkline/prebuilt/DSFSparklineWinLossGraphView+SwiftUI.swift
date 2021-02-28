//
//  DSFSparklineWinLossGraphView+SwiftUI.swift
//  DSFSparklines
//
//  Created by Darren Ford on 7/12/20.
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

/// A win-loss sparkline. DataSource values > 0 represent a 'win', whereas <= 0 represent a loss.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
public extension DSFSparklineWinLossGraphView {
	struct SwiftUI {
		/// Datasource for the graph
		let dataSource: DSFSparkline.DataSource

		/// The 'win' color for the sparkline
		let winColor: DSFColor
		/// The 'loss' color for the sparkline
		let lossColor: DSFColor
		/// The 'tie' color for the sparkline.  If nil, tie values are not drawn
		let tieColor: DSFColor?

		/// The line width (in pixels) to use when drawing the border of each bar
		let lineWidth: UInt
		/// The spacing (in pixels) between each bar
		let barSpacing: UInt

		/// Draw a dotted line at the zero point on the y-axis
		let showZeroLine: Bool
		/// The drawing definition for the zero line point
		let zeroLineDefinition: DSFSparkline.ZeroLineDefinition

		/// Create a bar graph sparkline
		/// - Parameters:
		///   - dataSource: The data source for the graph
		///   - winColor: The 'win' color for the sparkline
		///   - lossColor: The 'loss' color for the sparkline
		///   - tieColor: The 'tie' color for the sparkline
		///   - lineWidth: The width of the line around each bar
		///   - barSpacing: The spacing between the bars
		///   - showZeroLine: Show or hide a 'zero line' horizontal line
		///   - zeroLineDefinition: the settings for drawing the zero line
		public init(dataSource: DSFSparkline.DataSource,
						winColor: DSFColor = .systemGreen,
						lossColor: DSFColor = .systemRed,
						tieColor: DSFColor? = nil,
						lineWidth: UInt = 1,
						barSpacing: UInt = 1,
						showZeroLine: Bool = false,
						zeroLineDefinition: DSFSparkline.ZeroLineDefinition = .shared)
		{
			self.dataSource = dataSource

			self.winColor = winColor
			self.lossColor = lossColor
			self.tieColor = tieColor

			self.lineWidth = lineWidth
			self.barSpacing = barSpacing

			self.showZeroLine = showZeroLine
			self.zeroLineDefinition = zeroLineDefinition
		}
	}
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
extension DSFSparklineWinLossGraphView.SwiftUI: DSFViewRepresentable {
	#if os(macOS)
	public typealias NSViewType = DSFSparklineWinLossGraphView
	#else
	public typealias UIViewType = DSFSparklineWinLossGraphView
	#endif

	public class Coordinator: NSObject {
		let parent: DSFSparklineWinLossGraphView.SwiftUI
		init(_ sparkline: DSFSparklineWinLossGraphView.SwiftUI) {
			self.parent = sparkline
		}
	}

	public func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	private func makeWinLossGraph(_: Context) -> DSFSparklineWinLossGraphView {
		let view = DSFSparklineWinLossGraphView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false

		view.dataSource = self.dataSource

		view.winColor = self.winColor
		view.lossColor = self.lossColor
		view.tieColor = self.tieColor

		view.barSpacing = self.barSpacing
		view.lineWidth = self.lineWidth

		view.centerlineColor = self.showZeroLine ? self.zeroLineDefinition.color : nil
		view.centerlineWidth = self.zeroLineDefinition.lineWidth
		view.centerlineDashStyle = self.zeroLineDefinition.lineDashStyle

		return view
	}
}

// MARK: - iOS/tvOS Specific

@available(iOS 13.0, tvOS 13.0, macOS 9999.0, *)
public extension DSFSparklineWinLossGraphView.SwiftUI {
	func makeUIView(context: Context) -> DSFSparklineWinLossGraphView {
		return self.makeWinLossGraph(context)
	}

	func updateUIView(_ view: DSFSparklineWinLossGraphView, context _: Context) {
		self.updateView(view)
	}
}

// MARK: - macOS Specific

@available(macOS 10.15, iOS 9999.0, tvOS 9999.0, *)
public extension DSFSparklineWinLossGraphView.SwiftUI {
	func makeNSView(context: Context) -> DSFSparklineWinLossGraphView {
		return self.makeWinLossGraph(context)
	}

	func updateNSView(_ view: DSFSparklineWinLossGraphView, context _: Context) {
		self.updateView(view)
	}
}

// MARK: - Common updates

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
public extension DSFSparklineWinLossGraphView.SwiftUI {
	func updateView(_ view: DSFSparklineWinLossGraphView) {

		UpdateIfNotEqual(result: &view.winColor, val: self.winColor)
		UpdateIfNotEqual(result: &view.lossColor, val: self.lossColor)
		UpdateIfNotEqual(result: &view.tieColor, val: self.tieColor)

		UpdateIfNotEqual(result: &view.lineWidth, val: self.lineWidth)
		UpdateIfNotEqual(result: &view.barSpacing, val: self.barSpacing)

		UpdateIfNotEqual(result: &view.centerlineColor, val: self.showZeroLine ? self.zeroLineDefinition.color : nil)
		UpdateIfNotEqual(result: &view.centerlineWidth, val: self.zeroLineDefinition.lineWidth)
		UpdateIfNotEqual(result: &view.centerlineDashStyle, val: self.zeroLineDefinition.lineDashStyle)

		UpdateIfNotEqual(result: &view.dataSource, val: self.dataSource)
	}
}


#endif
