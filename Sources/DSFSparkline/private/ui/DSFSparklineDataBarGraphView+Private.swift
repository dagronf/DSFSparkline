//
//  DSFSparklineDataBarGraphView+Private.swift
//  DSFSparklines
//
//  Created by Darren Ford on 12/2/21.
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

public extension DSFSparklineDataBarGraphView {

	func dataDidChange() {
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
			self.drawDataBarGraph(primary: ctx)
		}
	}
	#else
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		if let ctx = UIGraphicsGetCurrentContext() {
			self.drawDataBarGraph(primary: ctx)
		}
	}
	#endif

	func drawDataBarGraph(primary: CGContext) {

		if fractionComplete == 0 {
			return
		}

		let total = self.maximumTotalValue > 0 ? self.maximumTotalValue : self.total

		let rect = self.bounds.integral
		var position: CGFloat = rect.minX
		let delta: CGFloat = (rect.width / total) * self.fractionComplete

		primary.clip(to: rect)

		if let unsetColor = self.unsetColor?.cgColor {
			primary.usingGState { state in
				state.addRect(rect)
				state.setFillColor(unsetColor)
				state.fillPath()
			}
		}

		for segment in self.dataSource.enumerated() {

			primary.usingGState { state in

				state.setFillColor(self.palette.cgColorAtOffset(segment.offset))

				let width = segment.element * delta

				let path = CGPath(rect: CGRect(x: position, y: rect.minY, width: width, height: rect.height), transform: nil)
				state.addPath(path)
				state.fillPath()

				if segment.offset > 0,
					let strokeColor = self.strokeColor {
					state.usingGState { separator in
						separator.setStrokeColor(strokeColor.cgColor)
						separator.setLineWidth(self.lineWidth)
						separator.move(to: CGPoint(x: position, y: rect.minY))
						separator.addLine(to: CGPoint(x: position, y: rect.maxY))

						separator.strokePath()
					}
				}

				position = position + width
			}
		}
	}
}

extension DSFSparklineDataBarGraphView {
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

extension DSFSparklineDataBarGraphView {
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
