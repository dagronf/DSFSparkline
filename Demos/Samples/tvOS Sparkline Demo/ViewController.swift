//
//  ViewController.swift
//  tvOS Sparkline Demo
//
//  Created by Darren Ford on 23/12/19.
//

import UIKit

import DSFSparkline

class ViewController: UIViewController {
	@IBOutlet var green: DSFSparklineDataSourceView!
	var greenDataSource = DSFSparkline.DataSource(range: -11 ... 11)

	@IBOutlet var red: DSFSparklineLineGraphView!
	var redDataSource = DSFSparkline.DataSource(range: -45 ... 15)

	@IBOutlet weak var centeredRedDataSource: DSFSparklineLineGraphView!

	@IBOutlet var purple: DSFSparklineDotGraphView!
	var purpleDataSource = DSFSparkline.DataSource(range: 0 ... 50)

	@IBOutlet var orange: DSFSparklineDotGraphView!
	var orangeDataSource = DSFSparkline.DataSource(range: 0 ... 50)

	@IBOutlet var winLoss: DSFSparklineWinLossGraphView!
	var wlSource = DSFSparkline.DataSource(range: -1 ... 1)

	@IBOutlet var pie1: DSFSparklinePieGraphView!
	@IBOutlet var pie2: DSFSparklinePieGraphView!
	@IBOutlet var pie3: DSFSparklinePieGraphView!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.

		self.winLoss.dataSource = self.wlSource

		let randWinLoss: [CGFloat] = (0 ..< 50).map { _ in
			CGFloat(Int.random(in: -1 ... 1))
		}
		self.wlSource.set(values: randWinLoss)

		self.green.dataSource = self.greenDataSource
		self.red.dataSource = self.redDataSource
		self.centeredRedDataSource.dataSource = self.redDataSource

		self.purple.dataSource = self.purpleDataSource
		self.orange.dataSource = self.orangeDataSource

		self.pie1.animationStyle = AnimationStyle(duration: 2.0)
		self.pie1.dataSource = DSFSparkline.StaticDataSource([1, 2, 3])

		self.pie2.animationStyle = AnimationStyle(duration: 2.0)
		self.pie2.dataSource = DSFSparkline.StaticDataSource([3, 2, 1])

		self.pie3.animationStyle = AnimationStyle(duration: 2.0)
		self.pie3.dataSource = DSFSparkline.StaticDataSource([1, 7, 4, 9])

		self.updateWithNewValues()
	}

	func updateWithNewValues() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
			guard let `self` = self else { return }
			_ = self.greenDataSource.push(value: CGFloat.random(in: self.greenDataSource.range!))
			_ = self.redDataSource.push(value: CGFloat.random(in: -40 ... 10))
			_ = self.purpleDataSource.push(value: CGFloat.random(in: self.purpleDataSource.range!))
			_ = self.orangeDataSource.push(value: CGFloat.random(in: self.orangeDataSource.range!))

			_ = self.wlSource.push(value: CGFloat(Int.random(in: -1 ... 1)))

			self.updateWithNewValues()
		}
	}
}
