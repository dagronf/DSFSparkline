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

import Foundation
import CoreGraphics

#if os(macOS)
import AppKit
#else
import UIKit
#endif

/// A Sparkline View with an attached datasource.
@objc public class DSFSparklineDataSourceView: DSFSparklineSurfaceView {

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
	@objc public dynamic var graphColor: NSColor = NSColor.black {
		didSet {
			self.colorDidChange()
		}
	}
	#else
	@objc public dynamic var graphColor: UIColor = UIColor.black {
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
	@objc public dynamic var graphWindowSize: UInt = 20 {
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
}
