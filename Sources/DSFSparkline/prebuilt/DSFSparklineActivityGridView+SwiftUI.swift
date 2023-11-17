//
//  DSFSparklineActivityGridView+SwiftUI.swift
//
//  Copyright © 2023 Darren Ford. All rights reserved.
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

import Foundation
import SwiftUI

#if os(macOS)
import AppKit
#else
import UIKit
#endif

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
public extension DSFSparklineActivityGridView {

	/// The SwiftUI percent bar graph
	struct SwiftUI {
		let values: [Double]
		let verticalCellCount: UInt?
		let cellDimension: Double?
		let cellSpacing: Double?
		let range: ClosedRange<Double>?
		let colorScheme: DSFSparkline.ValueBasedFill?
		let cellBorderColor: DSFColor?

		/// Create an Activity Grid
		/// - Parameters:
		///   - values: The values to display
		///   - verticalCellCount: The number of vertical cells
		///   - cellDimension: Each cell's dimension
		///   - cellSpacing: The spacing between each cell
		///   - range: The allowable upper/lower bounds for the input values
		///   - colors: The color scheme to use
		///   - cellBorderColor: The color for drawing the border of each cell
		public init(
			values: [Double],
			verticalCellCount: UInt? = nil,
			cellDimension: Double? = nil,
			cellSpacing: Double? = nil,
			range: ClosedRange<Double>? = nil,
			colorScheme: DSFSparkline.ValueBasedFill? = nil,
			cellBorderColor: DSFColor? = nil
		) {
			self.values = values
			self.verticalCellCount = verticalCellCount
			self.cellDimension = cellDimension
			self.cellSpacing = cellSpacing
			self.range = range
			self.colorScheme = colorScheme
			self.cellBorderColor = cellBorderColor
		}
	}
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
extension DSFSparklineActivityGridView.SwiftUI: DSFViewRepresentable {
	#if os(macOS)
	public typealias NSViewType = DSFSparklineActivityGridView
	#else
	public typealias UIViewType = DSFSparklineActivityGridView
	#endif

	public class Coordinator: NSObject {
		let parent: DSFSparklineActivityGridView.SwiftUI
		init(_ sparkline: DSFSparklineActivityGridView.SwiftUI) {
			self.parent = sparkline
		}
	}

	public func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	func makeActivityGrid(_: Context) -> DSFSparklineActivityGridView {
		let view = DSFSparklineActivityGridView(frame: .zero)
		self.updateView(view)
		return view
	}

	#if os(macOS)
	@available(macOS 13.0, *)
	public func sizeThatFits(_ proposal: ProposedViewSize, nsView: DSFSparklineActivityGridView, context: Context) -> CGSize? {
		return CGSize(
			width: proposal.width ?? nsView.activityLayer.intrinsicWidth,
			height: nsView.intrinsicContentSize.height
		)
	}
	#else
	@available(iOS 16.0, tvOS 16.0, *)
	public func sizeThatFits(_ proposal: ProposedViewSize, uiView: DSFSparklineActivityGridView, context: Context) -> CGSize? {
		return CGSize(
			width: proposal.width ?? uiView.activityLayer.intrinsicWidth,
			height: uiView.intrinsicContentSize.height
		)
	}
	#endif
}

// MARK: - iOS/tvOS Specific

@available(iOS 13.0, tvOS 13.0, macOS 9999.0, *)
public extension DSFSparklineActivityGridView.SwiftUI {
	func makeUIView(context: Context) -> DSFSparklineActivityGridView {
		return self.makeActivityGrid(context)
	}

	func updateUIView(_ view: DSFSparklineActivityGridView, context _: Context) {
		self.updateView(view)
	}
}

// MARK: - macOS Specific

@available(macOS 10.15, iOS 9999.0, tvOS 9999.0, *)
public extension DSFSparklineActivityGridView.SwiftUI {
	func makeNSView(context: Context) -> DSFSparklineActivityGridView {
		return self.makeActivityGrid(context)
	}

	func updateNSView(_ view: DSFSparklineActivityGridView, context _: Context) {
		self.updateView(view)
	}
}

// MARK: - Common updates

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
public extension DSFSparklineActivityGridView.SwiftUI {
	func updateView(_ view: DSFSparklineActivityGridView) {
		let v = self.values.map { CGFloat($0) }
		if let vh = self.verticalCellCount { view.verticalCellCount = vh }
		if let range = self.range {
			view.setValues(v, range: CGFloat(range.lowerBound) ... CGFloat(range.upperBound))
		}
		else {
			view.setValues(v)
		}

		if let c = self.colorScheme { view.colorScheme = c }
		if let d = self.cellDimension { view.cellDimension = CGFloat(d) }
		if let s = self.cellSpacing { view.cellSpacing = CGFloat(s) }
		view.cellBorderColor = self.cellBorderColor
	}
}

#endif
