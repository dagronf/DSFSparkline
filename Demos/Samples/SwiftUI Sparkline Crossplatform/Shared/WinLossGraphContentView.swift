//
//  WinLossGraphContentView.swift
//  SwiftUI Demo
//
//  Created by Darren Ford on 26/1/21.
//

import SwiftUI
import DSFSparkline

func WinLossCreate() -> some View {
	return WinLossGraphContentView(
		leftDataSource: WinLossDataSource1,
		rightDataSource: WinLossDataSource2,	
		upDataSource: WinLossDataSource3)
}

struct ProductSales: Identifiable {
	var id: String { product }

	static let formatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .percent
		formatter.minimumIntegerDigits = 1
		formatter.maximumIntegerDigits = 3
		formatter.maximumFractionDigits = 3
		return formatter
	}()

	let product: String
	let q1: Double
	var q1s: String { ProductSales.formatter.string(for: q1 / 100) ?? "" }
	let q2: Double
	var q2s: String { ProductSales.formatter.string(for: q2 / 100) ?? "" }
	let q3: Double
	var q3s: String { ProductSales.formatter.string(for: q3 / 100) ?? "" }
	let q4: Double
	var q4s: String { ProductSales.formatter.string(for: q4 / 100) ?? "" }
	var wl: [CGFloat] { [q1, q2, q3, q4] }
}

struct WinLossGraphContentView: View {

	let leftDataSource: DSFSparkline.DataSource
	let rightDataSource: DSFSparkline.DataSource
	let upDataSource: DSFSparkline.DataSource

	@State private var sales: [ProductSales] = [
		ProductSales(product: "AAA-001", q1: 6, q2: -4, q3: 9.80, q4: 10.20),
		ProductSales(product: "BBB-002", q1: 12, q2: -11, q3: -10.6, q4: 5.8),
		ProductSales(product: "CCC-003", q1: -9, q2: 7, q3: 5.20, q4: 6.70),
		ProductSales(product: "DDD-004", q1: 5, q2: -9, q3: 1.80, q4: -5.90),
	]

	var body: some View {
		VStack(spacing: 8) {

			Text("Win/Loss")
				.font(.title2).bold()

			DSFSparklineWinLossGraphView.SwiftUI(
				dataSource: leftDataSource
			)
			.frame(height: 60)
			.padding(5)
			.border(Color.gray.opacity(0.2), width: 1)

			Text("Win/Loss/Tie")
				.font(.title2).bold()

			DSFSparklineWinLossGraphView.SwiftUI(
				dataSource: rightDataSource,
				winColor: .systemIndigo,
				lossColor: .systemTeal,
				tieColor: DSFColor.systemGray.withAlphaComponent(0.1),
				lineWidth: 3,
				barSpacing: 6
			)
			.frame(height: 60)
			.padding(5)
			.border(Color.gray.opacity(0.2), width: 1)

			Text("Win/Loss/Tie with center-line")
				.font(.title2).bold()

			DSFSparklineWinLossGraphView.SwiftUI(
				dataSource: upDataSource,
				winColor: .systemGreen,
				lossColor: .systemRed,
				tieColor: DSFColor.systemYellow.withAlphaComponent(0.2),
				barSpacing: 3,
				showZeroLine: true,
				zeroLineDefinition: DSFSparkline.ZeroLineDefinition(color: .systemGray)
			)
			.frame(width: 330.0, height: 34.0)
			.padding(5)
			.border(Color.gray.opacity(0.2), width: 1)

			Text("Product quarter")
				.font(.title2).bold()

			Table(sales) {
				TableColumn("Product", value: \.product)
					.alignment(.leading)
				TableColumn("Quarter 1") { product in
					Text(product.q1s)
				}
				.width(75)
				.alignment(.trailing)
				TableColumn("Quarter 2") { product in
					Text(product.q2s)
				}
				.width(75)
				.alignment(.trailing)
				TableColumn("Quarter 3") { product in
					Text(product.q3s)
				}
				.width(75)
				.alignment(.trailing)
				TableColumn("Quarter 4") { product in
					Text(product.q4s)
				}
				.width(75)
				.alignment(.trailing)
				TableColumn("win-loss") { product in
					DSFSparklineWinLossGraphView.SwiftUI(
						dataSource: .init(values: product.wl)
					)
					.frame(height: 25)
					.frame(minWidth: 150)
				}
				.width(150)
				.alignment(.center)
			}
			.frame(height: 250)
		}
		.padding()
	}
}

var WinLossDataSource1: DSFSparkline.DataSource = {
	let d = DSFSparkline.DataSource(windowSize: 10, range: -1.0 ... 1)
	d.push(values: [1, -1, 0, 1, -1, -1, 1, -1, 0, 1])
	return d
}()

var WinLossDataSource2: DSFSparkline.DataSource = {
	let d = DSFSparkline.DataSource(windowSize: 10, range: -1.0 ... 1.0)
	d.push(values: [20, 10, 0, -10, -20, -30, 40, 50, 0, 70])
	return d
}()

var WinLossDataSource3: DSFSparkline.DataSource = {
	let d = DSFSparkline.DataSource(windowSize: 20, range: -1 ... 1)
	d.push(values: [1, 1, 1, -1, 1, 0, -1, -1, 1, 1, 1, -1, -1, 1, 1, 0, -1, 1, 1, 1])
	return d
}()

struct WinLossGraphContentView_Previews: PreviewProvider {
	static var previews: some View {
		WinLossGraphContentView(leftDataSource: WinLossDataSource1,
										rightDataSource: WinLossDataSource2,
										upDataSource: WinLossDataSource3)
	}
}
