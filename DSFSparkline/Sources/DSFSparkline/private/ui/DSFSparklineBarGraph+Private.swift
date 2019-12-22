//
//  DSFSparklineBarGraph+Private.swift
//  DSFSparklines
//
//  Created by Darren Ford on 21/12/19.
//  Copyright © 2019 Darren Ford. All rights reserved.
//

#if os(macOS)
import Cocoa
#else
import UIKit
#endif

extension DSFSparklineBarGraph {

	#if os(macOS)
	override public func draw(_ dirtyRect: NSRect) {
		super.draw(dirtyRect)
		if let ctx = NSGraphicsContext.current?.cgContext {
			drawBarGraph(primary: ctx)
		}
	}
	#else
	public override func draw(_ rect: CGRect) {
		super.draw(rect)
		if let ctx = UIGraphicsGetCurrentContext() {
			drawBarGraph(primary: ctx)
		}
	}
	#endif

	private func drawBarGraph(primary: CGContext) {

		let drawRect = self.bounds

		let range: ClosedRange<CGFloat> = 2 ... max(2, drawRect.maxY - 2)

		guard let dataSource = self.dataSource else {
			return
		}

		let normy = dataSource.normalized
		let xDiff = self.bounds.width / CGFloat(normy.count)
		let points = normy.enumerated().map {
			CGPoint(x: CGFloat($0.offset) * xDiff, y: ($0.element * (drawRect.height-1)).clamped(to: range))
		}

		primary.usingGState { (outer) in

			outer.setRenderingIntent(.relativeColorimetric)
			outer.interpolationQuality = .none

			if dataSource.counter < dataSource.windowSize {
				let pos = CGFloat(dataSource.counter) * xDiff + 1
				let clipRect = self.bounds.divided(atDistance: pos, from: .maxXEdge).slice
				outer.clip(to: clipRect)
			}

			let path = CGMutablePath()
			for point in points.enumerated() {
				let r = CGRect(x: CGFloat(point.offset) * xDiff, y: drawRect.height - point.element.y, width: xDiff - barSpacing, height: point.element.y)
				path.addRect(r)
			}
			path.closeSubpath()

			outer.addPath(path)

			outer.setFillColor(self.graphColor.withAlphaComponent(0.3).cgColor)
			outer.setLineWidth(self.lineWidth)
			outer.setStrokeColor(self.graphColor.cgColor)
			outer.setShouldAntialias(false)

			outer.drawPath(using: .fillStroke)
		}
	}


}
