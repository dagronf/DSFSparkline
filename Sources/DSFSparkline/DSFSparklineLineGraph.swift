//
//  DSFSparklineLineGraph.swift
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
public class DSFSparklineLineGraph: DSFSparklineView {
	/// The width for the line drawn on the graph
	@IBInspectable public var lineWidth: CGFloat = 1.5
	
	/// Interpolate a curve between the points
	@IBInspectable public var interpolated: Bool = false
	
	/// Shade the area under the line
	@IBInspectable public var lineShading: Bool = true
	
	/// Draw a shadow under the line
	@IBInspectable public var shadowed: Bool = false
	
	var gradient: CGGradient?
	public override func colorDidChange() {
		self.gradient = CGGradient(
			colorsSpace: nil,
			colors: [self.graphColor.withAlphaComponent(0.4).cgColor,
						self.graphColor.withAlphaComponent(0.2).cgColor] as CFArray,
			locations: [1.0, 0.0]
			)!
	}
}
