//
//  Copyright © 2024 Darren Ford. All rights reserved.
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

/// An angle
///
/// An angle value represents either a radians or a degrees angle, with functions to easily convert between the two
public enum Angle<T: BinaryFloatingPoint> {
	/// Radians angle value
	case radians(T)
	/// Degrees angle value
	case degrees(T)
	
	/// The radians value for the angle
	@inlinable public var radians: T {
		switch self {
		case let .radians(value): return value
		case let .degrees(value): return value * T.pi / 180.0
		}
	}
	
	/// The degrees value for the angle
	@inlinable public var degrees: T {
		switch self {
		case let .radians(value): return value * 180.0 / T.pi
		case let .degrees(value): return value
		}
	}
	
	/// Return a guaranteed radians angle representation
	@inlinable public var asRadians: Angle { .radians(self.radians) }
	/// Return a guaranteed degrees angle representation
	@inlinable public var asDegrees: Angle { .degrees(self.degrees) }
	
	/// Add two angle values
	@inlinable public static func +(_ left: Angle, _ right: Angle) -> Angle { .radians(left.radians + right.radians) }
	/// Subtract two angle values
	@inlinable public static func -(_ left: Angle, _ right: Angle) -> Angle { .radians(left.radians - right.radians) }
}
