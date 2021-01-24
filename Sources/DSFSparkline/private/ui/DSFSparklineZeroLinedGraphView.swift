//
//  DSFSparklineZeroLinedGraphView.swift
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

/// A view that can draw a zero-point line. Should never be used directly, just to inherit from for other graph types
@IBDesignable
public class DSFSparklineZeroLineGraphView: DSFSparklineView {

	/// Drawing definition for the zero line
	public struct Definition {
		#if os(macOS)
		public static let DefaultColor = DSFColor.disabledControlTextColor
		#else
		public static let DefaultColor = DSFColor.systemGray
		#endif

		public static let shared = Definition()

		let color: DSFColor
		let lineWidth: CGFloat
		let lineDashStyle: [CGFloat]

		public init(color: DSFColor = DefaultColor,
						lineWidth: CGFloat = 1.0,
						lineDashStyle: [CGFloat] = [1, 1])
		{
			self.color = color
			self.lineWidth = lineWidth
			self.lineDashStyle = lineDashStyle
		}
	}

	/// Draw a dotted line at the zero point on the y-axis
	@IBInspectable public var showZeroLine: Bool = false

	/// The color of the dotted line at the zero point on the y-axis
	#if os(macOS)
	@IBInspectable public var zeroLineColor = NSColor.gray {
		didSet {
			self.colorDidChange()
		}
	}
	#else
	@IBInspectable public var zeroLineColor: UIColor = .systemGray {
		didSet {
			self.colorDidChange()
		}
	}
	#endif

	/// The width of the dotted line at the zero point on the y-axis
	@IBInspectable public var zeroLineWidth: CGFloat = 1.0

	/// The line style for the dotted line. Use [] to specify a solid line.
	@objc public var zeroLineDashStyle: [CGFloat] = [1.0, 1.0]

	/// A string representation of the line dash lengths for the zero line, eg. "1,3,4,2". If you want a solid line, specify "-"
	///
	/// Primarily used for Interface Builder integration
	@IBInspectable public var zeroLineDashStyleString: String = "1,1" {
		didSet {
			if self.zeroLineDashStyleString == "-" {
				// Solid line
				self.zeroLineDashStyle = []
			}
			else {
				let components = self.zeroLineDashStyleString.split(separator: ",")
				let floats: [CGFloat] = components
					.map { String($0) } // Convert to string array
					.compactMap { Float($0) } // Convert to float array if possible
					.compactMap { CGFloat($0) } // Convert to CGFloat array
				if components.count == floats.count {
					self.zeroLineDashStyle = floats
				}
				else {
					Swift.print("ERROR: Zero Line Style string format is incompatible (\(self.zeroLineDashStyleString) -> \(components))")
				}
			}
			self.updateDisplay()
		}
	}
}

public extension DSFSparklineZeroLineGraphView {

	/// Configure the zero line using the ZeroLineDefinition 
	func setZeroLineDefinition(_ definition: DSFSparklineZeroLineGraphView.Definition) {
		self.zeroLineWidth = definition.lineWidth
		self.zeroLineColor = definition.color
		self.zeroLineDashStyle = definition.lineDashStyle
	}
}

// MARK: - Drawing

public extension DSFSparklineZeroLineGraphView {

	#if os(macOS)
	override func draw(_ dirtyRect: NSRect) {
		super.draw(dirtyRect)

		guard let dataSource = self.dataSource else { return }

		// Show the zero point if wanted
		if self.showZeroLine {
			let frac = dataSource.fractionalPosition(for: dataSource.zeroLineValue)
			let zeroPos = self.bounds.height - (frac * self.bounds.height)

			if let primary = NSGraphicsContext.current?.cgContext {
				primary.usingGState { ctx in
					let color = self.zeroLineColor
					ctx.setLineWidth(self.zeroLineWidth / self.retinaScale())
					ctx.setStrokeColor(color.cgColor)
					ctx.setLineDash(phase: 0.0, lengths: self.zeroLineDashStyle)
					ctx.strokeLineSegments(between: [CGPoint(x: 0.0, y: zeroPos), CGPoint(x: self.bounds.width, y: zeroPos)])
				}
			}
		}
	}
	#else
	override func draw(_ rect: CGRect) {
		super.draw(rect)

		guard let dataSource = self.dataSource else { return }

		// Show the zero point if wanted
		if self.showZeroLine {
			let frac = dataSource.fractionalPosition(for: dataSource.zeroLineValue)
			let zeroPos = self.bounds.height - (frac * self.bounds.height)

			if let primary = UIGraphicsGetCurrentContext() {
				primary.usingGState { ctx in
					let color = self.zeroLineColor
					ctx.setLineWidth(self.zeroLineWidth / self.retinaScale())
					ctx.setStrokeColor(color.cgColor)
					ctx.setLineDash(phase: 0, lengths: self.zeroLineDashStyle)
					ctx.strokeLineSegments(between: [CGPoint(x: 0.0, y: zeroPos), CGPoint(x: self.bounds.width, y: zeroPos)])
				}
			}
		}
	}
	#endif
}
