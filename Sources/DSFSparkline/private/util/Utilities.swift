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
#else
import UIKit
public typealias DSFColor = UIColor
public typealias DSFView = UIView
public typealias DSFFont = UIFont
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
	func clamped(to range: ClosedRange<Self>) -> Self {
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
	func usingGState(stateBlock: (_ context: CGContext) throws -> Void) rethrows {
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

