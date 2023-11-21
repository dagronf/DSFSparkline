//
//  LayerInvalidating.swift
//
//  Copyright © 2023 Darren Ford. All rights reserved.
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

#if os(macOS)
import AppKit
#else
import UIKit
#endif

public struct LayerInvalidatingType: OptionSet {
	public let rawValue: UInt
	/// Call 'setNeedsDisplay()' on the layer whenever the property value changes
	public static let display = LayerInvalidatingType(rawValue: 1 << 0)
	/// Call 'setNeedsLayout()' on the layer whenever the property value changes
	public static let layout = LayerInvalidatingType(rawValue: 1 << 1)
	public static let all: LayerInvalidatingType = [.display, .layout]
	public init(rawValue: UInt) {
		self.rawValue = rawValue
	}
}

/// A property wrapper for CAlayer member properties to force a `setNeedsDisplay()` on the layer
/// whenever the property changes
@propertyWrapper
public struct LayerInvalidating<Value: Equatable> {
	// Stored value
	private var valueType: Value

	// The invalidation types for the property
	private let invalidationType: LayerInvalidatingType

	/// Wrapped value
	public var wrappedValue: Value {
		get {	self.valueType }
		set { self.valueType = newValue }
	}

	/// Initialize with a built-in invalidating type(s).
	public init(wrappedValue: Value, _ invalidationType: LayerInvalidatingType) {
		self.valueType = wrappedValue
		self.invalidationType = invalidationType
	}

	public static subscript<EnclosingSelf: CALayer>(
		_enclosingInstance object: EnclosingSelf,
		wrapped _: ReferenceWritableKeyPath<EnclosingSelf, Value>,
		storage storageKeyPath: ReferenceWritableKeyPath<EnclosingSelf, LayerInvalidating<Value>>
	) -> Value {
		get {
			return object[keyPath: storageKeyPath].wrappedValue
		}
		set {
			object[keyPath: storageKeyPath].updateLayerInvalidatingPropertyWrapper(newValue, object)
		}
	}

	mutating func updateLayerInvalidatingPropertyWrapper(_ value: Value, _ layer: CALayer) {
		guard self.wrappedValue != value else { return }

		// Update the wrapped value
		self.wrappedValue = value

		// And trigger the invalidations associated with the propertywrapper
		if self.invalidationType.contains(.display) { layer.setNeedsDisplay() }
		if self.invalidationType.contains(.layout) { layer.setNeedsLayout() }
	}
}
