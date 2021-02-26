//
//  DSFSparklineDataBarGraphView+SwiftUI.swift
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

@available(macOS 11, iOS 13.0, tvOS 13.0, *)
public extension DSFSparklineStripesGraphView {
	struct SwiftUI {

		/// Datasource for the graph
		let dataSource: DSFSparkline.DataSource

		let barSpacing: UInt
		let integral: Bool

		let gradient: DSFSparkline.GradientBucket

		static public let shared = DSFSparkline.GradientBucket(posts: [
			DSFSparkline.GradientBucket.Post(color: CGColor(red: 1, green: 0, blue: 0, alpha: 1), location: 0),
			DSFSparkline.GradientBucket.Post(color: CGColor(red: 0, green: 0, blue: 1, alpha: 1), location: 1)
		])

		/// Create a databar graph
		/// - Parameters:
		///   - dataSource: The data source for the graph
		///   - maximumTotalValue: The maximum _total_ value. If the datasource values total is greater than this value, it clips the display
		///   - palette: The color palette to use when drawing the graph
		///   - unsetColor: (optional) the color to use when drawing the background (useful when the maximumValue is also set)
		///   - strokeColor: The color to draw the separator lines between data points
		///   - lineWidth: The width of the separator lines
		///   - animated: If set, animates any datasource value changes
		///   - animationDuration: The duration for the animate-in animation
		public init(dataSource: DSFSparkline.DataSource,
						integral: Bool = false,
						barSpacing: UInt = 0,
						gradient: DSFSparkline.GradientBucket = Self.shared)
		{
			self.dataSource = dataSource
			self.integral = integral
			self.barSpacing = barSpacing
			self.gradient = gradient
		}
	}
}

@available(macOS 11, iOS 13.0, tvOS 13.0, *)
extension DSFSparklineStripesGraphView.SwiftUI: DSFViewRepresentable {
	#if os(macOS)
	public typealias NSViewType = DSFSparklineStripesGraphView
	#else
	public typealias UIViewType = DSFSparklineStripesGraphView
	#endif

	public class Coordinator: NSObject {
		let parent: DSFSparklineStripesGraphView.SwiftUI
		init(_ sparkline: DSFSparklineStripesGraphView.SwiftUI) {
			self.parent = sparkline
		}
	}

	public func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	func makeStripesGraph(_: Context) -> DSFSparklineStripesGraphView {
		let view = DSFSparklineStripesGraphView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.barSpacing = self.barSpacing
		view.integral = self.integral
		view.gradient = self.gradient

		return view
	}
}

// MARK: - iOS/tvOS Specific

@available(iOS 13.0, tvOS 13.0, macOS 9999.0, *)
public extension DSFSparklineStripesGraphView.SwiftUI {
	func makeUIView(context: Context) -> DSFSparklineStripesGraphView {
		return self.makeStripesGraph(context)
	}

	func updateUIView(_ view: DSFSparklineStripesGraphView, context _: Context) {
		self.updateView(view)
	}
}

// MARK: - macOS Specific

@available(macOS 11, iOS 9999.0, tvOS 9999.0, *)
public extension DSFSparklineStripesGraphView.SwiftUI {
	func makeNSView(context: Context) -> DSFSparklineStripesGraphView {
		return self.makeStripesGraph(context)
	}

	func updateNSView(_ view: DSFSparklineStripesGraphView, context _: Context) {
		self.updateView(view)
	}
}

// MARK: - Common updates

@available(macOS 11, iOS 13.0, tvOS 13.0, *)
public extension DSFSparklineStripesGraphView.SwiftUI {
	func updateView(_ view: DSFSparklineStripesGraphView) {
		UpdateIfNotEqual(result: &view.barSpacing, val: self.barSpacing)
		UpdateIfNotEqual(result: &view.integral, val: self.integral)

		view.gradient = self.gradient

		UpdateIfNotEqual(result: &view.dataSource, val: self.dataSource)
	}
}

#endif
