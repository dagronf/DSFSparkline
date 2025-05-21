// swift-tools-version: 5.4

import PackageDescription

let package = Package(
	name: "DSFSparkline",
	platforms: [
		.macOS(.v10_13),
		.iOS(.v14),
		.tvOS(.v14)
	],
	products: [
		.library(name: "DSFSparkline", targets: ["DSFSparkline"]),
		.library(name: "DSFSparkline-static", type: .static, targets: ["DSFSparkline"]),
		.library(name: "DSFSparkline-shared", type: .dynamic, targets: ["DSFSparkline"]),
	],
	dependencies: [
		.package(url: "https://github.com/dagronf/SwiftImageReadWrite", from: "1.9.2"),
	],
	targets: [
		.target(
			name: "DSFSparkline",
			dependencies: []),
		.testTarget(
			name: "DSFSparklineTests",
			dependencies: ["DSFSparkline", "SwiftImageReadWrite"]),
	]
)
