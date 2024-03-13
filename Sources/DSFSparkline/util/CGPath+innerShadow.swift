//
//  CGPath+innerShadow.swift
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

import CoreGraphics
import Foundation

public extension CGContext {
	/// Draw an inner shadow in the path
	/// - Parameters:
	///   - path: The path to apply the inner shadow to
	///   - shadowColor: Specifies the color of the shadow, which may contain a non-opaque alpha value. If NULL, then shadowing is disabled.
	///   - offset: Specifies a translation in base-space.
	///   - blurRadius: A non-negative number specifying the amount of blur.
	///
	/// **Inner Shadows in Quartz: Helftone**
	/// [Blog Article](https://blog.helftone.com/demystifying-inner-shadows-in-quartz/)
	/// [(Archived)](https://web.archive.org/web/20221206132428/https://blog.helftone.com/demystifying-inner-shadows-in-quartz/)
	func drawInnerShadow(in path: CGPath, shadowColor: CGColor?, offset: CGSize, blurRadius: CGFloat) {
		guard
			let shadowColor = shadowColor,
			let opaqueShadowColor = shadowColor.copy(alpha: 1.0)
		else {
			return
		}

		self.usingGState { ctx in
			ctx.addPath(path)
			ctx.clip()
			ctx.setAlpha(shadowColor.alpha)
			ctx.usingTransparencyLayer {
				ctx.setShadow(offset: offset, blur: blurRadius, color: opaqueShadowColor)
				ctx.setBlendMode(.sourceOut)
				ctx.setFillColor(opaqueShadowColor)
				ctx.addPath(path)
				ctx.fillPath()
			}
		}
	}
}
