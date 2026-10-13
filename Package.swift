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
            checksum: "b7a0bd65a27287421154f95ae4ca4d73c59a13bd2399ed86a6ecf8069b774cac"
        ),
        .binaryTarget(
            name: "libavcodec",
            url: "\(releaseURL)/libavcodec.xcframework.zip",
            checksum: "6c94946a9e2ee5221c9a12724447471a8f5276f5946d99d20c6ce2b2fa62e135"
        ),
        .binaryTarget(
            name: "libavdevice",
            url: "\(releaseURL)/libavdevice.xcframework.zip",
            checksum: "e8bbffa298c1516637b7d71904299e7a22e20c6681cb4ce6f1461c04d9267483"
        ),
        .binaryTarget(
            name: "libavfilter",
            url: "\(releaseURL)/libavfilter.xcframework.zip",
            checksum: "8efb4703bec1f689827a9facf39810915059763bfbc84198b643e2f38f0ee562"
        ),
        .binaryTarget(
            name: "libavformat",
            url: "\(releaseURL)/libavformat.xcframework.zip",
            checksum: "317d172c0c83ae2c2ce99ef0f65ccac47c60b057c3cda147c46398736f20083f"
        ),
        .binaryTarget(
            name: "libavutil",
            url: "\(releaseURL)/libavutil.xcframework.zip",
            checksum: "70e521bceb36554fb6eff87e31b2d8167d32d8f01e988966d1e89425a1953cd0"
        ),
        .binaryTarget(
            name: "libswresample",
            url: "\(releaseURL)/libswresample.xcframework.zip",
            checksum: "375d8bd867c4e59e283ecde6f5ed3c52db87ffa14bcab3c3491e071cb322e4fe"
        ),
        .binaryTarget(
            name: "libswscale",
            url: "\(releaseURL)/libswscale.xcframework.zip",
            checksum: "f9650b179b67c16178f8bd9586891df2489e4096dd242baf571e629e6088db72"
        )
    ]
)
