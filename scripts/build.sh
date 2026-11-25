#!/usr/bin/env bash
# Builds FFmpegKitNext xcframeworks for SimpleIPTV (iOS, tvOS, macOS) from a pinned upstream tag.
set -euo pipefail

FFMPEG_KIT_NEXT_TAG="v9.0.2"
IOS_TARGET="18.0"
TVOS_TARGET="18.0"
MACOS_TARGET="15.0"

scripts="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root="$(dirname "$scripts")/build"
mkdir -p "$root"
src="$root/src"
out="$root/merged"

for tool in autoconf automake glibtoolize pkg-config nasm meson ninja gsed gtar wget yasm bison; do
  command -v "$tool" >/dev/null || { echo "missing tool: $tool (brew install autoconf automake libtool pkg-config nasm meson ninja texinfo gnu-sed gnu-tar wget xz bison yasm gettext libtasn1 bash coreutils make)"; exit 1; }
done

brew_prefix="$(brew --prefix)"
export PATH="$brew_prefix/opt/gnu-sed/libexec/gnubin:$brew_prefix/opt/gnu-tar/libexec/gnubin:$brew_prefix/opt/libtool/libexec/gnubin:$brew_prefix/opt/bison/bin:$brew_prefix/opt/make/libexec/gnubin:$brew_prefix/bin:$PATH"

rm -rf "$src"
git clone --depth 1 --branch "$FFMPEG_KIT_NEXT_TAG" https://github.com/arthenica/ffmpeg-kit-next.git "$src"
cd "$src"

# OpenSSL 3 rejects TLS 1.0/1.1 servers at its default security level; GnuTLS in the previous FFmpegKit accepted them.
sed -i 's|  no-tests \\|  no-tests \\\n  -DOPENSSL_TLS_SECURITY_LEVEL=0 \\|' scripts/apple/openssl.sh
grep -q 'OPENSSL_TLS_SECURITY_LEVEL=0' scripts/apple/openssl.sh || { echo "openssl.sh patch did not apply"; exit 1; }

# FFmpeg 9.0 verifies TLS certificates by default; FFmpeg 8.1 did not. Upstream skips its own download when src/ffmpeg exists
# and checks only that HEAD is the expected tag, so the patch goes into a clone made here.
ffmpeg_url="$(bash -c 'source scripts/source.sh && get_library_source ffmpeg 1')"
ffmpeg_tag="$(bash -c 'source scripts/source.sh && get_library_source ffmpeg 2')"
[[ -n "$ffmpeg_url" && -n "$ffmpeg_tag" ]] || { echo "cannot read the FFmpeg source from scripts/source.sh"; exit 1; }
git clone --depth 1 --branch "$ffmpeg_tag" "$ffmpeg_url" src/ffmpeg
"$scripts/patch-tls-verify.sh" src/ffmpeg/libavformat/tls.h

./macos.sh -x --target="$MACOS_TARGET" \
  --enable-lib-macos-audiotoolbox --enable-lib-macos-videotoolbox --enable-lib-macos-zlib \
  --enable-lib-macos-bzip2 --enable-lib-macos-libiconv --enable-lib-openssl

./ios.sh -x --target="$IOS_TARGET" \
  --disable-arch-arm64e --disable-arch-x86-64 --disable-arch-arm64-mac-catalyst --disable-arch-x86-64-mac-catalyst \
  --enable-lib-ios-audiotoolbox --enable-lib-ios-videotoolbox --enable-lib-ios-zlib \
  --enable-lib-ios-bzip2 --enable-lib-ios-libiconv --enable-lib-openssl

./tvos.sh -x --target="$TVOS_TARGET" --disable-arch-x86-64 \
  --enable-lib-tvos-audiotoolbox --enable-lib-tvos-videotoolbox --enable-lib-tvos-zlib \
  --enable-lib-tvos-bzip2 --enable-lib-tvos-libiconv --enable-lib-openssl

# Upstream ffmpeg.sh resets some FFmpeg source files before each architecture (scripts/apple/ffmpeg.sh:578-581).
"$scripts/patch-tls-verify.sh" --check src/ffmpeg/libavformat/tls.h

bash "$scripts/merge-xcframeworks.sh" "$src/prebuilt" "$out"
