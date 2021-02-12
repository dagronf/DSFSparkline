//
//  DSFSparklinePieGraphView.swift
//  DSFSparklines
//
//  Created by Darren Ford on 12/2/21.
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

/// A sparkline that draws a simple pie chart
@IBDesignable
public class DSFSparklinePieGraphView: DSFSparklineCoreView {

	/// The palette to use when drawing the pie. The first value in the datasource uses the first color,
	/// the second the second color etc.  If there are more datapoints than colors (you shouldn't do this!) then
	/// the chart will start back at the start of the palette.
	///
	/// These palettes can be safely shared between multiple pie views
	@objc public class Palette: NSObject {
		/// The colors to be used when drawing segments
		@objc public let colors: [DSFColor]

		/// A default palette used when no palette is specified.
		@objc public static let shared = Palette([
			DSFColor.systemRed,
			DSFColor.systemOrange,
			DSFColor.systemYellow,
			DSFColor.systemGreen,
			DSFColor.systemBlue,
			DSFColor.systemPurple,
			DSFColor.systemPink,
		])

		/// A default palette used when no palette is specified
		@objc public static let sharedGrays = Palette([
			DSFColor(deviceWhite: 0.9, alpha: 1),
			DSFColor(deviceWhite: 0.7, alpha: 1),
			DSFColor(deviceWhite: 0.5, alpha: 1),
			DSFColor(deviceWhite: 0.3, alpha: 1),
			DSFColor(deviceWhite: 0.1, alpha: 1),
		])

		@objc public init(_ colors: [DSFColor]) {
			self.colors = colors
			super.init()
		}
	}

	/// The stroke color for the pie chart
	#if os(macOS)
	@IBInspectable public var strokeColor: NSColor? {
		didSet {
			self.updateDisplay()
		}
	}
	#else
	@IBInspectable public var strokeColor: UIColor? {
		didSet {
			self.updateDisplay()
		}
	}
	#endif

	@IBInspectable public var lineWidth: CGFloat = 0.5 {
		didSet {
			self.updateDisplay()
		}
	}

	@objc public var dataSource: [CGFloat] = [] {
		didSet {
			self.updateDisplay()
		}
	}

	#if os(macOS)
	override public func draw(_ dirtyRect: NSRect) {
		super.draw(dirtyRect)
		if let ctx = NSGraphicsContext.current?.cgContext {
			self.drawPieGraph(primary: ctx)
		}
	}
	#else
	override public func draw(_ rect: CGRect) {
		super.draw(rect)
		if let ctx = UIGraphicsGetCurrentContext() {
			self.drawPieGraph(primary: ctx)
		}
	}
	#endif

	@objc public var palette = Palette.shared

	func colorForOffset(_ offset: Int) -> DSFColor {
		return self.palette.colors[offset % self.palette.colors.count]
	}

	public func drawPieGraph(primary: CGContext) {
		let rect = self.bounds.insetBy(dx: 1, dy: 1)

		// radius is the half the frame's width or height (whichever is smallest)
		let radius = min(rect.width, rect.height) * 0.5

		// center of the view
		let viewCenter = CGPoint(x: rect.midX, y: rect.midY)

		// enumerate the total value of the segments by using reduce to sum them
		let valueCount = self.dataSource.reduce(0) { $0 + $1 }

		// the starting angle is -90 degrees (top of the circle, as the context is flipped). By default, 0 is the right hand side of the circle, with the positive angle being in an anti-clockwise direction (same as a unit circle in maths).
		var startAngle = -CGFloat.pi * 0.5

		if let stroke = self.strokeColor?.cgColor {
			primary.setStrokeColor(stroke)
			primary.setLineWidth(self.lineWidth)
		}

		for segment in self.dataSource.enumerated() { // loop through the values array
			// set fill color to the segment color
			primary.setFillColor(self.colorForOffset(segment.offset).cgColor)

			// update the end angle of the segment
			let endAngle = startAngle + 2 * .pi * (segment.element / valueCount)

			// move to the center of the pie chart
			primary.move(to: viewCenter)

			// add arc from the center for each segment (anticlockwise is specified for the arc, but as the view flips the context, it will produce a clockwise arc)
			primary.addArc(center: viewCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)

			let drawType: CGPathDrawingMode = self.strokeColor != nil ? .fillStroke : .fill
			primary.drawPath(using: drawType)

			// update starting angle of the next segment to the ending angle of this segment
			startAngle = endAngle
		}
	}
}
