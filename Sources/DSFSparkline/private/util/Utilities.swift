//
//  Utilities.swift
//  DSFSparklines
//
//  Created by Darren Ford on 20/12/19.
//  Copyright © 2019 Darren Ford. All rights reserved.
//

import Foundation
import CoreGraphics.CGContext

extension ExpressibleByIntegerLiteral where Self: Comparable {
	/// Clamp a value to a closed range
	/// - Parameter range: the range to clamp to
	func clamped(to range: ClosedRange<Self>) -> Self {
		return min(max(self, range.lowerBound), range.upperBound)
	}
}

extension CGContext {
	/// Execute the supplied block within a `saveGState() / restoreGState()` pair, providing a context
	/// to draw in during the execution of the block
	///
	/// - Parameter stateBlock: The block to execute within the new graphics state
	/// - Parameter context: The context to draw into within the block
	///
	/// Example usage:
	/// ```
	///    context.usingGState { (ctx) in
	///       ctx.addPath(unsetBackground)
	///       ctx.setFillColor(bgc1.cgColor)
	///       ctx.fillPath(using: .evenOdd)
	///    }
	/// ```
	func usingGState(stateBlock: (_ context: CGContext) throws -> Void) rethrows {
		self.saveGState()
		defer {
			self.restoreGState()
		}
		try stateBlock(self)
	}
}
