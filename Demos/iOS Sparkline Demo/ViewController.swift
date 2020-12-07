//
//  ViewController.swift
//  iOS Sparkline Demo
//
//  Created by Darren Ford on 23/12/19.
//

import UIKit

import DSFSparkline

class ViewController: UIViewController {


	@IBOutlet weak var spark1: DSFSparklineLineGraph!
	var spark1ds = DSFSparklineDataSource(windowSize: 50, range: -10 ... 30)
	@IBOutlet weak var spark2: DSFSparklineLineGraph!
	var spark2ds = DSFSparklineDataSource(windowSize: 50, range: -10 ... 10)
	@IBOutlet weak var spark3: DSFSparklineBarGraph!
	var spark3ds = DSFSparklineDataSource(windowSize: 30, range: -10 ... 10)

	@IBOutlet weak var dot1: DSFSparklineDotGraph!
	var dot1ds = DSFSparklineDataSource(range: -10 ... 10)

	@IBOutlet weak var s1: DSFSparklineBarGraph!
	var ds1 = DSFSparklineDataSource(range: -10 ... 10)
	@IBOutlet weak var s2: DSFSparklineBarGraph!
	var ds2 = DSFSparklineDataSource(range: -10 ... 10)
	@IBOutlet weak var s3: DSFSparklineBarGraph!
	var ds3 = DSFSparklineDataSource(range: -10 ... 10)
	@IBOutlet weak var s4: DSFSparklineBarGraph!
	var ds4 = DSFSparklineDataSource(range: -10 ... 10)

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.

		spark1.dataSource = spark1ds
		spark2.dataSource = spark2ds
		spark3.dataSource = spark3ds

		dot1.dataSource = dot1ds

		s1.dataSource = ds1
		s2.dataSource = ds2
		s3.dataSource = ds3
		s4.dataSource = ds4

		self.addNewValue2()
	}

	func addNewValue2() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
			guard let `self` = self else {
				return
			}

			_ = self.spark1ds.push(value: CGFloat.random(in: self.spark1ds.range!))
			_ = self.spark2ds.push(value: CGFloat.random(in: -10.0 ... 10.0))
			_ = self.spark3ds.push(value: CGFloat.random(in: -10.0 ... 10.0))

			_ = self.dot1ds.push(value: CGFloat.random(in: -10.0 ... 10.0))

			_ = self.ds1.push(value: CGFloat.random(in: -10.0 ... 10.0))
			_ = self.ds2.push(value: CGFloat.random(in: -10.0 ... 10.0))
			_ = self.ds3.push(value: CGFloat.random(in: -10.0 ... 10.0))
			_ = self.ds4.push(value: CGFloat.random(in: -10.0 ... 10.0))

			self.addNewValue2()
		}
	}


}

