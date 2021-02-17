//
//  GradientUtils.swift
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

@objc(DSFGradient) public class DSFGradient: NSObject {
	@objc(DSFGradientPost) public class Post: NSObject {
		let color: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat, c: CGColor)
		let location: CGFloat
		
		static let rgbSpace = CGColorSpaceCreateDeviceRGB()
		
		public init(color: CGColor, location: CGFloat) {
			self.location = location
			
			let rgbColor = color.converted(to: Self.rgbSpace,
													 intent: .perceptual,
													 options: nil)!
			assert(rgbColor.numberOfComponents == 4)
			let r1 = rgbColor.components![0]
			let g1 = rgbColor.components![1]
			let b1 = rgbColor.components![2]
			let a1 = rgbColor.components![3]
			
			self.color = (r1, g1, b1, a1, rgbColor)
		}
	}
	
	static let rgbSpace = CGColorSpaceCreateDeviceRGB()
	static let EmptyColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0, 0, 0, 0])!
	
	var posts: [Post] = [] {
		didSet {
			self.sortPosts()
		}
	}
	
	private func sortPosts() {
		self.sortedPosts = self.posts.sorted(by: { (a, b) -> Bool in
			a.location < b.location
		})
	}
	
	private var sortedPosts: [Post] = []
	
	public init(posts: [Post]) {
		self.posts = posts
		super.init()
		
		self.sortPosts()
	}
	
	func color(at fraction: CGFloat) -> CGColor {
		if self.sortedPosts.count == 0 {
			return Self.EmptyColor
		}
		if self.sortedPosts.count == 1 {
			// Just the first color
			return self.sortedPosts[0].color.c
		}
		
		if fraction < 0 {
			// Just the first color
			return self.sortedPosts.first!.color.c
		}
		if fraction > 1 {
			// Just the last color
			return self.sortedPosts.last!.color.c
		}
		
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
}
