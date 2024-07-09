// swift-tools-version: 5.8

import PackageDescription

let package = Package(
	name: "WindowTreatment",
	platforms: [
		.macOS(.v10_13),
	],
	products: [
		.library(name: "WindowTreatment", targets: ["WindowTreatment"]),
	],
	dependencies: [],
	targets: [
		.target(name: "WindowTreatment", dependencies: []),
		.testTarget(name: "WindowTreatmentTests", dependencies: ["WindowTreatment"]),
	]
)

let swiftSettings: [SwiftSetting] = [
	.enableExperimentalFeature("StrictConcurrency"),
]

for target in package.targets {
	var settings = target.swiftSettings ?? []
	settings.append(contentsOf: swiftSettings)
	target.swiftSettings = settings
}
