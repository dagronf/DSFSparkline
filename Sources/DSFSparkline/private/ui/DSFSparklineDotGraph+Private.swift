//
//  DSFSparklineDataSource.swift
//  DSFSparklines
//
//  Created by Darren Ford on 21/12/19.
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

extension DSFSparklineDotGraph {

	#if os(macOS)
	override public func draw(_ dirtyRect: NSRect) {
		super.draw(dirtyRect)
		if let ctx = NSGraphicsContext.current?.cgContext {
			drawGraph(primary: ctx)
		}
	}
	#else
	public override func draw(_ rect: CGRect) {
		super.draw(rect)
		if let ctx = UIGraphicsGetCurrentContext() {
			drawGraph(primary: ctx)
		}
	}
	#endif
}

private extension DSFSparklineDotGraph {
	private func drawGraph(primary: CGContext) {

		guard let dataSource = self.dataSource else {
			return
		}

		let drawRect = self.bounds

		let height = drawRect.height
		let dimension = floor(height / CGFloat(self.verticalDotCount))

		// All values scaled between 0 and 1
		let normalized = dataSource.normalized

		var position = drawRect.width - dimension

		let path = CGMutablePath()
		let unsetPath = CGMutablePath()

		for dataPoint in normalized.reversed() {
			let boxCount = UInt(CGFloat(self.verticalDotCount) * dataPoint)

			for c in 0 ... verticalDotCount {
				let pos = self.upsideDown ? (CGFloat(c) * dimension) : height - (CGFloat(c) * dimension)
				let r = CGRect(x: position, y: pos, width: dimension, height: dimension)
				let ri = r.insetBy(dx: 0.5, dy: 0.5)

				if c < boxCount {
					path.addRect(ri)
				}
				else {
					unsetPath.addRect(ri)
				}
			}

			// Move left.  If we've hit the lower bound, then stop
			position -= dimension
			if position < 0 {
				break
			}
		}

		primary.usingGState { (state) in
			state.addPath(path)
			state.setFillColor(self.graphColor.cgColor)
			state.drawPath(using: .fill)
		}

		primary.usingGState { (state) in
			state.addPath(unsetPath)
			state.setFillColor(self.unsetGraphColor.cgColor)
			state.drawPath(using: .fill)
		}
	}


}
