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
	@objc class Shadow: NSObject {
		public let shadow: NSShadow
		public let isInner: Bool
		@inlinable public init(_ shadow: NSShadow, isInner: Bool = false) {
			self.shadow = shadow
			self.isInner = isInner
		}

		@inlinable convenience public init(blurRadius: CGFloat, offset: CGSize, color: DSFColor, isInner: Bool = false) {
			self.init(
				NSShadow(blurRadius: blurRadius, offset: offset, color: color),
				isInner: isInner
			)
		}

		@inlinable @objc public var offset: CGSize {
			get { shadow.shadowOffset }
			set { shadow.shadowOffset = newValue }
		}
		@inlinable @objc public var color: DSFColor? {
			get { shadow.shadowColor }
			set { shadow.shadowColor = newValue }
		}
		@inlinable @objc public var blurRadius: CGFloat {
			get { shadow.shadowBlurRadius}
			set { shadow.shadowBlurRadius = newValue }
		}
	}
}
