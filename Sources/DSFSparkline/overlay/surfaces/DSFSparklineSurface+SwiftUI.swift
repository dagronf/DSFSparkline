//
//  DSFSparklineSurface+SwiftUI.swift
//  DSFSparklines
//
//  Created by Darren Ford on 26/2/21.
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

import SwiftUI

public extension DSFSparklineSurface {

	/// A surface for creating a sparkline using overlays
	struct SwiftUI {
		let overlays: [DSFSparklineOverlay]

		public init(_ overlays: [DSFSparklineOverlay]) {
			self.overlays = overlays
		}
	}
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
extension DSFSparklineSurface.SwiftUI: DSFViewRepresentable {
	#if os(macOS)
	public typealias NSViewType = DSFSparklineSurfaceView
	#else
	public typealias UIViewType = DSFSparklineSurfaceView
	#endif

	public class Coordinator: NSObject {
		let parent: DSFSparklineSurface.SwiftUI
		init(_ sparkline: DSFSparklineSurface.SwiftUI) {
			self.parent = sparkline
		}
	}

	public func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	private func makeSurface(_ context: Context) -> DSFSparklineSurfaceView {
		let view = DSFSparklineSurfaceView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false

		let base = context.coordinator.parent
		base.overlays.forEach { view.addOverlay($0) }

		return view
	}
}

// MARK: - iOS/tvOS Specific

@available(iOS 13.0, tvOS 13.0, macOS 9999.0, *)
public extension DSFSparklineSurface.SwiftUI {
	func makeUIView(context: Context) -> DSFSparklineSurfaceView {
		return self.makeSurface(context)
	}

	func updateUIView(_ view: DSFSparklineSurfaceView, context: Context) {
		self.updateView(view, context: context)
	}
}

// MARK: - macOS Specific

@available(macOS 10.15, iOS 9999.0, tvOS 9999.0, *)
public extension DSFSparklineSurface.SwiftUI {
	func makeNSView(context: Context) -> DSFSparklineSurfaceView {
		return self.makeSurface(context)
	}

	func updateNSView(_ nsView: DSFSparklineSurfaceView, context: Context) {
		self.updateView(nsView, context: context)
	}
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
public extension DSFSparklineSurface.SwiftUI {
	func updateView(_ view: DSFSparklineSurfaceView, context: Context) {

	}
}
