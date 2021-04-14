//
//  DSFSparklineOverlay.swift
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

import QuartzCore

/// The core sparkline overlay class.
///
/// All sparkline renderers must inherit from this class
@objc public class DSFSparklineOverlay: CALayer {
	override public init() {
		super.init()
		self.configure()
	}

	override public init(layer: Any) {
		super.init(layer: layer)
		self.configure()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.configure()
	}

	private func configure() {
		self.anchorPoint = CGPoint(x: 0, y: 0)
		self.isOpaque = false

		// Disable the implicit animations on the layer to stop the fade when data changes
		let newActions = [
			"onOrderIn": NSNull(),
			"onOrderOut": NSNull(),
			"sublayers": NSNull(),
			"contents": NSNull(),
			"bounds": NSNull(),
		]

		self.actions = newActions
	}

	/// Return the minimum edge insets required to fit the graph within the specified rect
	///
	/// An example of this is a line graph with markers - if a data point is at zero, the marker will be clipped when drawn.
	/// Overriding this var allows a graph to inset the drawing when required to handle clipping edge cases, while making
	/// sure that grid lines, highlights etc. arrange themselves correctly draw within the range of the reduced graph size.
	internal func edgeInsets(for rect: CGRect) -> DSFEdgeInsets {
		return .zero
	}

	/// To be overridden by sub-classes to draw their content into the provided context
	/// - Parameters:
	///   - context: The context to draw into
	///   - bounds: The bounds in which to draw (which may NOT be the same as the bounds for the context!)
	///   - scale: The scale for the current drawing context (eg. retina == 2)
	internal func drawGraph(context _: CGContext, bounds _: CGRect, scale _: CGFloat) {
		fatalError("must be implemented in overridden classes")
	}
}
