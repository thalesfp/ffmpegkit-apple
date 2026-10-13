#!/usr/bin/env bash
# Builds FFmpegKitNext xcframeworks for SimpleIPTV (iOS, tvOS, macOS) from a pinned upstream tag.
set -euo pipefail

FFMPEG_KIT_NEXT_TAG="v8.1.1"
IOS_TARGET="18.0"
TVOS_TARGET="18.0"
MACOS_TARGET="15.0"

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/build"
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

./scripts/start-macos.sh -x --target="$MACOS_TARGET" \
  --enable-macos-audiotoolbox --enable-macos-videotoolbox --enable-macos-zlib \
  --enable-macos-bzip2 --enable-macos-libiconv --enable-openssl

./scripts/start-ios.sh -x --target="$IOS_TARGET" \
  --disable-arm64e --disable-x86-64 --disable-arm64-mac-catalyst --disable-x86-64-mac-catalyst \
  --enable-ios-audiotoolbox --enable-ios-videotoolbox --enable-ios-zlib \
  --enable-ios-bzip2 --enable-ios-libiconv --enable-openssl

./scripts/start-tvos.sh -x --target="$TVOS_TARGET" --disable-x86-64 \
  --enable-tvos-audiotoolbox --enable-tvos-videotoolbox --enable-tvos-zlib \
  --enable-tvos-bzip2 --enable-tvos-libiconv --enable-openssl

bash "$(dirname "${BASH_SOURCE[0]}")/merge-xcframeworks.sh" "$src/prebuilt" "$out"
