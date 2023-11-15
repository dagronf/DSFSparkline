//
//  Created by Darren Ford on 25/01/21.
//  Copyright © 2023 Darren Ford. All rights reserved.
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
import CoreGraphics

#if os(macOS)
import AppKit
#else
import UIKit
#endif

public extension DSFSparkline {
	/// Grid lines definition
	@objc(DSFSparklineGridLinesDefinition) class GridLinesDefinition: NSObject {
		/// Grid lines color
		@objc public let color: DSFColor
		/// Grid lines width
		@objc public let width: CGFloat
		/// The dash style to use when drawing
		@objc public let dashStyle: [CGFloat]
		/// The positions to draw the gridlines for the data source
		@objc public let values: [CGFloat]
		/// Create a grid lines definition
		/// - Parameters:
		///   - color: The color of the grid lines
		///   - width: The width to draw the grid lines
		///   - dashStyle: The dash style for the grid lines
		///   - values: The positions to draw the gridlines for the data source
		@objc public init(
			color: DSFColor = .init(white: 0.5, alpha: 0.5),
			width: CGFloat = 1.0,
			dashStyle: [CGFloat] = [1.0, 1.0],
			values: [CGFloat] = []
		) {
			self.color = color
			self.width = width
			self.dashStyle = dashStyle
			self.values = values
		}
	}
}
