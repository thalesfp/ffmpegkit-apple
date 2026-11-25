# ffmpegkit-apple

Prebuilt [FFmpegKitNext](https://github.com/arthenica/ffmpeg-kit-next) xcframeworks for iOS, macOS and tvOS, packaged for Swift Package Manager.

FFmpegKitNext publishes source only, so this repo builds it from a pinned upstream tag and ships the result as SPM binary targets. It is built for SimpleIPTV and may suit other apps that play network streams.

## Contents

| | |
|---|---|
| Upstream | FFmpegKitNext `v9.0.2` (FFmpeg 9.0.2), with the two build changes below |
| Platforms | iOS 18+ (arm64, arm64 simulator), macOS 15+ (arm64, x86_64), tvOS 18+ (arm64, arm64 simulator) |
| Linkage | Dynamic frameworks |
| Enabled | AudioToolbox, VideoToolbox, zlib, bzip2, libiconv, OpenSSL |
| License | LGPL 3.0 (no GPL components enabled) |

Two build changes:

- OpenSSL is configured with `-DOPENSSL_TLS_SECURITY_LEVEL=0`. OpenSSL 3 refuses TLS 1.0 and 1.1 servers at its default level, and many IPTV providers still run them.
- TLS certificate verification is off by default. FFmpeg 9.0 turned it on (`tls_verify` and `verify` in `libavformat/tls.h`); FFmpeg 8.1 and earlier had it off. Many IPTV providers serve self-signed or expired certificates. `scripts/patch-tls-verify.sh` sets both defaults back to 0 before the build, and the build stops if they do not read 0. An app can still pass `-tls_verify 1` on an HTTPS input (on a plain HTTP or file input, FFmpeg fails with "Option tls_verify not found").

## Use

```swift
.package(url: "https://github.com/thalesfp/ffmpegkit-apple", exact: "9.0.2")
```

Add the `FFmpegKit` product to your target and `import ffmpegkit`.

## Build

```sh
brew install autoconf automake libtool pkg-config nasm meson ninja texinfo gnu-sed gnu-tar wget xz bison yasm gettext libtasn1 bash coreutils make
scripts/build.sh
```

The xcframeworks land in `build/merged`. To release: zip each one with `ditto -c -k --norsrc --noextattr --noqtn --noacl --keepParent <lib>.xcframework <lib>.xcframework.zip` (resource forks or `__MACOSX` entries break SwiftPM), upload the zips to a GitHub release named after the version, and update `version` and the checksums (`swift package compute-checksum <zip>`) in `Package.swift`.

## License

FFmpegKitNext is licensed under the LGPL 3.0 (see `LICENSE`), and FFmpeg under the LGPL 2.1 or later. The source for every binary here is the upstream tag above with the changes made by `scripts/build.sh` and `scripts/patch-tls-verify.sh`. The libraries are dynamic frameworks, so an app that uses them can be relinked against a modified build.
