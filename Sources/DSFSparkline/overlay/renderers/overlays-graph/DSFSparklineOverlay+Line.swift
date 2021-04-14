//
//  DSFSparklineOverlay+Line.swift
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

public extension DSFSparklineOverlay {
	/// A line graph sparkline
	@objc(DSFSparklineOverlayLine) class Line: Centerable {

		/// The width for the line drawn on the graph
		@objc public var strokeWidth: CGFloat = 1.5 {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// Interpolate a curve between the points
		@objc public var interpolated: Bool = false {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// Draw a shadow under the line
		@objc public var shadow: NSShadow? {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The size of the markers to draw. If the markerSize is less than 0, markers will not draw
		@objc public var markerSize: CGFloat = -1 {
			didSet {
				self.setNeedsDisplay()
			}
		}

		// MARK: - Markers

		/// Representation of a marker within the sparkline
		@objc(DSFSparklineOverlayLineMarker) public class Marker: NSObject {
			/// The raw data value for the marker
			@objc public let value: CGFloat
			/// The rect representing the marker
			@objc public let rect: CGRect
			/// If the graph is a centering graph, is this marker considered to be positive or negative?
			@objc public let isPositiveValue: Bool
			@objc public init(value: CGFloat, rect: CGRect, isPositiveValue: Bool) {
				self.value = value
				self.rect = rect
				self.isPositiveValue = isPositiveValue
			}
		}

		/// Marker drawing callback
		/// - Parameters:
		///   - context: The drawing context
		///   - markerFrames: The Marker definitions for all of the markers within the current sparkline in left-to-right order
		public typealias MarkerDrawingBlock = (_ context: CGContext, _ markerFrames: [Marker]) -> Void

		/// An optional drawing function for custom drawing markers.
		///
		/// The `markerSize` value is used to determine the frameSize of each marker.
		/// If `markerSize` is less than 1, this block will not be called.
		///
		/// Note that this function is called very frequently so make sure its performant!
		@objc public lazy var markerDrawingBlock: MarkerDrawingBlock? = nil

		// Return the drawing function to use when drawing markers
		private var actualMarkerDrawingBlock: MarkerDrawingBlock {
			return self.markerDrawingBlock ?? self.DefaultMarkerDrawingBlock
		}

		// Convert the default marker drawing function to a block
		private lazy var DefaultMarkerDrawingBlock: MarkerDrawingBlock = { context, markers in
			DSFSparklineOverlay.Line.DefaultMarkerDrawingFunc(what: self, context: context, markers: markers)
		}

		deinit {
			self.markerDrawingBlock = nil
		}

		// MARK: - Draw handling

		// Override the edge insets to make sure our line graph fits
		override internal func edgeInsets(for rect: CGRect) -> DSFEdgeInsets {
			// If there's a shadow, inset by the maximum shadow offset + blur radius
			let shadowOffset: CGFloat = {
				if let s = shadow {
					return max(s.shadowOffset.width, s.shadowOffset.height) + s.shadowBlurRadius
				}
				else {
					return 0
				}
			}()

			let inset = (self.markerSize > 0 ? self.markerSize / 2 : self.strokeWidth) + shadowOffset
			return DSFEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
		}

		override internal func drawGraph(context: CGContext, bounds: CGRect, scale: CGFloat) {
			if self.centeredAtZeroLine {
				self.drawCenteredGraph(context: context, bounds: bounds, scale: scale)
			}
			else {
				self.drawLineGraph(context: context, bounds: bounds, scale: scale)
			}
		}
	}
}

// MARK: - Default marker drawing

private extension DSFSparklineOverlay.Line {

	// Default marker drawing
	static func DefaultMarkerDrawingFunc(what: Line, context ctx: CGContext, markers: [Marker]) {
		guard let primaryStrokeColor = what.primaryStrokeColor else { return }

		let positiveMarkers = markers.filter { $0.isPositiveValue }
		let negativeMarkers = markers.filter { $0.isPositiveValue == false }

		// draw positives. For a non-centered graph, all values are 'positive'
		if positiveMarkers.count > 0 {
			ctx.usingGState { pCtx in
				let path = CGMutablePath()
				positiveMarkers.forEach { marker in
					path.addPath(CGPath(ellipseIn: marker.rect, transform: nil))
				}
				pCtx.addPath(path)
				pCtx.setFillColor(primaryStrokeColor)
				if let shadow = what.shadow {
					pCtx.setShadow(shadow)
				}
				pCtx.fillPath()
			}
		}

		// draw negatives
		if negativeMarkers.count > 0 {
			let strokeColor = what.secondaryStrokeColor ?? primaryStrokeColor
			ctx.usingGState { nCtx in
				let path = CGMutablePath()
				negativeMarkers.forEach { marker in
					path.addPath(CGPath(ellipseIn: marker.rect, transform: nil))
				}
				nCtx.addPath(path)
				nCtx.setFillColor(strokeColor)
				if let shadow = what.shadow {
					nCtx.setShadow(shadow)
				}
				nCtx.fillPath()
			}
		}
	}
}

// MARK: - Sparkline drawing

private extension DSFSparklineOverlay.Line {
	func drawLineGraph(context: CGContext, bounds: CGRect, scale _: CGFloat) {
		guard let dataSource = self.dataSource,
				dataSource.counter != 0 else
		{
			// There's no line if there's either no data or just a single point
			// https://github.com/dagronf/DSFSparkline/issues/3#issuecomment-770324047
			return
		}

		let normy = dataSource.normalized
		let xDiff = bounds.width / CGFloat(normy.count - 1)
		let points = normy.enumerated().map {
			CGPoint(x: CGFloat($0.offset) * xDiff + bounds.minX,
					  y: bounds.height + bounds.minY - ($0.element * bounds.height))
		}

		let path = CGPath.pathWithPoints(points, smoothed: self.interpolated)

		var markersBounds: [CGRect] = []
		if self.markerSize > 0 {
			points.forEach { point in
				let w = self.markerSize / 2
				let r = CGRect(x: point.x - w, y: point.y - w, width: self.markerSize, height: self.markerSize)
				markersBounds.append(r)
			}
		}

		context.usingGState { outer in

			if dataSource.counter < dataSource.windowSize {
				let pos = bounds.minX + (CGFloat(dataSource.counter) * xDiff)
				let clipRect = bounds.divided(atDistance: pos, from: .maxXEdge).slice
				outer.clip(to: clipRect)
			}

			if let fill = self.primaryFill {
				outer.usingGState { ctx in

					let clipper = path.mutableCopy()!
					clipper.addLine(to: CGPoint(x: bounds.maxX, y: points.last!.y))
					clipper.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
					clipper.addLine(to: CGPoint(x: bounds.minX, y: bounds.maxY))
					clipper.addLine(to: CGPoint(x: bounds.minX, y: points.first!.y))
					clipper.closeSubpath()

					ctx.addPath(clipper)
					ctx.clip()
					fill.fill(context: ctx, bounds: bounds)
				}
			}

			if let strokeColor = self.primaryStrokeColor {
				outer.usingGState { ctx in
					ctx.addPath(path)
					ctx.setStrokeColor(strokeColor)
					ctx.setLineWidth(self.strokeWidth)

					if let shadow = self.shadow {
						ctx.setShadow(shadow)
					}
					ctx.setLineJoin(.round)
					ctx.setLineCap(.round)
					ctx.strokePath()
				}
			}

			/// Draw the markers
			if !markersBounds.isEmpty {
				outer.usingGState { ctx in
					// For the standard line, all values are 'positive'
					let markers = zip(dataSource.data, markersBounds).map { Marker(value: $0.0, rect: $0.1, isPositiveValue: true) }
					self.actualMarkerDrawingBlock(ctx, markers)
				}
			}
		}
	}

	func drawCenteredGraph(context: CGContext, bounds: CGRect, scale _: CGFloat) {
		guard let dataSource = self.dataSource,
				dataSource.counter != 0 else
		{
			// There's no line if there's either no data or just a single point
			// https://github.com/dagronf/DSFSparkline/issues/3#issuecomment-770324047
			return
		}

		let normy = dataSource.normalized
		let xDiff = bounds.width / CGFloat(normy.count - 1)
		let points = normy.enumerated().map {
			CGPoint(x: CGFloat($0.offset) * xDiff + bounds.minX,
					  y: bounds.height + bounds.minY - ($0.element * bounds.height))
		}

		let centroid = (1 - dataSource.normalizedZeroLineValue) * (bounds.height - 1)

		var markers: [Marker] = []

		if self.markerSize > 0 {
			points.enumerated().forEach { point in
				let w = self.markerSize / 2
				let r = CGRect(x: point.element.x - w, y: point.element.y - w,
									width: self.markerSize, height: self.markerSize)

				markers.append(
					Marker(
						value: dataSource.data[point.offset],
						rect: r,
						isPositiveValue: !dataSource.valueAtOffsetIsBelowZeroline(point.offset)))
			}
		}

		let path = CGPath.pathWithPoints(points, smoothed: self.interpolated).mutableCopy()!

		for which in 0 ... 1 {
			if dataSource.counter < dataSource.windowSize {
				let pos = CGFloat(dataSource.counter) * xDiff
				let clipRect = bounds.divided(atDistance: pos, from: .maxXEdge).slice
				context.clip(to: clipRect)
			}

			context.usingGState { inner in

				let split = bounds.divided(atDistance: centroid, from: .minYEdge)

				if which == 0 {
					inner.clip(to: split.slice)
				}
				else {
					inner.clip(to: split.remainder)
				}

				let fillItem = (which == 0) ? self.primaryFill : self.secondaryFill

				if let fill = fillItem {
					inner.usingGState { ctx in

						let altY = which == 0 ? bounds.maxY : bounds.minY

						let clipper = path.mutableCopy()!
						clipper.addLine(to: CGPoint(x: bounds.maxX, y: points.last!.y))
						clipper.addLine(to: CGPoint(x: bounds.maxX, y: altY))
						clipper.addLine(to: CGPoint(x: bounds.minX, y: altY))
						clipper.addLine(to: CGPoint(x: bounds.minX, y: points.first!.y))
						clipper.closeSubpath()

						ctx.addPath(clipper)
						ctx.clip()
						fill.fill(context: ctx, bounds: bounds)
					}
				}

				let whichColor = (which == 0) ? self.primaryStrokeColor : self.secondaryStrokeColor

				if let stroke = whichColor {
					inner.usingGState { ctx in
						ctx.addPath(path)
						ctx.setStrokeColor(stroke)
						ctx.setLineWidth(self.strokeWidth)
						if let shadow = self.shadow {
							ctx.setShadow(shadow)
						}
						ctx.setLineJoin(.round)
						ctx.setLineCap(.round)
						ctx.strokePath()
					}
				}
			}
		}

		// Draw the markers

		if self.markerSize > 0 {
			context.usingGState { ctx in
				self.actualMarkerDrawingBlock(ctx, markers)
			}
		}
	}
}
