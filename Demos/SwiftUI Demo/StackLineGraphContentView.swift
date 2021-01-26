//
//  StackLineGraphContentView.swift
//  SwiftUI Demo
//
//  Created by Darren Ford on 27/1/21.
//

import SwiftUI
import DSFSparkline

struct StackLineGraphContentView: View {

	let upDataSource: DSFSparklineDataSource

    var body: some View {
		DSFSparklineStackLineGraphView.SwiftUI(
			dataSource: upDataSource,
			graphColor: DSFColor.linkColor
		)
		.frame(width: 330.0, height: 60.0)
    }
}

var UpDataSource3: DSFSparklineDataSource = {
	let d = DSFSparklineDataSource(windowSize: 11, range: 0 ... 1)
	d.push(values: [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1])
	return d
}()

struct StackLineGraphContentView_Previews: PreviewProvider {
    static var previews: some View {
		StackLineGraphContentView(upDataSource: UpDataSource3)
    }
}
