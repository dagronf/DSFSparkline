//
//  ViewController.swift
//  tvOS Sparkline Demo
//
//  Created by Darren Ford on 23/12/19.
//

import UIKit

import DSFSparkline

class ViewController: UIViewController {

	@IBOutlet weak var green: DSFSparklineView!
	var greenDataSource = DSFSparklineDataSource(windowSize: 50, range: -11 ... 11)

	@IBOutlet weak var red: DSFSparklineLineGraph!
	var redDataSource = DSFSparklineDataSource(windowSize: 50, range: -40 ... 10)

	@IBOutlet weak var purple: DSFSparklineDotGraph!
	var purpleDataSource = DSFSparklineDataSource(windowSize: 200, range: 0 ... 50)

	@IBOutlet weak var orange: DSFSparklineDotGraph!
	var orangeDataSource = DSFSparklineDataSource(windowSize: 200, range: 0 ... 50)

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.

		green.dataSource = greenDataSource
		red.dataSource = redDataSource
		purple.dataSource = purpleDataSource
		orange.dataSource = orangeDataSource

		self.updateWithNewValues()

	}
	
	func updateWithNewValues() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
			guard let `self` = self else { return }
			_ = self.greenDataSource.push(value: CGFloat.random(in: self.greenDataSource.range!))
			_ = self.redDataSource.push(value: CGFloat.random(in: self.redDataSource.range!))
			_ = self.purpleDataSource.push(value: CGFloat.random(in: self.purpleDataSource.range!))
			_ = self.orangeDataSource.push(value: CGFloat.random(in: self.orangeDataSource.range!))

			self.updateWithNewValues()
		}
	}

}

