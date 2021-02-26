//
//  DSFSparklineFill.swift
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

@objc public class DSFSparklineFill: NSObject {
	@objc public var gradient: CGGradient?
	@objc public var flat: CGColor?

	@objc public init(flatColor: CGColor) {
		self.flat = flatColor
	}

	@objc public init(gradient: CGGradient) {
		self.gradient = gradient
	}

	@objc public func fill(context: CGContext, bounds: CGRect) {
		if let gradient = self.gradient {
			context.drawLinearGradient(
				gradient, start: CGPoint(x: 0.0, y: bounds.maxY),
				end: CGPoint(x: 0.0, y: bounds.minY),
				options: [.drawsAfterEndLocation, .drawsBeforeStartLocation]
			)
		}
		else if let fill = self.flat {
			context.setFillColor(fill)
			context.fill(bounds)
		}
	}
}
