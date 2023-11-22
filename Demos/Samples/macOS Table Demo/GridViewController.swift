//
//  GridViewController.swift
//  macOS Table Demo
//
//  Created by Darren Ford on 27/12/19.
//

import Cocoa

import DSFSparkline

class GridViewController: NSViewController {
	@IBOutlet weak var grid: NSGridView!

	let sz = 32

	var dataSources: [[DSFSparkline.DataSource]] = []

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do view setup here.

		grid.removeColumn(at: 0)
		grid.removeColumn(at: 0)

		grid.removeRow(at: 0)
		grid.removeRow(at: 0)
		grid.removeRow(at: 0)

		(0 ... sz).forEach { row in
			let item = (0 ... sz).map { _ in
				DSFSparkline.DataSource(windowSize: 30, range: -1 ... 1)
			}
			dataSources.append(item)
		}

		(0 ... sz).forEach { row in
			let vs = (0 ... sz).map { column -> DSFSparklineLineGraphView in
				let i = DSFSparklineLineGraphView()
				i.zeroLineVisible = false
				i.graphColor = self.color(row: row, col: column)
				i.lineWidth = 0.5
				i.translatesAutoresizingMaskIntoConstraints = false
				i.addConstraint(NSLayoutConstraint(item: i, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 32))
				i.addConstraint(NSLayoutConstraint(item: i, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 32))

				i.dataSource = self.dataSources[row][column]

				let ranr: [CGFloat] = RandomArray(count: 30, range: -1 ... 1)
				self.dataSources[row][column].push(values: ranr)

				return i
			}

			self.grid.addColumn(with: vs)
		}

		self.updateWithNewValues()
	}

	private func lighter(_ color: NSColor) -> NSColor {
		var h: CGFloat = 0
		var s: CGFloat = 0
		var b: CGFloat = 0
		var a: CGFloat = 0

		let cl = color.usingColorSpace(.genericRGB)!

		cl.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
		return NSColor(calibratedHue: h,
							saturation: max(s + 0.3, 1.0),
							brightness: max(b + 0.3, 1.0), alpha: a)
	}

	func color(row: Int, col: Int) -> NSColor {

		// CMYK
		let xpos = CGFloat(col) / CGFloat(sz)
		let ypos = CGFloat(row) / CGFloat(sz)

		let c = hypot(xpos, ypos) / 1.414
		let m = hypot(1.0 - xpos, ypos) / 1.414
		let y = hypot(1.0 - xpos, 1.0 - ypos) / 1.414
		let k = hypot(xpos, 1.0 - ypos) / 1.414

		let color = NSColor(deviceCyan: c, magenta: m, yellow: y, black: k, alpha: 1.0)
		return self.lighter(color)
	}

	func updateWithNewValues() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
			guard let `self` = self else {
				return
			}

			(0 ... self.sz).forEach { row in
				(0 ... self.sz).forEach { column in
					_ = self.dataSources[row][column].push(value: CGFloat.random(in: -1 ... 1))
				}
			}

			self.updateWithNewValues()
		}
	}

}

/// Generate an array of random values for Swift value types that support random value generation
/// - Parameters:
///   - count: The number of random numbers to generate
///   - range: The range of values to generate
///
/// Example:
///
/// ```swift
/// let tenVals: [CGFloat] = RandomArray(count: 10, range: -10 ... 10)
/// ```
///
/// Note that the `[CGFloat]` in the definition is required, as explicit generic function instantiation isn't supported
/// in Swift.
func RandomArray<T>(count: UInt, range: ClosedRange<T>) -> Array<T> where T: BinaryFloatingPoint, T.RawSignificand : FixedWidthInteger {
   return (0 ..< count).map { _ in T.random(in: range) }
}
