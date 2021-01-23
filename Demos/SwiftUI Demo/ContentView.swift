//
//  ContentView.swift
//  SwiftUI Demo
//
//  Created by Darren Ford on 7/12/20.
//

import SwiftUI

import DSFSparkline

struct UpperGraph: View {

	let label: String

	let dataSource: DSFSparklineDataSource
	let graphColor: DSFColor

	let showZero: Bool
	let interpolated: Bool
	let lineShading: Bool

	var body: some View {
		DSFSparklineLineGraphView.SwiftUI(dataSource: dataSource,
									  graphColor: graphColor,
									  showZero: showZero,
									  interpolated: interpolated,
									  lineShading: lineShading)
			.background(
				Rectangle()
					.fill(Color(.displayP3, white: 1.0, opacity: 0.1))
					.shadow(color: .black, radius: 8, x: 4, y: -4)
			)
			.clipShape(RoundedRectangle(cornerRadius: 8))
			.padding(4)
			.background(
				RoundedRectangle(cornerRadius: 8)
					.fill(Color(.displayP3, white: 0.5, opacity: 0.1))
					.shadow(color: .black, radius: 8, x: 4, y: -4)
			)
			.overlay(
				VStack(alignment: .leading, spacing: nil, content: {
					Text(self.label)
						.shadow(color: .black, radius: 1)
					Color.clear
				}).padding(6), alignment: .leading)
	}
}

var PreviewUpperGraphDataSource: DSFSparklineDataSource = {
	let d = DSFSparklineDataSource(windowSize: 10, range: 0.0 ... 100.0)
	d.push(values: [20, 77, 90, 22, 4, 16, 66, 99, 88, 44])
	return d
}()

struct UpperGraph_Previews: PreviewProvider {
	static var previews: some View {
		UpperGraph(label: "Testing",
				   dataSource: PreviewUpperGraphDataSource,
				   graphColor: DSFColor.systemOrange,
				   showZero: true,
				   interpolated: true,
				   lineShading: true)
	}
}

/////////////

struct ContentView: View {
	let dataSource1: DSFSparklineDataSource
	let dataSource2: DSFSparklineDataSource
	let dataSource3: DSFSparklineDataSource
	let dataSource4: DSFSparklineDataSource
	let dataSource5: DSFSparklineDataSource

	@State var selectedType = 1

	var body: some View {
		VStack {
			HStack(alignment: .center, spacing: 8, content: {
				UpperGraph(label: "Left", dataSource: dataSource4, graphColor: NSColor.systemOrange, showZero: false, interpolated: false, lineShading: true)
				UpperGraph(label: "Middle", dataSource: dataSource4, graphColor: NSColor.systemYellow, showZero: true, interpolated: true, lineShading: true)
				UpperGraph(label: "Right", dataSource: dataSource4, graphColor: NSColor.systemPurple, showZero: false, interpolated: false, lineShading: false)
			})
			HStack {
				DSFSparklineBarGraphView.SwiftUI(dataSource: dataSource1,
											 graphColor: NSColor.blue,
											 showZero: true,
											 barSpacing: 1)
					.frame(maxWidth: .infinity, maxHeight: .infinity)
				DSFSparklineBarGraphView.SwiftUI(dataSource: dataSource2,
											 graphColor: NSColor.green,
											 showZero: true,
											 lineWidth: 2,
											 barSpacing: 2)
					.frame(maxWidth: .infinity, maxHeight: .infinity)
			}
			HStack {
				DSFSparklineDotGraphView.SwiftUI(dataSource: dataSource3,
											 graphColor: NSColor.blue,
											 unsetGraphColor: NSColor.darkGray.withAlphaComponent(0.2))
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.padding(2)
				DSFSparklineDotGraphView.SwiftUI(dataSource: dataSource3,
											 graphColor: NSColor.red,
											 unsetGraphColor: NSColor.darkGray.withAlphaComponent(0.2),
											 upsideDown: true)
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.padding(2)
				VStack(alignment: .center, spacing: nil, content: {
					DSFSparklineDotGraphView.SwiftUI(dataSource: dataSource3,
												 graphColor: NSColor.systemGreen,
												 unsetGraphColor: NSColor.darkGray.withAlphaComponent(0.2),
												 verticalDotCount: 10)
						.frame(maxWidth: .infinity, maxHeight: .infinity)
					DSFSparklineDotGraphView.SwiftUI(dataSource: dataSource3,
												 graphColor: NSColor.systemPink,
												 unsetGraphColor: NSColor.darkGray.withAlphaComponent(0.2),
												 verticalDotCount: 10,
												 upsideDown: true)
						.frame(maxWidth: .infinity, maxHeight: .infinity)

				})
			}
			HStack {
				Picker(selection: $selectedType, label: EmptyView()) {
					Text("Line").tag(1)
					Text("Line (Smooth)").tag(2)
					Text("Bar").tag(3)
					Text("Dot").tag(4)
				}.pickerStyle(RadioGroupPickerStyle())
				if self.selectedType == 1 {
					DSFSparklineLineGraphView.SwiftUI(dataSource: dataSource5,
																 graphColor: NSColor.textColor,
																 showZero: true)
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.padding(2)
				}
				else if self.selectedType == 2 {
					DSFSparklineLineGraphView.SwiftUI(dataSource: dataSource5,
											 graphColor: NSColor.textColor,
											 showZero: true,
											 interpolated: true)
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.padding(2)
				}
				else if self.selectedType == 3 {
					DSFSparklineBarGraphView.SwiftUI(dataSource: dataSource5,
											 graphColor: NSColor.textColor,
											 showZero: true,
											 barSpacing: 1)
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.padding(2)
				}
				else {
					DSFSparklineDotGraphView.SwiftUI(dataSource: dataSource5,
											 graphColor: NSColor.textColor)
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.padding(2)
				}
			}

		}.padding(20)
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
	let d = DSFSparklineDataSource(windowSize: 20, range: 0.0 ... 100.0)
	d.push(values: [50, 40, 30, 20, 10, 0, 100, 90, 80, 70])
	return d
}()

var PreviewGlobalDataSource4: DSFSparklineDataSource = {
	let d = DSFSparklineDataSource(windowSize: 20, range: 0.0 ... 100.0)
	d.push(values: [20, 77, 90, 22, 4, 16, 66, 99, 88, 44])
	return d
}()

var PreviewGlobalDataSource5: DSFSparklineDataSource = {
	let d = DSFSparklineDataSource(windowSize: 20, range: 0.0 ... 100.0)
	d.push(values: [20, 77, 90, 22, 4, 16, 66, 99, 88, 44])
	return d
}()

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView(dataSource1: PreviewGlobalDataSource1,
					dataSource2: PreviewGlobalDataSource2,
					dataSource3: PreviewGlobalDataSource3,
					dataSource4: PreviewGlobalDataSource4,
					dataSource5: PreviewGlobalDataSource5)
	}
}


struct SparklineView: View {

   let leftDataSource: DSFSparklineDataSource
   let rightDataSource: DSFSparklineDataSource

   var body: some View {
	  HStack {
		 DSFSparklineLineGraphView.SwiftUI(
			dataSource: leftDataSource,
			graphColor: DSFColor.red,
			showZero: false,
			interpolated: true)
		 DSFSparklineBarGraphView.SwiftUI(
			dataSource: rightDataSource,
			graphColor: DSFColor.blue,
			showZero: true,
			lineWidth: 2)
	  }
	.padding()
   }
}

var SparklineView_PreviewGlobalDataSource1: DSFSparklineDataSource = {
	let d = DSFSparklineDataSource(windowSize: 10, range: 0.0 ... 100.0)
	d.push(values: [20, 77, 90, 22, 4, 16, 66, 99, 88, 44])
	return d
}()

var SparklineView_PreviewGlobalDataSource2: DSFSparklineDataSource = {
	let d = DSFSparklineDataSource(windowSize: 10, range: -100.0 ... 30.0)
	d.push(values: [20, 10, 0, -10, -20, -30, 40, 50, 60, 70])
	d.zeroLineValue = -80
	return d
}()


struct SparklineView_Previews: PreviewProvider {
	static var previews: some View {
		SparklineView(leftDataSource: SparklineView_PreviewGlobalDataSource1,
						  rightDataSource: SparklineView_PreviewGlobalDataSource2)
	}
}
