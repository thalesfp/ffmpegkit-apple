// swift-tools-version:6.0
import PackageDescription

let version = "8.1.1"
let releaseURL = "https://github.com/thalesfp/ffmpegkit-apple/releases/download/\(version)"

let package = Package(
    name: "FFmpegKit",
    platforms: [.iOS(.v18), .macOS(.v15), .tvOS(.v18)],
    products: [
        .library(name: "FFmpegKit", targets: ["ffmpegkit", "libavcodec", "libavdevice", "libavfilter", "libavformat", "libavutil", "libswresample", "libswscale"])
    ],
    targets: [
        .binaryTarget(
            name: "ffmpegkit",
            url: "\(releaseURL)/ffmpegkit.xcframework.zip",
            checksum: "c2c78315a5957cca3ce0c9240f7c6d1a09e67abb01e53ad47e5876a255cf0058"
        ),
        .binaryTarget(
            name: "libavcodec",
            url: "\(releaseURL)/libavcodec.xcframework.zip",
            checksum: "3d063c60e2bc8d2820800cb53d9f54ced2b8740502e70d36bf3311b228271ed0"
        ),
        .binaryTarget(
            name: "libavdevice",
            url: "\(releaseURL)/libavdevice.xcframework.zip",
            checksum: "2ff015ab94a7821ee163d085fb19c8808069df8cc2c19dbc7b17b96ab697e70d"
        ),
        .binaryTarget(
            name: "libavfilter",
            url: "\(releaseURL)/libavfilter.xcframework.zip",
            checksum: "a958bc60cf5f130b287bc1d6147abee03a54cca6208b0ab9e11a1afb94e24778"
        ),
        .binaryTarget(
            name: "libavformat",
            url: "\(releaseURL)/libavformat.xcframework.zip",
            checksum: "f6fa67d09333e4dc76491958080216e607ee45a11f213f2a0e735d4cac8cc001"
        ),
        .binaryTarget(
            name: "libavutil",
            url: "\(releaseURL)/libavutil.xcframework.zip",
            checksum: "2bdc0dab2cd8aa22c4e04cf8c5e610b094cdb6087d508672e575e8d33f26acf0"
        ),
        .binaryTarget(
            name: "libswresample",
            url: "\(releaseURL)/libswresample.xcframework.zip",
            checksum: "19e5c4fdd0561277bc210c11fb575c6dc2a27abf9553614d3fee64d75d9b4e9f"
        ),
        .binaryTarget(
            name: "libswscale",
            url: "\(releaseURL)/libswscale.xcframework.zip",
            checksum: "5e571f689008aa8eed0faf40858695417121b07524086a497ad65239102c7eb9"
        )
    ]
)
