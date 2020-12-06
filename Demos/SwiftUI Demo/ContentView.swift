//
//  ContentView.swift
//  SwiftUI Demo
//
//  Created by Darren Ford on 7/12/20.
//

import SwiftUI

import DSFSparkline

struct ContentView: View {

	let dataSource1: DSFSparklineDataSource
	let dataSource2: DSFSparklineDataSource

	var body: some View {
		VStack {
			Text("Hello, World!")
				.frame(maxWidth: .infinity, maxHeight: .infinity)
			HStack {
				DSFSparklineBarGraph.SwiftUI(dataSource: dataSource1,
											 graphColor: NSColor.blue,
											 barSpacing: 0)
					.frame(maxWidth: .infinity, maxHeight: .infinity)
				DSFSparklineBarGraph.SwiftUI(dataSource: dataSource2,
											 graphColor: NSColor.green,
											 showZero: true,
											 barSpacing: 2)
					.frame(maxWidth: .infinity, maxHeight: .infinity)
			}
		}
	}
}

var PreviewGlobalDataSource1: DSFSparklineDataSource = {
	let d = DSFSparklineDataSource(windowSize: 10, range: 0 ... 1.0)
	d.push(values: [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1])
	return d
}()
var PreviewGlobalDataSource2: DSFSparklineDataSource = {
	let d = DSFSparklineDataSource(windowSize: 10, range: -1.0 ... 1.0)
	d.push(values: [-0.5, -0.4, -0.3, -0.2, -0.1, 0.0, 0.1, 0.2, 0.3, 0.4, 0.5])
	return d
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView(dataSource1: PreviewGlobalDataSource1,
					dataSource2: PreviewGlobalDataSource2)
    }
}
