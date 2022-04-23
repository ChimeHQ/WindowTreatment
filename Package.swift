// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "WindowTreatment",
    platforms: [.macOS("10.11")],
    products: [
        .library(name: "WindowTreatment", targets: ["WindowTreatment"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "WindowTreatment", dependencies: []),
        .testTarget(name: "WindowTreatmentTests", dependencies: ["WindowTreatment"]),
    ]
)
