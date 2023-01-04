//
//  ViewController.swift
//  Simple Wiper Gauge
//
//  Created by Darren Ford on 4/1/23.
//

import Cocoa
import DSFSparkline

class ViewController: NSViewController {

	@IBOutlet weak var wiperGauge: DSFSparklineWiperGaugeGraphView!
	override func viewDidLoad() {
		super.viewDidLoad()

		wiperGauge.value = 0.65
		// Do any additional setup after loading the view.
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}

	@IBAction func valueDidUpdate(_ sender: NSSlider) {
		wiperGauge.value = CGFloat(sender.doubleValue)
	}

}

