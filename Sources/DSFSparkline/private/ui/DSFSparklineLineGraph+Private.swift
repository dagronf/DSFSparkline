//
//  DSFSparklineLineGraph+Private.swift
//  DSFSparklines
//
//  Created by Darren Ford on 21/12/19.
//  Copyright © 2019 Darren Ford. All rights reserved.
//

#if os(macOS)
import Cocoa
typealias SLFont = NSFont
#else
import UIKit
typealias SLFont = UIFont
#endif


extension DSFSparklineLineGraph {

	#if os(macOS)
	override public func draw(_ dirtyRect: NSRect) {
		super.draw(dirtyRect)
		if let ctx = NSGraphicsContext.current?.cgContext {
			drawGraph(primary: ctx)
		}
	}
	#else
	public override func draw(_ rect: CGRect) {
		super.draw(rect)
		if let ctx = UIGraphicsGetCurrentContext() {
			drawGraph(primary: ctx)
		}
	}
	#endif

	private func drawGraph(primary: CGContext) {

		let drawRect = self.bounds

		let range: ClosedRange<CGFloat> = 2 ... drawRect.maxY - 2

		guard let dataSource = self.dataSource else {
			return
		}

		let normy = dataSource.normalized
		let xDiff = self.bounds.width / CGFloat(normy.count - 1)
		let points = normy.enumerated().map {
			CGPoint(x: CGFloat($0.offset) * xDiff, y: drawRect.height - ($0.element * (drawRect.height-1)).clamped(to: range))
		}

		let path = CGPath.pathWithPoints(points, smoothed: self.interpolated).mutableCopy()!
		path.addLine(to: CGPoint(x: drawRect.width + 4, y: points.last!.y))
		path.addLine(to: CGPoint(x: drawRect.width + 4, y: drawRect.maxY + 2.0))
		path.addLine(to: CGPoint(x: -2.0, y: drawRect.maxY + 2.0))
		path.addLine(to: CGPoint(x: -2.0, y: points.first!.y))
		path.closeSubpath()

		primary.usingGState { (outer) in

			if dataSource.counter < dataSource.windowSize {
				let pos = CGFloat(dataSource.counter) * xDiff
				let clipRect = self.bounds.divided(atDistance: pos, from: .maxXEdge).slice
				outer.clip(to: clipRect)
			}

			if self.lineShading, let gradient = self.gradient {
				outer.usingGState { (ctx) in
					ctx.addPath(path)
					ctx.clip()
					ctx.drawLinearGradient(
						gradient, start: CGPoint(x: 0.0, y: self.bounds.maxY),
						end: CGPoint(x: 0.0, y: self.bounds.minY),
						options: [.drawsAfterEndLocation, .drawsBeforeStartLocation])
				}
			}

			outer.usingGState { (ctx) in
				ctx.addPath(path)
				ctx.setStrokeColor(self.graphColor.cgColor)
				ctx.setLineWidth(self.lineWidth)

				let yoff: CGFloat
				#if os(macOS)
				yoff = -0.5		// macos is flipped
				#else
				yoff = 0.5
				#endif

				if shadowed {
					ctx.setShadow(offset: CGSize(width: 0.5, height: yoff),
									  blur: 1.0,
									  color: SLColor.black.withAlphaComponent(0.3).cgColor)
				}
				ctx.setLineJoin(.round)
				ctx.strokePath()
			}
		}


		let color: SLColor
		#if os(macOS)
		color = SLColor.disabledControlTextColor
		#else
		color = SLColor.systemGray
		#endif

		if showZero {
			let normZero = self.bounds.height - (dataSource.normalize(value: 0.0) * self.bounds.height)
			primary.usingGState { (ctx) in
				ctx.setLineWidth(0.5)
				ctx.setStrokeColor(color.cgColor)
				ctx.setLineDash(phase: 0.0, lengths: [1, 1])
				ctx.strokeLineSegments(between: [CGPoint(x: 0.0, y: normZero), CGPoint(x: drawRect.width, y: normZero) ])
			}
		}

		/// Uncomment to draw the last datapoint value as text
//		if let yval = dataSource.data.last {
//			let yraw = NSMutableString(string: String(format: "%.2f", yval))
//			let a = [NSAttributedString.Key.font: SLFont.systemFont(ofSize: 9),
//						NSAttributedString.Key.foregroundColor: color]
//			yraw.draw(at: CGPoint(x:0, y:0), withAttributes: a)
//		}
	}
}


