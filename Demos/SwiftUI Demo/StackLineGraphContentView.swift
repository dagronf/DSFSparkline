//
//  StackLineGraphContentView.swift
//  SwiftUI Demo
//
//  Created by Darren Ford on 27/1/21.
//

import SwiftUI
import DSFSparkline

var UpDataSource1: DSFSparklineDataSource = {
	let d = DSFSparklineDataSource(windowSize: 11, range: 0 ... 1, zeroLineValue: 0.3)
	d.push(values: [0.0, 0.3, 0.2, 0.1, 0.8, 0.7, 0.5, 0.6, 0.4, 0.9, 1])
	return d
}()

var UpDataSource2: DSFSparklineDataSource = {
	let d = DSFSparklineDataSource(windowSize: 8, range: -100 ... 100)
	d.push(values: [100, -100, 0, -50, 50, 0, 10, -10])
	return d
}()

var UpDataSource3: DSFSparklineDataSource = {
	let d = DSFSparklineDataSource(windowSize: 21, range: -1 ... 1)

	var sins: CGFloat = 0.0
	let r: Range<Int> = 0 ..< 21
	let vars: [CGFloat] = r.map { sin(CGFloat($0)) }
	d.push(values: vars)
	return d
}()

var UpDataSource4: DSFSparklineDataSource = {
	let d = DSFSparklineDataSource(windowSize: 21, range: 0 ... 1)
	d.push(values: [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1, 0.0])
	return d
}()


struct StackLineGraphContentView_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			DSFSparklineStackLineGraphView.SwiftUI(
				dataSource: UpDataSource1,
				graphColor: DSFColor.linkColor,
				showZeroLine: true
			)
			.frame(width: 330.0, height: 60.0)

			DSFSparklineStackLineGraphView.SwiftUI(
				dataSource: UpDataSource2,
				graphColor: DSFColor.green,
				lineWidth: 1,
				showZeroLine: true
			)
			.frame(width: 250.0, height: 59.0)

			DSFSparklineStackLineGraphView.SwiftUI(
				dataSource: UpDataSource3,
				graphColor: DSFColor.yellow,
				lineWidth: 3,
				lineShading: false,
				shadowed: false
			)
			.frame(width: 330.0, height: 59.0)

			DSFSparklineStackLineGraphView.SwiftUI(
				dataSource: UpDataSource4,
				graphColor: DSFColor.red,
				lineWidth: 0.5,
				shadowed: false
			)
			.frame(width: 330.0, height: 59.0)
		}
	}
}
