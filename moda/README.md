# Moda OpenCV.js releases

Build from the upstream version and commit in upstream.json with this minimal
WASM/SIMD configuration. The tag workflow verifies and publishes the reviewed
OpenCV.js bytes with their SHA-256 and source revision. Studio serves those
same bytes in the browser and packages them for Electron.

The Web distribution for Studio and Pattern uses tags such as `v4.10.0-web.1`
and builds `opencv-web.mjs` with `bash moda/build-web.sh BUILD_DIR`. Activate
Emscripten 3.1.64 before running that command locally. The ES module embeds the
WASM and exposes a factory for use in a page or module worker.
