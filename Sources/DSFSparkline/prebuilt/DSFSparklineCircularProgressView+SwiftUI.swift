//
//  DSFSparklineCircularProgressView+SwiftUI.swift
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

import SwiftUI

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
public extension DSFSparklineCircularProgressView {
	struct SwiftUI {
		let value: Double
		let lineWidth: Double
		let fillStyle: DSFSparklineFillable
		let padding: CGFloat
		let trackColor: CGColor?

		init(
			value: Double,
			fillStyle: DSFSparklineFillable = DSFSparkline.Fill.Color(.white),
			lineWidth: Double = 10.0,
			padding: Double = 0.0,
			trackColor: CGColor? = nil
		) {
			self.value = value
			self.lineWidth = lineWidth
			self.fillStyle = fillStyle
			self.padding = padding
			self.trackColor = trackColor
		}
	}
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
extension DSFSparklineCircularProgressView.SwiftUI: DSFViewRepresentable {

#if os(macOS)
public typealias NSViewType = DSFSparklineCircularProgressView
#else
public typealias UIViewType = DSFSparklineCircularProgressView
#endif

	public class Coordinator: NSObject {
		let parent: DSFSparklineCircularProgressView.SwiftUI
		init(_ sparkline: DSFSparklineCircularProgressView.SwiftUI) {
			self.parent = sparkline
		}
	}

	public func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	func makeProgressGraph(_: Context) -> DSFSparklineCircularProgressView {
		let view = DSFSparklineCircularProgressView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.value = self.value
		view.lineWidth = self.lineWidth
		view.fillStyle = self.fillStyle.copyFill()
		view.padding = self.padding
		if let t = self.trackColor {
			view.trackColor = DSFColor(cgColor: t)
		}
		return view
	}
}

// MARK: - iOS/tvOS Specific

@available(iOS 13.0, tvOS 13.0, macOS 9999.0, *)
public extension DSFSparklineCircularProgressView.SwiftUI {
	func makeUIView(context: Context) -> DSFSparklineCircularProgressView {
		return self.makeProgressGraph(context)
	}

	func updateUIView(_ view: DSFSparklineCircularProgressView, context _: Context) {
		self.updateView(view)
	}
}

// MARK: - macOS Specific

@available(macOS 10.15, iOS 9999.0, tvOS 9999.0, *)
public extension DSFSparklineCircularProgressView.SwiftUI {
	func makeNSView(context: Context) -> DSFSparklineCircularProgressView {
		return self.makeProgressGraph(context)
	}

	func updateNSView(_ view: DSFSparklineCircularProgressView, context _: Context) {
		self.updateView(view)
	}
}

// MARK: - Common updates

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
public extension DSFSparklineCircularProgressView.SwiftUI {
	func updateView(_ view: DSFSparklineCircularProgressView) {
		UpdateIfNotEqual(result: &view.value, val: self.value)
		UpdateIfNotEqual(result: &view.lineWidth, val: self.lineWidth)
		UpdateIfNotEqual(result: &view.padding, val: self.padding)
		if view.fillStyle !== self.fillStyle {
			view.fillStyle = self.fillStyle
		}
		if view.trackColor !== self.trackColor {
			if let t = self.trackColor {
				view.trackColor = DSFColor(cgColor: t)
			}
		}
	}
}

#if DEBUG

@available(macOS 10.15, *)
struct DSFSparklineCircularProgressViewPreviews: PreviewProvider {
	static var previews: some SwiftUI.View {
		let ge = DSFSparkline.Fill.Gradient(
			colors: [
				CGColor(srgbRed: 1, green: 0.000, blue: 0.00, alpha: 1.0),
				CGColor(srgbRed: 0, green: 0.0, blue: 1, alpha: 1.0),
			]
		)

		let g = DSFSparkline.Fill.Gradient(
			colors: [
				CGColor(srgbRed: 0.977, green: 0.221, blue: 0.520, alpha: 1.0),
				CGColor(srgbRed: 0.891, green: 0.000, blue: 0.090, alpha: 1.0),
			]
		)
		let g1 = DSFSparkline.Fill.Gradient(
			colors: [
				CGColor(srgbRed: 0.849, green: 1.000, blue: 0.000, alpha: 1.0),
				CGColor(srgbRed: 0.601, green: 1.000, blue: 0.009, alpha: 1.0),
			]
		)
		let g2 = DSFSparkline.Fill.Gradient(
			colors: [
				CGColor(srgbRed: 0.000, green: 1.000, blue: 0.663, alpha: 1.0),
				CGColor(srgbRed: 0.015, green: 0.847, blue: 1.000, alpha: 1.0),
			]
		)
		let g3 = DSFSparkline.Fill.Gradient(
			colors: [
				CGColor(srgbRed: 0.996, green: 0.759, blue: 0.300, alpha: 1.0),
				CGColor(srgbRed: 0.996, green: 0.459, blue: 0.000, alpha: 1.0),
			]
		)
		SwiftUI.VStack {
			HStack(alignment: .center) {
				DSFSparklineCircularProgressView.SwiftUI(value: 0, lineWidth: 20)
					.frame(width: 100, height: 100)
				DSFSparklineCircularProgressView.SwiftUI(value: 0.4, lineWidth: 20)
					.frame(width: 100, height: 100)
				DSFSparklineCircularProgressView.SwiftUI(value: 0.8, lineWidth: 20)
					.frame(width: 100, height: 100)
				DSFSparklineCircularProgressView.SwiftUI(value: 1.2, lineWidth: 20)
					.frame(width: 100, height: 100)
				DSFSparklineCircularProgressView.SwiftUI(value: 1.6, lineWidth: 20)
					.frame(width: 100, height: 100)
				DSFSparklineCircularProgressView.SwiftUI(value: 2.0, lineWidth: 20)
					.frame(width: 100, height: 100)
			}
			HStack(alignment: .center) {
				DSFSparklineCircularProgressView.SwiftUI(value: 0, fillStyle: ge, lineWidth: 25)
					.frame(width: 100, height: 100)
				DSFSparklineCircularProgressView.SwiftUI(value: 0.4, fillStyle: ge, lineWidth: 25)
					.frame(width: 100, height: 100)
				DSFSparklineCircularProgressView.SwiftUI(value: 0.8, fillStyle: ge, lineWidth: 25)
					.frame(width: 100, height: 100)
				DSFSparklineCircularProgressView.SwiftUI(value: 1.2, fillStyle: ge, lineWidth: 25)
					.frame(width: 100, height: 100)
				DSFSparklineCircularProgressView.SwiftUI(value: 1.6, fillStyle: ge, lineWidth: 25)
					.frame(width: 100, height: 100)
				DSFSparklineCircularProgressView.SwiftUI(value: 2.0, fillStyle: ge, lineWidth: 25)
					.frame(width: 100, height: 100)
			}
			HStack(alignment: .center) {
				ZStack {
					DSFSparklineCircularProgressView.SwiftUI(value: 0, fillStyle: g, trackColor: CGColor(srgbRed: 0.977, green: 0.221, blue: 0.520, alpha: 0.1))
					DSFSparklineCircularProgressView.SwiftUI(value: 0, fillStyle: g1, padding: 12, trackColor: CGColor(srgbRed: 0.849, green: 1.000, blue: 0.000, alpha: 0.1))
					DSFSparklineCircularProgressView.SwiftUI(value: 0, fillStyle: g2, padding: 24, trackColor: CGColor(srgbRed: 0.000, green: 1.000, blue: 0.663, alpha: 0.1))
					DSFSparklineCircularProgressView.SwiftUI(value: 0, fillStyle: g3, padding: 36, trackColor: CGColor(srgbRed: 0.996, green: 0.759, blue: 0.300, alpha: 0.1))
				}
				.frame(width: 150, height: 150)
				ZStack {
					DSFSparklineCircularProgressView.SwiftUI(value: 0.4, fillStyle: g, trackColor: CGColor(srgbRed: 0.977, green: 0.221, blue: 0.520, alpha: 0.1))
					DSFSparklineCircularProgressView.SwiftUI(value: 0.4, fillStyle: g1, padding: 12, trackColor: CGColor(srgbRed: 0.849, green: 1.000, blue: 0.000, alpha: 0.1))
					DSFSparklineCircularProgressView.SwiftUI(value: 0.4, fillStyle: g2, padding: 24, trackColor: CGColor(srgbRed: 0.000, green: 1.000, blue: 0.663, alpha: 0.1))
					DSFSparklineCircularProgressView.SwiftUI(value: 0.4, fillStyle: g3, padding: 36, trackColor: CGColor(srgbRed: 0.996, green: 0.759, blue: 0.300, alpha: 0.1))
				}
					.frame(width: 150, height: 150)
				ZStack {
					DSFSparklineCircularProgressView.SwiftUI(value: 0.8, fillStyle: g, trackColor: CGColor(srgbRed: 0.977, green: 0.221, blue: 0.520, alpha: 0.1))
					DSFSparklineCircularProgressView.SwiftUI(value: 0.8, fillStyle: g1, padding: 12, trackColor: CGColor(srgbRed: 0.849, green: 1.000, blue: 0.000, alpha: 0.1))
					DSFSparklineCircularProgressView.SwiftUI(value: 0.8, fillStyle: g2, padding: 24, trackColor: CGColor(srgbRed: 0.000, green: 1.000, blue: 0.663, alpha: 0.1))
					DSFSparklineCircularProgressView.SwiftUI(value: 0.8, fillStyle: g3, padding: 36, trackColor: CGColor(srgbRed: 0.996, green: 0.759, blue: 0.300, alpha: 0.1))
		}
					.frame(width: 150, height: 150)
				ZStack {
					DSFSparklineCircularProgressView.SwiftUI(value: 1.1, fillStyle: g, trackColor: CGColor(srgbRed: 0.977, green: 0.221, blue: 0.520, alpha: 0.1))
					DSFSparklineCircularProgressView.SwiftUI(value: 1.1, fillStyle: g1, padding: 12, trackColor: CGColor(srgbRed: 0.849, green: 1.000, blue: 0.000, alpha: 0.1))
					DSFSparklineCircularProgressView.SwiftUI(value: 1.1, fillStyle: g2, padding: 24, trackColor: CGColor(srgbRed: 0.000, green: 1.000, blue: 0.663, alpha: 0.1))
					DSFSparklineCircularProgressView.SwiftUI(value: 1.1, fillStyle: g3, padding: 36, trackColor: CGColor(srgbRed: 0.996, green: 0.759, blue: 0.300, alpha: 0.1))
				}
					.frame(width: 150, height: 150)
				ZStack {
					DSFSparklineCircularProgressView.SwiftUI(value: 1.5, fillStyle: g, trackColor: CGColor(srgbRed: 0.977, green: 0.221, blue: 0.520, alpha: 0.1))
					DSFSparklineCircularProgressView.SwiftUI(value: 1.5, fillStyle: g1, padding: 12, trackColor: CGColor(srgbRed: 0.849, green: 1.000, blue: 0.000, alpha: 0.1))
					DSFSparklineCircularProgressView.SwiftUI(value: 1.5, fillStyle: g2, padding: 24, trackColor: CGColor(srgbRed: 0.000, green: 1.000, blue: 0.663, alpha: 0.1))
					DSFSparklineCircularProgressView.SwiftUI(value: 1.5, fillStyle: g3, padding: 36, trackColor: CGColor(srgbRed: 0.996, green: 0.759, blue: 0.300, alpha: 0.1))
				}
				.frame(width: 150, height: 150)
			}
		}
		.padding()
	}
}

#endif

#endif
