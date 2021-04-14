//
//  DSFSparklineSurface+View.swift
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

#if os(macOS)
import Cocoa
#else
import UIKit
#endif

/// A surface for drawing a sparkline into a view.
///
/// Represents the generic base class for a view.
@objc public class DSFSparklineSurfaceView: DSFView {
	#if os(macOS)
	override public var isFlipped: Bool {
		return true
	}
	#endif

	// Render delegate instance
	lazy private var renderDelegate: RendererDelegate = {
		return RendererDelegate(view: self)
	}()

	var rootLayer: CALayer {
		#if os(macOS)
		return self.layer!
		#else
		return self.layer
		#endif
	}

	deinit {}

	override public init(frame: CGRect) {
		super.init(frame: frame)
		self.setup()
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.setup()
	}

	private func setup() {
		#if os(macOS)
		self.wantsLayer = true
		#else
		// Configure iOS/tvOS to make the background transparent.
		// If isOpaque is true (the default value) iOS assumes that you're drawing
		// the ENTIRE content of the control (which we are not).
		self.isOpaque = false
		#endif
	}

	/// Multi-platform function for telling the view to update itself
	public func updateDisplay() {
		#if os(macOS)
		self.needsDisplay = true
		#else
		self.setNeedsDisplay()
		#endif
	}
}

extension DSFSparklineSurfaceView {

	var overlays: [DSFSparklineOverlay] {
		return self.rootLayer.sublayers?.compactMap { $0 as? DSFSparklineOverlay } ?? []
	}

	/// Add a sparkline overlay to the view
	public func addOverlay(_ overlay: DSFSparklineOverlay) {
		self.rootLayer.addSublayer(overlay)

		overlay.bounds = self.bounds
		overlay.delegate = self.renderDelegate

		self.syncLayers()
		overlay.setNeedsLayout()
		overlay.setNeedsDisplay()
	}

	/// Remove a sparkline overlay to the view
	public func removeOverlay(_ overlay: DSFSparklineOverlay) {
		overlay.removeFromSuperlayer()
	}

	func edgeInsets(for rect: CGRect) -> DSFEdgeInsets {
		/// Calculate the total inset required
		return self.overlays.reduce(DSFEdgeInsets.zero) { (result, overlay) in
			result.combineMaximum(using: overlay.edgeInsets(for: rect))
		}
	}

	private func syncLayers() {
		CATransaction.setDisableActions(true)
		self.rootLayer.sublayers?.forEach { layer in
			layer.bounds = self.bounds
			layer.contentsScale = self.retinaScale()
			layer.setNeedsDisplay()
		}
	}

	#if os(macOS)
	public override func layout() {
		super.layout()
		self.syncLayers()
	}
	public override func viewDidMoveToWindow() {
		super.viewDidMoveToWindow()
		self.syncLayers()
	}
	#else
	public override func layoutSubviews() {
		super.layoutSubviews()
		self.syncLayers()
	}
	public override func didMoveToWindow() {
		super.didMoveToWindow()
		self.syncLayers()
	}
	#endif
}

// the draw delegate for the overlay layers
fileprivate class RendererDelegate: NSObject, CALayerDelegate {

	let view: DSFSparklineSurfaceView

	init(view: DSFSparklineSurfaceView) {
		self.view = view
		super.init()
	}

	func draw(_ layer: CALayer, in ctx: CGContext) {
		if let l = layer as? DSFSparklineOverlay {
			let scale = view.retinaScale()
			l.contentsScale = scale
			let insetBounds = view.edgeInsets(for: view.bounds)
			l.drawGraph(context: ctx, bounds: view.bounds.inset(by: insetBounds), scale: scale)
		}
	}
}
