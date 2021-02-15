//
//  GradientUtils.swift
//  DSFSparklines
//
//  Created by Darren Ford on 15/2/2021.
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

private struct Pixel {
	var value: UInt32
	var red: UInt8 {
		get { return UInt8(self.value & 0xFF) }
		set { self.value = UInt32(newValue) | (self.value & 0xFFFF_FF00) }
	}

	var green: UInt8 {
		get { return UInt8((self.value >> 8) & 0xFF) }
		set { self.value = (UInt32(newValue) << 8) | (self.value & 0xFFFF_00FF) }
	}

	var blue: UInt8 {
		get { return UInt8((self.value >> 16) & 0xFF) }
		set { self.value = (UInt32(newValue) << 16) | (self.value & 0xFF00_FFFF) }
	}

	var alpha: UInt8 {
		get { return UInt8((self.value >> 24) & 0xFF) }
		set { self.value = (UInt32(newValue) << 24) | (self.value & 0x00FF_FFFF) }
	}
}

class GradientHandler: NSObject {
	public var gradient: CGGradient? {
		didSet {
			self.buildBitmap()
		}
	}

	let width: Int = 1024
	let height: Int = 1

	let bytesPerPixel = 4
	let bitsPerComponent = 8

	var pixels: [(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)] = []

	func buildBitmap() {
		self.pixels = []

		guard let gradient = self.gradient else {
			return
		}

		let fullWidth = self.width + 1

		let bytesPerRow = fullWidth * self.bytesPerPixel
		let imageData = UnsafeMutablePointer<Pixel>.allocate(capacity: fullWidth * self.height)
		let colorSpace = CGColorSpaceCreateDeviceRGB()
		var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
		bitmapInfo |= CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
		guard let context = CGContext(
			data: imageData,
			width: fullWidth, height: height,
			bitsPerComponent: bitsPerComponent,
			bytesPerRow: bytesPerRow,
			space: colorSpace,
			bitmapInfo: bitmapInfo
		) else { return }

		context.clear(CGRect(x: 0, y: 0, width: fullWidth, height: 1))

		context.drawLinearGradient(
			gradient,
			start: CGPoint(x: 0, y: 0),
			end: CGPoint(x: self.width + 1, y: 0),
			options: [.drawsAfterEndLocation, .drawsBeforeStartLocation]
		)

		// let generatedImage = context.makeImage()

		// The raw pixels from the context in RGBA format
		let rawData = UnsafeMutableBufferPointer<Pixel>(start: imageData, count: fullWidth)

		// Preconvert the values to 0 ... 1 to save drawing time later on
		self.pixels = rawData.map {
			(CGFloat($0.red) / 255.0,
			 CGFloat($0.green) / 255.0,
			 CGFloat($0.blue) / 255.0,
			 CGFloat($0.alpha) / 255.0)
		}
	}

	func color(at fraction: CGFloat) -> CGColor {
		// We need to make sure we clamp this value - as if there is a value outside the user's specified range
		// in the datasource (which is valid!) then the fractional value will be > 1 or < 0.
		let clampedValue = min(1, max(0, fraction))

		let offset = Int(CGFloat(width) * clampedValue)
		let pixel = self.pixels[offset]

		if #available(iOS 13.0, tvOS 13.0, macOS 10.10, *) {
			return CGColor(red: pixel.red, green: pixel.green, blue: pixel.blue, alpha: pixel.alpha)
		} else {
			return CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(),
								components: [pixel.red, pixel.green, pixel.blue, pixel.alpha])!
		}
	}
}
