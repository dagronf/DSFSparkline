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





	override func viewDidLoad() {
		super.viewDidLoad()

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
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}

