//
//  UnrangedContentView.swift
//  SwiftUI Demo
//
//  Created by Darren Ford on 27/1/21.
//

import SwiftUI
import DSFSparkline

var URSource1: DSFSparklineDataSource = {
	let d = DSFSparklineDataSource(windowSize: 11, zeroLineValue: 0.3)
	d.push(values: [0.0, 0.3, 0.2, 0.1, 0.8, 0.7, 0.5, 0.6, 0.4, 0.9, 1])
	return d
}()

var URSource2: DSFSparklineDataSource = {
	let d = DSFSparklineDataSource(windowSize: 6, zeroLineValue: 0.3)
	d.push(values: [0.8, 0.7, 0.2, 0.6, 0.4, 0.9])
	return d
}()

struct UnrangedContentView_Previews: PreviewProvider {
    static var previews: some View {
		VStack {
			DSFSparklineBarGraphView.SwiftUI(dataSource: URSource1,
														graphColor: NSColor.blue,
														barSpacing: 1,
														showZeroLine: true)
				.frame(maxWidth: .infinity, maxHeight: 80)
			DSFSparklineBarGraphView.SwiftUI(dataSource: URSource2,
														graphColor: NSColor.cyan,
														barSpacing: 1,
														showZeroLine: true)
				.frame(maxWidth: .infinity, maxHeight: 80)
		}
    }
}
