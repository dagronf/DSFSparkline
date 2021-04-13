//
//  StripesDemoView.swift
//  Demos
//
//  Created by Darren Ford on 16/2/21.
//

import SwiftUI
import DSFSparkline


struct StripesDemoView: View {

	let gradient = DSFSparkline.GradientBucket(
		posts: [
			DSFSparkline.GradientBucket.Post(color: CGColor(red: 0, green: 0, blue: 1, alpha: 1), location: 0),
			DSFSparkline.GradientBucket.Post(color: CGColor(red: 1, green: 1, blue: 1, alpha: 1), location: 0.5),
			DSFSparkline.GradientBucket.Post(color: CGColor(red: 1, green: 0, blue: 0, alpha: 1), location: 1)
		]
	)

	let gradientBucketed = DSFSparkline.GradientBucket(
		posts: [
			DSFSparkline.GradientBucket.Post(color: CGColor(red: 0, green: 0, blue: 1, alpha: 1), location: 0),
			DSFSparkline.GradientBucket.Post(color: CGColor(red: 1, green: 1, blue: 1, alpha: 1), location: 0.5),
			DSFSparkline.GradientBucket.Post(color: CGColor(red: 1, green: 0, blue: 0, alpha: 1), location: 1)
		],
		bucketCount: 6
	)

	let gradient2: DSFSparkline.GradientBucket = {
		let g = DSFSparkline.GradientBucket(posts: [
			DSFSparkline.GradientBucket.Post(color: DSFColor.systemYellow.cgColor, location: 0),
			DSFSparkline.GradientBucket.Post(r: 0.3, g: 0, b: 0.3, location: 1.0)
		])
		g.bucketCount = 4
		return g
	}()

	let gradient3: DSFSparkline.GradientBucket = {
		let g = DSFSparkline.GradientBucket(posts: [
			DSFSparkline.GradientBucket.Post(color: DSFColor.systemYellow.cgColor, location: 0),
			DSFSparkline.GradientBucket.Post(r: 0.3, g: 0, b: 0.3, location: 1.0)
		])
		g.bucketCount = 5
		return g
	}()

	let gradient4: DSFSparkline.GradientBucket = {
		let g = DSFSparkline.GradientBucket(posts: [
			DSFSparkline.GradientBucket.Post(r: 0.0, g: 0.0, b: 0.0, location: 0),
			DSFSparkline.GradientBucket.Post(r: 1.0, g: 1.0, b: 1.0, location: 1.0)
		])
		g.bucketCount = 8
		return g
	}()

	var body: some View {
		VStack {

			VStack {
				Text("Global annual mean temperature anomaly")
				DSFSparklineStripesGraphView.SwiftUI(dataSource: WorldDataSource,
																 barSpacing: 1,
																 gradient: self.gradient)
					.frame(height: 30)
					.padding(5)
					.border(Color.gray.opacity(0.2), width: 1)
			}

			VStack {
				Text("Global annual mean temperature anomaly (6 color buckets)")
				DSFSparklineStripesGraphView.SwiftUI(dataSource: WorldDataSource,
																 barSpacing: 1,
																 gradient: self.gradientBucketed)
					.frame(height: 30)
					.padding(5)
					.border(Color.gray.opacity(0.2), width: 1)
			}

			DSFSparklineLineGraphView.SwiftUI(dataSource: WorldDataSource,
														 graphColor: DSFColor.systemTeal,
														 lineShading: false,
														 showZeroLine: true)
				.frame(height: 30)
				.padding(5)
				.border(Color.gray.opacity(0.2), width: 1)

			VStack {
				Text("Global annual mean temperature anomaly overlaid")

				ZStack {

					DSFSparklineStripesGraphView.SwiftUI(dataSource: WorldDataSource,
																	 gradient: self.gradient)
					DSFSparklineLineGraphView.SwiftUI(dataSource: WorldDataSource,
																 graphColor: DSFColor.black,
																 lineWidth: 1.5,
																 interpolated: true,
																 lineShading: true)
				}
				.frame(height: 40)
				.padding(5)
				.border(Color.gray.opacity(0.2), width: 1)
			}

			VStack {
				Text("Global annual mean temperature anomaly overlaid (6 color buckets)")

				ZStack {

					DSFSparklineStripesGraphView.SwiftUI(dataSource: WorldDataSource,
																	 gradient: self.gradientBucketed)
					DSFSparklineLineGraphView.SwiftUI(dataSource: WorldDataSource,
																 graphColor: DSFColor.black,
																 lineWidth: 1,
																 interpolated: true,
																 lineShading: true)
				}
				.frame(height: 40)
				.padding(5)
				.border(Color.gray.opacity(0.2), width: 1)
			}


			Text("Australian annual mean temperature anomaly")

			VStack {
				HStack {
					Text("integral").frame(width: 70, alignment: Alignment.trailing)
					DSFSparklineStripesGraphView.SwiftUI(dataSource: australianAnomaly,
																	 integral: true,
																	 barSpacing: 2,
																	 gradient: self.gradient2)
						.frame(height: 25)
						.padding(5)
						.border(Color.gray.opacity(0.2), width: 1)
				}
				HStack {
					Text("integral").frame(width: 70, alignment: Alignment.trailing)
					DSFSparklineStripesGraphView.SwiftUI(dataSource: australianAnomaly,
																	 integral: true,
																	 barSpacing: 0,
																	 gradient: self.gradient2)
						.frame(height: 25)
						.padding(5)
						.border(Color.gray.opacity(0.2), width: 1)
				}

				HStack {
					Text("fractional").frame(width: 70, alignment: Alignment.trailing)
					DSFSparklineStripesGraphView.SwiftUI(dataSource: australianAnomaly,
																	 barSpacing: 1,
																	 gradient: self.gradient2)
						.frame(height: 25)
						.padding(5)
						.border(Color.gray.opacity(0.2), width: 1)
				}

				HStack {
					Text("fractional").frame(width: 70, alignment: Alignment.trailing)
					DSFSparklineStripesGraphView.SwiftUI(dataSource: australianAnomaly,
																	 gradient: self.gradient2)
						.frame(height: 25)
						.padding(5)
						.border(Color.gray.opacity(0.2), width: 1)
				}
			}

			VStack {
				HStack {
					VStack {
						DSFSparklineStripesGraphView.SwiftUI(dataSource: GradientTestDataSource,
																		 gradient: self.gradient3)
							.frame(height: 25)
							.padding(5)
							.border(Color.gray.opacity(0.2), width: 1)
						DSFSparklineBarGraphView.SwiftUI(dataSource: GradientTestDataSource,
																	graphColor: DSFColor(red: 0.5, green: 0, blue: 0.5, alpha: 1.0),
																	centeredAtZeroLine: true,
																	lowerGraphColor: DSFColor.systemYellow)
							.frame(height: 50)
							.padding(5)
							.border(Color.gray.opacity(0.2), width: 1)
					}
					VStack {
						DSFSparklineStripesGraphView.SwiftUI(dataSource: GradientTestDataSource2,
																		 barSpacing: 1,
																		 gradient: self.gradient4)
							.frame(height: 50)
							.padding(5)
							.border(Color.gray.opacity(0.2), width: 1)
					}
				}
			}
		}
		.padding(4)
//		.frame(width: 400)

	}
}

struct StripesDemoView_Previews: PreviewProvider {
	static var previews: some View {
		StripesDemoView()
	}
}


// MARK: -

fileprivate var GradientTestDataSource: DSFSparkline.DataSource = {
	let e = DSFSparkline.DataSource()
	e.set(values: [-10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0,
						1, 2, 3, 4, 5, 6, 7, 8, 9])
	return e
}()

fileprivate var GradientTestDataSource2: DSFSparkline.DataSource = {
	let e = DSFSparkline.DataSource()
	e.set(values: [-10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0,
						1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
	return e
}()

// MARK: - World definition

let WorldDataSource: DSFSparkline.DataSource = {
	let e = DSFSparkline.DataSource(windowSize: UInt(WorldRawData.count))
	e.set(values: WorldRawData)
	return e
}()

// https://www.metoffice.gov.uk/hadobs/hadcrut4/data/current/download.html
// https://www.metoffice.gov.uk/hadobs/hadcrut4/data/current/time_series/HadCRUT.4.6.0.0.annual_ns_avg.txt
// Data format :- https://www.metoffice.gov.uk/hadobs/hadcrut4/data/current/series_format.html

let WorldRawData: [CGFloat] = [
	-0.373,
	-0.218,
	-0.228,
	-0.269,
	-0.248,
	-0.272,
	-0.358,
	-0.461,
	-0.467,
	-0.284,
	-0.343,
	-0.407,
	-0.524,
	-0.278,
	-0.494,
	-0.279,
	-0.251,
	-0.321,
	-0.238,
	-0.262,
	-0.276,
	-0.335,
	-0.227,
	-0.304,
	-0.368,
	-0.395,
	-0.384,
	-0.075,
	 0.035,
	-0.230,
	-0.227,
	-0.200,
	-0.213,
	-0.296,
	-0.409,
	-0.389,
	-0.367,
	-0.418,
	-0.307,
	-0.171,
	-0.416,
	-0.330,
	-0.455,
	-0.473,
	-0.410,
	-0.390,
	-0.186,
	-0.206,
	-0.412,
	-0.289,
	-0.203,
	-0.259,
	-0.402,
	-0.479,
	-0.520,
	-0.377,
	-0.283,
	-0.465,
	-0.511,
	-0.522,
	-0.490,
	-0.544,
	-0.437,
	-0.424,
	-0.244,
	-0.141,
	-0.383,
	-0.468,
	-0.333,
	-0.275,
	-0.247,
	-0.187,
	-0.302,
	-0.276,
	-0.294,
	-0.215,
	-0.108,
	-0.210,
	-0.206,
	-0.350,
	-0.137,
	-0.087,
	-0.137,
	-0.273,
	-0.131,
	-0.178,
	-0.147,
	-0.026,
	-0.006,
	-0.052,
	 0.014,
	 0.020,
	-0.027,
	-0.004,
	 0.144,
	 0.025,
	-0.071,
	-0.038,
	-0.039,
	-0.074,
	-0.173,
	-0.052,
	 0.028,
	 0.097,
	-0.129,
	-0.190,
	-0.267,
	-0.007,
	 0.046,
	 0.017,
	-0.049,
	 0.038,
	 0.014,
	 0.048,
	-0.223,
	-0.140,
	-0.068,
	-0.074,
	-0.113,
	 0.032,
	-0.027,
	-0.186,
	-0.065,
	 0.062,
	-0.214,
	-0.149,
	-0.241,
	 0.047,
	-0.062,
	 0.057,
	 0.092,
	 0.140,
	 0.011,
	 0.194,
	-0.014,
	-0.030,
	 0.045,
	 0.192,
	 0.198,
	 0.118,
	 0.296,
	 0.254,
	 0.105,
	 0.148,
	 0.208,
	 0.325,
	 0.183,
	 0.390,
	 0.539,
	 0.306,
	 0.294,
	 0.441,
	 0.496,
	 0.505,
	 0.447,
	 0.545,
	 0.506,
	 0.491,
	 0.395,
	 0.506,
	 0.560,
	 0.425,
	 0.470,
	 0.514,
	 0.579,
	 0.763,
	 0.797,
	 0.677,
	 0.597,
	 0.736,
	 0.768
]

// MARK: - Australia Mean Temp Deviation

fileprivate var australianAnomaly: DSFSparkline.DataSource = {
	let e = DSFSparkline.DataSource(windowSize: UInt(AustraliaMeanTempDeviation.count))
	e.set(values: AustraliaMeanTempDeviation)
	return e
}()

// http://www.bom.gov.au/climate/change/#tabs=Tracker&tracker=timeseries&tQ=graph%3Dtmean%26area%3Daus%26season%3D0112
let AustraliaMeanTempDeviation: [CGFloat] = [
	-0.50,
	-0.68,
	-0.20,
	-0.87,
	 0.12,
	 0.07,
	-0.57,
	-1.24,
	-0.54,
	-0.15,
	-0.53,
	-0.23,
	-0.47,
	-0.38,
	-0.69,
	-0.77,
	-0.17,
	-0.51,
	 0.16,
	-0.87,
	-0.24,
	-0.59,
	-0.42,
	-0.45,
	-0.36,
	-0.50,
	-0.14,
	-0.36,
	 0.19,
	-0.62,
	-0.24,
	-0.55,
	 0.08,
	-0.62,
	-0.40,
	-0.29,
	-0.73,
	-0.25,
	-0.45,
	-0.94,
	-0.61,
	-0.43,
	-0.43,
	-0.45,
	-0.36,
	-0.32,
	-0.92,
	 0.04,
	 0.14,
	 0.24,
	-0.66,
	 0.05,
	-0.11,
	-0.13,
	-0.22,
	 0.25,
	-0.50,
	-0.22,
	-0.39,
	-0.03,
	-0.10,
	-0.22,
	 0.15,
	 0.54,
	-0.70,
	-0.22,
	-0.75,
	-0.04,
	-0.31,
	 0.37,
	 0.74,
	 0.27,
	-0.04,
	 0.33,
	-0.38,
	 0.21,
	 0.22,
	 0.17,
	 0.73,
	-0.02,
	 0.47,
	 0.60,
	 0.12,
	 0.31,
	 0.18,
	 0.16,
	 0.60,
	 0.30,
	 0.97,
	 0.32,
	-0.04,
	 0.05,
	 0.71,
	 0.69,
	 0.54,
	 1.16,
	 0.50,
	 0.76,
	 0.45,
	 0.93,
	 0.33,
	-0.00,
	 0.24,
	 1.33,
	 1.04,
	 0.94,
	 0.99,
	 1.06,
	 1.12,
	 1.52,
	 1.15
]

