//
//  DSFSparklineOverlayLine.swift
//
//
//  Created by Darren Ford on 14/2/21.
//

#if os(macOS)
import Cocoa
#else
import UIKit
#endif

public extension DSFSparklineOverlay {
	@objc(DSFSparklineOverlayBar) class Bar: Centerable {

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

		public override func drawGraph(context: CGContext, bounds: CGRect, hostedIn view: DSFView) -> CGRect {
			if self.centeredAtZeroLine {
				return self.drawCenteredBarGraph(context: context, bounds: bounds, hostedIn: view)
			}
			else {
				return self.drawBarGraph(context: context, bounds: bounds, hostedIn: view)
			}
		}
	}
}

extension DSFSparklineOverlay.Bar {
	private func drawBarGraph(context: CGContext, bounds: CGRect, hostedIn view: DSFView) -> CGRect {
		guard let dataSource = self.dataSource else {
			return bounds
		}

		let integralRect = self.bounds.integral

		// This represents the _full_ width of a bar within the graph, including the spacing.
		let componentWidth = Int(integralRect.width) / Int(dataSource.windowSize)

		// The width of the BAR component
		let barWidth = componentWidth - Int(barSpacing)

		// The left offset in order to center X
		let xOffset: Int = (Int(self.bounds.width) - (componentWidth * Int(dataSource.windowSize))) / 2

		// The available height range
		let range: ClosedRange<CGFloat> = 2 ... max(2, integralRect.maxY - 2)

		let normy = dataSource.normalized
		let xDiff = self.bounds.width / CGFloat(normy.count)
		let points = normy.enumerated().map {
			CGPoint(x: CGFloat($0.offset) * xDiff, y: ($0.element * (integralRect.height - 1)).clamped(to: range))
		}

		context.usingGState { outer in

			outer.setRenderingIntent(.relativeColorimetric)
			outer.interpolationQuality = .none
			outer.setShouldAntialias(false)

			if dataSource.counter < dataSource.windowSize {
				let pos = xOffset + (Int(dataSource.counter) * componentWidth)
				let clipRect = self.bounds.divided(atDistance: CGFloat(pos), from: .maxXEdge).slice
				outer.clip(to: clipRect)
			}

			var bars: [CGRect] = []
			for point in points.enumerated() {
				let yVal = Int(point.element.y.rounded(.down))
				let r = CGRect(x: xOffset + point.offset * componentWidth,
									y: Int(integralRect.height) - yVal,
									width: barWidth,
									height: yVal - Int(self.lineWidth))
				bars.append(r.integral)
			}

			let path = CGMutablePath()
			path.addRects(bars)

			outer.usingGState { fillCtx in
				fillCtx.addPath(path)
				if let gradient = self.primaryGradient {
					fillCtx.clip()
					fillCtx.drawLinearGradient(
						gradient, start: CGPoint(x: 0.0, y: self.bounds.maxY),
						end: CGPoint(x: 0.0, y: self.bounds.minY),
						options: [.drawsAfterEndLocation, .drawsBeforeStartLocation]
					)
				}
				else {
					fillCtx.setFillColor(self.primaryFillColor)
					fillCtx.fillPath()
				}
			}

			outer.usingGState { strokeCtx in
				strokeCtx.addPath(path)
				strokeCtx.setLineWidth(1 / view.retinaScale() * CGFloat(self.lineWidth))
				strokeCtx.setStrokeColor(self.primaryLineColor)
				strokeCtx.drawPath(using: .stroke)
			}
		}
		return bounds
	}

	private func drawCenteredBarGraph(context: CGContext, bounds: CGRect, hostedIn view: DSFView) -> CGRect {

		guard let dataSource = self.dataSource else {
			return bounds
		}

		let drawRect = self.bounds
		let height = drawRect.height - 1

		let normy = dataSource.normalized
		let xDiff = self.bounds.width / CGFloat(normy.count)

		let centre = dataSource.normalizedZeroLineValue
		let centroid = (1 - centre) * (drawRect.height - 1)

		context.usingGState { outer in

			outer.setRenderingIntent(.relativeColorimetric)
			outer.interpolationQuality = .none

			if dataSource.counter < dataSource.windowSize {
				let pos = CGFloat(dataSource.counter) * xDiff + 1
				let clipRect = self.bounds.divided(atDistance: pos, from: .maxXEdge).slice
				outer.clip(to: clipRect)
			}

			var positivePath: [CGRect] = []
			var negativePath: [CGRect] = []

			for value in normy.enumerated() {
				let x = CGFloat(value.offset) * xDiff
				if value.element >= centre {
					let yy = (centre - value.element) * height
					let r = CGRect(x: x,
										y: centroid,
										width: xDiff - 1 - (CGFloat(self.barSpacing)),
										height: yy) // - CGFloat(self.lineWidth))
					positivePath.append(r.integral)
				}
				else {
					let yy = (value.element - centre) * height
					let r = CGRect(x: x,
										y: centroid,
										width: xDiff - 1 - (CGFloat(self.barSpacing)),
										height: -yy - CGFloat(self.lineWidth))
					negativePath.append(r.integral)
				}
			}

			outer.setShouldAntialias(false)

			if !positivePath.isEmpty {
				let path = CGMutablePath()
				path.addRects(positivePath)
				outer.usingGState { fillCtx in
					fillCtx.addPath(path)
					if let gradient = self.primaryGradient {
						fillCtx.clip()
						fillCtx.drawLinearGradient(
							gradient, start: CGPoint(x: 0.0, y: self.bounds.maxY),
							end: CGPoint(x: 0.0, y: self.bounds.minY),
							options: [.drawsAfterEndLocation, .drawsBeforeStartLocation]
						)
					}
					else {
						fillCtx.setFillColor(self.primaryFillColor)
						fillCtx.fillPath()
					}
				}

				outer.usingGState { strokeCtx in
					strokeCtx.addPath(path)
					strokeCtx.setLineWidth(1 / view.retinaScale() * CGFloat(self.lineWidth))
					strokeCtx.setStrokeColor(self.primaryLineColor)
					strokeCtx.strokePath()
				}
			}

			if !negativePath.isEmpty {
				let path = CGMutablePath()
				path.addRects(negativePath)
				outer.usingGState { fillCtx in
					fillCtx.addPath(path)

					if let gradient = self.secondaryGradientReal {
						fillCtx.clip()
						fillCtx.drawLinearGradient(
							gradient, start: CGPoint(x: 0.0, y: self.bounds.maxY),
							end: CGPoint(x: 0.0, y: self.bounds.minY),
							options: [.drawsAfterEndLocation, .drawsBeforeStartLocation]
						)
					}
					else {
						fillCtx.setFillColor(self.secondaryFillColorReal)
						fillCtx.fillPath()
					}
				}

				outer.usingGState { strokeCtx in
					strokeCtx.addPath(path)
					strokeCtx.setLineWidth(1 / view.retinaScale() * CGFloat(self.lineWidth))
					strokeCtx.setStrokeColor(self.secondaryLineColorReal)
					strokeCtx.strokePath()
				}
			}
		}

		return bounds
	}
}
