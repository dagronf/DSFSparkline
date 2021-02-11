//
//  DSFSparklineStackLineGraphView.swift
//  DSFSparklines
//
//  Created by Darren Ford on 20/12/19.
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

#if os(macOS)
import Cocoa
#else
import UIKit
#endif

/// A stack line sparkline type
@IBDesignable
public class DSFSparklineStackLineGraphView: DSFSparklineZeroLineGraphView {
	/// The width for the line drawn on the graph
	@IBInspectable public var lineWidth: CGFloat = 1
	
	/// Shade the area under the line
	@IBInspectable public var lineShading: Bool = true
	
	/// Draw a shadow under the line
	@IBInspectable public var shadowed: Bool = false
	
	internal var gradient: CGGradient?
	internal var lowerGradient: CGGradient?
}
