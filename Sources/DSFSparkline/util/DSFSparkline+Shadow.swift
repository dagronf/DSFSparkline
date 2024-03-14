//
//  CGContext+extensions.swift
//
//  Copyright © 2024 Darren Ford. All rights reserved.
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

#if os(macOS)
import AppKit
#else
import UIKit
#endif

public extension DSFSparkline {
	/// A shadow object
	@objc class Shadow: NSObject {
		/// The shadow
		public let shadow: NSShadow
		/// Is the shadow an inner shadow?
		public let isInner: Bool

		/// Create a new shadow object
		@objc public init(_ shadow: NSShadow, isInner: Bool = false) {
			self.shadow = shadow
			self.isInner = isInner
			super.init()
		}

		/// Create a new shadow object
		@objc convenience public init(blurRadius: CGFloat, offset: CGSize, color: CGColor, isInner: Bool = false) {
			#if os(macOS)
			let color: DSFColor = DSFColor(cgColor: color) ?? .black
			#else
			let color: DSFColor = DSFColor(cgColor: color)
			#endif
			self.init(
				NSShadow(blurRadius: blurRadius, offset: offset, color: color),
				isInner: isInner
			)
		}

		/// Shadow offset
		@inlinable @objc public var offset: CGSize {
			get { shadow.shadowOffset }
			set { shadow.shadowOffset = newValue }
		}
		#if os(macOS)
		/// Shadow color
		@inlinable @objc public var color: CGColor? {
			get { shadow.shadowColor?.cgColor }
			set { shadow.shadowColor = newValue != nil ? NSColor(cgColor: newValue!) : nil }
		}
		#else
		/// Shadow color
		@inlinable @objc public var color: CGColor? {
			get { (shadow.shadowColor as? DSFColor)?.cgColor }
			set { shadow.shadowColor = (newValue != nil) ? UIColor(cgColor: newValue!) : nil }
		}
		#endif
		/// Shadow blur radius
		@inlinable @objc public var blurRadius: CGFloat {
			get { shadow.shadowBlurRadius}
			set { shadow.shadowBlurRadius = newValue }
		}

		/// Calculate the amount of inset required to cater for drawing a shadow
		@inlinable internal var requiredShadowInset: CGFloat {
			if self.isInner { return 0 }
			let dx = (abs(self.offset.width) + self.blurRadius) * 2
			let dy = (abs(self.offset.height) + self.blurRadius) * 2
			return max(dx, dy)
		}
	}
}
