// swift-tools-version: 5.9
//
// The manifest customers depend on, published in its own repository and tagged with each release. It holds no source: only where the
// binary is and its checksum. This is the template: scripts/build-xcframework.sh writes build/apple/package/ with both filled in.

import PackageDescription

let version = "1.8.1"
let checksum = "a312382c720f6507e83fbd5868a404214109c2ce25e2de361ce10e21687fb6ef"

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
