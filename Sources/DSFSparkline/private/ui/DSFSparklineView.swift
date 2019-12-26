//
//  DSFSparklineView.swift
//  DSFSparklines
//
//  Created by Darren Ford on 16/12/19.
//  Copyright © 2019 Darren Ford. All rights reserved.
//

#if os(macOS)
import Cocoa
public typealias SLColor = NSColor
public typealias SLView = NSView
#else
import UIKit
public typealias SLColor = UIColor
public typealias SLView = UIView
#endif

@IBDesignable
@objc public class DSFSparklineView: SLView {

	#if TARGET_INTERFACE_BUILDER
	/// Need this to hold on to the datasource when using designable, or else it disappears due to being weak
	var ibDataSource: DSFSparklineDataSource?
	#endif

	// Listen for changes in the data and update appropriately
	private var dataObserver: NSObjectProtocol?
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

	/// The source of data for the sparkline
	@objc weak public var dataSource: DSFSparklineDataSource? {
		didSet {
			self.updateDataObserver()
			self.dataSource?.windowSize = self.windowSize
			self.updateDisplay()
		}
	}

	deinit {
		self.dataObserver = nil
	}

	#if os(macOS)
	public override var isFlipped: Bool {
		return true
	}
	#endif

	func colorDidChange() {	}

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

	/// Draw a line at the zero point
	@IBInspectable public var showZero: Bool = false

	@IBInspectable public var windowSize: UInt = 20 {
		didSet {
			self.dataSource?.windowSize = self.windowSize
		}
	}

	public override func awakeFromNib() {
		super.awakeFromNib()
		self.dataSource?.windowSize = self.windowSize
	}

	public func updateDisplay() {
		#if os(macOS)
		self.needsDisplay = true
		#else
		self.setNeedsDisplay()
		#endif
	}

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
		let e = 0 ..< self.windowSize
		let data = e.map { arg in return CGFloat.random(in: -10.0 ... 10.0) }

		let ds = DSFSparklineDataSource(windowSize: self.windowSize)
		self.dataSource = ds
		ds.set(values: data)

		#if TARGET_INTERFACE_BUILDER
		/// Need this to hold on to the datasource, or else it disappears due to being weak
		self.ibDataSource = ds
		#endif
	}
}
