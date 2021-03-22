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
	enum PercentBar {

		/// Percent Bar style class
		@objc(DSFSparklinePercentBarStyle) public class Style: NSObject {

			// MARK: Public

			/// The corner radius for the bar/underbar
			@objc public var cornerRadius: CGFloat = 4

			/// The graph background color
			@objc public var underBarColor = CGColor.DefaultWhite
			/// The color of text when drawn on the background
			@objc public var underBarTextColor = CGColor.DefaultBlack

			/// The color of the value bar
			@objc public var barColor = CGColor.DefaultBlack
			/// The color of text when drawn on top of the bar
			@objc public var barTextColor = CGColor.DefaultWhite

			/// The formatter to use
			@objc public var numberFormatter = Style.DefaultFormatter

			/// The font to use
			@objc public var font = DSFFont.systemFont(ofSize: 12.0)

			/// How much to inset the value bar from the bounds of the control
			@objc public var barEdgeInsets = DSFEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

			/// Should we display a text percentage value on the bar?
			@objc public var showLabel: Bool = true

			/// Should the pie chart animate in?
			@objc public var animated: Bool = false
			/// The length of the animate-in duration
			@objc public var animationDuration: Double = 0.25

			@objc public func label(for value: CGFloat) -> String {
				return self.numberFormatter.string(from: NSNumber(value: Double(value))) ?? ""
			}

			// MARK: Private

			fileprivate static let DefaultFormatter: NumberFormatter = {
				let f = NumberFormatter()
				f.numberStyle = .percent
				f.minimumFractionDigits = 0
				f.maximumFractionDigits = 0
				return f
			}()

			// Convenience
			fileprivate var fontSize: CGFloat { return self.font.pointSize }
		}
	}
}

public extension DSFSparklineOverlay {
	/// A percent bar sparkline
	@objc(DSFSparklineOverlayPercentBar) class PercentBar: DSFSparklineOverlay {

		/// The value assigned to the percent bar.
		@objc public var value: CGFloat = 0.0 {
			didSet {
				self.valueChanged()
			}
		}

		/// The style to apply to the percent bar
		@objc public var displayStyle = DSFSparkline.PercentBar.Style() {
			didSet {
				self.syncStyle()
				self.dataDidChange()
			}
		}

		/// Creator
		public init(style: DSFSparkline.PercentBar.Style = DSFSparkline.PercentBar.Style(), value: CGFloat) {
			super.init()

			self.addSublayer(self.fractionLayer)
			self.addSublayer(self.textLayer)

			self.cornerRadius = style.cornerRadius

			self.fractionLayer.zPosition = -3
			self.fractionLayer.cornerRadius = self.displayStyle.cornerRadius

			self.textLayer.contentsScale = 2

			self.displayStyle = style

			self.syncStyle()

			self.value = value
			self.valueChanged()

			self.setNeedsLayout()
		}

		@available(*, unavailable)
		required init?(coder _: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}

		override public func drawGraph(context: CGContext, bounds: CGRect, scale: CGFloat) -> CGRect {
			// Do nothing.  All the content is handled by layers
			return bounds
		}

		// MARK: Layers
		private let textLayer = LCTextLayer()        // Text layer
		private let fractionLayer = CAShapeLayer()   // Bar layer

		// MARK: Value helpers
		private var previousValue: CGFloat = 0.0     // The previously assigned fractional value (for animation)
		private var fractionValue: CGFloat = 0.0     // A guaranteed 0 ... 1 fractional value for the control

		// MARK: Animation
		private var animator = ArbitraryAnimator()   //
		private var fractionComplete: CGFloat = 0
	}
}

extension DSFSparklineOverlay.PercentBar {

	public override func layoutSublayers() {
		super.layoutSublayers()
		self.layoutGraph()
	}

	private func layoutGraph() {
		CATransaction.withDisabledActions {

			let diff = self.fractionValue - self.previousValue
			let fDiff = diff * self.fractionComplete

			let complete = fDiff + self.previousValue

			let nb = bounds.inset(by: self.displayStyle.barEdgeInsets)
			let divide = nb.divided(atDistance: complete * bounds.width,
											from: .minXEdge)

			let setRect = divide.slice

			self.fractionLayer.frame = setRect

			if self.displayStyle.showLabel {
				let textSz = self.textLayer.textBounds(
					for: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).width
				let leftRect = setRect.insetBy(dx: 3, dy: 0)

				if textSz > leftRect.width {
					self.textLayer.frame = divide.remainder.insetBy(dx: 3, dy: 0)
					self.textLayer.alignmentMode = .left
					self.textLayer.foregroundColor = self.displayStyle.underBarTextColor
				}
				else {
					self.textLayer.frame = leftRect
					self.textLayer.alignmentMode = .right
					self.textLayer.foregroundColor = self.displayStyle.barTextColor
				}
			}
		}
	}
}

private extension DSFSparklineOverlay.PercentBar {

	func updateLabel() {
		let label = self.displayStyle.label(for: self.fractionValue)
		CATransaction.withDisabledActions {
			self.textLayer.string = label
		}
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

	func valueChanged() {
		self.previousValue = self.fractionValue
		self.fractionValue = self.value.clamped(to: 0 ... 1)
		self.updateLabel()
		self.dataDidChange()
	}

	func startAnimateIn() {
		// Stop any animation that is currently active
		self.animator.stop()
		self.fractionComplete = 0

		self.animator.animationFunction = ArbitraryAnimator.Function.EaseInEaseOut()
		self.animator.duration = self.displayStyle.animationDuration
		self.animator.progressBlock = { progress in
			self.fractionComplete = CGFloat(progress)
			self.setNeedsLayout()
		}
		self.animator.start()
	}

	func syncStyle() {
		CATransaction.withDisabledActions {
			self.cornerRadius = self.displayStyle.cornerRadius
			self.backgroundColor = self.displayStyle.underBarColor

			self.fractionLayer.backgroundColor = self.displayStyle.barColor
			self.fractionLayer.cornerRadius = self.displayStyle.cornerRadius

			self.textLayer.isHidden = !self.displayStyle.showLabel
			self.textLayer.font = CTFontCreateWithFontDescriptor(self.displayStyle.font.fontDescriptor, 0, nil)
			self.textLayer.fontSize = self.displayStyle.fontSize
		}
	}
}
