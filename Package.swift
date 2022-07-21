// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "DSFSparkline",
    platforms: [
       .macOS(.v10_11),
       .iOS(.v11),
       .tvOS(.v11)
    ],
    products: [
        .library(name: "DSFSparkline", type: .static, targets: ["DSFSparkline"]),
		  .library(name: "DSFSparkline-shared", type: .dynamic, targets: ["DSFSparkline"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "DSFSparkline",
            dependencies: []),
        .testTarget(
            name: "DSFSparklineTests",
            dependencies: ["DSFSparkline"]),
    ],
	 swiftLanguageVersions: [.v5]
)
