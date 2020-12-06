//
//  AppDelegate.swift
//  SwiftUI Demo
//
//  Created by Darren Ford on 7/12/20.
//

import Cocoa
import SwiftUI

import DSFSparkline

@main
class AppDelegate: NSObject, NSApplicationDelegate {

	var window: NSWindow!

	let demoDataSource1 = DSFSparklineDataSource()
	let demoDataSource2 = DSFSparklineDataSource(range: -1 ... 1)
	let demoDataSource3 = DSFSparklineDataSource(range: 0 ... 100)

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Create the SwiftUI view that provides the window contents.
		let contentView = ContentView(dataSource1: demoDataSource1,
									  dataSource2: demoDataSource2,
									  dataSource3: demoDataSource3,
									  dataSource4: demoDataSource3)

		// Create the window and set the content view.
		window = NSWindow(
		    contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
		    styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
		    backing: .buffered, defer: false)
		window.isReleasedWhenClosed = false
		window.center()
		window.setFrameAutosaveName("Main Window")
		window.contentView = NSHostingView(rootView: contentView)
		window.makeKeyAndOrderFront(nil)

		self.demoDataSource3.windowSize = 40

		self.updateWithNewValues()
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}


	func updateWithNewValues() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
			guard let `self` = self else {
				return
			}

			let cr = CGFloat.random(in: -1.0 ... 1.0)
			_ = self.demoDataSource1.push(value: cr)

			let cr2 = CGFloat.random(in: -1 ... 1)
			_ = self.demoDataSource2.push(value: cr2)

			let cr3 = CGFloat.random(in: 0 ... 100)
			_ = self.demoDataSource3.push(value: cr3)


//			_ = self.sparkCrashDatasource.push(value: cr)
//			_ = self.sparkCrash2Datasource.push(value: cr)
//
//			_ = self.sparkDeprecationDatasource.push(value: CGFloat.random(in: -10.0 ... 10.0))
//			_ = self.sparkInterventionDatasource.push(value: CGFloat.random(in: -10.0 ... 10.0))
//			_ = self.sparkNetworkErrorDatasource.push(value: CGFloat.random(in: -10.0 ... 30.0))
//			_ = self.sparkTransmissionErrorDatasource.push(value: CGFloat.random(in: 0 ... 1))
//
//			/////
//
//			_ = self.fakeSparkCpu1Datasource.push(value: CGFloat.random(in: 0 ... 1))
//			_ = self.fakeSparkCpu2Datasource.push(value: CGFloat.random(in: 0 ... 1))
//			_ = self.fakeSparkCpu3Datasource.push(value: CGFloat.random(in: 0 ... 1))
//			_ = self.fakeSparkCpu4Datasource.push(value: CGFloat.random(in: 0 ... 1))
//			_ = self.fakeSparkCpu5Datasource.push(value: CGFloat.random(in: 0 ... 1))
//
//			_ = self.cpuDotViewDatasource.push(value: CGFloat.random(in: 0 ... 100))
//			_ = self.cpu2DotViewDatasource.push(value: CGFloat.random(in: 0 ... 100))

			self.updateWithNewValues()
		}
	}

}

