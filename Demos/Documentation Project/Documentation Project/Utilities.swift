//
//  Utilities.swift
//  Documentation Project
//
//  Created by Darren Ford on 14/4/21.
//

import Foundation
import CoreGraphics

/// A CGPath creation function using a block
/// - Parameter block: The block used to add to a mutablepath object
/// - Returns: The created path object
///
/// Example :-
///   ```
///   let path = CGPath.Create { path in
///      path.move(to: CGPoint(x: 0, y: 5))
///      path.addLine(to: CGPoint(x: 10, y: 5))
///      path.move(to: CGPoint(x: 5, y: 0))
///      path.addLine(to: CGPoint(x: 10, y: 5))
///   }
///   ```
@inlinable func CGPath(_ block: (CGMutablePath) throws -> Void) rethrows -> CGPath {
	let pth = CGMutablePath()
	try block(pth)
	return pth.copy()!
}

