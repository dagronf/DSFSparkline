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

	@IBOutlet weak var red: DSFSparklineLineGraph!
	var redDataSource = DSFSparklineDataSource(range: -21 ... 11)

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.

		green.dataSource = greenDataSource
		red.dataSource = redDataSource

		addNewValue2()

	}
	
	func addNewValue2() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
			_ = self?.greenDataSource.push(value: CGFloat.random(in: -10.0 ... 10.0))
			_ = self?.redDataSource.push(value: CGFloat.random(in: -15.0 ... 10.0))

			self?.addNewValue2()
		}
	}

}

