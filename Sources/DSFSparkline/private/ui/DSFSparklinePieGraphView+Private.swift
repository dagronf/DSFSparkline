//
//  DSFSparklineTabletGraphView+Private.swift
//  DSFSparklines
//
//  Created by Darren Ford on 16/1/20.
//  Copyright © 2019 Darren Ford. All rights reserved.
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

public extension DSFSparklinePieGraphView {

	internal func dataDidChange() {
		// Precalculate the total.
		self.total = self.dataSource.reduce(0) { $0 + $1 }

		if self.animated {
			self.startAnimateIn()
		}
		else {
			self.fractionComplete = 1.0
			self.updateDisplay()
		}
	}

	#if os(macOS)
	override func draw(_ dirtyRect: NSRect) {
		super.draw(dirtyRect)
		if let ctx = NSGraphicsContext.current?.cgContext {
			self.drawPieGraph(primary: ctx)
		}
	}
	#else
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		if let ctx = UIGraphicsGetCurrentContext() {
			self.drawPieGraph(primary: ctx)
		}
	}
	#endif

	func drawPieGraph(primary: CGContext) {

		if fractionComplete == 0 {
			return
		}

		let rect = self.bounds.insetBy(dx: 1, dy: 1)

		// radius is the half the frame's width or height (whichever is smallest)
		let radius = min(rect.width, rect.height) * 0.5

		// center of the view
		let viewCenter = CGPoint(x: rect.midX, y: rect.midY)

		// the starting angle is -90 degrees (top of the circle, as the context is flipped). By default, 0 is the right hand side of the circle, with the positive angle being in an anti-clockwise direction (same as a unit circle in maths).
		var startAngle = -CGFloat.pi * 0.5

		for segment in self.dataSource.enumerated() { // loop through the values array

			primary.usingGState { state in

				// set fill color to the segment color
				state.setFillColor(self.palette.cgColorAtOffset(segment.offset))

				// update the end angle of the segment
				//let endAngle = startAngle + 2 * .pi * (segment.element / total)
				let fraEndAngle = startAngle + (2 * .pi * (segment.element / total)) * fractionComplete

				// move to the center of the pie chart
				state.move(to: viewCenter)

				// add arc from the center for each segment (anticlockwise is specified for the arc, but as the view flips the context, it will produce a clockwise arc)
				state.addArc(center: viewCenter, radius: radius, startAngle: startAngle, endAngle: fraEndAngle, clockwise: false)

				state.drawPath(using: .fill)

				// update starting angle of the next segment to the ending angle of this segment
				startAngle = fraEndAngle // endAngle
			}
		}

		// We draw the strokes AFTER we draw ALL the segment fills to avoid unpleasant rendering

		if let stroke = self.strokeColor?.cgColor {

			var startAngle = -CGFloat.pi * 0.5

			primary.setStrokeColor(stroke)
			primary.setLineWidth(self.lineWidth)

			for segment in self.dataSource.enumerated() { // loop through the values array

				primary.usingGState { state in

					// update the end angle of the segment
					// let endAngle = startAngle + (2 * .pi * (segment.element / total))
					let fraEndAngle = startAngle + (2 * .pi * (segment.element / total)) * fractionComplete

					// move to the center of the pie chart
					state.move(to: viewCenter)

					// add arc from the center for each segment (anticlockwise is specified for the arc, but as the view flips the context, it will produce a clockwise arc)
					state.addArc(center: viewCenter, radius: radius, startAngle: startAngle, endAngle: fraEndAngle, clockwise: false)

					state.drawPath(using: .stroke)

					// update starting angle of the next segment to the ending angle of this segment
					startAngle = fraEndAngle // endAngle
				}
			}
		}

	}
}

extension DSFSparklinePieGraphView {
	public override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()

		#if TARGET_INTERFACE_BUILDER
		self.animated = false
		self.dataSource = [
			CGFloat(UInt.random(in: 1 ... 9)),
			CGFloat(UInt.random(in: 1 ... 9)),
			CGFloat(UInt.random(in: 1 ... 9)),
			CGFloat(UInt.random(in: 1 ... 9)),
		]
		#endif
	}
}

extension DSFSparklinePieGraphView {
	func startAnimateIn() {

		self.fractionComplete = 0

		if let a = self.animationLayer {
			// Stop any existing animations
			a.removeAllAnimations()
			a.removeFromSuperlayer()
		}

		let alayer = ArbitraryAnimationLayer()
		self.animationLayer = alayer
		self.rootLayer.addSublayer(alayer)

		alayer.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
		let anim = CABasicAnimation()
		anim.fromValue = 0.0
		anim.toValue = 1.0
		anim.duration = CFTimeInterval(animationDuration)
		anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
		anim.isRemovedOnCompletion = true

		alayer.progressCallback = { [weak self] progress in
			self?.fractionComplete = progress
			self?.updateDisplay()
		}
		alayer.add(anim, forKey: "progress")
	}
}
