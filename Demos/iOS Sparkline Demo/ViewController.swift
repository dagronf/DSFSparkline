//
//  ViewController.swift
//  iOS Sparkline Demo
//
//  Created by Darren Ford on 23/12/19.
//

import UIKit

import DSFSparkline

class ViewController: UIViewController {
	@IBOutlet var spark1: DSFSparklineLineGraphView!
	@IBOutlet var spark12: DSFSparklineLineGraphView!
	var spark1ds = DSFSparklineDataSource(windowSize: 50, range: -10 ... 30)
	@IBOutlet var spark2: DSFSparklineLineGraphView!
	var spark2ds = DSFSparklineDataSource(windowSize: 50, range: -12 ... 12)
	@IBOutlet var spark3: DSFSparklineBarGraphView!
	var spark3ds = DSFSparklineDataSource(windowSize: 30, range: -10 ... 10)
	@IBOutlet var spark4: DSFSparklineBarGraphView!
	var spark4ds = DSFSparklineDataSource(windowSize: 30, range: -10 ... 10)

	@IBOutlet var dot1: DSFSparklineDotGraphView!
	var dot1ds = DSFSparklineDataSource(windowSize: 80, range: -10 ... 10)

	@IBOutlet var s1: DSFSparklineBarGraphView!
	var ds1 = DSFSparklineDataSource(range: -10 ... 10)
	@IBOutlet var s2: DSFSparklineBarGraphView!
	var ds2 = DSFSparklineDataSource(range: -10 ... 10)
	@IBOutlet var s3: DSFSparklineBarGraphView!
	var ds3 = DSFSparklineDataSource(range: -10 ... 10)
	@IBOutlet var s4: DSFSparklineBarGraphView!
	var ds4 = DSFSparklineDataSource(range: -10 ... 10)

	@IBOutlet var winLoss1: DSFSparklineWinLossGraphView!
	var wl1 = DSFSparklineDataSource(range: -1 ... 1)

	@IBOutlet var winLoss2: DSFSparklineWinLossGraphView!

	@IBOutlet var tabletView1: DSFSparklineTabletGraphView!
	@IBOutlet var tabletView2: DSFSparklineTabletGraphView!

	@IBOutlet var stacklineGraphView: DSFSparklineStackLineGraphView!
	var sl1 = DSFSparklineDataSource(range: 0 ... 10)

	@IBOutlet var stacklineGraphView2: DSFSparklineStackLineGraphView!

	@IBOutlet var pie0: DSFSparklinePieGraphView!
	@IBOutlet var pie1: DSFSparklinePieGraphView!
	@IBOutlet var pie2: DSFSparklinePieGraphView!
	@IBOutlet var pie3: DSFSparklinePieGraphView!
	@IBOutlet var pie4: DSFSparklinePieGraphView!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.

		self.spark1.dataSource = self.spark1ds
		self.spark12.dataSource = self.spark1ds

		self.spark2.dataSource = self.spark2ds
		self.spark2ds.zeroLineValue = 0

		self.spark3.dataSource = self.spark3ds

		self.spark4.dataSource = self.spark4ds
		self.spark4ds.zeroLineValue = -5

		self.dot1.dataSource = self.dot1ds

		self.s1.dataSource = self.ds1
		self.s2.dataSource = self.ds2
		self.s3.dataSource = self.ds3
		self.s4.dataSource = self.ds4

		self.winLoss1.dataSource = self.wl1
		self.winLoss2.dataSource = self.wl1

		self.tabletView1.dataSource = self.wl1
		self.tabletView2.dataSource = self.wl1

		self.sl1.zeroLineValue = 5
		self.stacklineGraphView.dataSource = self.sl1
		self.stacklineGraphView2.dataSource = self.sl1

		let palette = DSFSparklinePalette(
			[
				DSFColor(red: 0.6, green: 0.6, blue: 1, alpha: 1),
				DSFColor(red: 0.4, green: 0.4, blue: 1, alpha: 1),
				DSFColor(red: 0.2, green: 0.2, blue: 1, alpha: 1),
				DSFColor(red: 0.0, green: 0.0, blue: 1, alpha: 1),
			])

		self.pie0.palette = .sharedGrays
		self.pie0.dataSource = [5, 5, 5, 5, 5]

		self.pie1.palette = palette
		self.pie2.palette = palette

		self.updateValues(self)

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

			_ = self.spark4ds.push(value: val * 10.0)

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

	@IBAction func updateValues(_: Any) {
		let v1 = UInt.random(count: 4, range: 1 ... 10).map { CGFloat($0) }
		self.pie1.dataSource = v1
		self.pie2.dataSource = v1
		let v2 = UInt.random(count: 4, range: 1 ... 10).map { CGFloat($0) }
		self.pie3.dataSource = v2
		self.pie4.dataSource = v2

		let im = self.pie1.snapshot()
		Swift.print(im)

	}
}

extension CGFloat {
	static func random(count: UInt, range: ClosedRange<CGFloat>) -> [CGFloat] {
		return (0 ..< count).map { _ in CGFloat.random(in: range) }
	}
}

extension UInt {
	static func random(count: UInt, range: ClosedRange<UInt>) -> [UInt] {
		return (0 ..< count).map { _ in UInt.random(in: range) }
	}
}
