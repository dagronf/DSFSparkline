//
//  DSFSparklineSurface+Bitmap.swift
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

import CoreGraphics
import Foundation

public extension DSFSparklineSurface {

/// A surface for drawing a sparkline into an image
	@objc(DSFSparklineSurfaceBitmap) class Bitmap: DSFSparklineSurface {

		private func edgeInsets(for rect: CGRect) -> DSFEdgeInsets {
			/// Calculate the total inset required
			return self.overlays.reduce(DSFEdgeInsets.zero) { (result, overlay) in
				result.combineMaximum(using: overlay.edgeInsets(for: rect))
			}
		}

		/// Add a sparkline overlay to the surface
		@objc public func addOverlay(_ overlay: DSFSparklineOverlay) {
			self.overlays.append(overlay)
		}

		/// Return a CGImage representation of the sparklline
		/// - Parameters:
		///   - size: The dimension in pixels
		///   - scale: The scale to use (eg. retina == 2)
		/// - Returns: A CGImage representation, or nil if the image couldn't be generated
		@objc public func cgImage(size: CGSize, scale: CGFloat = 2) -> CGImage? {
			let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)

			// Create the bitmap context to draw into
			guard let bitmapContext = self.generateBitmapContext(rect: rect, scale: scale) else {
				return nil
			}

			// Calculate the inset required
			let bounds = rect.inset(by: self.edgeInsets(for: rect))

			// Loop through each overlay and ask it to draw
			self.overlays.forEach { overlay in
				bitmapContext.usingGState { ctx in
					overlay.frame = bounds
					overlay.setNeedsDisplay()
					overlay.contentsScale = scale
					#if os(macOS)
					overlay.isGeometryFlipped = true
					#endif

					// Render the layer content
					overlay.render(in: ctx)

					// Render any bitmap content
					overlay.drawGraph(context: ctx, bounds: bounds, scale: scale)
				}
			}

			return bitmapContext.makeImage()
		}

		// MARK: Private

		// The overlays to use when generating the image
		private var overlays: [DSFSparklineOverlay] = []
	}
}

// MARK: - AppKit Additions

#if os(macOS)

import AppKit
public extension DSFSparklineSurface.Bitmap {
	/// Generate an NSImage with the contents of the surface
	/// - Parameters:
	///   - size: The dimensions of the image
	///   - scale: The scale for the returned image. For example, for a retina scale (144dpi) image, scale == 2
	/// - Returns: The created image, or nil if something went wrong
	@objc func image(size: CGSize, scale: CGFloat = 1) -> NSImage? {
		guard let cgImage = self.cgImage(size: size, scale: scale) else {
			return nil
		}
		return NSImage(cgImage: cgImage, size: size)
	}

	/// Generate an NSImage with the contents of the surface
	/// - Parameters:
	///   - width: The width of the resultant image
	///   - height: The height of the resultant image
	///   - scale: The scale for the returned image. For example, for a retina scale (144dpi) image, scale == 2
	/// - Returns: The created image, or nil if something went wrong
	@objc func image(width: CGFloat, height: CGFloat, scale: CGFloat = 1) -> NSImage? {
		let size = CGSize(width: width, height: height)
		guard let cgImage = self.cgImage(size: size, scale: scale) else {
			return nil
		}
		return NSImage(cgImage: cgImage, size: size)
	}
}

#else

// MARK: - UIKit Additions

import UIKit
public extension DSFSparklineSurface.Bitmap {
	/// Generate an NSImage with the contents of the surface
	/// - Parameters:
	///   - size: The dimensions of the image
	///   - scale: The scale for the returned image. For example, for a retina scale (144dpi) image, scale == 2
	/// - Returns: The created image, or nil if something went wrong
	@objc func image(size: CGSize, scale: CGFloat = 1) -> UIImage? {
		guard let cgImage = self.cgImage(size: size, scale: scale) else {
			return nil
		}
		return UIImage(
			cgImage: cgImage,
			scale: scale,
			orientation: UIImage.Orientation.up
		)
	}

	/// Generate an NSImage with the contents of the surface
	/// - Parameters:
	///   - width: The width of the resultant image
	///   - height: The height of the resultant image
	///   - scale: The scale for the returned image. For example, for a retina scale (144dpi) image, scale == 2
	/// - Returns: The created image, or nil if something went wrong
	@objc func image(width: CGFloat, height: CGFloat, scale: CGFloat = 1) -> UIImage? {
		guard let cgImage = self.cgImage(size: CGSize(width: width, height: height), scale: scale) else {
			return nil
		}
		return UIImage(
			cgImage: cgImage,
			scale: scale,
			orientation: UIImage.Orientation.up
		)
	}
}


#endif

// MARK: - Private

private extension DSFSparklineSurface.Bitmap {
	// Generate a bitmap context for the specified rect and scale
	func generateBitmapContext(rect: CGRect, scale: CGFloat) -> CGContext? {
		let colorSpace = CGColorSpaceCreateDeviceRGB()
		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
		guard let bitmapContext = CGContext(
			data: nil,
			width: Int(rect.width * scale),
			height: Int(rect.height * scale),
			bitsPerComponent: 8,
			bytesPerRow: 0,
			space: colorSpace,
			bitmapInfo: bitmapInfo.rawValue
		) else {
			Swift.print("(ERROR) DSFSparklineBitmap unable to generate bitmap context for drawing")
			return nil
		}

		// Need to flip
		bitmapContext.scaleBy(x: scale, y: -scale)
		bitmapContext.translateBy(x: 0, y: -rect.height)
		return bitmapContext
	}
}
