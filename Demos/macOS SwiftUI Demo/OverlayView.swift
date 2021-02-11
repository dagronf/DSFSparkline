//
//  OverlayView.swift
//  SwiftUI Demo
//
//  Created by Darren Ford on 26/1/21.
//

import SwiftUI
import DSFSparkline

struct OverlayView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

var ds1: DSFSparklineDataSource = {
	let d = DSFSparklineDataSource(windowSize: 10, range: 0 ... 100, zeroLineValue: 50)
	d.push(values: [20, 77, 90, 22, 4, 16, 66, 99, 88, 44])
	return d
}()

var ds2: DSFSparklineDataSource = {
	let d = DSFSparklineDataSource(windowSize: 10, range: 0 ... 100)
	d.push(values: [3, 66, 77, 100, 43, 19, 4, 0, 32, 44])
	return d
}()

struct OverlayView_Previews: PreviewProvider {
	static var previews: some View {
		ZStack {
			DSFSparklineBarGraphView.SwiftUI(
				dataSource: ds1,
				graphColor: .blue,
				showZeroLine: true
			)
			DSFSparklineLineGraphView.SwiftUI(
				dataSource: ds2,
				graphColor: .textColor,
				lineWidth: 4,
				lineShading: false
			)
		}
	}
}
