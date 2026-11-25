#!/usr/bin/env bash
# Sets the default of FFmpeg's TLS certificate verification to off in libavformat/tls.h.
# With --check, only confirms that it is off. Exits non-zero when tls.h does not have the expected option lines.
set -euo pipefail

check_only=0
if [[ "${1:-}" == "--check" ]]; then
  check_only=1
  shift
fi
tls_h="${1:?usage: patch-tls-verify.sh [--check] <path to libavformat/tls.h>}"

# FFmpeg 9.0 declares "tls_verify" and "verify" on the same field, each with default 1 (libavformat/tls.h:93-94).
# av_opt_set_defaults2 writes every default in table order, so both lines must read 0.
options=(tls_verify verify)

count_default() {
  grep -cE "^[[:space:]]*\\{\"$1\",[^{]*\\{ \\.i64 = $2 \\}" "$tls_h" || true
}

if (( ! check_only )); then
  for option in "${options[@]}"; do
    [[ "$(count_default "$option" 1)" == 1 ]] || { echo "tls.h: no single \"$option\" option line with default 1; the patch does not fit this FFmpeg source"; exit 1; }
  done

  sed -E 's/^([[:space:]]*\{"(tls_verify|verify)",[^{]*\{ \.i64 = )1 \}/\10 }/' "$tls_h" > "$tls_h.patched"
  mv "$tls_h.patched" "$tls_h"
fi

for option in "${options[@]}"; do
  [[ "$(count_default "$option" 0)" == 1 && "$(count_default "$option" 1)" == 0 ]] || { echo "tls.h: the \"$option\" default is not 0"; exit 1; }
done

echo "tls.h: tls_verify and verify default to 0"
