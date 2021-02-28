//
//  DSFSparklineDataSourceView.swift
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

/// A Sparkline View with an attached datasource.
@IBDesignable
@objc public class DSFSparklineDataSourceView: DSFSparklineSurfaceView {

	#if TARGET_INTERFACE_BUILDER
	/// Need this to hold on to the datasource when using designable, or else it disappears due to being weak
	var ibDataSource: DSFSparkline.DataSource?
	#endif

	// Listen for changes in the data and update appropriately
	private var dataObserver: NSObjectProtocol?

	/// The source of data for the sparkline
	@objc weak public var dataSource: DSFSparkline.DataSource? {
		didSet {
			if self.windowSizeSetInXib {
				self.dataSource?.windowSize = self.graphWindowSize
			}
			self.updateDataObserver()

			self.rootLayer.sublayers?.forEach { layer in
				if let l = layer as? DSFSparklineOverlay.DataSource {
					l.dataSource = self.dataSource
				}
			}

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

	#if os(macOS)
	/// Force an update when the view moves to the window
	public override func viewWillMove(toSuperview newSuperview: DSFView?) {
		super.viewWillMove(toSuperview: newSuperview)
		self.colorDidChange()
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

extension DSFSparklineDataSourceView {

	private func updateDataObserver() {
		self.dataObserver = nil
		if self.dataSource != nil {
			self.dataObserver = NotificationCenter.default.addObserver(
				forName: DSFSparkline.DataSource.DataChangedNotification,
				object: self.dataSource!,
				queue: nil, using: { [weak self] (notification) in
					self?.updateDisplay()
			})
		}
	}

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

		let ds = DSFSparkline.DataSource(windowSize: self.graphWindowSize)
		self.dataSource = ds
		ds.set(values: data)

		#if TARGET_INTERFACE_BUILDER
		/// Need this to hold on to the datasource, or else it disappears due to being weak
		self.ibDataSource = ds
		#endif
	}
}

