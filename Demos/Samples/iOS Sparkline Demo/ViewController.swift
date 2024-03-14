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
	var spark1ds = DSFSparkline.DataSource(windowSize: 50, range: -10 ... 30)
	@IBOutlet var spark2: DSFSparklineLineGraphView!
	var spark2ds = DSFSparkline.DataSource(windowSize: 50, range: -12 ... 12)
	@IBOutlet var spark3: DSFSparklineBarGraphView!
	var spark3ds = DSFSparkline.DataSource(windowSize: 30, range: -10 ... 10)
	@IBOutlet var spark4: DSFSparklineBarGraphView!
	var spark4ds = DSFSparkline.DataSource(windowSize: 30, range: -10 ... 10)

	@IBOutlet var dot1: DSFSparklineDotGraphView!
	var dot1ds = DSFSparkline.DataSource(windowSize: 80, range: -10 ... 10)

	@IBOutlet var s1: DSFSparklineBarGraphView!
	var ds1 = DSFSparkline.DataSource(range: -10 ... 10)
	@IBOutlet var s2: DSFSparklineBarGraphView!
	var ds2 = DSFSparkline.DataSource(range: -10 ... 10)
	@IBOutlet var s3: DSFSparklineBarGraphView!
	var ds3 = DSFSparkline.DataSource(range: -10 ... 10)
	@IBOutlet var s4: DSFSparklineBarGraphView!
	var ds4 = DSFSparkline.DataSource(range: -10 ... 10)

	@IBOutlet var winLoss1: DSFSparklineWinLossGraphView!
	var wl1 = DSFSparkline.DataSource(range: -1 ... 1)

	@IBOutlet var winLoss2: DSFSparklineWinLossGraphView!

	@IBOutlet var tabletView1: DSFSparklineTabletGraphView!
	@IBOutlet var tabletView2: DSFSparklineTabletGraphView!

	@IBOutlet var stacklineGraphView: DSFSparklineStackLineGraphView!
	var sl1 = DSFSparkline.DataSource(range: 0 ... 10)

	@IBOutlet var stacklineGraphView2: DSFSparklineStackLineGraphView!

	@IBOutlet var pie0: DSFSparklinePieGraphView!
	@IBOutlet var pie1: DSFSparklinePieGraphView!
	@IBOutlet var pie2: DSFSparklinePieGraphView!
	@IBOutlet var pie3: DSFSparklinePieGraphView!
	@IBOutlet var pie4: DSFSparklinePieGraphView!


	@IBOutlet weak var attributedStringSupportLabel: UILabel!


	@IBOutlet weak var percentBar1: DSFSparklinePercentBarGraphView!
	@IBOutlet weak var percentBar2: DSFSparklinePercentBarGraphView!
	@IBOutlet weak var percentBar3: DSFSparklinePercentBarGraphView!


	override func viewDidLoad() {
		super.viewDidLoad()

		// Setup the inline attributed string
		self.configureAttributedString()

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

		let palette = DSFSparkline.Palette([
			DSFColor(red: 0.6, green: 0.6, blue: 1, alpha: 1),
			DSFColor(red: 0.4, green: 0.4, blue: 1, alpha: 1),
			DSFColor(red: 0.2, green: 0.2, blue: 1, alpha: 1),
			DSFColor(red: 0.0, green: 0.0, blue: 1, alpha: 1),
		])

		self.pie0.palette = .sharedGrays
		self.pie0.dataSource = DSFSparkline.StaticDataSource([5, 5, 5, 5, 5])

		self.pie1.palette = palette
		self.pie2.palette = palette

		self.percentBar1.animationStyle = DSFSparkline.AnimationStyle()
		self.percentBar2.animationStyle = DSFSparkline.AnimationStyle()
		self.percentBar3.animationStyle = DSFSparkline.AnimationStyle()

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

	func configureAttributedString() {
		let source = DSFSparkline.DataSource(values: [4, 1, 8, 7, 5, 9, 3], range: 0 ... 10)

		let baseColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.033,  0.277, 0.650, 1.000])!
		let primaryStroke = baseColor // (gray: 0.0, alpha: 0.3))
		let primaryFill = DSFSparkline.Fill.Color(baseColor.copy(alpha: 0.3)!)

		let bitmap = DSFSparklineSurface.Bitmap()   // Create a bitmap surface
		let line = DSFSparklineOverlay.Line()       // Create a line overlay
		line.strokeWidth = 1
		line.primaryStrokeColor = primaryStroke
		line.primaryFill = primaryFill
		line.dataSource = source                    // Assign the datasource to the overlay
		bitmap.addOverlay(line)                     // And add the overlay to the surface.

		let attr = bitmap.attributedString(size: CGSize(width: 40, height: 18), scale: 2)!
		let message = NSMutableAttributedString(string: "Inlined ")
		message.append(attr)
		message.append(NSAttributedString(string: " line graph"))

		self.attributedStringSupportLabel.attributedText = message
	}


	@IBAction func updateValues(_: Any) {
		let v1 = UInt.random(count: 4, range: 1 ... 10).map { CGFloat($0) }
		self.pie1.dataSource = DSFSparkline.StaticDataSource(v1)
		self.pie2.dataSource = DSFSparkline.StaticDataSource(v1)
		let v2 = UInt.random(count: 4, range: 1 ... 10).map { CGFloat($0) }
		self.pie3.dataSource = DSFSparkline.StaticDataSource(v2)
		self.pie4.dataSource = DSFSparkline.StaticDataSource(v2)
	}

	@IBAction func newValuesForPercentBar(_ sender: Any) {
		self.percentBar1.value = CGFloat(drand48())
		self.percentBar2.value = CGFloat(drand48())
		self.percentBar3.value = CGFloat(drand48())
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
