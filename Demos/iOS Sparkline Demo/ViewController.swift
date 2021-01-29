//
//  ViewController.swift
//  iOS Sparkline Demo
//
//  Created by Darren Ford on 23/12/19.
//

import UIKit

import DSFSparkline

class ViewController: UIViewController {


	@IBOutlet weak var spark1: DSFSparklineLineGraphView!
	var spark1ds = DSFSparklineDataSource(windowSize: 50, range: -10 ... 30)
	@IBOutlet weak var spark2: DSFSparklineLineGraphView!
	var spark2ds = DSFSparklineDataSource(windowSize: 50, range: -12 ... 12)
	@IBOutlet weak var spark3: DSFSparklineBarGraphView!
	var spark3ds = DSFSparklineDataSource(windowSize: 30, range: -10 ... 10)
	@IBOutlet weak var spark4: DSFSparklineBarGraphView!
	var spark4ds = DSFSparklineDataSource(windowSize: 30, range: -10 ... 10)

	@IBOutlet weak var dot1: DSFSparklineDotGraphView!
	var dot1ds = DSFSparklineDataSource(windowSize: 80, range: -10 ... 10)

	@IBOutlet weak var s1: DSFSparklineBarGraphView!
	var ds1 = DSFSparklineDataSource(range: -10 ... 10)
	@IBOutlet weak var s2: DSFSparklineBarGraphView!
	var ds2 = DSFSparklineDataSource(range: -10 ... 10)
	@IBOutlet weak var s3: DSFSparklineBarGraphView!
	var ds3 = DSFSparklineDataSource(range: -10 ... 10)
	@IBOutlet weak var s4: DSFSparklineBarGraphView!
	var ds4 = DSFSparklineDataSource(range: -10 ... 10)

	@IBOutlet weak var winLoss1: DSFSparklineWinLossGraphView!
	var wl1 = DSFSparklineDataSource(range: -1 ... 1)

	@IBOutlet weak var winLoss2: DSFSparklineWinLossGraphView!

	@IBOutlet weak var tabletView1: DSFSparklineTabletGraphView!
	@IBOutlet weak var tabletView2: DSFSparklineTabletGraphView!

	@IBOutlet weak var stacklineGraphView: DSFSparklineStackLineGraphView!
	var sl1 = DSFSparklineDataSource(range: 0 ... 10)

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.

		spark1.dataSource = spark1ds

		spark2.dataSource = spark2ds
		spark2ds.zeroLineValue = -7
		spark2ds.highlightRange = -3 ..< 3

		spark3.dataSource = spark3ds

		spark4.dataSource = spark4ds
		spark4ds.zeroLineValue = -5

		dot1.dataSource = dot1ds

		s1.dataSource = ds1
		s2.dataSource = ds2
		s3.dataSource = ds3
		s4.dataSource = ds4

		winLoss1.dataSource = wl1
		winLoss2.dataSource = wl1

		tabletView1.dataSource = wl1
		tabletView2.dataSource = wl1

		stacklineGraphView.dataSource = sl1

		self.addNewValue2()
	}

	var sinusoid: CGFloat = 0.00

	func addNewValue2() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
			guard let `self` = self else {
				return
			}

			_ = self.spark1ds.push(value: CGFloat.random(in: self.spark1ds.range!))
			_ = self.spark2ds.push(value: CGFloat.random(in: -10.0 ... 10.0))

			_ = self.spark3ds.push(value: CGFloat.random(in: -10.0 ... 10.0))

			let val = sin(self.sinusoid)
			self.sinusoid += 0.3

			_ = self.spark4ds.push(value: (val * 10.0))

			_ = self.dot1ds.push(value: CGFloat.random(in: -10.0 ... 10.0))

			_ = self.ds1.push(value: CGFloat.random(in: -10.0 ... 10.0))
			_ = self.ds2.push(value: CGFloat.random(in: -10.0 ... 10.0))
			_ = self.ds3.push(value: CGFloat.random(in: -10.0 ... 10.0))
			_ = self.ds4.push(value: CGFloat.random(in: -10.0 ... 10.0))

			_ = self.wl1.push(value: CGFloat(Int.random(in: -1 ... 1)))

			_ = self.sl1.push(value: CGFloat(Int.random(in: 0 ... 10)))


			self.addNewValue2()
		}
	}


}

