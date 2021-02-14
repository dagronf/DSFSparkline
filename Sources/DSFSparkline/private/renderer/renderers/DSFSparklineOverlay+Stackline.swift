//
//  DSFSparklineOverlay+Stackline.swift
//
//
//  Created by Darren Ford on 14/2/21.
//

import QuartzCore

public extension DSFSparklineOverlay {
	@objc(DSFSparklineOverlayStackline) class Stackline: Centerable {

		/// The width for the line drawn on the graph
		@objc public var lineWidth: CGFloat = 1.5 {
			didSet {
				self.setNeedsDisplay()
			}
		}
		/// Interpolate a curve between the points
		@objc public var barSpacing: UInt = 1 {
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

		public override func drawGraph(context: CGContext, bounds: CGRect, hostedIn view: DSFView) -> CGRect {
			if self.centeredAtZeroLine {
				return self.drawCenteredStackLineGraph(context: context, bounds: bounds, hostedIn: view)
			}
			else {
				return self.drawStackLineGraph(context: context, bounds: bounds, hostedIn: view)
			}
		}
	}
}

extension DSFSparklineOverlay.Stackline {
	private func drawStackLineGraph(context: CGContext, bounds: CGRect, hostedIn view: DSFView) -> CGRect {
		guard let dataSource = self.dataSource else {
			return bounds
		}

		let integralRect = bounds.integral
		let integralHeight: CGFloat = integralRect.height

		// This represents the _full_ width of a bar within the graph, including the spacing.
		let componentWidth = Int(integralRect.width) / Int(dataSource.windowSize)

		// The left offset in order to center X
		let xOffset: Int = (Int(self.bounds.width) - (componentWidth * Int(dataSource.windowSize))) / 2

		// The available height range
		let range: ClosedRange<CGFloat> = 1 ... max(1, integralRect.maxY)

		// The normalized (0 -> 1) data points
		let normalized = dataSource.normalized

		let points: [CGPoint] = normalized.enumerated().map {
			let xVal = xOffset + ($0.offset * componentWidth)
			let yVal = (integralHeight - ($0.element * integralHeight)).clamped(to: range)
			return CGPoint(x: xVal, y: Int(yVal))
		}

		let ordered = points.enumerated()

		let emptyBuckets = Int(dataSource.emptyValueCount)
		let available = Array(ordered.dropFirst(emptyBuckets))

		if available.count == 0 {
			// Nothing to do!
			return bounds
		}

		context.usingGState { outer in

			outer.setRenderingIntent(.relativeColorimetric)
			outer.interpolationQuality = .none
			outer.setShouldAntialias(false)

			let linePath = CGMutablePath()
			for point in available {
				let currentPoint = point.element

				if linePath.isEmpty {
					// First point
					linePath.move(to: currentPoint)
					linePath.addLine(to: currentPoint.offsettingX(by: CGFloat(componentWidth)))
				}
				else {
					linePath.addLine(to: currentPoint)
					linePath.addLine(to: point.element.offsettingX(by: CGFloat(componentWidth)))
				}
			}

			if linePath.isEmpty {
				return
			}

			outer.usingGState { fillCtx in

				let fillPath = linePath.mutableCopy()!
				let bounds = fillPath.boundingBox

				fillPath.addLine(to: CGPoint(x: bounds.maxX, y: integralRect.maxY))
				fillPath.addLine(to: CGPoint(x: bounds.minX, y: integralRect.maxY))
				fillPath.closeSubpath()

				fillCtx.addPath(fillPath)
				if let gradient = self.primaryGradient {
					fillCtx.clip()
					fillCtx.drawLinearGradient(
						gradient, start: CGPoint(x: bounds.minX, y: integralRect.maxY),
						end: CGPoint(x: bounds.minX, y: integralRect.minY),
						options: [.drawsAfterEndLocation, .drawsBeforeStartLocation]
					)
				}
				else {
					fillCtx.setFillColor(self.primaryFillColor)
					fillCtx.fillPath()
				}
			}

			outer.addPath(linePath)
			outer.setStrokeColor(self.primaryLineColor)
			outer.setLineWidth(self.lineWidth)

			if self.shadowed {
				let yoff: CGFloat
				#if os(macOS)
				yoff = -0.5 // macos is flipped
				#else
				yoff = 0.5
				#endif

				outer.setShadow(offset: CGSize(width: 0.5, height: yoff),
									 blur: 1.0,
									 color: DSFColor.black.withAlphaComponent(0.3).cgColor)
			}

			outer.strokePath()
		}

		return bounds
	}

	private func drawCenteredStackLineGraph(context: CGContext, bounds: CGRect, hostedIn view: DSFView) -> CGRect {
		guard let dataSource = self.dataSource else {
			return bounds
		}

		let integralRect = self.bounds.integral
		let integralHeight: CGFloat = integralRect.height

		// This represents the _full_ width of a bar within the graph, including the spacing.
		let componentWidth = Int(integralRect.width) / Int(dataSource.windowSize)

		// The left offset in order to center X
		let xOffset: Int = (Int(self.bounds.width) - (componentWidth * Int(dataSource.windowSize))) / 2

		// The available height range
		let range: ClosedRange<CGFloat> = 1 ... max(1, integralRect.maxY)

		// The normalized (0 -> 1) data points
		let normalized = dataSource.normalized

		let points: [CGPoint] = normalized.enumerated().map {
			let xVal = xOffset + ($0.offset * componentWidth)
			let yVal = (integralHeight - ($0.element * integralHeight)).clamped(to: range)
			return CGPoint(x: xVal, y: Int(yVal))
		}

		let ordered = points.enumerated()

		let emptyBuckets = Int(dataSource.emptyValueCount)
		let available = Array(ordered.dropFirst(emptyBuckets))

		if available.count == 0 {
			// Nothing to do!
			return bounds
		}

		let centroid = (1 - dataSource.normalizedZeroLineValue) * (integralHeight - 1)

		let first = available.first!
		if first.offset != 0 {
			var clip = self.bounds
			clip.origin.x = first.element.x
			clip.size.width -= first.element.x
			context.clip(to: clip)
		}

		context.usingGState { outer in

			outer.setRenderingIntent(.relativeColorimetric)
			outer.interpolationQuality = .none
			outer.setShouldAntialias(false)

			let linePath = CGMutablePath()
			linePath.move(to: CGPoint(x: integralRect.minX - 1, y: centroid))
			linePath.addLine(to: CGPoint(x: integralRect.minX - 1, y: available.first!.element.y))

			for point in available {
				let currentPoint = point.element
				linePath.addLine(to: currentPoint)
				linePath.addLine(to: point.element.offsettingX(by: CGFloat(componentWidth)))
			}

			linePath.addLine(to: CGPoint(x: integralRect.maxX + 1, y: available.last!.element.y))
			linePath.addLine(to: CGPoint(x: integralRect.maxX + 1, y: centroid))

			if linePath.isEmpty {
				return
			}

			let outerClip = integralRect.insetBy(dx: CGFloat(xOffset), dy: 0)
			outer.clip(to: outerClip)

			outer.usingGState { clipped in

				let split = outerClip.divided(atDistance: centroid, from: .minYEdge)

				for which in 0 ... 1 {
					clipped.usingGState { inner in

						if which == 0 {
							inner.clip(to: split.slice)
						}
						else {
							inner.clip(to: split.remainder)
						}

						inner.usingGState { fillCtx in
							fillCtx.addPath(linePath)
							if let gradient = (which == 0) ? self.primaryGradient : self.secondaryGradientReal {
								fillCtx.clip()
								fillCtx.drawLinearGradient(
									gradient, start: CGPoint(x: bounds.minX, y: integralRect.maxY),
									end: CGPoint(x: bounds.minX, y: integralRect.minY),
									options: [.drawsAfterEndLocation, .drawsBeforeStartLocation]
								)
							}
							else {
								fillCtx.setFillColor((which == 0) ? self.primaryFillColor : self.secondaryFillColorReal)
								fillCtx.fillPath()
							}
						}

						inner.addPath(linePath)
						inner.setStrokeColor((which == 0) ? self.primaryLineColor : self.secondaryLineColorReal)
						inner.setLineWidth(self.lineWidth)

						if self.shadowed {
							inner.setShadow(
								offset: CGSize(width: 0.5, height: 0.5),
								blur: 1.0,
								color: DSFColor.black.withAlphaComponent(0.3).cgColor)
						}

						inner.strokePath()
					}
				}
			}
		}
		return bounds
	}

}
