//
//  DSFSparklinePercentBarGraphView+SwiftUI.swift
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

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
public extension DSFSparklinePercentBarGraphView {

	/// The SwiftUI percent bar graph
	struct SwiftUI {
		/// Datasource for the graph
		let style: DSFSparkline.PercentBar.Style
		/// Palette to use when coloring the chart
		let value: Double
		
		/// Create a sparkline graph that displays dots (like the CPU history graph in Activity Monitor)
		/// - Parameters:
		public init(style: DSFSparkline.PercentBar.Style = DSFSparkline.PercentBar.Style(),
						value: Double)
		{
			self.style = style
			self.value = value
		}
	}
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
extension DSFSparklinePercentBarGraphView.SwiftUI: DSFViewRepresentable {
	#if os(macOS)
	public typealias NSViewType = DSFSparklinePercentBarGraphView
	#else
	public typealias UIViewType = DSFSparklinePercentBarGraphView
	#endif
	
	public class Coordinator: NSObject {
		let parent: DSFSparklinePercentBarGraphView.SwiftUI
		init(_ sparkline: DSFSparklinePercentBarGraphView.SwiftUI) {
			self.parent = sparkline
		}
	}
	
	public func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}
	
	func makePercentBar(_: Context) -> DSFSparklinePercentBarGraphView {
		let view = DSFSparklinePercentBarGraphView(frame: .zero)
		view.displayStyle = self.style
		view.value = CGFloat(self.value)
		return view
	}
}

// MARK: - iOS/tvOS Specific

@available(iOS 13.0, tvOS 13.0, macOS 9999.0, *)
public extension DSFSparklinePercentBarGraphView.SwiftUI {
	func makeUIView(context: Context) -> DSFSparklinePercentBarGraphView {
		return self.makePercentBar(context)
	}
	
	func updateUIView(_ view: DSFSparklinePercentBarGraphView, context _: Context) {
		self.updateView(view)
	}
}

// MARK: - macOS Specific

@available(macOS 10.15, iOS 9999.0, tvOS 9999.0, *)
public extension DSFSparklinePercentBarGraphView.SwiftUI {
	func makeNSView(context: Context) -> DSFSparklinePercentBarGraphView {
		return self.makePercentBar(context)
	}
	
	func updateNSView(_ view: DSFSparklinePercentBarGraphView, context _: Context) {
		self.updateView(view)
	}
}

// MARK: - Common updates

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
public extension DSFSparklinePercentBarGraphView.SwiftUI {
	func updateView(_ view: DSFSparklinePercentBarGraphView) {
		view.displayStyle = self.style
		view.value = CGFloat(self.value)
	}
}

#endif
