//
//  DSFSparklineSurface+AttributedString.swift
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

// NSAttributedString extensions for DSFSparklineSurface.Bitmap

import CoreGraphics
import Foundation

public extension DSFSparklineSurface.Bitmap {

	/// Returns an NSAttributedString containing an image of the sparkline
	/// - Parameters:
	///   - size: The dimensions of the image
	///   - scale: The scale for the returned image. For example, for a retina scale (144dpi) image, scale == 2
	/// - Returns: An NSAttributedString containing the sparkline bitmap, or nil if the bitmap couldn't be generated
	@objc(attributedString::) func attributedString(size: CGSize, scale: CGFloat = 1) -> NSAttributedString? {
		guard let attachment = self.textAttachment(size: size, scale: scale) else {
			return nil
		}
		return NSAttributedString(attachment: attachment)
	}
}

// MARK: - AppKit Additions

#if os(macOS)

import AppKit
public extension DSFSparklineSurface.Bitmap {

	/// Returns a TextAttachment containing an image of the sparkline
	/// - Parameters:
	///   - size: The dimensions of the image
	///   - scale: The scale for the returned image. For example, for a retina scale (144dpi) image, scale == 2
	/// - Returns: An NSTextAttachment containing the sparkline bitmap, or nil if the bitmap couldn't be generated
	@objc(textAttachment::) func textAttachment(size: CGSize, scale: CGFloat = 1) -> NSTextAttachment? {

		guard let image = self.image(size: size, scale: scale) else {
			return nil
		}

		let attachment = NSTextAttachment()
		let flipped = NSImage(size: size, flipped: false, drawingHandler: { (rect: NSRect) -> Bool in
			image.draw(in: rect)
			return true
		})

		attachment.image = flipped
		return attachment
	}
}

#else

// MARK: - UIKit Additions

import UIKit
public extension DSFSparklineSurface.Bitmap {

	/// Returns an NSTextAttachment containing an image of the sparkline
	/// - Parameters:
	///   - size: The dimensions of the image
	///   - scale: The scale for the returned image. For example, for a retina scale (144dpi) image, scale == 2
	/// - Returns: An NSTextAttachment containing the sparkline bitmap, or nil if the bitmap couldn't be generated
	@objc(textAttachment::) func textAttachment(size: CGSize, scale: CGFloat = 1) -> NSTextAttachment? {

		guard let image = self.image(size: size, scale: scale) else {
			return nil
		}

		let attachment = NSTextAttachment()
		attachment.image = image
		attachment.bounds = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
		return attachment
	}
}

#endif
