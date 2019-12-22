//
//  DSFSparklineBarGraph.swift
//  DSFSparklines
//
//  Created by Darren Ford on 20/12/19.
//  Copyright © 2019 Darren Ford. All rights reserved.
//

#if os(macOS)
import Cocoa
#else
import UIKit
#endif

@IBDesignable
public class DSFSparklineBarGraph: DSFSparklineView {
	@IBInspectable public var lineWidth: CGFloat = 0.5
	@IBInspectable public var barSpacing: CGFloat = 1.0
}
