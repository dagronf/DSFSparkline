//
//  File.swift
//  
//
//  Created by Darren Ford on 17/1/2024.
//

import Foundation
import QuartzCore

#if os(macOS)
import AppKit
#else
import UIKit
#endif

public extension DSFSparklineOverlay {

	@objc(DSFSparklineOverlayCircularProgress) class CircularProgress: DSFSparklineOverlay {
		/// The value assigned to the percent bar. A value between 0.0 and 1.0
		@objc public var value: CGFloat = 0.25 {
			didSet {
				self.valueDidChange()
			}
		}

		/// The value assigned to the percent bar. A value between 0.0 and 1.0
		@objc public var lineWidth: CGFloat = 10.0 {
			didSet {
				self.valueDidChange()
			}
		}

		/// The padding (inset) for drawing the ring
		@objc public var padding: CGFloat = 0.0 {
			didSet {
				self.valueDidChange()
			}
		}

		/// The fill style for the progress track
		@objc public var fillStyle: DSFSparklineFillable {
			didSet {
				self.valueDidChange()
			}
		}

		/// The color of the track background
		@objc public var trackColor = CGColor.init(gray: 0.5, alpha: 0.1) {
			didSet {
				self.valueDidChange()
			}
		}

		override init() {
			self.fillStyle = DSFSparkline.Fill.Color(.white)
			super.init()
		}

		init(value: CGFloat, lineWidth: CGFloat, fillStyle: DSFSparklineFillable) {
			self.value = value
			self.lineWidth = lineWidth
			self.fillStyle = fillStyle
			super.init()
		}
		
		public override init(layer: Any) {
			if let layer = layer as? CircularProgress {
				self.value = layer.value
				self.lineWidth = layer.lineWidth
				self.fillStyle = layer.fillStyle
			}
			else {
				fatalError()
			}
			super.init(layer: layer)
		}

		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}

		override internal func drawGraph(context: CGContext, bounds: CGRect, scale: CGFloat) {
			self.drawCircularProgressGraph(context: context, bounds: bounds, scale: scale)
		}

		private let fullCircle = 2.0 * CGFloat.pi
	}
}

private extension DSFSparklineOverlay.CircularProgress {
	func valueDidChange() {
		self.setNeedsDisplay()
	}

	func drawCircularProgressGraph(context: CGContext, bounds: CGRect, scale: CGFloat) {
		ActivityRing.drawRing(
			in: context,
			destination: bounds,
			value: self.value,
			padding: self.padding,
			lineWidth: self.lineWidth,
			fillStyle: self.fillStyle,
			trackColor: self.trackColor
		)
	}
}


////

private class ActivityRing {

	static func drawRing(
		in ctx: CGContext,
		destination: CGRect = .zero,
		value: CGFloat,
		padding: CGFloat,
		lineWidth: CGFloat,
		fillStyle: DSFSparklineFillable,
		trackColor: CGColor
	) {
		assert(value >= 0.0)

		let _fullCircle = 2.0 * CGFloat.pi

		let ctxBounds = CGRect(origin: .zero, size: CGSize(width: ctx.width, height: ctx.height))

		var drawRect = destination == .zero ? ctxBounds : destination
		if drawRect.width != drawRect.height {
			let m = min(drawRect.width, drawRect.height)
			drawRect = CGRect(
				x: drawRect.minX + ((drawRect.width - m) / 2),
				y: drawRect.minY + ((drawRect.height - m) / 2),
				width: m,
				height: m
			)
		}

		// Inset by the padding amount
		drawRect = drawRect.insetBy(dx: padding, dy: padding)

		let centerPoint = CGPoint(x: drawRect.midX, y: drawRect.midY)
		let dimension = drawRect.width > drawRect.height ? drawRect.height : drawRect.width
		let radius: CGFloat = drawRect.width > drawRect.height ? (drawRect.height - lineWidth) / 2.0 : (drawRect.width - lineWidth) / 2.0

		//
		// Clip to the activity track
		//

		let pth = CGMutablePath()
		pth.addArc(center: centerPoint, radius: radius, startAngle: 0, endAngle: _fullCircle, clockwise: false)
		let act = pth.copy(strokingWithWidth: lineWidth, lineCap: .round, lineJoin: .round, miterLimit: 1.0)
		ctx.addPath(act)
		ctx.clip()

		//
		// Fill the background track
		//

		ctx.usingGState { ctx in
			ctx.setFillColor(trackColor)
			ctx.fill([drawRect])
		}

		//
		// Draw the ring
		//

		var offset: CGFloat = 0
		do {
			let colorSpace = CGColorSpaceCreateDeviceRGB()
			let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
			let fill = CGContext(
				data: nil,
				width: Int(dimension),
				height: Int(dimension),
				bitsPerComponent: 8,
				bytesPerRow: 0,
				space: colorSpace,
				bitmapInfo: bitmapInfo.rawValue
			)!

			// The full angle sweep (which may be > 1)
			let totalAngle = _fullCircle * value

			while offset <= totalAngle {

				let fractionalValue = totalAngle == 0 ? 0 : (offset / totalAngle)
				let c = fillStyle.color(at: fractionalValue)

				let x = radius + (radius * cos(offset - (CGFloat.pi * 0.5)))
				let y = radius + (radius * sin(offset - (CGFloat.pi * 0.5)))
				offset += 0.01

				let p = CGPath(
					ellipseIn: CGRect(x: x, y: y, width: lineWidth, height: lineWidth),
					transform: nil)

				fill.addPath(p)
				fill.setFillColor(c)
				fill.fillPath()
			}

			/// An image containing the drawn ring
			let ringImage = fill.makeImage()!
			ctx.draw(ringImage, in: drawRect, byTiling: false)
		}

		//
		// Draw a circle at the end
		//

		if value >= 0.92 {
			ctx.usingGState { ctx in
				let x = drawRect.minX + (radius + (radius * cos(offset - (CGFloat.pi * 0.5))))
				let y = drawRect.minY + (radius + (radius * sin(offset - (CGFloat.pi * 0.5))))

				let cp = CGPath(
					ellipseIn: CGRect(x: x, y: y, width: lineWidth, height: lineWidth),
					transform: nil
				)
				ctx.addPath(cp)
				ctx.setFillColor(fillStyle.color(at: 1.0))

				let shadowAngle = offset + 0.1
				let sx = drawRect.minX + (radius + (radius * cos(shadowAngle - (CGFloat.pi * 0.5))))
				let sy = drawRect.minY + (radius + (radius * sin(shadowAngle - (CGFloat.pi * 0.5))))
				ctx.setShadow(
					offset: CGSize(width: sx - x, height: sy - y),
					blur: dimension / 25,
					color: .black.copy(alpha: 0.4)
				)

				ctx.fillPath()
			}
		}

		///////////

//		let cgi = ctx.makeImage()!
//		let nsi = NSImage(cgImage: cgi, size: .zero)
//		Swift.print(nsi)
	}
}

