//
//  ViewController.swift
//  macOS Sparkline Demo
//
//  Created by Darren Ford on 23/12/19.
//

import Cocoa

import DSFSparkline

class ViewController: NSViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}


	@IBOutlet weak var sparkCrash: DSFSparklineDataSourceView!
	var sparkCrashDatasource = DSFSparkline.DataSource(range: -10 ... 10)

	@IBOutlet weak var sparkCrash2: DSFSparklineDataSourceView!
	var sparkCrash2Datasource = DSFSparkline.DataSource(range: -13 ... 13)

	@IBOutlet weak var sparkDeprecation: DSFSparklineDataSourceView!
	var sparkDeprecationDatasource = DSFSparkline.DataSource(range: -10 ... 10)

	@IBOutlet weak var sparkIntervention: DSFSparklineDataSourceView!
	var sparkInterventionDatasource = DSFSparkline.DataSource()

	@IBOutlet weak var sparkNetworkError: DSFSparklineDataSourceView!
	var sparkNetworkErrorDatasource = DSFSparkline.DataSource(range: -10 ... 30)

	@IBOutlet weak var sparkTransmissionError: DSFSparklineDataSourceView!
	var sparkTransmissionErrorDatasource = DSFSparkline.DataSource(range: 0 ... 1)

	@IBOutlet weak var sparkPacketRejection: DSFSparklineWinLossGraphView!
	var sparkPacketRejectionDatasource = DSFSparkline.DataSource(windowSize: 10, range: -1 ... 1)

	@IBOutlet weak var stackLineView: DSFSparklineStackLineGraphView!
	var stackLineViewDatasource = DSFSparkline.DataSource(range: 0 ... 10)



	@IBOutlet weak var fakeSparkCpu1: DSFSparklineDataSourceView!
	var fakeSparkCpu1Datasource = DSFSparkline.DataSource(range: 0 ... 1, zeroLineValue: 0.8)
	@IBOutlet weak var fakeSparkCpu2: DSFSparklineDataSourceView!
	var fakeSparkCpu2Datasource = DSFSparkline.DataSource(range: 0 ... 1, zeroLineValue: 0.8)
	@IBOutlet weak var fakeSparkCpu3: DSFSparklineDataSourceView!
	var fakeSparkCpu3Datasource = DSFSparkline.DataSource(range: 0 ... 1, zeroLineValue: 0.8)
	@IBOutlet weak var fakeSparkCpu4: DSFSparklineDataSourceView!
	var fakeSparkCpu4Datasource = DSFSparkline.DataSource(range: 0 ... 1, zeroLineValue: 0.8)
	@IBOutlet weak var fakeSparkCpu5: DSFSparklineDataSourceView!
	var fakeSparkCpu5Datasource = DSFSparkline.DataSource(range: 0 ... 1, zeroLineValue: 0.8)

	@IBOutlet weak var sparkStaticData: DSFSparklineLineGraphView!
	var sparkStaticDatasource = DSFSparkline.DataSource(range: -20 ... 50)

	@IBOutlet weak var cpuStack: NSStackView!

	@IBOutlet weak var cpuDotView: DSFSparklineDotGraphView!
	var cpuDotViewDatasource = DSFSparkline.DataSource(windowSize: 100, range: 0 ... 100)

	@IBOutlet weak var cpu2DotView: DSFSparklineDotGraphView!
	var cpu2DotViewDatasource = DSFSparkline.DataSource(windowSize: 100, range: 0 ... 100)

	let cpuUsage = MyCpuUsage()

	@IBOutlet weak var attributedStringTextField: NSTextField!

	override func viewWillAppear() {
		super.viewWillAppear()

		self.configureAttributedString()

		self.cpuStack.translatesAutoresizingMaskIntoConstraints = false

		cpuUsage.delegate = self

		sparkCrash.dataSource = sparkCrashDatasource

		sparkCrash2.dataSource = sparkCrash2Datasource
		sparkCrash2Datasource.zeroLineValue = -5

		sparkDeprecation.dataSource = sparkDeprecationDatasource
		sparkIntervention.dataSource = sparkInterventionDatasource
		sparkNetworkError.dataSource = sparkNetworkErrorDatasource
		sparkTransmissionError.dataSource = sparkTransmissionErrorDatasource

		sparkPacketRejectionDatasource.windowSize = 20
		sparkPacketRejection.dataSource = sparkPacketRejectionDatasource

		stackLineView.dataSource = stackLineViewDatasource
		//stackLineView.highlightRangeDefinition?.range = 3 ..< 7
		stackLineView.highlightRangeVisible = true

		fakeSparkCpu1.dataSource = fakeSparkCpu1Datasource
		fakeSparkCpu2.dataSource = fakeSparkCpu2Datasource
		fakeSparkCpu3.dataSource = fakeSparkCpu3Datasource
		fakeSparkCpu4.dataSource = fakeSparkCpu4Datasource
		fakeSparkCpu5.dataSource = fakeSparkCpu5Datasource

		cpuDotView.dataSource = cpuDotViewDatasource
		cpu2DotView.dataSource = cpu2DotViewDatasource

		sparkStaticData.dataSource = sparkStaticDatasource
		sparkStaticDatasource.set(values: (0 ... 10).map { _ in
			CGFloat.random(in: -20.0 ... 50.0)
		})

		self.updateWithNewValues()

		cpuUsage.updateInfo(Timer())
	}

	func updateWithNewValues() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
			guard let `self` = self else {
				return
			}

			let cr = CGFloat.random(in: -10.0 ... 10.0)
			_ = self.sparkCrashDatasource.push(value: cr)
			_ = self.sparkCrash2Datasource.push(value: cr)

			_ = self.sparkDeprecationDatasource.push(value: CGFloat.random(in: -10.0 ... 10.0))
			_ = self.sparkInterventionDatasource.push(value: CGFloat.random(in: -10.0 ... 10.0))
			_ = self.sparkNetworkErrorDatasource.push(value: CGFloat.random(in: -10.0 ... 30.0))
			_ = self.sparkTransmissionErrorDatasource.push(value: CGFloat.random(in: 0 ... 1))

			_ = self.sparkPacketRejectionDatasource.push(value: CGFloat(Int.random(in: -1 ... 1)))

			_ = self.stackLineViewDatasource.push(value: CGFloat(Int.random(in: 0 ... 10)))


			/////

			_ = self.fakeSparkCpu1Datasource.push(value: CGFloat.random(in: 0 ... 1))
			_ = self.fakeSparkCpu2Datasource.push(value: CGFloat.random(in: 0 ... 1))
			_ = self.fakeSparkCpu3Datasource.push(value: CGFloat.random(in: 0 ... 1))
			_ = self.fakeSparkCpu4Datasource.push(value: CGFloat.random(in: 0 ... 1))
			_ = self.fakeSparkCpu5Datasource.push(value: CGFloat.random(in: 0 ... 1))

			_ = self.cpuDotViewDatasource.push(value: CGFloat.random(in: 0 ... 100))
			_ = self.cpu2DotViewDatasource.push(value: CGFloat.random(in: 0 ... 100))

			self.updateWithNewValues()
		}
	}

	var cpuDataSources: [DSFSparkline.DataSource] = []

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

		self.attributedStringTextField.attributedStringValue = message
	}

}


extension ViewController: CPUDelegate {
	func cpuUsage(usage: [Float]) {
		DispatchQueue.main.async { [weak self] in
			self?.updateOnMainThread(usage: usage)
		}
	}

	func updateOnMainThread(usage: [Float]) {

		if cpuDataSources.count == 0 {
			self.cpuStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
			cpuDataSources.removeAll()

			usage.forEach { _ in
				let cpu = DSFSparklineBarGraphView(frame: CGRect(x: 0, y: 0, width: cpuStack.frame.width, height: 32))
				let ds = DSFSparkline.DataSource(range: 0 ... 100)
				ds.windowSize = 30
				cpu.dataSource = ds
				self.cpuDataSources.append(ds)

				cpu.translatesAutoresizingMaskIntoConstraints = false
				cpu.addConstraint(NSLayoutConstraint(item: cpu, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 48))
				cpu.graphColor = .systemBlue
				cpu.isHidden = false
				cpu.barSpacing = 1
				self.cpuStack.addArrangedSubview(cpu)

				let box = NSBox(frame: NSRect(x: 0, y: 0, width: 20, height: 1))
				box.translatesAutoresizingMaskIntoConstraints = false
				box.boxType = .separator
				self.cpuStack.addArrangedSubview(box)
			}
		}

		usage.enumerated().forEach { (offset, element) in
			_ = cpuDataSources[offset].push(value: CGFloat(element * 100.0))
		}
	}
}
