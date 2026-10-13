# ffmpegkit-apple

Prebuilt [FFmpegKitNext](https://github.com/arthenica/ffmpeg-kit-next) xcframeworks for iOS, macOS and tvOS, packaged for Swift Package Manager.

FFmpegKitNext publishes source only, so this repo builds it from a pinned upstream tag and ships the result as SPM binary targets. It is built for SimpleIPTV and may suit other apps that play network streams.

## Contents

| | |
|---|---|
| Upstream | FFmpegKitNext `v8.1.1` (FFmpeg 8.1), unmodified source |
| Platforms | iOS 18+ (arm64, arm64 simulator), macOS 15+ (arm64, x86_64), tvOS 18+ (arm64, arm64 simulator) |
| Linkage | Dynamic frameworks |
| Enabled | AudioToolbox, VideoToolbox, zlib, bzip2, libiconv, OpenSSL |
| License | LGPL 3.0 (no GPL components enabled) |

One build change: OpenSSL is configured with `-DOPENSSL_TLS_SECURITY_LEVEL=0`. OpenSSL 3 refuses TLS 1.0 and 1.1 servers at its default level, and many IPTV providers still run them. Certificate verification stays off by default, as in upstream FFmpeg.

## Use

```swift
.package(url: "https://github.com/thalesfp/ffmpegkit-apple", exact: "8.1.1")
```

Add the `FFmpegKit` product to your target and `import ffmpegkit`.

## Build

```sh
brew install autoconf automake libtool pkg-config nasm meson ninja texinfo gnu-sed gnu-tar wget xz bison yasm gettext libtasn1 bash coreutils make
scripts/build.sh
```

The xcframeworks land in `build/merged`. To release: zip each one with `ditto -c -k --norsrc --noextattr --noqtn --noacl --keepParent <lib>.xcframework <lib>.xcframework.zip` (resource forks or `__MACOSX` entries break SwiftPM), upload the zips to a GitHub release named after the version, and update `version` and the checksums (`swift package compute-checksum <zip>`) in `Package.swift`.

## License

FFmpegKitNext is licensed under the LGPL 3.0 (see `LICENSE`), and FFmpeg under the LGPL 2.1 or later. The source for every binary here is the upstream tag above, built with `scripts/build.sh`. The libraries are dynamic frameworks, so an app that uses them can be relinked against a modified build.
