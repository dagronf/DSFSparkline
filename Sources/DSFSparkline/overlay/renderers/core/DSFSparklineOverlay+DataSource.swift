//
//  DSFSparklineOverlay+DataSource.swift
//  DSFSparklines
//
//  Created by Darren Ford on 26/2/21.
//  Copyright © 2021 Darren Ford. All rights reserved.
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

import QuartzCore

public extension DSFSparklineOverlay {

	/// An overlay that contains a DSFSparklineDataSource.
	///
	/// Generally you don't create one of these yourself, you subclass it
	@objc(DSFSparklineDataSourceOverlay) class DataSource : DSFSparklineOverlay {
		/// The datasource for displaying the overlay
		@objc public var dataSource: DSFSparkline.DataSource? {
			didSet {
				// Update our observer to detect changes to data in this new DataSource
				self.updateDataObserver()

				// And tell any listeners that the datasource was changed
				self.dataSourceContentDidChange()
			}
		}

		// Listen for changes in the data and update appropriately
		private var dataObserver: NSObjectProtocol?

		// Update the observer to point to a new datasource
		private func updateDataObserver() {
			self.dataObserver = nil
			if let datasource = self.dataSource {
				self.dataObserver = NotificationCenter.default.addObserver(
					forName: DSFSparkline.DataSource.DataChangedNotification,
					object: datasource,
					queue: nil, using: { [weak self] _ in
						self?.dataSourceContentDidChange()
					}
				)
			}
		}

		/// Overridable to allow overlays to be notified when the content of the data source changes
		internal func dataSourceContentDidChange() {
			self.setNeedsDisplay()
		}

		@objc public init(dataSource: DSFSparkline.DataSource? = nil) {
			self.dataSource = dataSource
			super.init()
		}

		override public init(layer: Any) {
			super.init(layer: layer)
		}

		required init?(coder: NSCoder) {
			super.init(coder: coder)
		}

		deinit {
			self.dataObserver = nil
			self.dataSource = nil
		}
	}
}
