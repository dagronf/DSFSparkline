//
//  File.swift
//  
//
//  Created by Darren Ford on 25/2/21.
//

import QuartzCore

public extension DSFSparklineOverlay {

	@objc(DSFSparklineOverlayStaticDataSource) class StaticDataSource: DSFSparklineOverlay {

		/// The data to be displayed in the pie.
		///
		/// The values become a percentage of the total value stored within the
		/// dataStore, and as such each value ends up being drawn as a fraction of the total.
		/// So for example, if you want the pie chart to represent the number of red cars vs. number of
		/// blue cars, you just set the values directly.
		@objc public var dataSource: [CGFloat] = [] {
			didSet {
				self.dataDidChange()
			}
		}

		func dataDidChange() {
			// Do nothing
		}

	}

}
