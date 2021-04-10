//
//  DSFSparklineOverlay+StaticDataSource.swift
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
	/// A data source that displays a static set of data, like for a pie chart
	@objc(DSFSparklineOverlayStaticDataSource) class StaticDataSource: DSFSparklineOverlay {
		/// The data to be displayed in this graph
		///
		/// The values become a percentage of the total value stored within the
		/// dataStore, and as such each value ends up being drawn as a fraction of the total.
		/// So for example, if you want the pie chart to represent the number of red cars vs. number of
		/// blue cars, you just set the values directly.
		@objc public var dataSource = DSFSparkline.StaticDataSource() {
			didSet {
				self.staticDataSourceDidChange()
			}
		}

		/// Overridable to allow overlays to be notified when the data source is changed
		func staticDataSourceDidChange() {
			// Do nothing
		}
	}
}
