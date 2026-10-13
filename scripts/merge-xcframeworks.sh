#!/usr/bin/env bash
# Merges the per-platform FFmpegKitNext xcframework bundles into one xcframework per library.
set -euo pipefail

prebuilt="$1"
out="$2"
libs=(ffmpegkit libavcodec libavdevice libavfilter libavformat libavutil libswresample libswscale)

rm -rf "$out"
mkdir -p "$out"

for lib in "${libs[@]}"; do
  args=()
  for bundle in "$prebuilt"/bundle-apple-xcframework-*; do
    for slice in "$bundle/$lib.xcframework"/*/; do
      args+=(-framework "${slice}${lib}.framework")
    done
  done
  xcodebuild -create-xcframework "${args[@]}" -output "$out/$lib.xcframework" >/dev/null
  echo "$lib: $(ls "$out/$lib.xcframework" | grep -v Info.plist | tr '\n' ' ')"
done
