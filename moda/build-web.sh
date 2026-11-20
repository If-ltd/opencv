#!/usr/bin/env bash
set -euo pipefail

source_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
build_dir="${1:?Usage: bash moda/build-web.sh BUILD_DIR}"

# Run with the Emscripten 3.1.64 SDK activated (the version pinned in moda/Dockerfile).
python3 "$source_dir/platforms/js/build_js.py" "$build_dir" \
  --opencv_dir "$source_dir" \
  --build_wasm \
  --simd \
  --config "$source_dir/moda/opencv_js_minimal.config.py" \
  --build_flags="-sEXPORT_ES6 -sENVIRONMENT=web,worker " \
  -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
  -DBUILD_LIST=core,imgproc,photo,js \
  -DBUILD_EXAMPLES=OFF \
  -DBUILD_TESTS=OFF \
  -DBUILD_PERF_TESTS=OFF

# The upstream build also writes a UMD wrapper. The raw ES module is the browser artifact.
cp "$build_dir/bin/opencv_js.js" "$build_dir/opencv-web.mjs"
