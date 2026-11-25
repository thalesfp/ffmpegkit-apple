// swift-tools-version:6.0
import PackageDescription

let version = "9.0.2"
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
            checksum: "a75eaa65336477f9acceecd43a84eb644c115ec2fdaedec99dff100ef485c2ea"
        ),
        .binaryTarget(
            name: "libavcodec",
            url: "\(releaseURL)/libavcodec.xcframework.zip",
            checksum: "8b813e304e935f6023156dc46bd3ecece0aa77f2639632ad7f248608e7dd4b81"
        ),
        .binaryTarget(
            name: "libavdevice",
            url: "\(releaseURL)/libavdevice.xcframework.zip",
            checksum: "6f960217430f4dc5790c455502cdf86812365df815c853e86f916cdb303dde11"
        ),
        .binaryTarget(
            name: "libavfilter",
            url: "\(releaseURL)/libavfilter.xcframework.zip",
            checksum: "ab69764d84541328dd3c046bc185009dd183106cdd10e27bba591e288785c1ad"
        ),
        .binaryTarget(
            name: "libavformat",
            url: "\(releaseURL)/libavformat.xcframework.zip",
            checksum: "645d107738323adf02ea5002ace8e3156a14a911a9b7b900a93530673080999c"
        ),
        .binaryTarget(
            name: "libavutil",
            url: "\(releaseURL)/libavutil.xcframework.zip",
            checksum: "f0fc2020647c9d7e0ab8596af1a8fd0886e3516752670fd82913b6e4f1406d8d"
        ),
        .binaryTarget(
            name: "libswresample",
            url: "\(releaseURL)/libswresample.xcframework.zip",
            checksum: "364fcffbed386e956ee1c96bf656d3cd798d1429d0294de503e179ba9fca22e5"
        ),
        .binaryTarget(
            name: "libswscale",
            url: "\(releaseURL)/libswscale.xcframework.zip",
            checksum: "ed937f90025d6ed5d796e3621cf353845076574af2a736e880c6e0a33a02c039"
        )
    ]
)
