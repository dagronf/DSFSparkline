//
//  DSFSparklineOverlay+CircularProgress.swift
//
//  Copyright © 2024 Darren Ford. All rights reserved.
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

import Foundation
import QuartzCore

#if os(macOS)
import AppKit
#else
import UIKit
#endif

public extension DSFSparklineOverlay {

	/// A circular progress sparkline
	@objc(DSFSparklineOverlayCircularProgress) class CircularProgress: DSFSparklineOverlay {

		/// The value assigned to the percent bar. A value between 0.0 and 1.0
		@objc public var value: CGFloat = 0.25 {
			didSet {
				self.valueDidChange()
			}
		}

		/// Default track width
		@objc public static let DefaultTrackWidth: CGFloat = 10.0

		/// The width of the circular ring track
		@objc public var trackWidth: CGFloat = CircularProgress.DefaultTrackWidth {
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

		/// Default fill style
		@objc public static let DefaultFillStyle = DSFSparkline.Fill.Color(srgbRed: 0, green: 0, blue: 1)


		/// The fill style for the progress track
		@objc public var fillStyle: DSFSparklineFillable = CircularProgress.DefaultFillStyle {
			didSet {
				self.valueDidChange()
			}
		}

		/// Default track color
		@objc public static let DefaultTrackColor = CGColor(gray: 0.5, alpha: 0.1)

		/// The color of the track background
		@objc public var trackColor: CGColor = CircularProgress.DefaultTrackColor {
			didSet {
				self.valueDidChange()
			}
		}

		/// The icon appearing in the track at the top of the ring
		@objc public var icon: CGImage? = nil {
			didSet {
				self._flippedIcon = icon?.flipped()
				self.valueDidChange()
			}
		}
		private var _flippedIcon: CGImage? = nil

		override init() {
			super.init()
			self.drawsAsynchronously = true
		}

		init(value: CGFloat, trackWidth: CGFloat, fillStyle: DSFSparklineFillable, trackColor: CGColor = CircularProgress.DefaultTrackColor) {
			self.value = value
			self.trackWidth = trackWidth
			self.fillStyle = fillStyle
			self.trackColor = trackColor
			super.init()
			self.drawsAsynchronously = true
		}
		
		public override init(layer: Any) {
			if let layer = layer as? CircularProgress {
				self.value = layer.value
				self.trackWidth = layer.trackWidth
				self.fillStyle = layer.fillStyle
				self.trackColor = layer.trackColor.copy()!
				self.padding = layer.padding
				self.icon = layer.icon?.copy()
			}
			else {
				fatalError()
			}
			super.init(layer: layer)
			self.drawsAsynchronously = true
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
			trackWidth: self.trackWidth,
			fillStyle: self.fillStyle,
			trackColor: self.trackColor,
			icon: self._flippedIcon
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
		trackWidth: CGFloat,
		fillStyle: DSFSparklineFillable,
		trackColor: CGColor,
		icon: CGImage?
	) {
		assert(value >= 0.0)
		guard destination.isEmpty == false else { return }

		let _fullCircle = 2.0 * CGFloat.pi

		var drawRect = destination

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

		guard drawRect.isEmpty == false else {
			return
		}

		let centerPoint = CGPoint(x: drawRect.midX, y: drawRect.midY)
		let dimension = drawRect.width > drawRect.height ? drawRect.height : drawRect.width
		let radius: CGFloat = drawRect.width > drawRect.height ? (drawRect.height - trackWidth) / 2.0 : (drawRect.width - trackWidth) / 2.0

		//
		// Clip to the activity track
		//

		let pth = CGMutablePath()
		pth.addArc(center: centerPoint, radius: radius, startAngle: 0, endAngle: _fullCircle, clockwise: false)
		let act = pth.copy(strokingWithWidth: trackWidth, lineCap: .round, lineJoin: .round, miterLimit: 1.0)
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
					ellipseIn: CGRect(x: x - 0.1, y: y - 0.1, width: trackWidth + 0.2, height: trackWidth + 0.2),
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
					ellipseIn: CGRect(x: x - 0.1, y: y - 0.1, width: trackWidth + 0.2, height: trackWidth + 0.2),
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

		//
		// Draw the icon
		//

		if let icon = icon {
			let x = drawRect.minX + (radius + (radius * cos(-(CGFloat.pi * 0.5))))
			let y = drawRect.minY + (radius + (radius * sin(-(CGFloat.pi * 0.5))))

			let iconRect = CGRect(x: x, y: y, width: trackWidth, height: trackWidth).insetBy(dx: 2, dy: 2)
			ctx.draw(icon, in: iconRect, byTiling: false)
		}
	}
}
