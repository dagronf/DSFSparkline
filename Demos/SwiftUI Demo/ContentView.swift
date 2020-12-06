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
	let dataSource3: DSFSparklineDataSource
	let dataSource4: DSFSparklineDataSource

	var body: some View {
		VStack {
			Text("Hello, World!")
				.frame(maxWidth: .infinity, maxHeight: .infinity)
			HStack {
				DSFSparklineBarGraph.SwiftUI(dataSource: dataSource1,
											 graphColor: NSColor.blue,
											 showZero: true,
											 barSpacing: 0)
					.frame(maxWidth: .infinity, maxHeight: .infinity)
				DSFSparklineBarGraph.SwiftUI(dataSource: dataSource2,
											 graphColor: NSColor.green,
											 showZero: true,
											 barSpacing: 2)
					.frame(maxWidth: .infinity, maxHeight: .infinity)
			}
			HStack {
				DSFSparklineDotGraph.SwiftUI(dataSource: dataSource3,
											 graphColor: NSColor.blue,
											 unsetGraphColor: NSColor.darkGray.withAlphaComponent(0.2))
					.frame(maxWidth: .infinity, maxHeight: .infinity)
				DSFSparklineDotGraph.SwiftUI(dataSource: dataSource3,
											 graphColor: NSColor.red,
											 unsetGraphColor: NSColor.darkGray.withAlphaComponent(0.2),
											 upsideDown: true)
					.frame(maxWidth: .infinity, maxHeight: .infinity)
				VStack(alignment: .center, spacing: nil, content: {
					DSFSparklineDotGraph.SwiftUI(dataSource: dataSource4,
												 graphColor: NSColor.systemGreen,
												 unsetGraphColor: NSColor.darkGray.withAlphaComponent(0.2),
												 verticalDotCount: 10)
						.frame(maxWidth: .infinity, maxHeight: .infinity)
					DSFSparklineDotGraph.SwiftUI(dataSource: dataSource4,
												 graphColor: NSColor.systemPink,
												 unsetGraphColor: NSColor.darkGray.withAlphaComponent(0.2),
												 verticalDotCount: 10,
												 upsideDown: true)
						.frame(maxWidth: .infinity, maxHeight: .infinity)

				})
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

var PreviewGlobalDataSource3: DSFSparklineDataSource = {
	let d = DSFSparklineDataSource(windowSize: 10, range: 0.0 ... 100.0)
	d.push(values: [50, 40, 30, 20, 10, 0, 100, 90, 80, 70])
	return d
}()

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView(dataSource1: PreviewGlobalDataSource1,
					dataSource2: PreviewGlobalDataSource2,
					dataSource3: PreviewGlobalDataSource3,
					dataSource4: PreviewGlobalDataSource3)
	}
}
