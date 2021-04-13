//
//  DSFSparklineOverlay+DataBar.swift
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

import QuartzCore

public extension DSFSparklineOverlay {

	@objc(DSFSparklineOverlayDataBar) class DataBar: DSFSparklineOverlay.StaticDataSource {

		/// The maximum _total_ value. If the datasource values total is greater than this value, it clips the display
		@objc public var maximumTotalValue: CGFloat = -1 {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The 'undrawn' color for the graph.
		///
		/// If a maximum total value is defined, and the datasource doesn't completely fill the total, then
		/// the empty section of the databar is drawn using this color.
		@objc public var unsetColor: CGColor? {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The stroke color for the line(s) to be drawn between each segment of the databar.
		@objc public var strokeColor: CGColor? {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The width of the stroke line to be drawn between each segment of the databar.  if 0, no stroke is drawn
		@objc public var lineWidth: CGFloat = 0.5 {
			didSet {
				self.setNeedsDisplay()
			}
		}

		/// The palette to use when drawing the databar
		@objc public var palette = DSFSparkline.Palette.shared {
			didSet {
				self.setNeedsDisplay()
			}
		}

		// MARK: Animation support

		/// Should the pie chart animate in?
		@objc public var animated: Bool = false

		/// The length of the animate-in duration
		@objc public var animationDuration: CGFloat = 0.25

		// MARK: Data change

		override func staticDataSourceDidChange() {
			super.staticDataSourceDidChange()

			if self.animated {
				self.startAnimateIn()
			}
			else {
				self.fractionComplete = 1.0
				self.setNeedsDisplay()
			}
		}

		internal override func drawGraph(context: CGContext, bounds: CGRect, scale: CGFloat) {
			self.drawDataBarGraph(context: context, bounds: bounds, scale: scale)
		}

		// MARK: - Privates

		internal var animator = ArbitraryAnimator()
		internal var fractionComplete: CGFloat = 0
	}
}

private extension DSFSparklineOverlay.DataBar {

	func startAnimateIn() {

		// Stop any animation that is currently active
		self.animator.stop()

		self.fractionComplete = 0

		self.animator.animationFunction = ArbitraryAnimator.Function.EaseInEaseOut()
		self.animator.progressBlock = { progress in
			self.fractionComplete = CGFloat(progress)
			self.setNeedsDisplay()
		}

		self.animator.start()
	}

}

private extension DSFSparklineOverlay.DataBar {
	func drawDataBarGraph(context: CGContext, bounds: CGRect, scale: CGFloat) {
		if fractionComplete == 0 { return }

		let total = self.maximumTotalValue > 0 ? self.maximumTotalValue : self.dataSource.total

		let rect = bounds.integral
		var position: CGFloat = rect.minX
		let delta: CGFloat = (rect.width / total) * self.fractionComplete

		context.clip(to: rect)

		if self.maximumTotalValue > 0, let unsetColor = self.unsetColor {
			let cbheight = max(2, rect.height / 6)
			let center = rect.midY
			let centerBar = CGRect(x: rect.minX, y: center - (cbheight / 2), width: rect.width, height: cbheight)
			let pth = CGPath(roundedRect: centerBar,
								  cornerWidth: cbheight / 2, cornerHeight: cbheight / 2, transform: nil)

			context.usingGState { state in
				state.addPath(pth)
				state.setFillColor(unsetColor)
				state.fillPath()
			}
		}

		for segment in self.dataSource.values.enumerated() {
			context.usingGState { state in

				state.setFillColor(self.palette.cgColorAtOffset(segment.offset))

				let width = segment.element * delta

				let path = CGPath(rect: CGRect(x: position, y: rect.minY, width: width, height: rect.height), transform: nil)
				state.addPath(path)
				state.fillPath()

				if segment.offset > 0, let strokeColor = self.strokeColor {
					state.usingGState { separator in
						separator.setStrokeColor(strokeColor)
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
