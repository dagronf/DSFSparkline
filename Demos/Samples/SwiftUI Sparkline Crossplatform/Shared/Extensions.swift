//
//  Extensions.swift
//  Demos
//
//  Created by Darren Ford on 26/2/21.
//

import CoreGraphics

#if !os(macOS)
internal extension CGColor {
	static var black: CGColor {
		return CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0, 0, 0, 1])!
	}
	static var clear: CGColor {
		return CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0, 0, 0, 0])!
	}
}
#endif
