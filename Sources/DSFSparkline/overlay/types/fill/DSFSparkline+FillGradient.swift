//
//  DSFSparkline+FillGradient.swift
//  DSFSparklines
//
//  Copyright © 2022 Darren Ford. All rights reserved.
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

import CoreGraphics
import Foundation

// MARK: - Gradient fill

public extension DSFSparkline.Fill {

	/// The gradient fill (vertical only at the moment)
	@objc(DSFSparklineFillGradient) class `Gradient`: NSObject, DSFSparklineFillable {

		/// The gradient to use when filling
		@objc public var gradient: CGGradient

		/// Is the gradient horizontal or vertical
		@objc public var isHorizontal: Bool

		/// A workaround for retrieving a color at a fractional location within a CGGradient
		private lazy var peek: GradientPeek = {
			GradientPeek(gradient: self.gradient)
		}()

		/// Create a fill gradient
		@objc public init(gradient: CGGradient, isHorizontal: Bool = false) {
			self.gradient = gradient
			self.isHorizontal = isHorizontal
		}

		/// Create a fill gradient
		public init(colors: [CGColor], isHorizontal: Bool = false) {
			assert(colors.count >= 2)

			self.isHorizontal = isHorizontal

			let count = colors.count
			let divisor = 1.0 / (CGFloat(count) - 1)
			let locations = (0 ..< count - 1).map { Double($0) * divisor }.appending(1)

			let gradient = CGGradient(
				colorsSpace: nil,
				colors: colors as CFArray,
				locations: locations)

			self.gradient = gradient!
		}

		/// Make a copy of a gradient
		@objc public func copyFill() -> DSFSparklineFillable {
			Gradient(gradient: self.gradient, isHorizontal: isHorizontal)
		}

		@objc public func fill(context: CGContext, bounds: CGRect) {
			if isHorizontal {
				context.drawLinearGradient(
					gradient,
					start: CGPoint(x: bounds.minX, y: bounds.maxY),
					end: CGPoint(x: bounds.maxX, y: bounds.maxY),
					options: [.drawsAfterEndLocation, .drawsBeforeStartLocation]
				)
			}
			else {
				context.drawLinearGradient(
					gradient,
					start: CGPoint(x: 0.0, y: bounds.maxY),
					end: CGPoint(x: 0.0, y: bounds.minY),
					options: [.drawsAfterEndLocation, .drawsBeforeStartLocation]
				)
			}
		}

		/// Return the color at a fractional (0 -> 1) position within the gradient
		@objc public func color(at fractionalValue: CGFloat) -> CGColor {
			self.peek.color(at: fractionalValue)
		}
	}
}

private extension DSFSparkline.Fill.Gradient {
	class GradientPeek {
		static let divisor: CGFloat = 1.0 / 255.0
		let snapshotSize = 4096
		let gradient: CGGradient

		private let colorSpace = CGColorSpace(name: CGColorSpace.sRGB)!
		private lazy var bitmap: [UInt8] = {
			[UInt8](repeating: 0, count: (self.snapshotSize + 1) * 4)
		}()

		init(gradient: CGGradient) {
			self.gradient = gradient
			self.build()
		}

		func color(at fraction: CGFloat) -> CGColor {
			let fraction = fraction.clamped(to: 0 ... 1)
			let pixel = Int((CGFloat(self.snapshotSize) * fraction).rounded(.towardZero))
			let offset = pixel * 4

			let r = bitmap[offset + 0]
			let g = bitmap[offset + 1]
			let b = bitmap[offset + 2]
			let a = bitmap[offset + 3]

			return CGColor(
				colorSpace: self.colorSpace,
				components: [
					CGFloat(r) * Self.divisor,
					CGFloat(g) * Self.divisor,
					CGFloat(b) * Self.divisor,
					CGFloat(a) * Self.divisor
				]
			)!
		}

		private func build() {
			let sz = self.snapshotSize + 1
			let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
			guard
				let ctx = CGContext(
					data: &bitmap,
					width: sz,
					height: 1,
					bitsPerComponent: 8,
					bytesPerRow: sz * 4,
					space: self.colorSpace,
					bitmapInfo: bitmapInfo.rawValue
				)
			else {
				fatalError()
			}

			ctx.drawLinearGradient(
				gradient,
				start: .init(x: 0, y: 0),
				end: .init(x: sz, y: 0),
				options: []
			)
		}
	}
}
