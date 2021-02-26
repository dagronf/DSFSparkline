//
//  DSFSparklineZeroLineDefinition.swift
//  DSFSparklines
//
//  Created by Darren Ford on 25/01/21.
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
public extension DSFSparklineTabletGraphView {
	struct SwiftUI {
		/// Datasource for the graph
		let dataSource: DSFSparkline.DataSource

		/// The 'win' color for the sparkline
		let winColor: DSFColor
		/// The 'loss' color for the sparkline
		let lossColor: DSFColor

		/// The line width (in pixels) to use when drawing the border of each tablet
		let lineWidth: CGFloat
		/// The spacing (in pixels) between each tablet
		let barSpacing: CGFloat

		/// Create a bar graph sparkline
		/// - Parameters:
		///   - dataSource: The data source for the graph
		///   - winColor: The 'win' color for the sparkline
		///   - lossColor: The 'loss' color for the sparkline
		///   - lineWidth: The width of the line around each tablet
		///   - barSpacing: The spacing between the tablets
		public init(dataSource: DSFSparkline.DataSource,
						winColor: DSFColor = .systemGreen,
						lossColor: DSFColor = .systemRed,
						lineWidth: CGFloat = 1,
						barSpacing: CGFloat = 1)
		{
			self.dataSource = dataSource

			self.winColor = winColor
			self.lossColor = lossColor

			self.lineWidth = lineWidth
			self.barSpacing = barSpacing
		}
	}
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
extension DSFSparklineTabletGraphView.SwiftUI: DSFViewRepresentable {
	#if os(macOS)
	public typealias NSViewType = DSFSparklineTabletGraphView
	#else
	public typealias UIViewType = DSFSparklineTabletGraphView
	#endif

	public class Coordinator: NSObject {
		let parent: DSFSparklineTabletGraphView.SwiftUI
		init(_ sparkline: DSFSparklineTabletGraphView.SwiftUI) {
			self.parent = sparkline
		}
	}

	public func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	private func makeTabletGraph(_: Context) -> DSFSparklineTabletGraphView {
		let view = DSFSparklineTabletGraphView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false

		view.dataSource = self.dataSource

		view.winColor = self.winColor
		view.lossColor = self.lossColor

		view.barSpacing = self.barSpacing
		view.lineWidth = self.lineWidth

		return view
	}
}

// MARK: - iOS/tvOS Specific

@available(iOS 13.0, tvOS 13.0, macOS 9999.0, *)
public extension DSFSparklineTabletGraphView.SwiftUI {
	func makeUIView(context: Context) -> DSFSparklineTabletGraphView {
		return self.makeTabletGraph(context)
	}

	func updateUIView(_ view: DSFSparklineTabletGraphView, context _: Context) {
		self.updateView(view)
	}
}

// MARK: - macOS Specific

@available(macOS 10.15, iOS 9999.0, tvOS 9999.0, *)
public extension DSFSparklineTabletGraphView.SwiftUI {
	func makeNSView(context: Context) -> DSFSparklineTabletGraphView {
		return self.makeTabletGraph(context)
	}

	func updateNSView(_ view: DSFSparklineTabletGraphView, context _: Context) {
		self.updateView(view)
	}
}

// MARK: - Common updates

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
public extension DSFSparklineTabletGraphView.SwiftUI {
	func updateView(_ view: DSFSparklineTabletGraphView) {

		UpdateIfNotEqual(result: &view.winColor, val: self.winColor)
		UpdateIfNotEqual(result: &view.lossColor, val: self.lossColor)

		UpdateIfNotEqual(result: &view.lineWidth, val: self.lineWidth)
		UpdateIfNotEqual(result: &view.barSpacing, val: self.barSpacing)

		UpdateIfNotEqual(result: &view.dataSource, val: self.dataSource)
	}
}

#endif
