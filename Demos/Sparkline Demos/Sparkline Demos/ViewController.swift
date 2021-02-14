//
//  ViewController.swift
//  Sparkline Demos
//
//  Created by Darren Ford on 14/2/21.
//

import Cocoa

import DSFSparkline

class ViewController: NSViewController {

	@IBOutlet weak var line1: DSFSparklineRendererView!
	@IBOutlet weak var bar1: DSFSparklineRendererView!
	@IBOutlet weak var stackline1: DSFSparklineRendererView!

	override func viewDidLoad() {
		super.viewDidLoad()

		self.configure()
		// Do any additional setup after loading the view.
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}

fileprivate var LineSource1: DSFSparklineDataSource = {
	let d = DSFSparklineDataSource(windowSize: 20, /*range: 0 ... 1,*/ zeroLineValue: 0.3)
	d.push(values: [
		0.72, 0.84, 0.15, 0.16, 0.30, 0.58, 0.87, 0.44, 0.02, 0.27,
		0.48, 0.16, 0.15, 0.14, 0.81, 0.53, 0.67, 0.52, 0.07, 0.50
	])
	return d
}()

fileprivate var LineSource2: DSFSparklineDataSource = {
	let d = DSFSparklineDataSource(windowSize: 20, /*range: 0 ... 1,*/ zeroLineValue: 0.3)
	d.push(values: [
		0.58, 0.87, 0.56, 0.18, 0.36, 0.49, 0.86, 0.95, 0.57, 0.96,
		0.00, 0.09, 0.24, 0.34, 0.29, 0.10, 0.59, 0.52, 0.82, 0.73
	])
	return d
}()

extension ViewController {

	func configure() {

//		let h1 = DSFSparklineOverlay.RangeHighlight()
//		h1.dataSource = LineSource1
//		h1.fillColor = CGColor(red: 1.0, green: 0, blue: 0, alpha: 0.2)
//		h1.highlightRange = 0 ..< 0.3
//		line1.addOverlay(h1)
//
//		let h2 = DSFSparklineOverlay.RangeHighlight()
//		h2.dataSource = LineSource1
//		h2.fillColor = CGColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.2)
//		h2.highlightRange = 0.7 ..< 1.0
//		line1.addOverlay(h2)

		let grid = DSFSparklineOverlay.GridLines()
		grid.dataSource = LineSource1
		grid.dashStyle = []
		grid.strokeWidth = 0.5
		grid.strokeColor = CGColor.white.copy(alpha: 0.1)!
		grid.floatValues = [0.0, 0.2, 0.4, 0.6, 0.8, 1.0]
		line1.addOverlay(grid)

		let zeroLine = DSFSparklineOverlay.ZeroLine()
		zeroLine.dataSource = LineSource1
		line1.addOverlay(zeroLine)
		
		let lineOverlay = DSFSparklineOverlay.Line()
		lineOverlay.dataSource = LineSource1
		lineOverlay.primaryLineColor = NSColor.textColor.cgColor
		lineOverlay.primaryFillColor = NSColor.textColor.withAlphaComponent(0.3).cgColor
		lineOverlay.primaryGradient = CGGradient.Create([
			(position: 1.0, color: NSColor.textColor.withAlphaComponent(0.8).cgColor),
			(position: 0.0, color: NSColor.textColor.withAlphaComponent(0.1).cgColor)
		])

		lineOverlay.secondaryFillColor = NSColor.systemRed.cgColor

		lineOverlay.lineWidth = 1
		lineOverlay.lineShading = true
		lineOverlay.markerSize = 4
		lineOverlay.centeredAtZeroLine = true
		line1.addOverlay(lineOverlay)

//		let lineOverlay2 = DSFSparklineOverlay.Line()
//		lineOverlay2.dataSource = LineSource2
//		lineOverlay2.primaryLineColor = NSColor.systemBlue.cgColor
//		lineOverlay2.primaryFillColor = NSColor.systemBlue.withAlphaComponent(0.3).cgColor
//		lineOverlay2.secondaryLineColor = NSColor.systemOrange.cgColor
//		lineOverlay2.secondaryFillColor = NSColor.systemOrange.withAlphaComponent(0.3).cgColor
//
//		lineOverlay2.lineWidth = 1
//		lineOverlay2.lineShading = true
//		lineOverlay2.markerSize = 3
//		lineOverlay2.centeredAtZeroLine = true
//		line1.addOverlay(lineOverlay2)

		////////

		let bar0 = DSFSparklineOverlay.Bar()
		bar0.dataSource = LineSource1
		bar0.barSpacing = 3
		bar0.centeredAtZeroLine = true
		bar0.primaryLineColor = NSColor.systemBlue.cgColor
		bar0.primaryGradient = CGGradient.Create([
			(position: 1.0, color: NSColor.systemBlue.withAlphaComponent(0.8).cgColor),
			(position: 0.0, color: NSColor.systemBlue.withAlphaComponent(0.1).cgColor)
		])
		bar1.addOverlay(bar0)

		////////

		let h2 = DSFSparklineOverlay.RangeHighlight()
		h2.dataSource = LineSource1
		h2.fillColor = NSColor.quaternaryLabelColor.cgColor
		h2.highlightRange = 0.3 ..< 0.7
		stackline1.addOverlay(h2)

		let h3 = DSFSparklineOverlay.RangeHighlight()
		h3.dataSource = LineSource1
		h3.fillColor = NSColor.systemRed.withAlphaComponent(0.1).cgColor
		h3.highlightRange = 0.0 ..< 0.3
		stackline1.addOverlay(h3)

		let zeroLine2 = DSFSparklineOverlay.ZeroLine()
		zeroLine2.dataSource = LineSource1
		stackline1.addOverlay(zeroLine2)


		let stack1 = DSFSparklineOverlay.Stackline()
		stack1.dataSource = LineSource1
		stack1.shadowed = true
		stack1.centeredAtZeroLine = true
		stack1.lineWidth = 1
		stack1.primaryLineColor = NSColor.systemPurple.cgColor
		stack1.primaryFillColor = NSColor.systemPurple.withAlphaComponent(0.7).cgColor
//		stack1.secondaryLineColor = NSColor.systemYellow.cgColor
//		stack1.secondaryFillColor = NSColor.systemYellow.withAlphaComponent(0.7).cgColor

		stackline1.addOverlay(stack1)


		////////

		updateWithNewValues()
	}



	func updateWithNewValues() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
			guard let `self` = self else {
				return
			}

			var cr = CGFloat.random(in: 0.0 ... 1.0)
			_ = LineSource1.push(value: cr)

			cr = CGFloat.random(in: 0.0 ... 1.0)
			_ = LineSource2.push(value: cr)

			self.updateWithNewValues()
		}
	}

}
