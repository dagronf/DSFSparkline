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

	let demoDataSource1 = DSFSparklineDataSource(windowSize: 30)
	let demoDataSource2 = DSFSparklineDataSource(range: -1 ... 1)
	let demoDataSource3 = DSFSparklineDataSource(range: -100 ... 100)

	let demoDataSource4 = DSFSparklineDataSource(range: 0 ... 100)
	var lastSource4: CGFloat = 50.0

	let demoDataSource5 = DSFSparklineDataSource(range: 0 ... 100, zeroLineValue: 80)

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Create the SwiftUI view that provides the window contents.
		let contentView = ContentView(dataSource1: demoDataSource1,
									  dataSource2: demoDataSource2,
									  dataSource3: demoDataSource3,
									  dataSource4: demoDataSource4,
									  dataSource5: demoDataSource5)

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

		demoDataSource1.highlightRange = -0.1 ..< 0.1

		self.demoDataSource3.windowSize = 100
		self.demoDataSource4.windowSize = 40
		_ = self.demoDataSource4.push(value: 50)

		self.demoDataSource5.windowSize = 50

		self.updateWithNewValues()
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}

	var sinusoid = 0.00

	func updateWithNewValues() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
			guard let `self` = self else {
				return
			}

			let val = sin(self.sinusoid)
			self.sinusoid += 0.12

			let cr = CGFloat(val)
			_ = self.demoDataSource1.push(value: cr)

			let cr2 = CGFloat.random(in: self.demoDataSource2.range!) //-1 ... 1)
			_ = self.demoDataSource2.push(value: cr2)

			let cr3 = CGFloat.random(in: self.demoDataSource3.range!) // -100 ... 100)
			_ = self.demoDataSource3.push(value: cr3)

			let cr4 = CGFloat.random(in: -20 ... 20)
			let newVal = min(100, max(0, self.lastSource4 + cr4))
			_ = self.demoDataSource4.push(value: newVal)
			self.lastSource4 = newVal

			let cr5 = CGFloat.random(in: self.demoDataSource5.range!)
			_ = self.demoDataSource5.push(value: cr5)

			self.updateWithNewValues()
		}
	}

}

