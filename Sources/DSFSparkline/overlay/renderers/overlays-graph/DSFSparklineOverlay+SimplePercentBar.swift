//
//  DSFSparklineOverlay+SimplePercentBar.swift
//  DSFSparklines
//
//  Created by Darren Ford on 16/3/21.
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
import SwiftUI

public extension DSFSparkline {
	class PercentBar {
		@objc(DSFSparklinePercentBarStyle) public class Style: NSObject {
			/// The graph background color
			@objc public var backgroundColor: CGColor = CGColor.DefaultClear
			/// The color of text when drawn on the background
			@objc public var backgroundTextColor: CGColor = CGColor.DefaultBlack

			/// The color of the value bar
			@objc public var barColor: CGColor = CGColor.DefaultBlack
			/// The color of text when drawn on top of the bar
			@objc public var barTextColor: CGColor = CGColor.DefaultWhite

			/// The formatter to use
			@objc public var numberFormatter: NumberFormatter = Style.defaultFormatter

			@objc public var font: DSFFont = DSFFont.systemFont(ofSize: 12.0)
			@objc public var fontSize: CGFloat {
				return font.pointSize
			}

			/// Should the pie chart animate in?
			@objc public var animated: Bool = false
			/// The length of the animate-in duration
			@objc public var animationDuration: Double = 0.25

			@objc public func label(for value: CGFloat) -> String {
				return self.numberFormatter.string(from: NSNumber(value: Double(value))) ?? ""
			}

			static let defaultFormatter: NumberFormatter = {
				let f = NumberFormatter()
				f.numberStyle = .percent
				f.minimumFractionDigits = 0
				f.maximumFractionDigits = 0
				return f
			}()
		}
	}
}

public extension DSFSparklineOverlay {

	@objc(DSFSparklineOverlaySimplePercentBar) class SimplePercentBar: DSFSparklineOverlay {



		let textLayer = LCTextLayer()
		let fractionLayer = CAShapeLayer()

		// MARK: - Value

		@objc public var fractional: CGFloat = 0.66 {
			didSet {
				self.updateLabel()
				self.dataDidChange()
			}
		}

		// MARK: - Style

		@objc public var displayStyle = DSFSparkline.PercentBar.Style() {
			didSet {
				self.syncStyle()
				self.dataDidChange()
			}
		}

		public init(style: DSFSparkline.PercentBar.Style = DSFSparkline.PercentBar.Style(), value: CGFloat = 0) {
			super.init()

			self.addSublayer(self.fractionLayer)
			self.addSublayer(self.textLayer)

			self.fractionLayer.zPosition = -3
			self.fractionLayer.cornerRadius = 3

			self.textLayer.contentsScale = 2

			self.displayStyle = style

			self.syncStyle()

			self.fractional = value
			self.updateLabel()

			DispatchQueue.main.async {
				self.dataDidChange()
			}
		}

		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}

		override public func drawGraph(context: CGContext, bounds: CGRect, scale: CGFloat) -> CGRect {
			self.drawSimplePercentBarGraph(context: context, bounds: bounds, scale: scale)
		}

		private func updateLabel() {
			let label = self.displayStyle.label(for: self.fractional)
			self.textLayer.string = label
		}

		func dataDidChange() {
			if self.displayStyle.animated {
				self.startAnimateIn()
			}
			else {
				self.fractionComplete = 1.0
				self.setNeedsDisplay()
			}
		}

		internal var animator = ArbitraryAnimator()
		internal var fractionComplete: CGFloat = 0
	}
}

public extension DSFSparklineOverlay.SimplePercentBar {

	func startAnimateIn() {
		// Stop any animation that is currently active
		self.animator.stop()

		self.fractionComplete = 0

		self.animator.animationFunction = ArbitraryAnimator.Function.EaseInEaseOut()
		self.animator.duration = self.displayStyle.animationDuration
		self.animator.progressBlock = { progress in
			self.fractionComplete = CGFloat(progress)
			self.setNeedsDisplay()
		}

		self.animator.start()
	}

	func syncStyle() {

		self.backgroundColor = self.displayStyle.backgroundColor

		self.fractionLayer.backgroundColor = self.displayStyle.barColor

		self.textLayer.font = CTFontCreateWithFontDescriptor(self.displayStyle.font.fontDescriptor, 0, nil)
		self.textLayer.fontSize = self.displayStyle.fontSize

		self.setNeedsDisplay()
	}

	func drawSimplePercentBarGraph(context: CGContext, bounds: CGRect, scale: CGFloat) -> CGRect {

		self.cornerRadius = 4

		CATransaction.begin()
		CATransaction.setDisableActions(true)

		let fraction = (self.fractional).clamped(to: 0 ... 1)
		let complete = self.fractionComplete * fraction
		let nb = bounds.insetBy(dx: 2, dy: 2)
		let divide = nb.divided(atDistance: complete * bounds.width,
											 from: .minXEdge)

		let setRect = divide.slice
		self.fractionLayer.frame = setRect

		if complete > 0.15 {
			self.textLayer.frame = setRect.insetBy(dx: 4, dy: 0)
			self.textLayer.alignmentMode = .right
			self.textLayer.foregroundColor = self.displayStyle.barTextColor
		}
		else {
			self.textLayer.frame = divide.remainder.insetBy(dx: 4, dy: 0)
			self.textLayer.alignmentMode = .left
			self.textLayer.foregroundColor = self.displayStyle.backgroundTextColor
		}
		CATransaction.commit()

		return bounds
	}
}

