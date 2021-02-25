//
//  File.swift
//
//
//  Created by Darren Ford on 24/2/21.
//

import CoreGraphics
import Foundation

@objc public class DSFSparklineBitmap: NSObject {

	// The overlays to use when generating the image
	private var overlays: [DSFSparklineOverlay] = []

	/// Add a sparkline overlay to the bitmap
	@objc public func addOverlay(_ overlay: DSFSparklineOverlay) {
		self.overlays.append(overlay)
	}

	/// Return a CGImage representation of the sparklilne
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

		var bounds: CGRect = rect

		// Loop through each overlay and ask it to draw
		self.overlays.forEach { overlay in
			bitmapContext.usingGState { ctx in
				bounds = overlay.drawGraph(context: ctx, bounds: bounds, scale: scale)
			}
		}

		return bitmapContext.makeImage()
	}
}

// MARK: - AppKit Additions

#if canImport(AppKit)
import AppKit
public extension DSFSparklineBitmap {
	@objc func image(size: CGSize, scale: CGFloat = 2) -> NSImage? {
		guard let cgImage = self.cgImage(size: size, scale: scale) else {
			return nil
		}
		return NSImage(cgImage: cgImage, size: size)
	}
}
#endif

// MARK: - UIKit Additions

#if canImport(UIKit)
import UIKit
public extension DSFSparklineBitmap {
	@objc func image(size: CGSize, scale: CGFloat = 2) -> UIImage? {
		guard let cgImage = self.cgImage(size: size, scale: scale) else {
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

private extension DSFSparklineBitmap {
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
