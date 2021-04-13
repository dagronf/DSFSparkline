//
//  Utilities.swift
//  DSFSparklines
//
//  Created by Darren Ford on 20/12/19.
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

import Foundation
import CoreGraphics.CGContext

#if os(macOS)
import Cocoa
public typealias DSFColor = NSColor
public typealias DSFView = NSView
public typealias DSFFont = NSFont
public typealias DSFEdgeInsets = NSEdgeInsets
#else
import UIKit
public typealias DSFColor = UIColor
public typealias DSFView = UIView
public typealias DSFFont = UIFont
public typealias DSFEdgeInsets = UIEdgeInsets
#endif

#if canImport(SwiftUI)
import SwiftUI
#if os(macOS)
@available(macOS 10.15, *)
typealias DSFViewRepresentable = NSViewRepresentable
#else
@available(iOS 13.0, tvOS 13.0, *)
typealias DSFViewRepresentable = UIViewRepresentable
#endif
#endif

extension ExpressibleByIntegerLiteral where Self: Comparable {
	/// Clamp a value to a closed range
	/// - Parameter range: the range to clamp to
	@inlinable func clamped(to range: ClosedRange<Self>) -> Self {
		return min(max(self, range.lowerBound), range.upperBound)
	}
}

public extension CGGradient {
	static func Create(_ definition: [(position: CGFloat, color: CGColor)],
							 colorSpace: CGColorSpace? = nil) -> CGGradient {
		return CGGradient(
			colorsSpace: colorSpace,
			colors: definition.map { $0.1 } as CFArray, // [c1, c2] as CFArray,
			locations: definition.map { $0.0 } //[1.0, 0.0]
		)!
	}
}


extension CGContext {
	/// Execute the supplied block within a `saveGState() / restoreGState()` pair, providing a context
	/// to draw in during the execution of the block
	///
	/// - Parameter stateBlock: The block to execute within the new graphics state
	/// - Parameter context: The context to draw into within the block
	///
	/// Example usage:
	/// ```
	///    context.usingGState { (ctx) in
	///       ctx.addPath(unsetBackground)
	///       ctx.setFillColor(bgc1.cgColor)
	///       ctx.fillPath(using: .evenOdd)
	///    }
	/// ```
	@inlinable func usingGState(stateBlock: (_ context: CGContext) throws -> Void) rethrows {
		self.saveGState()
		defer {
			self.restoreGState()
		}
		try stateBlock(self)
	}
}

extension DSFView {
	#if os(macOS)
	@objc func retinaScale() -> CGFloat {
		return self.window?.screen?.backingScaleFactor ?? 1.0
	}
	#else
	@objc func retinaScale() -> CGFloat {
		return self.window?.screen.scale ?? 1.0
	}
	#endif
}

extension CGPoint {
	@inlinable func offsettingX(by value: CGFloat) -> CGPoint {
		return CGPoint(x: self.x + value, y: self.y)
	}
	@inlinable func offsettingY(by value: CGFloat) -> CGPoint {
		return CGPoint(x: self.x, y: self.y + value)
	}
}

/// Return the slope of the line joining points a and b
@inlinable func gradient(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
	return (b.y - a.y) / (b.x - a.x)
}

// MARK: - NSView/UIView snapshot

#if os(macOS)
public extension NSView {
	@objc func snapshot() -> NSImage? {
		guard let bitmapRep = self.bitmapImageRepForCachingDisplay(in: self.bounds) else { return nil }
		self.cacheDisplay(in: self.bounds, to: bitmapRep)
		let image = NSImage()
		image.addRepresentation(bitmapRep)
		return image
	}
}
#else
public extension UIView {
	@objc func snapshot() -> UIImage {
		if #available(iOS 10.0, tvOS 10.0, *) {
			let renderer = UIGraphicsImageRenderer(bounds: bounds)
			return renderer.image { rendererContext in
				layer.render(in: rendererContext.cgContext)
			}
		} else {
			UIGraphicsBeginImageContext(self.frame.size)
			self.layer.render(in:UIGraphicsGetCurrentContext()!)
			let image = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			return UIImage(cgImage: image!.cgImage!)
		}
	}
}
#endif

// MARK: -

@discardableResult
@inlinable internal func UpdateIfNotEqual<T>(result: inout T, val: T) -> Bool where T: Equatable {
	if result != val {
		result = val
		return true
	}
	return false
}

// MARK: - Debugging utils

// Simple method to draw a rectangle in a context (usually for testing)
func DrawRect(primary: CGContext, rect: CGRect, color: CGColor = DSFColor.systemRed.cgColor) {
	primary.usingGState { (outer) in
		outer.addRect(rect)
		outer.setLineWidth(0.5)
		outer.setStrokeColor(color)
		outer.strokePath()
	}
}

#if !os(macOS)
extension CGColor {
	static var black: CGColor {
		return CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0, 0, 0, 1])!
	}
	static var clear: CGColor {
		return CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0, 0, 0, 0])!
	}
}
#endif

extension String {
	func extractCGFloats() -> [CGFloat] {
		let components = self.split(separator: ",")
		let floats: [CGFloat] = components
			.map { String($0) } // Convert to string array
			.compactMap { Float($0) } // Convert to float array if possible
			.compactMap { CGFloat($0) } // Convert to CGFloat array
		return floats
	}
}

// Returns the first item in the specified array which is non-nil. If all elements are nil, returns nil
@inlinable internal func firstNotNil<T>(_ items: [T?]) -> T? {
	if let first = items.first(where: { $0 != nil }) {
		return first
	}
	return nil
}

// A CATextLayer that vertically centers its content
class LCTextLayer : CATextLayer {

	// REF: http://lists.apple.com/archives/quartz-dev/2008/Aug/msg00016.html
	// CREDIT: David Hoerl - https://github.com/dhoerl
	// USAGE: To fix the vertical alignment issue that currently exists within the CATextLayer class. Change made to the yDiff calculation.

	override func draw(in context: CGContext) {
		let height = self.bounds.size.height
		let fontSize = self.fontSize
		let yDiff = (height-fontSize)/2 - fontSize/10

		context.saveGState()
		context.translateBy(x: 0, y: yDiff) // Use -yDiff when in non-flipped coordinates (like macOS's default)
		super.draw(in: context)
		context.restoreGState()
	}
}


extension CGColor {
	/// Returns a black or white contrasting color for this color
	/// - Parameter defaultColor: If the color cannot be converted to the genericRGB colorspace, or the input color is .clear, the fallback color
	/// - Returns: black or white depending on which provides the greatest contrast to this color
	func flatContrastColor(defaultColor: CGColor = CGColor.DefaultBlack) -> CGColor {
		guard self != CGColor.clear,
			let rgbColor = self.converted(to: CGColorSpace(name: CGColorSpace.sRGB)!,
													intent: .perceptual,
													options: nil) else {
			return defaultColor
		}

		let r = 0.299 * rgbColor.components![0]
		let g = 0.587 * rgbColor.components![1]
		let b = 0.114 * rgbColor.components![2]
		let avgGray: CGFloat = 1 - (r + g + b)
		return (avgGray >= 0.45) ? CGColor.DefaultWhite : CGColor.DefaultBlack
	}
}

extension CGColor {

	static let DefaultWhite = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1, 1, 1, 1])!
	static let DefaultBlack = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0, 0, 0, 1])!
	static let DefaultClear = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1, 1, 1, 0])!
}

// MARK: - CATextLayer extensions

extension CATextLayer {
	func font() -> DSFFont? {
		if let f = self.font as? DSFFont {
			return f //return DSFFont(name: f.fontName, size: self.fontSize)
		}
		else if let s = self.font as? String {
			return DSFFont(name: s, size: self.fontSize)
		}
		else {
			return nil
		}
	}

	func attributedString() -> NSAttributedString {
		if let asv = self.string as? NSAttributedString {
			return asv
		}
		else if let s = self.string as? String {
			let attrs = [NSAttributedString.Key.font: self.font() as Any]
			return NSAttributedString(string: s, attributes: attrs)
		}
		else {
			fatalError()
		}
	}

	/// Get the required bounds for the text layer content given `size` constraints
	func textBounds(for size: CGSize) -> CGSize {

		#if os(macOS)
		let options: NSString.DrawingOptions = [NSString.DrawingOptions.usesFontLeading, NSString.DrawingOptions.usesLineFragmentOrigin]
		#else
		let options: NSStringDrawingOptions = [NSStringDrawingOptions.usesFontLeading, NSStringDrawingOptions.usesLineFragmentOrigin]
		#endif

		let ttt = self.attributedString()
		let br = ttt.boundingRect(
			with: CGSize(width: size.width, height: size.height),
			options: options,
			context: nil)
		return br.size
	}
}

extension CATransaction {
	/// Perform 'body' without implicit animations
	///
	/// - Parameters:
	///   - body: The block to execute without implicit animations
	///
	/// Example :-
	/// ```
	/// CATransaction.withDisabledActions {
	///     self.checkerboardLayer.image.frame = self.bounds
	///     ...
	/// }
	/// ```
	class func withDisabledActions<T>(_ body: () throws -> T) rethrows -> T {
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		defer {
			CATransaction.commit()
		}
		return try body()
	}
}

#if os(macOS)
extension CGRect {
	/// Inset this rect by the amount specified in `insets`.
	@inlinable func inset(by insets: NSEdgeInsets) -> CGRect {
		var result = self
		result.origin.x    += insets.left
		result.origin.y    += insets.top
		result.size.width  -= (insets.left + insets.right)
		result.size.height -= (insets.top  + insets.bottom)
		return result
	}
}
#endif

extension DSFEdgeInsets {
	/// A default zero inset
	static let zero = DSFEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

	/// Calculate the maximum insets between the two edgeinset objects
	@inlinable func combineMaximum(using other: DSFEdgeInsets) -> DSFEdgeInsets {
		return DSFEdgeInsets(top: max(self.top, other.top),
									left: max(self.left, other.left),
									bottom: max(self.bottom, other.bottom),
									right: max(self.right, other.right))
	}
}
