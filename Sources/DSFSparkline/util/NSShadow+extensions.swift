//
//  NSShadow+extensions.swift
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

#if os(macOS)
import Cocoa
#else
import UIKit
#endif

public extension NSShadow {
	@objc convenience init(blurRadius: CGFloat, offset: CGSize, color: DSFColor) {
		self.init()

		self.shadowBlurRadius = blurRadius
		self.shadowOffset = offset
		self.shadowColor = color
	}
}

extension CGContext {
	@inlinable func setShadow(_ shadow: NSShadow) {

		#if os(macOS)
		let color = shadow.shadowColor
		#else
		let color = shadow.shadowColor as? UIColor
		#endif

		self.setShadow(offset: shadow.shadowOffset,
							blur: shadow.shadowBlurRadius,
							color: color?.cgColor)
	}
}

// Static definition of the 'default' shadow.
private let _NSShadowDefaultValue = NSShadow(blurRadius: 1.0,
															offset: CGSize(width: 0.5, height: 0.5),
															color: DSFColor.black.withAlphaComponent(0.3))

internal extension NSShadow {
	/// The default shadow
	@objc static let sparklineDefault = _NSShadowDefaultValue
}
