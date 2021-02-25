//
//  DSFSparklineOverlayLine.swift
//  
//
//  Created by Darren Ford on 14/2/21.
//

import QuartzCore

public extension DSFSparklineOverlay {
	@objc(DSFSparklineOverlayLine) class Line: Centerable {

		/// The width for the line drawn on the graph
		@objc public var lineWidth: CGFloat = 1.5 {
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
		@objc public var shadowed: Bool = false {
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

		public override func drawGraph(context: CGContext, bounds: CGRect, scale: CGFloat) -> CGRect {
			if self.centeredAtZeroLine {
				return self.drawCenteredGraph(context: context, bounds: bounds, scale: scale)
			}
			else {
				return self.drawLineGraph(context: context, bounds: bounds, scale: scale)
			}
		}
	}
}

private extension DSFSparklineOverlay.Line {

	func drawLineGraph(context: CGContext, bounds: CGRect, scale: CGFloat) -> CGRect {

		guard let dataSource = self.dataSource,
				dataSource.counter != 0  else {
			// There's no line if there's either no data or just a single point
			// https://github.com/dagronf/DSFSparkline/issues/3#issuecomment-770324047
			return bounds
		}

		// Adjust the inset so that markers can draw unclipped if they are asked for
		let inset = self.markerSize > 0 ? self.markerSize / 2 : self.lineWidth
		let drawRect = self.bounds.insetBy(dx: inset, dy: inset)

		let normy = dataSource.normalized
		let xDiff = drawRect.width / CGFloat(normy.count - 1)
		let points = normy.enumerated().map {
			CGPoint(x: CGFloat($0.offset) * xDiff + drawRect.minX,
					  y: drawRect.height + drawRect.minY - ($0.element * drawRect.height))
		}

		let path = CGPath.pathWithPoints(points, smoothed: self.interpolated)

		let allP = CGMutablePath()
		if self.markerSize > 0 {
			points.forEach { point in
				let w = self.markerSize / 2
				let r = CGRect(x: point.x - w, y: point.y - w, width: self.markerSize, height: self.markerSize)
				allP.addPath(CGPath(ellipseIn: r, transform: nil))
			}
		}

		context.usingGState { outer in

			if dataSource.counter < dataSource.windowSize {
				let pos = self.bounds.minX + (CGFloat(dataSource.counter) * xDiff)
				let clipRect = self.bounds.divided(atDistance: pos, from: .maxXEdge).slice
				outer.clip(to: clipRect)
			}

			if self.wantsPrimaryFill {
				outer.usingGState { ctx in

					let clipper = path.mutableCopy()!
					clipper.addLine(to: CGPoint(x: drawRect.maxX, y: points.last!.y))
					clipper.addLine(to: CGPoint(x: drawRect.maxX, y: drawRect.maxY))
					clipper.addLine(to: CGPoint(x: drawRect.minX, y: drawRect.maxY))
					clipper.addLine(to: CGPoint(x: drawRect.minX, y: points.first!.y))
					clipper.closeSubpath()

					ctx.addPath(clipper)
					ctx.clip()

					if let gradient = self.primaryGradient {
						ctx.drawLinearGradient(
							gradient, start: CGPoint(x: 0.0, y: drawRect.maxY),
							end: CGPoint(x: 0.0, y: drawRect.minY),
							options: [.drawsAfterEndLocation, .drawsBeforeStartLocation]
						)
					}
					else if let fill = self.primaryFillColor {
						ctx.setFillColor(fill)
						ctx.fill(drawRect)
						ctx.fillPath()
					}
				}
			}

			if let strokeColor = self.primaryStrokeColor {
				outer.usingGState { ctx in
					ctx.addPath(path)
					ctx.setStrokeColor(strokeColor)
					ctx.setLineWidth(self.lineWidth)

					if shadowed {
						ctx.setShadow(offset: CGSize(width: 0.5, height: 0.5),
										  blur: 1.0,
										  color: DSFColor.black.withAlphaComponent(0.3).cgColor)
					}
					ctx.setLineJoin(.round)
					ctx.strokePath()
				}
			}

			/// Draw the markers the same color as the line for the moment
			if !allP.isEmpty {
				if let strokeColor = self.primaryStrokeColor {
					outer.usingGState { ctx in
						ctx.addPath(allP)
						ctx.setFillColor(strokeColor)
						ctx.fillPath()
					}
				}
			}
		}

		return drawRect
	}

	func drawCenteredGraph(context: CGContext, bounds: CGRect, scale: CGFloat) -> CGRect {

		guard let dataSource = self.dataSource,
				dataSource.counter != 0  else {
			// There's no line if there's either no data or just a single point
			// https://github.com/dagronf/DSFSparkline/issues/3#issuecomment-770324047
			return bounds
		}

		// Adjust the inset so that markers can draw unclipped if they are asked for
		let inset = self.markerSize > 0 ? self.markerSize / 2 : self.lineWidth
		let drawRect = self.bounds.insetBy(dx: inset, dy: inset)

		let normy = dataSource.normalized
		let xDiff = drawRect.width / CGFloat(normy.count - 1)
		let points = normy.enumerated().map {
			CGPoint(x: CGFloat($0.offset) * xDiff + drawRect.minX,
					  y: drawRect.height + drawRect.minY - ($0.element * drawRect.height))
		}

		let centroid = (1 - dataSource.normalizedZeroLineValue) * (drawRect.height - 1)

		let pPoints = CGMutablePath()
		let nPoints = CGMutablePath()

		if self.markerSize > 0 {
			points.enumerated().forEach { point in
				let w = self.markerSize / 2
				let r = CGRect(x: point.element.x - w, y: point.element.y - w,
									width: self.markerSize, height: self.markerSize)
				if dataSource.valueAtOffsetIsBelowZeroline(point.offset) {
					nPoints.addPath(CGPath(ellipseIn: r, transform: nil))
				}
				else {
					pPoints.addPath(CGPath(ellipseIn: r, transform: nil))
				}
			}
		}

		let path = CGPath.pathWithPoints(points, smoothed: self.interpolated).mutableCopy()!

		for which in 0 ... 1 {
			if dataSource.counter < dataSource.windowSize {
				let pos = CGFloat(dataSource.counter) * xDiff
				let clipRect = drawRect.divided(atDistance: pos, from: .maxXEdge).slice
				context.clip(to: clipRect)
			}

			context.usingGState { inner in

				let split = drawRect.divided(atDistance: centroid, from: .minYEdge)

				if which == 0 {
					inner.clip(to: split.slice)
				}
				else {
					inner.clip(to: split.remainder)
				}

				let hasFill = (which == 0) ? self.wantsPrimaryFill : self.wantsSecondaryFill

				if hasFill {
					inner.usingGState { ctx in

						let altY = which == 0 ? drawRect.maxY : drawRect.minY

						let clipper = path.mutableCopy()!
						clipper.addLine(to: CGPoint(x: drawRect.maxX, y: points.last!.y))
						clipper.addLine(to: CGPoint(x: drawRect.maxX, y: altY))
						clipper.addLine(to: CGPoint(x: drawRect.minX, y: altY))
						clipper.addLine(to: CGPoint(x: drawRect.minX, y: points.first!.y))
						clipper.closeSubpath()

						ctx.addPath(clipper)
						ctx.clip()

						let gradient = (which == 0) ? self.primaryGradient : self.secondaryGradient
						if let grad = gradient {
							ctx.drawLinearGradient(
								grad, start: CGPoint(x: drawRect.minX, y: drawRect.maxY),
								end: CGPoint(x: drawRect.minX, y: drawRect.minY),
								options: [.drawsAfterEndLocation, .drawsBeforeStartLocation]
							)
						}
						else {
							if let fill = (which == 0) ? self.primaryFillColor : self.secondaryFillColor {
								ctx.setFillColor(fill)
								ctx.fill(drawRect)
							}
						}
					}
				}

				let whichColor = (which == 0) ? self.primaryStrokeColor : self.secondaryStrokeColor

				if let stroke = whichColor {
					inner.usingGState { ctx in
						ctx.addPath(path)
						ctx.setStrokeColor(stroke)
						ctx.setLineWidth(self.lineWidth)

						if shadowed {
							ctx.setShadow(offset: CGSize(width: 0.5, height: 0.5),
											  blur: 1.0,
											  color: DSFColor.black.withAlphaComponent(0.3).cgColor)
						}
						ctx.setLineJoin(.round)
						ctx.strokePath()
					}
				}
			}
		}

		if !pPoints.isEmpty {
			if let stroke = self.primaryStrokeColor {
				context.usingGState { ctx in
					ctx.addPath(pPoints)
					ctx.setFillColor(stroke)
					ctx.fillPath()
				}
			}
		}
		if !nPoints.isEmpty {
			if let stroke = self.secondaryStrokeColor {
				context.usingGState { ctx in
					ctx.addPath(nPoints)
					ctx.setFillColor(stroke)
					ctx.fillPath()
				}
			}
		}

		return drawRect
	}
}
