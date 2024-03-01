//
//  ActiveView.swift
//  Demos
//
//  Created by Darren Ford on 17/2/21.
//

import SwiftUI

import DSFSparkline

struct UpperGraph: View {
	let label: String
	
	let dataSource: DSFSparkline.DataSource
	let graphColor: DSFColor
	
	let showZeroLine: Bool
	var zeroLineDefinition: DSFSparkline.ZeroLineDefinition = .shared
	
	let interpolated: Bool
	let lineShading: Bool
	
	var shadowed: Bool = false
	
	var body: some View {
		DSFSparklineLineGraphView.SwiftUI(dataSource: dataSource,
													 graphColor: graphColor,
													 interpolated: interpolated,
													 lineShading: lineShading,
													 shadowed: shadowed,
													 showZeroLine: showZeroLine,
													 zeroLineDefinition: self.zeroLineDefinition)
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
				}).padding(6), alignment: .leading
			)
	}
}

var PreviewUpperGraphDataSource: DSFSparkline.DataSource = {
	let d = DSFSparkline.DataSource(windowSize: 10, range: 0.0 ... 100.0, zeroLineValue: 25)
	d.push(values: [20, 77, 90, 22, 4, 16, 66, 99, 88, 44])
	return d
}()

struct UpperGraph_Previews: PreviewProvider {
	static var previews: some View {
		UpperGraph(label: "Testing",
					  dataSource: PreviewUpperGraphDataSource,
					  graphColor: DSFColor.systemOrange,
					  showZeroLine: true,
					  zeroLineDefinition: DSFSparkline.ZeroLineDefinition(),
					  interpolated: true,
					  lineShading: true,
					  shadowed: true)
	}
}

/////////////

var PreviewGlobalDataSource1: DSFSparkline.DataSource = {
	let d = DSFSparkline.DataSource(windowSize: 10, range: 0 ... 1.0)
	d.push(values: [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1])
	return d
}()

var PreviewGlobalDataSource2: DSFSparkline.DataSource = {
	let d = DSFSparkline.DataSource(windowSize: 10, range: -1.0 ... 1.0)
	d.push(values: [-0.5, -0.4, -0.3, -0.2, -0.1, 0.0, 0.1, 0.2, 0.3, 0.4, 0.5])
	return d
}()

var PreviewGlobalDataSource3: DSFSparkline.DataSource = {
	let d = DSFSparkline.DataSource(windowSize: 20, range: 0.0 ... 100.0)
	d.push(values: [50, 40, 30, 20, 10, 0, 100, 90, 80, 70])
	return d
}()

var PreviewGlobalDataSource4: DSFSparkline.DataSource = {
	let d = DSFSparkline.DataSource(windowSize: 20, range: 0.0 ... 100.0)
	d.push(values: [20, 77, 90, 22, 4, 16, 66, 99, 88, 44])
	return d
}()

var PreviewGlobalDataSource5: DSFSparkline.DataSource = {
	let d = DSFSparkline.DataSource(windowSize: 20, range: 0.0 ... 100.0)
	d.push(values: [20, 77, 90, 22, 4, 16, 66, 99, 88, 44])
	return d
}()

struct ActiveView_Previews: PreviewProvider {
	static var previews: some View {
		ActiveView(dataSource: DataSource(PreviewGlobalDataSource1,
													 PreviewGlobalDataSource2,
													 PreviewGlobalDataSource3,
													 PreviewGlobalDataSource4,
													 PreviewGlobalDataSource5)
		)
	}
}

func MakeActiveView() -> ActiveView {
	return ActiveView(dataSource: globalSource)
}

struct ActiveView: View {
	let dataSource: DataSource
	
	let BigCyanZeroLine = DSFSparkline.ZeroLineDefinition(
		color: .cyan,
		lineWidth: 3,
		lineDashStyle: [4, 1, 2, 1]
	)
	
	@State var selectedType = 1
	
	let gradient = DSFSparkline.GradientBucket(posts: [
		DSFSparkline.GradientBucket.Post(color: DSFColor.systemRed.cgColor, location: 0),
		DSFSparkline.GradientBucket.Post(color: DSFColor.systemOrange.cgColor, location: 1 / 6),
		DSFSparkline.GradientBucket.Post(color: DSFColor.systemYellow.cgColor, location: 2 / 6),
		DSFSparkline.GradientBucket.Post(color: DSFColor.systemGreen.cgColor, location: 3 / 6),
		DSFSparkline.GradientBucket.Post(color: DSFColor.systemBlue.cgColor, location: 4 / 6),
		DSFSparkline.GradientBucket.Post(color: DSFColor.systemIndigo.cgColor, location: 5 / 6),
		DSFSparkline.GradientBucket.Post(color: DSFColor.systemPurple.cgColor, location: 6 / 6),
	])
	
	var body: some View {
		VStack {
			HStack(alignment: .center, spacing: 8, content: {
				UpperGraph(label: "Left", dataSource: dataSource.PreviewGlobalDataSource4, graphColor: DSFColor.systemOrange, showZeroLine: false, interpolated: false, lineShading: true).frame(height: 60)
				UpperGraph(label: "Middle", dataSource: dataSource.PreviewGlobalDataSource4, graphColor: DSFColor.systemYellow, showZeroLine: true, interpolated: true, lineShading: true).frame(height: 60)
				UpperGraph(label: "Right", dataSource: dataSource.PreviewGlobalDataSource4, graphColor: DSFColor.systemPurple, showZeroLine: false, interpolated: false, lineShading: false).frame(height: 60)
			})
			HStack {
				VStack {
					DSFSparklineBarGraphView.SwiftUI(dataSource: dataSource.PreviewGlobalDataSource1,
																graphColor: DSFColor.systemBlue,
																barSpacing: 1,
																showZeroLine: true,
																showHighlightRange: true,
																highlightDefinitions: [
																	DSFSparkline.HighlightRangeDefinition(
																		range: 0 ..< 0.5,
																		fillColor: DSFColor.gray.withAlphaComponent(0.3).cgColor
																	),
																])
					.frame(height: 60)
					DSFSparklineStripesGraphView.SwiftUI(dataSource: dataSource.PreviewGlobalDataSource1,
																	 barSpacing: 1,
																	 gradient: self.gradient)
					.frame(height: 60)
					.padding(2)
				}
				
				DSFSparklineBarGraphView.SwiftUI(dataSource: dataSource.PreviewGlobalDataSource2,
															graphColor: DSFColor.systemGreen,
															lineWidth: 2,
															barSpacing: 2,
															showZeroLine: true,
															zeroLineDefinition: BigCyanZeroLine,
															centeredAtZeroLine: true)
				.frame(height: 60)
			}
			HStack {
				DSFSparklineDotGraphView.SwiftUI(dataSource: dataSource.PreviewGlobalDataSource3,
															graphColor: DSFColor.systemBlue,
															unsetGraphColor: DSFColor.darkGray.withAlphaComponent(0.2))
				.frame(height: 60)
				.padding(2)
				DSFSparklineDotGraphView.SwiftUI(dataSource: dataSource.PreviewGlobalDataSource3,
															graphColor: DSFColor.systemRed,
															unsetGraphColor: DSFColor.darkGray.withAlphaComponent(0.2),
															upsideDown: true)
				.frame(height: 60)
				.padding(2)
				VStack(alignment: .center, spacing: nil, content: {
					DSFSparklineDotGraphView.SwiftUI(dataSource: dataSource.PreviewGlobalDataSource3,
																graphColor: DSFColor.systemGreen,
																unsetGraphColor: DSFColor.darkGray.withAlphaComponent(0.2),
																verticalDotCount: 10)
					.frame(height: 60)
					DSFSparklineDotGraphView.SwiftUI(dataSource: dataSource.PreviewGlobalDataSource3,
																graphColor: DSFColor.systemPink,
																unsetGraphColor: DSFColor.darkGray.withAlphaComponent(0.2),
																verticalDotCount: 10,
																upsideDown: true)
					.frame(height: 60)
					
				})
			}
			
#if os(macOS)
			HStack {
				Picker(selection: $selectedType, label: EmptyView()) {
					Text("Line").tag(1)
					Text("Line (Smooth)").tag(2)
					Text("Bar").tag(3)
					Text("Dot").tag(4)
					Text("Stripes").tag(5)
				}.pickerStyle(RadioGroupPickerStyle())
				Group {
					if self.selectedType == 1 {
						DSFSparklineLineGraphView.SwiftUI(dataSource: dataSource.PreviewGlobalDataSource5,
																	 graphColor: DSFColor.systemOrange,
																	 showZeroLine: true)
					}
					else if self.selectedType == 2 {
						DSFSparklineLineGraphView.SwiftUI(dataSource: dataSource.PreviewGlobalDataSource5,
																	 graphColor: DSFColor.systemOrange,
																	 interpolated: true,
																	 showZeroLine: true)
					}
					else if self.selectedType == 3 {
						DSFSparklineBarGraphView.SwiftUI(dataSource: dataSource.PreviewGlobalDataSource5,
																	graphColor: DSFColor.systemOrange,
																	barSpacing: 1,
																	showZeroLine: true)
					}
					else if self.selectedType == 4 {
						DSFSparklineDotGraphView.SwiftUI(dataSource: dataSource.PreviewGlobalDataSource5,
																	graphColor: DSFColor.systemOrange)
					}
					else {
						DSFSparklineStripesGraphView.SwiftUI(dataSource: dataSource.PreviewGlobalDataSource5,
																		 barSpacing: 1, gradient: self.gradient)
					}
				}
				.frame(height: 80)
				.padding(2)
			}
#else
			VStack {
				Picker(selection: $selectedType, label: EmptyView()) {
					Text("Line").tag(1)
					Text("Line (Smooth)").tag(2)
					Text("Bar").tag(3)
					Text("Dot").tag(4)
					Text("Stripes").tag(5)
				}
				Group {
					if self.selectedType == 1 {
						DSFSparklineLineGraphView.SwiftUI(dataSource: dataSource.PreviewGlobalDataSource5,
																	 graphColor: DSFColor.systemOrange,
																	 showZeroLine: true)
					}
					else if self.selectedType == 2 {
						DSFSparklineLineGraphView.SwiftUI(dataSource: dataSource.PreviewGlobalDataSource5,
																	 graphColor: DSFColor.systemOrange,
																	 interpolated: true,
																	 showZeroLine: true)
					}
					else if self.selectedType == 3 {
						DSFSparklineBarGraphView.SwiftUI(dataSource: dataSource.PreviewGlobalDataSource5,
																	graphColor: DSFColor.systemOrange,
																	barSpacing: 1,
																	showZeroLine: true)
					}
					else if self.selectedType == 4 {
						DSFSparklineDotGraphView.SwiftUI(dataSource: dataSource.PreviewGlobalDataSource5,
																	graphColor: DSFColor.systemOrange)
					}
					else {
						DSFSparklineStripesGraphView.SwiftUI(dataSource: dataSource.PreviewGlobalDataSource5,
																		 barSpacing: 1, gradient: self.gradient)
					}
				}
				.frame(height: 80)
				.padding(2)
			}
#endif
			
		}.padding(20)
			.onAppear {
				self.dataSource.start()
			}
			.onDisappear {
				self.dataSource.stop()
			}
	}
}

let globalSource = DataSource(
	DSFSparkline.DataSource(windowSize: 30),
	DSFSparkline.DataSource(range: -1.0 ... 1.0),
	DSFSparkline.DataSource(range: -100 ... 100),
	DSFSparkline.DataSource(range: 0 ... 100),
	DSFSparkline.DataSource(range: 0 ... 100, zeroLineValue: 80)
)

class DataSource {
	let PreviewGlobalDataSource1: DSFSparkline.DataSource
	let PreviewGlobalDataSource2: DSFSparkline.DataSource
	let PreviewGlobalDataSource3: DSFSparkline.DataSource
	let PreviewGlobalDataSource4: DSFSparkline.DataSource
	let PreviewGlobalDataSource5: DSFSparkline.DataSource
	
	var shouldStop: Bool = false
	
	init(_ d1: DSFSparkline.DataSource,
		  _ d2: DSFSparkline.DataSource,
		  _ d3: DSFSparkline.DataSource,
		  _ d4: DSFSparkline.DataSource,
		  _ d5: DSFSparkline.DataSource)
	{
		self.PreviewGlobalDataSource1 = d1
		self.PreviewGlobalDataSource2 = d2
		self.PreviewGlobalDataSource3 = d3
		self.PreviewGlobalDataSource4 = d4
		self.PreviewGlobalDataSource5 = d5
	}
	
	func start() {
		self.shouldStop = false
		
		self.PreviewGlobalDataSource3.windowSize = 100
		self.PreviewGlobalDataSource4.windowSize = 40
		_ = self.PreviewGlobalDataSource4.push(value: 50)
		
		self.PreviewGlobalDataSource5.windowSize = 50
		
		self.updateWithNewValues()
	}
	
	func stop() {
		self.shouldStop = true
	}
	
	var sinusoid = 0.00
	var lastSource4: CGFloat = 50.0
	
	func updateWithNewValues() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
			guard let `self` = self else {
				return
			}
			
			if self.shouldStop {
				return
			}
			
			let val = sin(self.sinusoid)
			self.sinusoid += 0.12
			
			let cr = CGFloat(val)
			_ = self.PreviewGlobalDataSource1.push(value: cr)
			
			let cr2 = CGFloat.random(in: self.PreviewGlobalDataSource2.range!) // -1 ... 1)
			_ = self.PreviewGlobalDataSource2.push(value: cr2)
			
			let cr3 = CGFloat.random(in: self.PreviewGlobalDataSource3.range!) // -100 ... 100)
			_ = self.PreviewGlobalDataSource3.push(value: cr3)
			
			let cr4 = CGFloat.random(in: -20 ... 20)
			let newVal = min(100, max(0, self.lastSource4 + cr4))
			_ = self.PreviewGlobalDataSource4.push(value: newVal)
			self.lastSource4 = newVal
			
			let cr5 = CGFloat.random(in: self.PreviewGlobalDataSource5.range!)
			_ = self.PreviewGlobalDataSource5.push(value: cr5)
			
			self.updateWithNewValues()
		}
	}
}
