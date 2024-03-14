//
//  DSFSparklineOverlay+CircularGauge.swift
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
	/// A circular gauge
	@objc(DSFSparklineOverlayCircularGauge) class CircularGauge: DSFSparklineOverlay {
		/// The default track style
		@objc public static let DefaultTrackStyle = DSFSparklineOverlay.CircularGauge.TrackStyle(
			width: 10,
			fillColor: DSFSparkline.Fill.Color(red: 0, green: 0, blue: 0, alpha: 0.2)
		)

		/// The default value style
		@objc public static let DefaultLineStyle = DSFSparklineOverlay.CircularGauge.TrackStyle(
			width: 7,
			fillColor: DSFSparkline.Fill.Color(red: 0, green: 0, blue: 0, alpha: 1)
		)

		/// The value assigned to the percent bar. A value between 0.0 and 1.0
		@objc public var value: CGFloat = 0 {
			willSet {
				animationTransition = DSFSparkline.AnimationTransition(start: _value, stop: newValue)
			}
			didSet {
				if isAnimated {
					startAnimateIn()
				}
				else {
					self._value = self.value.clamped(to: 0 ... 1)
				}
			}
		}

		private var _value: CGFloat = 0 {
			didSet { self.setNeedsDisplay() }
		}

		/// The style to use when drawing the gauge's track
		@objc public var trackStyle: TrackStyle = TrackStyle(
			width: 5,
			fillColor: DSFSparkline.Fill.Color(srgbRed: 0, green: 0, blue: 0, alpha: 0.2)
		)

		/// The style to use when drawing the gauge's value
		@objc public var lineStyle: TrackStyle = TrackStyle(
			width: 3,
			fillColor: DSFSparkline.Fill.Color(srgbRed: 0, green: 0, blue: 0)
		)

		/// The animation style to apply
		@objc public var animationStyle: DSFSparkline.AnimationStyle? = nil
		private var isAnimated: Bool { animationStyle != nil }

		override func drawGraph(context: CGContext, bounds: CGRect, scale: CGFloat) {
			CATransaction.withDisabledActions { [weak self] in
				self?.drawCircularGauge(context: context, bounds: bounds, scale: scale)
			}
		}

		// MARK: Animation

		private var animator = ArbitraryAnimator() //
		private var animationTransition: DSFSparkline.AnimationTransition?
	}
}

extension DSFSparklineOverlay.CircularGauge {
	func startAnimateIn() {
		guard let animStyle = animationStyle else { fatalError() }
		// Stop any animation that is currently active
		self.animator.progressBlock = nil
		self.animator.stop()

		self.animator.animationFunction = animStyle.function.function
		self.animator.duration = animStyle.duration
		self.animator.progressBlock = { [weak self] progress in
			guard let `self` = self, let a = self.animationTransition else { return }
			_value = a.start + (a.stop - a.start) * progress
		}
		self.animator.start()
	}
}

public extension DSFSparklineOverlay.CircularGauge {
	/// A circular gauge track style
	@objc(DSFSparklineOverlayCircularGaugeTrackStyle) class TrackStyle: NSObject {
		/// The width of the track
		@objc public var width: CGFloat
		/// The fill style to use
		@objc public var fillColor: DSFSparklineFillable
		/// The stroke width
		@objc public var strokeWidth: CGFloat
		/// The stroke color
		@objc public var strokeColor: CGColor?
		/// The shadow to use
		@objc public var shadow: DSFSparkline.Shadow?
		/// The line's cap style
		@objc public var lineCap: CGLineCap

		/// Create
		@objc public init(
			width: CGFloat,
			fillColor: DSFSparklineFillable,
			strokeWidth: CGFloat = 0.0,
			strokeColor: CGColor? = nil,
			shadow: DSFSparkline.Shadow? = nil,
			lineCap: CGLineCap = .round
		) {
			self.width = width
			self.fillColor = fillColor
			self.strokeWidth = strokeWidth
			self.strokeColor = strokeColor
			self.shadow = shadow
			self.lineCap = lineCap
			super.init()
		}
	}
}

private extension DSFSparklineOverlay.CircularGauge {
	func drawCircularGauge(context: CGContext, bounds: CGRect, scale: CGFloat) {
		var drawRect = bounds
		if drawRect.width != drawRect.height {
			let m = min(drawRect.width, drawRect.height)
			drawRect = CGRect(
				x: drawRect.minX + ((drawRect.width - m) / 2),
				y: drawRect.minY + ((drawRect.height - m) / 2),
				width: m,
				height: m
			)
		}
		let baseRect = drawRect

		// Inset so that the line drawing doesn't crop at the edges
		let inset: CGFloat = {
			var inset = max(trackStyle.width + trackStyle.strokeWidth, lineStyle.width + lineStyle.strokeWidth)
			let trackW = trackStyle.shadow?.requiredShadowInset ?? 0
			let valueW = lineStyle.shadow?.requiredShadowInset ?? 0
			inset += max(trackW, valueW)
			return inset
		}()

		drawRect = drawRect.insetBy(dx: inset / 2, dy: inset / 2)

		let centerPoint = CGPoint(x: drawRect.midX, y: drawRect.midY)
		let radius: CGFloat = drawRect.width > drawRect.height ? (drawRect.height / 2.0) : (drawRect.width / 2.0)

		// The track
		self.drawComponent(
			context: context,
			bounds: baseRect,
			centerPoint: centerPoint,
			radius: radius,
			value: 1,
			style: trackStyle
		)

		// The value
		self.drawComponent(
			context: context,
			bounds: baseRect,
			centerPoint: centerPoint,
			radius: radius,
			value: _value,
			style: lineStyle
		)
	}
}

private extension DSFSparklineOverlay.CircularGauge {
	func drawComponent(
		context: CGContext,
		bounds: CGRect,
		centerPoint: CGPoint,
		radius: CGFloat,
		value: CGFloat,
		style: TrackStyle
	) {
		let pth = CGMutablePath()
		pth.addArc(
			center: centerPoint,
			radius: radius,
			startAngle: Angle.degrees(135).radians,
			endAngle: Angle.degrees(135 + (270 * value)).radians,
			clockwise: false
		)

		let act = pth.copy(
			strokingWithWidth: style.width,
			lineCap: style.lineCap,
			lineJoin: .round,
			miterLimit: 1.0
		)

		if let shadow = style.shadow {
			if shadow.isInner {
				context.usingGState { ctx in
					// Draw the track
					ctx.addPath(act)
					ctx.clip()
					style.fillColor.fill(context: ctx, bounds: bounds)

					// Overlay the inner shadow
					ctx.drawInnerShadow(
						in: act,
						shadowColor: shadow.color,
						offset: shadow.offset,
						blurRadius: shadow.blurRadius
					)
				}
			}
			else {
				context.usingGState { ctx in

					ctx.addRect(bounds)
					ctx.addPath(act)
					ctx.clip(using: .evenOdd)

					ctx.setShadow(shadow.shadow)
					ctx.addPath(act)
					ctx.setFillColor(shadow.color!)
					ctx.fillPath()
				}

				context.usingGState { ctx in
					ctx.addPath(act)
					ctx.clip()
					style.fillColor.fill(context: ctx, bounds: bounds)
				}
			}
		}
		else {
			context.usingGState { ctx in
				ctx.addPath(act)
				ctx.clip()
				style.fillColor.fill(context: ctx, bounds: bounds)
			}
		}

		if let s = style.strokeColor {
			context.usingGState { ctx in
				ctx.addPath(act)
				ctx.setStrokeColor(s)
				ctx.setLineWidth(style.strokeWidth)
				ctx.setLineCap(.round)
				ctx.strokePath()
			}
		}
	}
}
