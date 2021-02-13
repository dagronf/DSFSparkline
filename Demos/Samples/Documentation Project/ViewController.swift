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


	fileprivate var lineSource: DSFSparklineDataSource = {
		let d = DSFSparklineDataSource(windowSize: 20, range: 0 ... 1, zeroLineValue: 0.3)
		d.push(values: [
			0.72, 0.84, 0.15, 0.16, 0.30, 0.58, 0.87, 0.44, 0.02, 0.27,
			0.48, 0.16, 0.15, 0.14, 0.81, 0.53, 0.67, 0.52, 0.07, 0.50
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


	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}

