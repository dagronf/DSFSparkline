//
//  DSFSparkline+GradientBucket.swift
//  DSFSparklines
//
//  Created by Darren Ford on 15/2/2021.
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

public extension DSFSparkline {
	/// A class that represents buckets of color within a gradient within the RGB colorspace.
	///
	/// Defines a smooth transition between colors.
	///
	/// **Buckets**
	/// A gradient object can also be 'bucketed', so that rather than a smooth transition the gradient output is
	/// broken up into equal buckets containing a color

	@objc(DSFGradientBucket) class GradientBucket: NSObject {
		static let rgbSpace = CGColorSpaceCreateDeviceRGB()
		static let EmptyColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0, 0, 0, 0])!

		/// The number of buckets to create. If 0 or 1, the gradient is smooth.
		@objc public var bucketCount: UInt = 0 {
			didSet {
				self.buildBuckets()
			}
		}

		private func sorted(_ posts: [Post]) -> [Post] {
			return posts.sorted(by: { (a, b) -> Bool in
				a.location < b.location
			})
		}

		// The posts sorted in order of their location 0.0 -> 1.0
		private var sortedPosts: [Post] = []

		// The color buckets
		private var buckets: [Bucket] = []

		/// Create a gradient
		/// - Parameter posts: The color 'posts' within the gradient
		@objc public init(posts: [Post], bucketCount: UInt = 0) {
			self.bucketCount = bucketCount
			super.init()
			self.sortedPosts = self.sorted(posts)

			self.buildBuckets()
		}

		/// Create a gradient
		/// - Parameter posts: The colors to use evenly across the gradient fill
		public init(colors: [CGColor], bucketCount: UInt = 0) {
			assert(colors.count > 1)
			self.bucketCount = bucketCount

			super.init()

			var offset: CGFloat = 0.0
			let diff = 1.0 / CGFloat(colors.count - 1)
			var posts: [Post] = []

			colors.forEach { color in
				let clamped = offset.clamped(to: 0.0 ... 1.0)
				let post = DSFSparkline.GradientBucket.Post(color: color, location: clamped)
				posts.append(post)
				offset += diff
			}

			self.sortedPosts = self.sorted(posts)

			self.buildBuckets()
		}

		// MARK: - Buckets

		private func buildBuckets() {
			//
			//    |-----|-----|-----|-----|
			//    |     |     |     |     |
			//    |     |     |     |     |
			//    |-----|-----|-----|-----|
			//
			//
			//  If the bucket count is 4, we want the FIRST bucket to be equal
			//  to the first color in the gradient, and the LAST bucket to be
			//  equal to the last color in the gradient.
			//  Which means that the colors for bucket 2 and 3 are represented
			//  by the 1/3 and 2/3 colors to get an even spread across the buckets
			//

			self.buckets = []

			guard self.bucketCount > 1 else {
				return
			}

			if self.bucketCount == 2 {
				self.buckets = [
					Bucket(range: 0.0 ..< 0.5, color: self.color(at: 0)),
					Bucket(range: 0.5 ..< .infinity, color: self.color(at: 1)),
				]
				return
			}

			// The diff for the buckets
			let bucketDiff: CGFloat = 1.0 / CGFloat(self.bucketCount)

			// The diff for the colors
			let colordiff: CGFloat = 1.0 / CGFloat(self.bucketCount - 1)

			// Add in the first bucket. We want the first bucket to be the first color in the gradient
			let first = Bucket(range: -.infinity ..< bucketDiff, color: self.color(at: 0))
			var bkts = [first]

			// The offset within the middle buckets
			var offset: CGFloat = 1
			var rangeOffset = offset * bucketDiff

			// We only need to fill the center buckets because we do first and last manually
			(1 ..< self.bucketCount - 1).forEach { index in

				let colorIndex = colordiff * CGFloat(index)
				let color = self.color(at: colorIndex)

				// let rangeOffset = offset * bucketDiff
				let bucket = Bucket(range: rangeOffset ..< rangeOffset + bucketDiff, color: color)

				bkts.append(bucket)

				// Step to the next middle bucket
				offset += 1
				rangeOffset = rangeOffset + bucketDiff
			}

			// Add in the last bucket. We want the last bucket to be the last color in the gradient
			let last = Bucket(range: (1 - bucketDiff) ..< .infinity, color: self.color(at: 1))
			bkts.append(last)

			self.buckets = bkts
		}

		// MARK: - Colors

		// Returns the color at the specified fractional value
		func color(at fraction: CGFloat) -> CGColor {
			if self.sortedPosts.count == 0 {
				return Self.EmptyColor
			}
			if self.sortedPosts.count == 1 {
				// Just the first color
				return self.sortedPosts[0].color.c
			}

			if fraction <= 0 {
				// Just the first color
				return self.sortedPosts.first!.color.c
			}
			if fraction >= 1 {
				// Just the last color
				return self.sortedPosts.last!.color.c
			}

			if self.buckets.isEmpty {
				return self.gradientColor(at: fraction)
			}
			else {
				return self.bucketColor(at: fraction)
			}
		}

		private func gradientColor(at fraction: CGFloat) -> CGColor {
			var location: Int?
			for index in 0 ..< self.sortedPosts.count - 1 {
				let range = self.sortedPosts[index].location ..< self.sortedPosts[index + 1].location
				if range.contains(fraction) {
					location = index
					break
				}
			}

			guard let loc = location else {
				return self.sortedPosts.last!.color.c
			}

			let delta = self.sortedPosts[loc + 1].location - self.sortedPosts[loc].location
			let divisor = (fraction - self.sortedPosts[loc].location) / delta

			let c1 = self.sortedPosts[loc].color
			let r1 = c1.r
			let g1 = c1.g
			let b1 = c1.b
			let a1 = c1.a

			let c2 = self.sortedPosts[loc + 1].color
			let r2 = c2.r
			let g2 = c2.g
			let b2 = c2.b
			let a2 = c2.a

			let newR = r1 + ((r2 - r1) * divisor)
			let newG = g1 + ((g2 - g1) * divisor)
			let newB = b1 + ((b2 - b1) * divisor)
			let newA = a1 + ((a2 - a1) * divisor)

			return CGColor(colorSpace: Self.rgbSpace, components: [newR, newG, newB, newA])!
		}

		private func bucketColor(at fraction: CGFloat) -> CGColor {
			/// Map the fraction to the bucket ranges
			if let whichColor = self.buckets.first(where: { bucket in
				bucket.range.contains(fraction)
			})?.color {
				return whichColor
			}
			return Self.EmptyColor
		}
	}
}

public extension DSFSparkline.GradientBucket {
	/// A gradient 'post' represents an absolute color at a fractional point within the gradient.
	@objc(DSFGradientBucketPost) class Post: NSObject {
		/// The color at the location
		let color: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat, c: CGColor)

		/// The fractional (0 -> 1) location within the gradient for a color. Values outside this range are clamped
		let location: CGFloat

		private static let rgbSpace = CGColorSpaceCreateDeviceRGB()

		/// Create a post
		/// - Parameters:
		///   - color: the color for the post
		///   - location: the location for the color within the gradient (0.0 -> 1.0)
		@objc public init(color: CGColor, location: CGFloat) {
			self.location = max(0, min(location, 1))

			let rgbColor = color.converted(to: Self.rgbSpace,
													 intent: .perceptual,
													 options: nil)!
			assert(rgbColor.numberOfComponents == 4)
			let r1 = rgbColor.components![0]
			let g1 = rgbColor.components![1]
			let b1 = rgbColor.components![2]
			let a1 = rgbColor.components![3]

			self.color = (r1, g1, b1, a1, rgbColor)

			super.init()
		}

		/// Create a post
		/// - Parameters:
		///   - r: the red component (0.0 -> 1.0)
		///   - g: the green component (0.0 -> 1.0)
		///   - b: the blue component (0.0 -> 1.0)
		///   - location: the location for the color within the gradient (0.0 -> 1.0)
		@objc public init(r: CGFloat, g: CGFloat, b: CGFloat, location: CGFloat) {
			self.location = max(0, min(location, 1))
			self.color = (r, g, b, 1.0, CGColor(colorSpace: Self.rgbSpace,
															components: [r, g, b, 1.0])!)
			super.init()
		}

		/// Create a post
		/// - Parameters:
		///   - r: the red component (0.0 -> 1.0)
		///   - g: the green component (0.0 -> 1.0)
		///   - b: the blue component (0.0 -> 1.0)
		///   - a: the alpha component (0.0 -> 1.0)
		///   - location: the location for the color within the gradient (0.0 -> 1.0)
		@objc public init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat, location: CGFloat) {
			self.location = max(0, min(location, 1))
			self.color = (r, g, b, a, CGColor(colorSpace: Self.rgbSpace,
														 components: [r, g, b, a])!)
			super.init()
		}
	}
}

private extension DSFSparkline.GradientBucket {
	/// Color bucket definition
	struct Bucket: CustomDebugStringConvertible {
		let range: Range<CGFloat>
		let color: CGColor

		var debugDescription: String {
			return "color: \(self.color), range: \(self.range)"
		}
	}

}
