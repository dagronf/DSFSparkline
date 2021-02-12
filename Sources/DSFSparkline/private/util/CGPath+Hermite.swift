//
//  CGPath+Hermite.swift
//  DSFSparklines
//
//  Created by Darren Ford on 20/6/19.
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

import CoreGraphics
import Foundation

extension CGMutablePath {
	@discardableResult
	func addPathWithPoints(_ points: [CGPoint], smoothed: Bool = false) -> CGPath {
		if smoothed {
			return self.addPathByExtrapolatingPoints(points)
		}
		else {
			return self.addPathWithPoints(points)
		}
	}

	private func addPathByExtrapolatingPoints(_ interpolationPoints: [CGPoint]) -> CGPath {
		self.interpolatePointsWithHermite(interpolationPoints: interpolationPoints)
		return self
	}

	private func addPathWithPoints(_ points: [CGPoint]) -> CGPath {
		assert(points.count > 1)
		self.move(to: points.first!)
		for point in points.dropFirst() {
			self.addLine(to: point)
		}
		return self
	}
}

extension CGPath {
	func fit(verticallyIn rect: CGRect) -> CGPath? {
		let boundingBox = self.boundingBox
		let dy = rect.height / boundingBox.height

		let scaleTransform = CGAffineTransform.identity
		var tr = scaleTransform.scaledBy(x: 1.0, y: dy)
		return self.copy(using: &tr)
	}

	static func pathWithPoints(_ points: [CGPoint], smoothed: Bool = false) -> CGPath {
		if smoothed {
			return CGPath.byExtrapolatingPoints(points)
		}
		else {
			return CGPath.byPathWithPoints(points)
		}
	}

	private static func byExtrapolatingPoints(_ interpolationPoints: [CGPoint]) -> CGPath {
		let newPath = CGMutablePath()
		newPath.interpolatePointsWithHermite(interpolationPoints: interpolationPoints)
		return newPath
	}

	private static func byPathWithPoints(_ points: [CGPoint]) -> CGPath {
		assert(points.count > 1)
		let path = CGMutablePath()
		path.move(to: points.first!)
		for point in points.dropFirst() {
			path.addLine(to: point)
		}
		return path
	}
}

extension CGMutablePath {
	func interpolatePointsWithHermite(interpolationPoints: [CGPoint]) {
		let n = interpolationPoints.count - 1

		for ii in 0 ..< n {
			var currentPoint = interpolationPoints[ii]

			if ii == 0 {
				self.move(to: interpolationPoints[0])
			}

			var nextii = (ii + 1) % interpolationPoints.count
			var previi = (ii - 1 < 0 ? interpolationPoints.count - 1 : ii - 1)
			var previousPoint = interpolationPoints[previi]
			var nextPoint = interpolationPoints[nextii]
			let endPoint = nextPoint
			var mx: CGFloat = 0.0
			var my: CGFloat = 0.0

			if ii > 0 {
				mx = (nextPoint.x - currentPoint.x) * 0.5 + (currentPoint.x - previousPoint.x) * 0.5
				my = (nextPoint.y - currentPoint.y) * 0.5 + (currentPoint.y - previousPoint.y) * 0.5
			}
			else {
				mx = (nextPoint.x - currentPoint.x) * 0.5
				my = (nextPoint.y - currentPoint.y) * 0.5
			}

			let controlPoint1 = CGPoint(x: currentPoint.x + mx / 3.0, y: currentPoint.y + my / 3.0)

			currentPoint = interpolationPoints[nextii]
			nextii = (nextii + 1) % interpolationPoints.count
			previi = ii
			previousPoint = interpolationPoints[previi]
			nextPoint = interpolationPoints[nextii]

			if ii < n - 1 {
				mx = (nextPoint.x - currentPoint.x) * 0.5 + (currentPoint.x - previousPoint.x) * 0.5
				my = (nextPoint.y - currentPoint.y) * 0.5 + (currentPoint.y - previousPoint.y) * 0.5
			}
			else {
				mx = (currentPoint.x - previousPoint.x) * 0.5
				my = (currentPoint.y - previousPoint.y) * 0.5
			}

			let controlPoint2 = CGPoint(x: currentPoint.x - mx / 3.0, y: currentPoint.y - my / 3.0)

			self.addCurve(to: endPoint, control1: controlPoint1, control2: controlPoint2)
		}
	}
}

extension CGPath {

	/// Fit a bezier path through all of the points.
	static func InterpolatePointsUsingBezier(points: [CGPoint], f: CGFloat = 0.3, t: CGFloat = 0.6) -> CGPath? {

		// See: https://www.geeksforgeeks.org/how-to-draw-smooth-curve-through-multiple-points-using-javascript/

		let path = CGMutablePath()

		guard let first: CGPoint = points.first,
				points.count > 1 else
		{
			return nil
		}

		path.move(to: first)

		let remaining = [CGPoint](points.dropFirst())
		let pairs: [(CGPoint, CGPoint?)] = remaining.enumerated().map { point in
			let next: CGPoint? =
				point.offset < remaining.count - 1 ? remaining[point.offset + 1] : nil
			return (point.element, next)
		}

		var m: CGFloat = 0
		var dx1: CGFloat = 0
		var dy1: CGFloat = 0
		var preP = first

		for pair in pairs {
			let curP = pair.0
			let nexP = pair.1 // This is nil for the last point in the graph

			let dx2: CGFloat
			let dy2: CGFloat

			if let next = nexP {
				m = gradient(preP, next)
				dx2 = (next.x - curP.x) * -f
				dy2 = dx2 * m * t
			}
			else {
				dx2 = 0
				dy2 = 0
			}

			path.addCurve(to: curP,
							  control1: CGPoint(x: preP.x - dx1, y: preP.y - dy1),
							  control2: CGPoint(x: curP.x + dx2, y: curP.y + dy2))

			dx1 = dx2
			dy1 = dy2
			preP = curP
		}

		return path.copy()
	}
}
