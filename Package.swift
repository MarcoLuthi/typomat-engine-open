// swift-tools-version: 5.9
//
// The manifest customers depend on, published in its own repository and tagged with each release. It holds no source: only where the
// binary is and its checksum. This is the template: scripts/build-xcframework.sh writes build/apple/package/ with both filled in.

import PackageDescription

let version = "1.6.0"
let checksum = "e705068eab37cd5655dd892b6ade51b3c8808c4e2d548ab30f85557fd92c2912"

let package = Package(
    name: "TypomatEngine",
    platforms: [.iOS(.v17), .macOS(.v14), .macCatalyst(.v17)],
    products: [
        .library(name: "TypomatEngine", targets: ["TypomatEngine"]),
    ],
    targets: [
        .binaryTarget(
            name: "TypomatEngine",
            url: "https://engine.typomat.app/api/apple/\(version)/TypomatEngine.xcframework.zip",
            checksum: checksum
        ),
    ]
)
