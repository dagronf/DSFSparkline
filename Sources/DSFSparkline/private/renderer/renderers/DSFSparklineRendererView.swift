//
//  File.swift
//
//
//  Created by Darren Ford on 3/2/21.
//

#if os(macOS)
import Cocoa
#else
import UIKit
#endif

@objc public class DSFSparklineRendererView: DSFView {
	#if os(macOS)
	override public var isFlipped: Bool {
		return true
	}
	#endif

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

	func setup() {
		#if os(macOS)
		self.wantsLayer = true
		#else
		// Configure iOS/tvOS to make the background transparent.
		// If isOpaque is true (the default value) iOS assumes that you're drawing
		// the ENTIRE content of the control (which we are not).
		self.isOpaque = false
		#endif
	}
}

extension DSFSparklineRendererView {

	public func addOverlay(_ overlay: DSFSparklineOverlay) {
		self.rootLayer.addSublayer(overlay)

		let scale = self.window?.backingScaleFactor ?? 2
		overlay.contentsScale = scale

		overlay.bounds = self.bounds
		#if os(macOS)
		overlay.delegate = self
		#endif
		overlay.setNeedsDisplay()
	}

	public func removeOverlay(_ overlay: DSFSparklineOverlay) {
		overlay.removeFromSuperlayer()
	}

	private func syncLayers() {
		CATransaction.setDisableActions(true)
		self.rootLayer.sublayers?.forEach { layer in
			layer.bounds = self.bounds
			layer.setNeedsDisplay()
		}
	}

	#if os(macOS)
	public override func layout() {
		super.layout()
		self.syncLayers()
	}
	
	#else
	public override func layoutSubviews() {
		super.layoutSubviews()
		self.syncLayers()
	}
	override public func draw(_ layer: CALayer, in ctx: CGContext) {
		layer.contentsScale = self.contentScaleFactor
		super.draw(layer, in: ctx)

		if let l = layer as? DSFSparklineOverlay {
			_ = l.drawGraph(context: ctx, bounds: self.bounds, hostedIn: self)
		}
	}
	#endif
}

#if os(macOS)
extension DSFSparklineRendererView: CALayerDelegate {
	public func draw(_ layer: CALayer, in ctx: CGContext) {
		let scale = self.window?.backingScaleFactor ?? 2
		layer.contentsScale = scale

		if let l = layer as? DSFSparklineOverlay {
			_ = l.drawGraph(context: ctx, bounds: self.bounds, hostedIn: self)
		}
	}
}
#endif
