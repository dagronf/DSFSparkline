//
//  ViewController.swift
//  Documentation project
//
//  Created by Darren Ford on 14/2/21.
//

import Cocoa
import DSFSparkline

class FlippedClipView: NSClipView {
	override var isFlipped: Bool {
		return true
	}
}

public extension NSView {
	func snapshot() -> NSImage? {
		guard let bitmapRep = self.bitmapImageRepForCachingDisplay(in: self.bounds) else { return nil }
		self.cacheDisplay(in: self.bounds, to: bitmapRep)
		let image = NSImage()
		image.addRepresentation(bitmapRep)
		return image
	}
}

class ViewController: NSViewController {

	@IBOutlet weak var primaryScrollView: NSScrollView!


	@IBOutlet weak var lineStandardView: DSFSparklineLineGraphView!
	@IBOutlet weak var lineCenteredView: DSFSparklineLineGraphView!

	@IBOutlet weak var lineInterpolatedStandardView: DSFSparklineLineGraphView!
	@IBOutlet weak var lineInterpolatedCenteredView: DSFSparklineLineGraphView!

	@IBOutlet weak var lineMarkersStandardView: DSFSparklineLineGraphView!
	@IBOutlet weak var lineMarkersCenteredView: DSFSparklineLineGraphView!


	@IBOutlet weak var barStandardView: DSFSparklineBarGraphView!
	@IBOutlet weak var barCenteredView: DSFSparklineBarGraphView!

	@IBOutlet weak var stackStandardView: DSFSparklineStackLineGraphView!
	@IBOutlet weak var stackCenteredView: DSFSparklineStackLineGraphView!

	@IBOutlet weak var dotStandardView: DSFSparklineDotGraphView!
	@IBOutlet weak var dotSecondView: DSFSparklineDotGraphView!

	@IBOutlet weak var winLoss: DSFSparklineWinLossGraphView!
	@IBOutlet weak var winLossTie: DSFSparklineWinLossGraphView!

	@IBOutlet weak var tablet1: DSFSparklineTabletGraphView!


	@IBOutlet weak var pie1: DSFSparklinePieGraphView!
	@IBOutlet weak var pie2: DSFSparklinePieGraphView!
	@IBOutlet weak var pie3: DSFSparklinePieGraphView!
	@IBOutlet weak var pie4: DSFSparklinePieGraphView!
	@IBOutlet weak var pie5: DSFSparklinePieGraphView!
	@IBOutlet weak var pie6: DSFSparklinePieGraphView!
	@IBOutlet weak var pie7: DSFSparklinePieGraphView!
	@IBOutlet weak var pie8: DSFSparklinePieGraphView!
	@IBOutlet weak var pieContainerView: NSView!

	@IBOutlet weak var databarPercent1: DSFSparklineDataBarGraphView!
	@IBOutlet weak var databarPercent2: DSFSparklineDataBarGraphView!
	@IBOutlet weak var databarPercent3: DSFSparklineDataBarGraphView!
	@IBOutlet weak var databarPercent4: DSFSparklineDataBarGraphView!
	@IBOutlet weak var databarPercent5: DSFSparklineDataBarGraphView!
	@IBOutlet weak var databarPercent6: DSFSparklineDataBarGraphView!
	@IBOutlet weak var databarContainerView: NSView!

	@IBOutlet weak var databarTotal1: DSFSparklineDataBarGraphView!
	@IBOutlet weak var databarTotal2: DSFSparklineDataBarGraphView!
	@IBOutlet weak var databarTotal3: DSFSparklineDataBarGraphView!
	@IBOutlet weak var databarTotal4: DSFSparklineDataBarGraphView!
	@IBOutlet weak var databarTotal5: DSFSparklineDataBarGraphView!
	@IBOutlet weak var databarTotal6: DSFSparklineDataBarGraphView!
	@IBOutlet weak var databarTotalContainerView: NSView!



//	lazy var nameMap: [String: NSView] = { [
//		"line-standard": lineStandardView,
//		"line-centered": lineCenteredView,
//		"line-interpolated": lineInterpolatedStandardView,
//		"line-interpolated-centered": lineInterpolatedCenteredView,
//		"line-markers": lineMarkersStandardView,
//		"line-markers-centered": lineMarkersCenteredView,
//
//		"bar-standard": barStandardView,
//		"bar-centered": barCenteredView,
//
//		"stackline-standard": stackStandardView,
//		"stackline-centered": stackCenteredView,
//
//		"dot-standard": dotStandardView,
//		"dot-inverted": dotSecondView,
//
//		"win-loss": self.winLoss,
//		"win-loss-tie": self.winLossTie,
//
//		"tablet": self.tablet1,
//
//		"pie": self.pieContainerView,
//
//		"databar": self.databarContainerView,
//		"databar-max": self.databarTotalContainerView
//	]
//	}()

	var nameMap: [String: NSView] = [:]
	func buildNameMap() {
		nameMap["line-standard"] = lineStandardView
		nameMap["line-centered"] = lineCenteredView
		nameMap["line-interpolated"] = lineInterpolatedStandardView
		nameMap["line-interpolated-centered"] = lineInterpolatedCenteredView
		nameMap["line-markers"] = lineMarkersStandardView
		nameMap["line-markers-centered"] = lineMarkersCenteredView
		nameMap["bar-standard"] = barStandardView
		nameMap["bar-centered"] = barCenteredView
		nameMap["stackline-standard"] = stackStandardView
		nameMap["stackline-centered"] = stackCenteredView
		nameMap["dot-standard"] = dotStandardView
		nameMap["dot-inverted"] = dotSecondView
		nameMap["win-loss"] = self.winLoss
		nameMap["win-loss-tie"] = self.winLossTie
		nameMap["tablet"] = self.tablet1
		nameMap["pie"] = self.pieContainerView
		nameMap["databar"] = self.databarContainerView
		nameMap["databar-max"] = self.databarTotalContainerView
	}

	fileprivate var lineSource: DSFSparklineDataSource = {
		let d = DSFSparklineDataSource(windowSize: 20, range: 0 ... 1, zeroLineValue: 0.3)
		d.push(values: [
			0.72, 0.84, 0.15, 0.16, 0.30, 0.58, 0.87, 0.44, 0.02, 0.27,
			0.48, 0.16, 0.15, 0.14, 0.81, 0.53, 0.67, 0.52, 0.07, 0.50
		])
		return d
	}()

	fileprivate var dotSource: DSFSparklineDataSource = {
		let d = DSFSparklineDataSource(windowSize: 70, range: 0 ... 1)
		d.push(values: [
			0.73, 0.86, 0.72, 0.35, 0.36, 0.09, 0.06, 0.89, 0.94, 0.22,
			0.52, 0.74, 0.53, 0.89, 0.34, 0.67, 0.88, 0.00, 0.78, 0.99,
			0.84, 0.55, 0.02, 0.96, 0.66, 0.94, 0.70, 0.27, 0.18, 0.02,
			0.18, 0.03, 0.00, 0.23, 0.93, 0.17, 0.48, 0.34, 0.89, 0.56,
			0.70, 0.59, 0.12, 0.77, 0.98, 0.31, 0.10, 0.47, 0.42, 0.06,
			1.00, 0.12, 0.50, 0.18, 0.02, 0.90, 0.33, 0.05, 0.60, 0.17,
			0.53, 0.84, 0.72, 0.39, 0.56, 0.57, 0.61, 0.23, 0.96, 0.85
		])
		return d
	}()

	fileprivate var winLossDataSource1: DSFSparklineDataSource = {
		let d = DSFSparklineDataSource(windowSize: 10, range: -1.0 ... 1)
		d.push(values: [1, -1, 0, 1, -1, -1, 1, -1, 0, 1])
		return d
	}()



	override func viewDidLoad() {
		super.viewDidLoad()

		self.buildNameMap()

//		do {
//			guard let scroll = self.primaryScrollView,
//					let documentView = scroll.documentView else {
//				return
//			}
//
//			scroll.translatesAutoresizingMaskIntoConstraints = false
//
//			let clip = scroll.contentView
//			clip.translatesAutoresizingMaskIntoConstraints = false
//
//			scroll.addConstraint(NSLayoutConstraint(item: clip, attribute: .left, relatedBy: .equal, toItem: scroll, attribute: .left, multiplier: 1, constant: 0))
//			scroll.addConstraint(NSLayoutConstraint(item: clip, attribute: .top, relatedBy: .equal, toItem: scroll, attribute: .top, multiplier: 1, constant: 0))
//			scroll.addConstraint(NSLayoutConstraint(item: clip, attribute: .right, relatedBy: .equal, toItem: scroll, attribute: .right, multiplier: 1, constant: 0))
//			scroll.addConstraint(NSLayoutConstraint(item: clip, attribute: .bottom, relatedBy: .equal, toItem: scroll, attribute: .bottom, multiplier: 1, constant: 0))
//
//			documentView.translatesAutoresizingMaskIntoConstraints = false
//
//			clip.addConstraint(NSLayoutConstraint(item: clip, attribute: .left, relatedBy: .equal, toItem: documentView, attribute: .left, multiplier: 1, constant: 0))
//			clip.addConstraint(NSLayoutConstraint(item: clip, attribute: .top, relatedBy: .equal, toItem: documentView, attribute: .top, multiplier: 1, constant: 0))
//			//clip.addConstraint(NSLayoutConstraint(item: clip, attribute: .right, relatedBy: .equal, toItem: documentView, attribute: .right, multiplier: 1, constant: 0))
//		}

		self.lineStandardView.dataSource = lineSource
		self.lineCenteredView.dataSource = lineSource

		self.lineInterpolatedStandardView.dataSource = lineSource
		self.lineInterpolatedCenteredView.dataSource = lineSource

		self.lineMarkersStandardView.dataSource = lineSource
		self.lineMarkersCenteredView.dataSource = lineSource


		self.barStandardView.dataSource = lineSource
		self.barCenteredView.dataSource = lineSource

		self.stackStandardView.dataSource = lineSource
		self.stackCenteredView.dataSource = lineSource

		self.dotStandardView.dataSource = dotSource
		self.dotSecondView.dataSource = dotSource

		self.winLoss.dataSource = winLossDataSource1
		self.winLossTie.dataSource = winLossDataSource1

		self.tablet1.dataSource = winLossDataSource1


		self.pie1.dataSource = [10, 30, 20]
		self.pie2.dataSource = [33, 33, 33]
		self.pie3.dataSource = [40, 5, 80]
		self.pie4.dataSource = [1, 2, 3]
		self.pie5.dataSource = [66.7, 66, 66.9]
		self.pie6.dataSource = [9, 9, 4]
		self.pie7.dataSource = [0.5, 0.1, 0.1]
		self.pie8.dataSource = [1000, 2000, 300]

		let palette = DSFSparklinePalette([
			DSFColor(deviceRed: 0, green: 0, blue: 1, alpha: 1),
			DSFColor(deviceRed: 0.33, green: 0.33, blue: 1, alpha: 1),
			DSFColor(deviceRed: 0.66, green: 0.66, blue: 1, alpha: 1)
		])
		self.pie2.palette = DSFSparklinePalette.sharedGrays
		self.pie4.palette = palette
		self.pie6.palette = palette
		self.pie6.palette = DSFSparklinePalette.sharedGrays
		self.pie8.palette = palette


		///

		self.databarPercent1.dataSource = [10, 30, 20]
		self.databarPercent2.dataSource = [33, 33, 33]
		self.databarPercent3.dataSource = [40, 5, 80]
		self.databarPercent4.dataSource = [1, 2, 3]
		self.databarPercent5.dataSource = [66.7, 66, 66.9]
		self.databarPercent6.dataSource = [9, 9, 4]


		self.databarTotal1.dataSource = [8, 19, 20]
		self.databarTotal1.maximumTotalValue = 60
		self.databarTotal2.dataSource = [20, 20, 20]
		self.databarTotal2.maximumTotalValue = 60
		self.databarTotal3.dataSource = [30, 5, 12]
		self.databarTotal3.maximumTotalValue = 60
		self.databarTotal4.dataSource = [10, 15, 20]
		self.databarTotal4.maximumTotalValue = 60
		self.databarTotal5.dataSource = [25, 10, 12]
		self.databarTotal5.maximumTotalValue = 60
		self.databarTotal6.dataSource = [9, 9, 4]
		self.databarTotal6.maximumTotalValue = 60

	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}

	@IBAction func generate(_ sender: Any) {

		let dialog = NSOpenPanel();

		dialog.title = "Choose a folder";
		dialog.showsResizeIndicator = true
		dialog.allowsMultipleSelection = false
		dialog.canChooseDirectories = true
		dialog.canChooseFiles = false
		dialog.canCreateDirectories = true

		dialog.beginSheetModal(for: self.view.window!, completionHandler: { response in
			guard response == NSApplication.ModalResponse.OK,
					let url = dialog.url else {
				return
			}
			DispatchQueue.main.async { [weak self] in
				self?.generate(path: url)
			}
		})
	}

	func generate(path: URL) {

		self.nameMap.forEach { (name, view) in
			let name = "\(name).png"

			let outputFile = path.appendingPathComponent(name)

			guard let image = view.snapshot(),
					let tiff = image.tiffRepresentation,
					let imageRep = NSBitmapImageRep(data: tiff),
					let pngData = imageRep.representation(using: .png, properties: [:]) else {
				return
			}

			do {
				try pngData.write(to: outputFile)
			}
			catch {
				Swift.print("\(error)")
			}
		}
	}


}

