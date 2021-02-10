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


	@IBOutlet weak var sparkCrash: DSFSparklineView!
	var sparkCrashDatasource = DSFSparklineDataSource(range: -10 ... 10)

	@IBOutlet weak var sparkCrash2: DSFSparklineView!
	var sparkCrash2Datasource = DSFSparklineDataSource(range: -13 ... 13)

	@IBOutlet weak var sparkDeprecation: DSFSparklineView!
	var sparkDeprecationDatasource = DSFSparklineDataSource(range: -10 ... 10)

	@IBOutlet weak var sparkIntervention: DSFSparklineView!
	var sparkInterventionDatasource = DSFSparklineDataSource()

	@IBOutlet weak var sparkNetworkError: DSFSparklineView!
	var sparkNetworkErrorDatasource = DSFSparklineDataSource(range: -10 ... 30)

	@IBOutlet weak var sparkTransmissionError: DSFSparklineView!
	var sparkTransmissionErrorDatasource = DSFSparklineDataSource(range: 0 ... 1)

	@IBOutlet weak var fakeSparkCpu1: DSFSparklineView!
	var fakeSparkCpu1Datasource = DSFSparklineDataSource(range: 0 ... 1, zeroLineValue: 0.8)
	@IBOutlet weak var fakeSparkCpu2: DSFSparklineView!
	var fakeSparkCpu2Datasource = DSFSparklineDataSource(range: 0 ... 1, zeroLineValue: 0.8)
	@IBOutlet weak var fakeSparkCpu3: DSFSparklineView!
	var fakeSparkCpu3Datasource = DSFSparklineDataSource(range: 0 ... 1, zeroLineValue: 0.8)
	@IBOutlet weak var fakeSparkCpu4: DSFSparklineView!
	var fakeSparkCpu4Datasource = DSFSparklineDataSource(range: 0 ... 1, zeroLineValue: 0.8)
	@IBOutlet weak var fakeSparkCpu5: DSFSparklineView!
	var fakeSparkCpu5Datasource = DSFSparklineDataSource(range: 0 ... 1, zeroLineValue: 0.8)

	@IBOutlet weak var sparkStaticData: DSFSparklineLineGraphView!
	var sparkStaticDatasource = DSFSparklineDataSource(range: -20 ... 50)

	@IBOutlet weak var cpuStack: NSStackView!

	@IBOutlet weak var cpuDotView: DSFSparklineDotGraphView!
	var cpuDotViewDatasource = DSFSparklineDataSource(windowSize: 100, range: 0 ... 100)

	@IBOutlet weak var cpu2DotView: DSFSparklineDotGraphView!
	var cpu2DotViewDatasource = DSFSparklineDataSource(windowSize: 100, range: 0 ... 100)


	let cpuUsage = MyCpuUsage()

	override func viewWillAppear() {
		super.viewWillAppear()

		self.cpuStack.translatesAutoresizingMaskIntoConstraints = false

		cpuUsage.delegate = self

		sparkCrash.dataSource = sparkCrashDatasource

		sparkCrash2.dataSource = sparkCrash2Datasource
		sparkCrash2Datasource.zeroLineValue = -5

		sparkDeprecation.dataSource = sparkDeprecationDatasource
		sparkIntervention.dataSource = sparkInterventionDatasource
		sparkNetworkError.dataSource = sparkNetworkErrorDatasource
		sparkTransmissionError.dataSource = sparkTransmissionErrorDatasource

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

	var cpuDataSources: [DSFSparklineDataSource] = []

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
				let cpu = DSFSparklineBarGraphView.init(frame: CGRect(x: 0, y: 0, width: cpuStack.frame.width, height: 32))
				let ds = DSFSparklineDataSource(range: 0 ... 100)
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
