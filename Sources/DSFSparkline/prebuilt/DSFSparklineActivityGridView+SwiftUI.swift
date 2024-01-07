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
		let range: ClosedRange<Double>?
		let verticalCellCount: UInt?
		let horizontalCellCount: UInt
		let cellStyle: DSFSparkline.ActivityGrid.CellStyle
		let layoutStyle: DSFSparkline.ActivityGrid.LayoutStyle

		var _tooltipStringForCell: ((Int) -> String?)?

		/// Create an Activity Grid
		/// - Parameters:
		///   - values: The values to display
		///   - range: The allowable upper/lower bounds for the input values
		///   - verticalCellCount: The number of vertical cells
		///   - cellStyle: The stying to apply to each cell
		///   - layoutStyle: The style for drawing the activity grid
		public init(
			values: [Double],
			range: ClosedRange<Double>? = nil,
			verticalCellCount: UInt? = nil,
			horizontalCellCount: UInt = 0,
			cellStyle: DSFSparkline.ActivityGrid.CellStyle = .init(),
			layoutStyle: DSFSparkline.ActivityGrid.LayoutStyle = .github
		) {
			self.values = values
			self.range = range
			self.verticalCellCount = verticalCellCount
			self.horizontalCellCount = horizontalCellCount
			self.cellStyle = cellStyle
			self.layoutStyle = layoutStyle
		}

		/// Create an Activity Grid
		/// - Parameters:
		///   - values: The values to display
		///   - range: The allowable upper/lower bounds for the input values
		///   - verticalCellCount: The number of vertical cells, or 0 to fill vertically
		///   - horizontalCellCount: The number of horizontal cells, or 0 to fill horizontally
		///   - layoutStyle: The style for drawing the activity grid
		///   - fillStyle: The fill mechanism
		///   - borderColor: Cell border color
		///   - borderWidth: Cell border width
		///   - cellDimension: Cell dimension (cells are always square)
		///   - cellSpacing: The spacing between cells
		///   - cornerRadius: Cell corner radius
		public init(
			values: [Double],
			range: ClosedRange<Double>? = nil,
			verticalCellCount: UInt? = nil,
			horizontalCellCount: UInt = 0,
			layoutStyle: DSFSparkline.ActivityGrid.LayoutStyle = .github,
			fillScheme: DSFSparkline.ValueBasedFill,
			borderColor: CGColor? = nil,
			borderWidth: CGFloat = 1,
			cellDimension: CGFloat = 11,
			cellSpacing: CGFloat = 2.5,
			cornerRadius: CGFloat = 2.5
		) {
			self.values = values
			self.range = range
			self.verticalCellCount = verticalCellCount
			self.horizontalCellCount = horizontalCellCount
			self.layoutStyle = layoutStyle
			self.cellStyle = DSFSparkline.ActivityGrid.CellStyle(
				fillScheme: fillScheme,
				borderColor: borderColor,
				borderWidth: borderWidth,
				cellDimension: cellDimension,
				cellSpacing: cellSpacing,
				cornerRadius: cornerRadius
			)
		}

		/// A callback block for retrieving the tooltip text for a cell within the activity grid
		public func tooltipStringForCell(_ block: @escaping (Int) -> String?) -> Self {
			var copy = self
			copy._tooltipStringForCell = block
			return copy
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

	func makeActivityGrid(_ context: Context) -> DSFSparklineActivityGridView {
		let view = DSFSparklineActivityGridView(frame: .zero)
		self.updateView(view)
		view.cellTooltipString = self._tooltipStringForCell
		return view
	}

	#if os(macOS)
	@available(macOS 13.0, *)
	public func sizeThatFits(_ proposal: ProposedViewSize, nsView: DSFSparklineActivityGridView, context: Context) -> CGSize? {
		let w = (nsView.horizontalCellCount == 0) ? (proposal.width ?? nsView.activityLayer.intrinsicWidth) : nsView.activityLayer.intrinsicWidth
		return CGSize(width: w, height: nsView.intrinsicContentSize.height)
	}
	#else
	@available(iOS 16.0, tvOS 16.0, *)
	public func sizeThatFits(_ proposal: ProposedViewSize, uiView: DSFSparklineActivityGridView, context: Context) -> CGSize? {
		let w = (uiView.horizontalCellCount == 0) ? (proposal.width ?? uiView.activityLayer.intrinsicWidth) : uiView.activityLayer.intrinsicWidth
		return CGSize(width: w, height: uiView.intrinsicContentSize.height)
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
		let v = self.makeActivityGrid(context)
		return v
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
		view.horizontalCellCount = self.horizontalCellCount
		if let range = self.range {
			view.setValues(v, range: CGFloat(range.lowerBound) ... CGFloat(range.upperBound))
		}
		else {
			view.setValues(v)
		}

		view.cellStyle = self.cellStyle
		view.layoutStyle = self.layoutStyle
	}
}

#endif
