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
	var greenDataSource = DSFSparklineDataSource(range: -11 ... 11)

	@IBOutlet weak var red: DSFSparklineLineGraphView!
	var redDataSource = DSFSparklineDataSource(range: -45 ... 15)

	@IBOutlet weak var centeredRedDataSource: DSFSparklineLineGraphView!


	@IBOutlet weak var purple: DSFSparklineDotGraphView!
	var purpleDataSource = DSFSparklineDataSource(range: 0 ... 50)

	@IBOutlet weak var orange: DSFSparklineDotGraphView!
	var orangeDataSource = DSFSparklineDataSource(range: 0 ... 50)

	@IBOutlet weak var winLoss: DSFSparklineWinLossGraphView!
	var wlSource = DSFSparklineDataSource(range: -1 ... 1)

	@IBOutlet weak var pie1: DSFSparklinePieGraphView!
	@IBOutlet weak var pie2: DSFSparklinePieGraphView!
	@IBOutlet weak var pie3: DSFSparklinePieGraphView!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.

		winLoss.dataSource = wlSource

		let randWinLoss: [CGFloat] = (0 ..< 50).map { _ in
			return CGFloat(Int.random(in: -1 ... 1))
		}
		wlSource.set(values: randWinLoss)

		green.dataSource = greenDataSource
		red.dataSource = redDataSource
		centeredRedDataSource.dataSource = redDataSource

		purple.dataSource = purpleDataSource
		orange.dataSource = orangeDataSource

		pie1.animated = true
		pie1.animationDuration = 2.0
		pie1.dataSource = [1, 2, 3]

		pie2.animated = true
		pie2.animationDuration = 2.0
		pie2.dataSource = [3, 2, 1]

		pie3.animated = true
		pie3.animationDuration = 2.0
		pie3.dataSource = [1, 7, 4, 9]

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
