// swift-tools-version:5.3

import PackageDescription

let package = Package(
	name: "DSFSparkline",
	platforms: [
		.macOS(.v10_11),
		.iOS(.v13),
		.tvOS(.v13)
	],
	products: [
		.library(name: "DSFSparkline", targets: ["DSFSparkline"]),
		.library(name: "DSFSparkline-static", type: .static, targets: ["DSFSparkline"]),
		.library(name: "DSFSparkline-shared", type: .dynamic, targets: ["DSFSparkline"]),
	],
	dependencies: [
		// A microframework for cleaning handling image conversion
		.package(
			url: "https://github.com/dagronf/SwiftImageReadWrite",
			.upToNextMinor(from: "1.6.1")
		),
	],
	targets: [
		.target(
			name: "DSFSparkline",
			dependencies: []),
		.testTarget(
			name: "DSFSparklineTests",
			dependencies: ["DSFSparkline", "SwiftImageReadWrite"]),
	],
	swiftLanguageVersions: [.v5]
)
