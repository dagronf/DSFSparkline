//
//  DSFSparklineView.swift
//  DSFSparklines
//
//  Created by Darren Ford on 16/12/19.
//  Copyright © 2019 Darren Ford. All rights reserved.
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

#if os(macOS)
import Cocoa
#else
import UIKit
#endif

/// A common base class for all graph view types
@objc public class DSFSparklineCoreView: DSFView {

	public override init(frame: CGRect) {
		super.init(frame: frame)
		self.setup()
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.setup()
	}

	func setup() {
		#if !os(macOS)
		// Configure iOS/tvOS to make the background transparent.
		// If isOpaque is true (the default value) iOS assumes that you're drawing
		// the ENTIRE content of the control (which we are not).
		self.isOpaque = false
		#else
		self.wantsLayer = true
		#endif
	}

	/// The root layer for the view
	var rootLayer: CALayer {
		#if os(macOS)
		return self.layer!
		#else
		return self.layer
		#endif
	}

	public func updateDisplay() {
		#if os(macOS)
		self.needsDisplay = true
		#else
		self.setNeedsDisplay()
		#endif
	}
}

@IBDesignable
@objc public class DSFSparklineView: DSFSparklineCoreView {

	#if TARGET_INTERFACE_BUILDER
	/// Need this to hold on to the datasource when using designable, or else it disappears due to being weak
	var ibDataSource: DSFSparklineDataSource?
	#endif

	// Listen for changes in the data and update appropriately
	private var dataObserver: NSObjectProtocol?

	/// The source of data for the sparkline
	@objc weak public var dataSource: DSFSparklineDataSource? {
		didSet {
			if self.windowSizeSetInXib {
				self.dataSource?.windowSize = self.graphWindowSize
			}

			self.updateDataObserver()
			self.updateDisplay()
		}
	}

	deinit {
		self.dataObserver = nil
	}

	/// The primary color for the sparkline
	#if os(macOS)
	@IBInspectable public var graphColor: NSColor = NSColor.black {
		didSet {
			self.colorDidChange()
		}
	}
	#else
	@IBInspectable public var graphColor: UIColor = UIColor.black {
		didSet {
			self.colorDidChange()
		}
	}
	#endif

	/// The size of the sparkline window
	///
	/// This member is purely IBDesignable display related
	/// `windowSize` on the dataSource
	@IBInspectable public var graphWindowSize: UInt = 20 {
		didSet {
			self.windowSizeSetInXib = true
			self.dataSource?.windowSize = self.graphWindowSize
			self.updateDisplay()
		}
	}
	private var windowSizeSetInXib = false
}

extension DSFSparklineView {

	private func updateDataObserver() {
		self.dataObserver = nil
		if self.dataSource != nil {
			self.dataObserver = NotificationCenter.default.addObserver(
				forName: DSFSparklineDataSource.DataChangedNotification,
				object: self.dataSource!,
				queue: nil, using: { [weak self] (notification) in
					self?.updateDisplay()
			})
		}
	}

	#if os(macOS)
	public override var isFlipped: Bool {
		return true
	}
	#endif

	/// Override in inherited classes to be notified when the color changes
	@objc func colorDidChange() {	}

	#if os(macOS)
	override public func draw(_ dirtyRect: NSRect) {
		super.draw(dirtyRect)
	}
	#else
	public override func draw(_ rect: CGRect) {
		super.draw(rect)
	}
	#endif

	public override func prepareForInterfaceBuilder() {

		let e = 0 ..< self.graphWindowSize
		let data = e.map { arg in return CGFloat.random(in: -10.0 ... 10.0) }

		let ds = DSFSparklineDataSource(windowSize: self.graphWindowSize)
		self.dataSource = ds
		ds.set(values: data)

		#if TARGET_INTERFACE_BUILDER
		/// Need this to hold on to the datasource, or else it disappears due to being weak
		self.ibDataSource = ds
		#endif
	}
}

extension DSFSparklineDataSource {

	/// Return the vertical fractional position within the data window that represents
	/// zero for the current set of data.
	func fractionalZeroPosition() -> CGFloat {
		return fractionalPosition(for: 0.0)
	}

	/// Return the vertical fractional position within the data window that represents
	/// the zero line value for the current set of data.
	func fractionalPosition(for value: CGFloat) -> CGFloat {
		let result: CGFloat
		if let r = self.range {
			// If a fixed range is specified, calculate the zero line from the specified range
			let full = r.upperBound - r.lowerBound		// full range width
			result = abs(value - r.lowerBound) / full
		}
		else {
			// If no fixed range is specified, calculate the zero line position using the current range of the data.
			result = self.normalize(value: value)
		}

		// Clamp to 0.0 -> 1.0
		return min(max(result, 0.0), 1.0)
	}
}
