//
//  File.swift
//  
//
//  Created by Darren Ford on 24/2/21.
//

import Foundation
import CoreGraphics

public class DSFSparklineBitmap: NSObject {

	var overlays: [DSFSparklineOverlay] = []

	public override init() {
		super.init()
	}

	public func addOverlay(_ overlay: DSFSparklineOverlay) {
		self.overlays.append(overlay)
	}

	public func generateImage(size: CGSize, scale: CGFloat = 2) -> CGImage? {

		let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)

		let colorSpace = CGColorSpaceCreateDeviceRGB()
		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
		guard let bitmapContext = CGContext(
					data: nil,
					width: Int(rect.width * scale),
					height: Int(rect.height * scale),
					bitsPerComponent: 8,
					bytesPerRow: 0,
					space: colorSpace,
					bitmapInfo: bitmapInfo.rawValue) else {
			fatalError()
		}

		#if os(macOS)
		bitmapContext.scaleBy(x: scale, y: -scale)
		bitmapContext.translateBy(x: 0, y: -rect.height)
		#else
		bitmapContext.scaleBy(x: scale, y: scale)
		#endif

		var bounds: CGRect = rect

		// Loop through each overlay and ask it to draw
		self.overlays.forEach { overlay in
			bounds = overlay.drawGraph(context: bitmapContext, bounds: bounds, scale: scale)
		}

		return bitmapContext.makeImage()
	}

}
