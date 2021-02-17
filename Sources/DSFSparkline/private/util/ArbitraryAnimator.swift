//
//  ArbitraryAnimator.swift
//  DSFSparklines
//
//  Created by Darren Ford on 17/2/21.
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

import Foundation
import QuartzCore

protocol ArbitraryAnimatorFunction {
	func evaluate(linearPosition: Double) -> Double
}

class ArbitraryAnimator {
	class Function {}

	#if os(macOS)
	var displayLink: CVDisplayLink?
	#else
	var displayLink: CADisplayLink?
	#endif

	var progress: Double = 0.0
	var duration: CFTimeInterval = 1

	var startTime: CFTimeInterval = 0
	var endTime: CFTimeInterval = 0

	var animationFunction: ArbitraryAnimatorFunction = Function.Linear()

	var isActive: Bool = false

	var progressBlock: ((Double) -> Void)?

	init() {
		#if os(macOS)
		CVDisplayLinkCreateWithActiveCGDisplays(&self.displayLink)

		let displayLinkOutputCallback: CVDisplayLinkOutputCallback = {
			(_: CVDisplayLink,
			 _: UnsafePointer<CVTimeStamp>,
			 _: UnsafePointer<CVTimeStamp>,
			 _: CVOptionFlags,
			 _: UnsafeMutablePointer<CVOptionFlags>,
			 displayLinkContext: UnsafeMutableRawPointer?) -> CVReturn in

			let view = unsafeBitCast(displayLinkContext, to: ArbitraryAnimator.self)
			view.perform()
			return CVReturn()
		}

		CVDisplayLinkSetOutputCallback(
			displayLink!,
			displayLinkOutputCallback,
			UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
		)

		#else
		self.displayLink = CADisplayLink(target: self, selector: #selector(self.callback(displaylink:)))
		#endif
	}

	func start() {
		self.startTime = CACurrentMediaTime()
		self.endTime = self.startTime + self.duration

		self.isActive = true

		#if os(macOS)
		guard let displayLink = self.displayLink else { fatalError() }
		CVDisplayLinkStart(displayLink)
		#else
		guard let displayLink = self.displayLink else { fatalError() }
		displayLink.add(to: RunLoop.main, forMode: .default)
		#endif
	}

	func stop() {
		if !self.isActive {
			return
		}

		self.isActive = false

		#if os(macOS)
		guard let link = self.displayLink else { fatalError() }
		CVDisplayLinkStop(link)
		#else
		guard let displayLink = self.displayLink else { fatalError() }
		displayLink.remove(from: RunLoop.main, forMode: .default)
		#endif

		// Force the animation to complete
		self.progress = 1.0
		self.progressBlock?(self.progress)
	}

	#if !os(macOS)
	@objc func callback(displaylink _: CADisplayLink) {
		self.perform()
	}
	#endif

	func perform() {
		DispatchQueue.main.async { [weak self] in
			guard let `self` = self else { return }

			let current = CACurrentMediaTime()

			if current >= self.endTime {
				self.progress = 1.0
				self.stop()
			}
			else {
				let linearPosition = (current - self.startTime) / self.duration
				let evaluatedPosition = self.animationFunction.evaluate(linearPosition: linearPosition)
				self.progress = evaluatedPosition
			}
			self.progressBlock?(self.progress)
		}
	}
}

extension ArbitraryAnimator.Function {
	class EaseInEaseOut: ArbitraryAnimatorFunction {
		let firstControlPoint: Double
		let secondControlPoint: Double
		init(firstControlPoint: Double = 0, secondControlPoint: Double = 1) {
			self.firstControlPoint = firstControlPoint
			self.secondControlPoint = secondControlPoint
		}

		func evaluate(linearPosition: Double) -> Double {
			return
				3 * linearPosition * (1 - linearPosition) * (1 - linearPosition) * self.firstControlPoint +
				3 * linearPosition * linearPosition * (1 - linearPosition) * self.secondControlPoint +
				linearPosition * linearPosition * linearPosition * 1.0
		}
	}

	class Linear: ArbitraryAnimatorFunction {
		func evaluate(linearPosition: Double) -> Double {
			return linearPosition
		}
	}
}
