//
//  ViewController.swift
//  macOS Table Demo
//
//  Created by Darren Ford on 27/12/19.
//

import Cocoa

import DSFSparkline

class ViewController: NSViewController {

	@IBOutlet weak var tableView: NSTableView!

	let count = 200

	var inDataSources: [DSFSparkline.DataSource] = []
	var outDataSources: [DSFSparkline.DataSource] = []
	var cpuDataSources: [DSFSparkline.DataSource] = []

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.

		(0 ..< count).forEach { _ in
			inDataSources.append(DSFSparkline.DataSource(windowSize: 50, range: -1.5 ... 1.5))
			outDataSources.append(DSFSparkline.DataSource(windowSize: 50, range: -1.5 ... 1.5))

			cpuDataSources.append(DSFSparkline.DataSource(windowSize: 100, range: 0 ... 100))
		}

		self.tableView.reloadData()

		self.updateWithNewValues()
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}

	func updateWithNewValues() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
			guard let `self` = self else {
				return
			}

			self.inDataSources.forEach {
				 _ = $0.push(value: CGFloat.random(in: -1 ... 1))
			}
			self.outDataSources.forEach {
				 _ = $0.push(value: CGFloat.random(in: -1 ... 1))
			}
			self.cpuDataSources.forEach {
				 _ = $0.push(value: CGFloat.random(in: 0 ... 100))
			}
			self.updateWithNewValues()
		}
	}


}

class Graphico: NSTableCellView {
	@IBOutlet weak var sparkline: DSFSparklineLineGraphView!
}

class Graphicodot: NSTableCellView {
	@IBOutlet weak var sparkline: DSFSparklineDotGraphView!
}


extension ViewController: NSTableViewDataSource, NSTableViewDelegate {

	func numberOfRows(in tableView: NSTableView) -> Int {
		return count
	}

	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		if tableColumn?.identifier == NSUserInterfaceItemIdentifier("ident"),
			let tcv = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("identifier"), owner: self) as? NSTableCellView {
			tcv.textField?.stringValue = "Input \(row)"
			return tcv
		}
		else if tableColumn?.identifier == NSUserInterfaceItemIdentifier("ingraph"),
			let tcv = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("ingraph"), owner: self) as? Graphico {
			tcv.sparkline.dataSource = inDataSources[row]
			return tcv
		}
		else if tableColumn?.identifier == NSUserInterfaceItemIdentifier("outgraph"),
			let tcv = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("outgraph"), owner: self) as? Graphico {
			tcv.sparkline.dataSource = outDataSources[row]
			return tcv
		}
		else if tableColumn?.identifier == NSUserInterfaceItemIdentifier("cpuGraph"),
			let tcv = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("cpuGraph"), owner: self) as? Graphicodot {
			tcv.sparkline.dataSource = cpuDataSources[row]
			return tcv
		}
		return nil
	}
}
