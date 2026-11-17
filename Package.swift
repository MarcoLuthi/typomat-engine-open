// swift-tools-version: 5.9
//
// The manifest customers depend on, published in its own repository and tagged with each release. It holds no source: only where the
// binary is and its checksum. This is the template: scripts/build-xcframework.sh writes build/apple/package/ with both filled in.

import PackageDescription

let version = "1.8.17"
let checksum = "af7c818d99870e755437001bc856c5d3e35d6c85cc9c2bb62dbea6fa447b5514"

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
