//
//  ContentView.swift
//  Shared
//
//  Created by Darren Ford on 27/1/21.
//

import DSFSparkline
import SwiftUI

struct UserResults {
	let name: String
	var values: [Int]

	let dataSource = DSFSparkline.DataSource(windowSize: 5)

	init(name: String, values: [Int]) {
		self.name = name
		self.values = values
		self.dataSource.set(values: self.values.map { CGFloat($0) })
	}
}

struct SalesResult {
	let name: String
	var values: [CGFloat]
	var maximumTotal: CGFloat

	init(name: String, values: [CGFloat], maximumTotal: CGFloat) {
		self.name = name
		self.values = values
		self.maximumTotal = maximumTotal
	}
}

struct ReportView: View {
	static func Make() -> ReportView {
		return ReportView()
	}

	var gridItems1: [GridItem] = [
		GridItem(.fixed(35), spacing: 2),
		GridItem(.fixed(35), spacing: 2),
		GridItem(.fixed(35), spacing: 2),
		GridItem(.fixed(35), spacing: 2),
		GridItem(.fixed(35), spacing: 2),
		GridItem(.fixed(35), spacing: 2),
	]

	let userItems1: [UserResults] = [
		UserResults(name: "Aiden", values: [90, 120, 110, 130, 115]),
		UserResults(name: "Ethan", values: [100, 95, 115, 120, 118]),
		UserResults(name: "Jackson", values: [120, 125, 140, 130, 135]),
		UserResults(name: "Lucas", values: [118, 120, 125, 128, 135]),
		UserResults(name: "Noah", values: [130, 130, 125, 120, 90]),
	]

	var gridItems2: [GridItem] = [
		GridItem(.fixed(35), spacing: 2),
		GridItem(.fixed(35), spacing: 2),
		GridItem(.fixed(35), spacing: 2),
		GridItem(.fixed(35), spacing: 2),
		GridItem(.fixed(35), spacing: 2),
		GridItem(.fixed(35), spacing: 2),
	]

	let userItems2: [UserResults] = [
		UserResults(name: "Aiden", values: [1, 1, -1, 1, -1, 1, 1, 1]),
		UserResults(name: "Ethan", values: [1, 1, -1, 1, 1, -1, 1, -1]),
		UserResults(name: "Jackson", values: [-1, 1, 1, -1, -1, 1, 1, 1]),
		UserResults(name: "Lucas", values: [1, -1, -1, 1, 1, -1, -1, 1]),
		UserResults(name: "Noah", values: [-1, 1, 1, 1, -1, 1, 1, 1]),
	]

	let salesItems: [SalesResult] = [
		SalesResult(name: "Aiden", values: [120, 200, 0, 270], maximumTotal: 1000),
		SalesResult(name: "Ethan", values: [300, 400, 100, 90], maximumTotal: 1000),
		SalesResult(name: "Jackson", values: [100, 140, 90, 110], maximumTotal: 1000),
		SalesResult(name: "Lucas", values: [250, 250, 100, 100], maximumTotal: 1000),
		SalesResult(name: "Noah", values: [300, 100, 200, 270], maximumTotal: 1000),
	]

	func sparklineAttributedString() -> NSAttributedString {
		let source = DSFSparkline.DataSource(values: [4, 1, 8, 7, 5, 9, 3], range: 0 ... 10)

		let baseColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.033, 0.277, 0.650, 1.000])!
		let primaryStroke = baseColor // (gray: 0.0, alpha: 0.3))
		let primaryFill = DSFSparkline.Fill.Color(baseColor.copy(alpha: 0.3)!)

		let bitmap = DSFSparklineSurface.Bitmap() // Create a bitmap surface
		let line = DSFSparklineOverlay.Line() // Create a line overlay
		line.strokeWidth = 1
		line.primaryStrokeColor = primaryStroke
		line.primaryFill = primaryFill
		line.dataSource = source // Assign the datasource to the overlay
		bitmap.addOverlay(line) // And add the overlay to the surface.

		let attr = bitmap.attributedString(size: CGSize(width: 40, height: 18), scale: 2)!
		let message = NSMutableAttributedString(string: "Inlined - ")
		message.append(attr)
		message.append(NSAttributedString(string: " - line graph"))

		message.addAttributes([.foregroundColor: DSFColor.primaryTextColor], range: NSRange(location: 0, length: message.length))

		return message
	}

	var body: some View {
		VStack {
			ReportHeaderView(attrString: self.sparklineAttributedString())
				.padding(EdgeInsets(top: 16, leading: 0, bottom: 25, trailing: 0))
			
			ReportExamResults(gridItems1: self.gridItems1, userItems1: self.userItems1)
				.frame(maxWidth: .infinity)
			
			ReportTeamWinLosses(gridItems2: self.gridItems2, userItems2: self.userItems2)
				.frame(maxWidth: .infinity)
			
			ReportTeamSales(gridItems2: self.gridItems2, salesItems: self.salesItems)
				.frame(maxWidth: .infinity)
		}
	}
}

struct ReportHeaderView: View {
	let attrString: NSAttributedString
	var body: some View {
		VStack {
			AttributedText(attrString)
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.padding(20)

			HStack {
				Text("NASDAQ Feb 2020 -> Feb 2021").frame(width: 300)
				DSFSparklineLineGraphView.SwiftUI(dataSource: NasdaqFeb2020Feb2021DataSource,
															 graphColor: DSFColor.systemRed,
															 lineWidth: 0.5)
					.frame(width: 75, height: 20)
			}
			HStack {
				Text("Gold Feb 2020 -> Feb 2021").frame(width: 300)
				DSFSparklineLineGraphView.SwiftUI(dataSource: GoldFeb2020Feb2021DataSource,
															 graphColor: DSFColor.systemGreen,
															 lineWidth: 0.5,
															 centeredAtZeroLine: true,
															 lowerGraphColor: DSFColor.systemRed)
					.frame(width: 75, height: 20)
			}
		}
	}
}

struct ReportExamResults: View {

	let gridItems1: [GridItem]
	let userItems1: [UserResults]

	var body: some View {
		VStack {
			Text("Exam Results")

			LazyHGrid(rows: gridItems1) {
				ForEach(0 ..< 5, id: \.self) { number in
					HStack {
						Text(userItems1[number].name)
							.frame(width: 80, alignment: .leading)
						ForEach(0 ..< 5, id: \.self) { count in
							Text("\(userItems1[number].values[count])")
								.frame(width: 30, alignment: .center)
						}
						DSFSparklineLineGraphView.SwiftUI(
							dataSource: userItems1[number].dataSource,
							graphColor: DSFColor.systemBlue,
							lineShading: false
						)
						.frame(width: 120)
					}
					.padding(8)
					.background(number % 2 == 0 ? Color(Color.RGBColorSpace.sRGB, red: 0, green: 0, blue: 0, opacity: 0.1) : Color.clear)
				}
			}
		}
	}
}

struct ReportTeamWinLosses: View {

	let gridItems2: [GridItem]
	let userItems2: [UserResults]

	var body: some View {
		VStack {
			Text("Team Wins/Losses")

			LazyHGrid(rows: gridItems2) {
				ForEach(0 ..< 5, id: \.self) { number in
					HStack {
						Text(userItems2[number].name)
							.frame(width: 80, alignment: .leading)
						ForEach(0 ..< 8, id: \.self) { count in
							Text("\(userItems2[number].values[count])")
								.frame(width: 25, alignment: .center)
						}
						DSFSparklineWinLossGraphView.SwiftUI(
							dataSource: userItems2[number].dataSource,
							barSpacing: 3,
							showZeroLine: true,
							zeroLineDefinition: .init(color: .systemGray,
															  lineWidth: 1,
															  lineDashStyle: [1, 1])
						)
						.frame(width: 120)
						DSFSparklineTabletGraphView.SwiftUI(
							dataSource: userItems2[number].dataSource,
							barSpacing: 2
						)
						.frame(width: 200, height: 12)
					}
					.padding(4)
					.background(number % 2 == 0 ? Color(Color.RGBColorSpace.sRGB, red: 0, green: 0, blue: 0, opacity: 0.1) : Color.clear)
				}
			}
		}
	}
}

struct ReportTeamSales: View {

	let gridItems2: [GridItem]
	let salesItems: [SalesResult]

	var body: some View {
		VStack {
			Text("Team Sales")

			LazyHGrid(rows: gridItems2) {
				ForEach(0 ..< 5, id: \.self) { number in
					HStack(spacing: 10) {
						Text(salesItems[number].name)
							.frame(width: 80, alignment: .leading)
						ForEach(0 ..< 4, id: \.self) { count in
							Text("\(salesItems[number].values[count], specifier: "%.2f")")
								.frame(width: 60, alignment: .trailing)
						}

						DSFSparklineLineGraphView.SwiftUI(
							dataSource: DSFSparkline.DataSource(values: salesItems[number].values),
							graphColor: DSFColor.systemBlue,
							lineShading: false,
							markerSize: 6
						)
						.frame(width: 120)

						DSFSparklinePieGraphView.SwiftUI(
							dataSource: DSFSparkline.StaticDataSource(salesItems[number].values)
						)
						.frame(width: 28, height: 28)

						DSFSparklineDataBarGraphView.SwiftUI(
							dataSource: DSFSparkline.StaticDataSource(salesItems[number].values),
							maximumTotalValue: salesItems[number].maximumTotal,
							unsetColor: DSFColor.black.withAlphaComponent(0.2)
						)
						.frame(width: 120)
					}
					.padding(4)
					.background(number % 2 == 0 ? Color(Color.RGBColorSpace.sRGB, red: 0, green: 0, blue: 0, opacity: 0.1) : Color.clear)
				}
			}
		}
	}
}


struct ReportView_Previews: PreviewProvider {
	static var previews: some View {
		ReportView()
	}
}

let NasdaqFeb2020Feb2021DataSource = DSFSparkline.DataSource(values: NasdaqFeb2020Feb2021)
let NasdaqFeb2020Feb2021: [CGFloat] = [
	8965.61,
	8980.78,
	8566.48,
	8567.37,
	8952.16,
	8684.08,
	9018.08,
	8738.58,
	8575.62,
	7950.68,
	8344.25,
	7952.04,
	7201.79,
	7874.87,
	6904.58,
	7334.77,
	6989.83,
	7150.58,
	6879.52,
	6860.66,
	7417.85,
	7384.29,
	7797.54,
	7502.37,
	7774.14,
	7700.10,
	7360.58,
	7487.31,
	7373.08,
	7913.24,
	7887.25,
	8090.89,
	8153.58,
	8192.41,
	8515.74,
	8393.17,
	8532.36,
	8650.13,
	8560.73,
	8263.23,
	8495.37,
	8494.75,
	8634.51,
	8730.16,
	8607.73,
	8914.70,
	8889.54,
	8604.95,
	8710.70,
	8809.12,
	8854.38,
	8979.66,
	9121.32,
	9192.33,
	9002.54,
	8863.16,
	8943.71,
	9014.55,
	9234.83,
	9185.09,
	9375.78,
	9284.87,
	9324.58,
	9340.21,
	9412.36,
	9368.99,
	9489.87,
	9552.04,
	9608.37,
	9682.91,
	9615.80,
	9814.08,
	9924.75,
	9953.75,
	10020.34,
	9492.73,
	9588.80,
	9726.01,
	9895.87,
	9910.53,
	9943.04,
	9946.12,
	10056.48,
	10131.37,
	9909.16,
	10017.00,
	9757.21,
	9874.15,
	10058.76,
	10154.62,
	10207.62,
	10433.65,
	10343.88,
	10492.50,
	10547.75,
	10617.44,
	10390.83,
	10488.58,
	10550.49,
	10473.83,
	10503.19,
	10767.08,
	10680.36,
	10706.12,
	10461.41,
	10363.17,
	10536.26,
	10402.08,
	10542.94,
	10587.80,
	10745.26,
	10902.79,
	10941.16,
	10998.40,
	11108.07,
	11010.98,
	10968.36,
	10782.82,
	11012.24,
	11042.50,
	11019.29,
	11129.73,
	11210.83,
	11146.45,
	11264.95,
	11311.79,
	11379.71,
	11466.46,
	11665.05,
	11625.33,
	11695.62,
	11775.45,
	11939.66,
	12056.44,
	11458.09,
	11313.12,
	10847.69,
	11141.55,
	10919.58,
	10853.54,
	11056.65,
	11190.32,
	11050.46,
	10910.28,
	10793.28,
	10778.79,
	10963.63,
	10632.99,
	10672.26,
	10913.55,
	11117.53,
	11085.25,
	11167.50,
	11326.50,
	11075.01,
	11332.49,
	11154.59,
	11364.59,
	11420.98,
	11579.94,
	11876.25,
	11863.90,
	11768.73,
	11713.87,
	11671.55,
	11478.87,
	11516.49,
	11484.69,
	11506.00,
	11548.28,
	11358.94,
	11431.34,
	11004.87,
	11185.58,
	10911.58,
	10957.61,
	11160.57,
	11590.78,
	11890.92,
	11895.23,
	11713.78,
	11553.86,
	11786.42,
	11709.58,
	11829.29,
	11924.12,
	11899.33,
	11801.59,
	11904.70,
	11854.96,
	11880.62,
	12036.79,
	12094.40,
	12205.84,
	12198.74,
	12355.11,
	12349.37,
	12377.17,
	12464.23,
	12519.95,
	12582.76,
	12338.95,
	12405.80,
	12377.87,
	12440.04,
	12595.05,
	12658.19,
	12764.75,
	12755.63,
	12742.51,
	12807.91,
	12771.11,
	12804.73,
	12899.41,
	12850.21,
	12870.00,
	12888.28,
	12698.45,
	12818.95,
	12740.79,
	13067.48,
	13201.98,
	13036.42,
	13072.42,
	13128.95,
	13112.63,
	12998.50,
	13197.17,
	13457.25,
	13530.91,
	13543.05,
	13635.99,
	13626.05,
	13270.59,
	13337.16,
	13070.69,
	13403.38,
	13612.78,
	13610.54,
	13777.74,
	13856.29,
	13987.63,
	14007.70,
	13972.53,
	14025.76,
	14095.46,
	14047.50,
	13965.49,
	13865.36,
	13874.45,
	13533.04,
	13465.20,
	13597.96,
	13119.43,
]

let GoldFeb2020Feb2021DataSource: DSFSparkline.DataSource = {
	let s = DSFSparkline.DataSource(zeroLineValue: 1775.4)
	s.push(values: GoldFeb2020Feb2021)
	return s
}()

let GoldFeb2020Feb2021: [CGFloat] = [
	1646.90,
	1640.00,
	1640.00,
	1564.09,
	1592.30,
	1642.09,
	1641.09,
	1666.40,
	1670.80,
	1674.50,
	1659.09,
	1641.40,
	1589.30,
	1515.69,
	1485.90,
	1524.90,
	1477.30,
	1478.59,
	1484.00,
	1567.00,
	1660.19,
	1632.30,
	1650.09,
	1623.90,
	1622.00,
	1583.40,
	1578.19,
	1625.69,
	1633.69,
	1677.00,
	1664.80,
	1665.40,
	1736.19,
	1744.80,
	1756.69,
	1727.19,
	1720.40,
	1689.19,
	1701.59,
	1678.19,
	1728.69,
	1733.30,
	1723.50,
	1711.90,
	1710.50,
	1703.40,
	1684.19,
	1694.50,
	1706.90,
	1704.40,
	1684.19,
	1721.80,
	1709.90,
	1695.30,
	1704.40,
	1713.90,
	1738.09,
	1753.40,
	1731.80,
	1744.19,
	1750.59,
	1720.50,
	1734.59,
	1704.80,
	1710.30,
	1713.30,
	1736.90,
	1737.80,
	1725.19,
	1697.80,
	1718.90,
	1676.19,
	1698.30,
	1714.69,
	1713.30,
	1732.00,
	1729.30,
	1720.30,
	1729.59,
	1729.19,
	1724.80,
	1745.90,
	1756.69,
	1772.09,
	1765.80,
	1762.09,
	1772.50,
	1774.80,
	1793.00,
	1773.19,
	1784.00,
	1788.50,
	1804.19,
	1815.50,
	1799.19,
	1798.19,
	1811.00,
	1810.59,
	1811.40,
	1798.69,
	1808.30,
	1815.90,
	1842.40,
	1864.09,
	1889.09,
	1897.30,
	1931.00,
	1944.69,
	1953.50,
	1942.30,
	1962.80,
	1966.00,
	2001.19,
	2031.09,
	2051.50,
	2010.09,
	2024.40,
	1932.59,
	1934.90,
	1956.69,
	1937.00,
	1985.00,
	1999.40,
	1958.69,
	1933.80,
	1934.59,
	1927.69,
	1911.80,
	1940.69,
	1921.59,
	1964.59,
	1967.59,
	1968.19,
	1934.40,
	1927.59,
	1923.90,
	1933.00,
	1944.69,
	1954.19,
	1937.80,
	1953.09,
	1956.30,
	1960.19,
	1940.00,
	1952.09,
	1901.19,
	1898.59,
	1859.90,
	1868.30,
	1857.69,
	1872.80,
	1894.30,
	1887.50,
	1908.40,
	1900.19,
	1912.50,
	1901.09,
	1883.59,
	1888.59,
	1919.50,
	1922.50,
	1888.50,
	1901.30,
	1903.19,
	1900.80,
	1906.40,
	1910.40,
	1924.59,
	1901.09,
	1902.00,
	1902.69,
	1908.80,
	1876.19,
	1865.59,
	1877.40,
	1890.40,
	1908.50,
	1894.59,
	1945.30,
	1950.30,
	1853.19,
	1875.40,
	1860.69,
	1872.59,
	1885.69,
	1887.30,
	1884.50,
	1873.50,
	1861.09,
	1872.59,
	1837.80,
	1804.80,
	1805.69,
	1775.69,
	1814.09,
	1825.69,
	1836.80,
	1835.90,
	1861.80,
	1870.80,
	1834.59,
	1833.59,
	1839.80,
	1828.69,
	1852.30,
	1856.09,
	1887.19,
	1885.69,
	1879.19,
	1866.59,
	1874.69,
	1877.19,
	1879.69,
	1891.00,
	1893.09,
	1944.69,
	1952.69,
	1906.90,
	1912.30,
	1834.09,
	1849.59,
	1842.90,
	1853.59,
	1850.30,
	1829.30,
	1839.50,
	1865.90,
	1865.30,
	1855.69,
	1854.90,
	1850.69,
	1844.90,
	1837.90,
	1847.30,
	1860.80,
	1830.50,
	1832.19,
	1788.90,
	1810.90,
	1831.90,
	1835.30,
	1840.59,
	1824.90,
	1821.59,
	1797.19,
	1771.09,
	1773.40,
	1775.80,
	1806.69,
	1804.40,
	1796.40,
	1770.30,
]
