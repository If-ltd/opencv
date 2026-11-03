#!/bin/bash
set -e

# Proxy settings
export http_proxy=http://192.168.1.160:8788
export https_proxy=http://192.168.1.160:8788
export HTTP_PROXY=http://192.168.1.160:8788
export HTTPS_PROXY=http://192.168.1.160:8788

# Build minimal OpenCV.js using Docker
# This script is designed to run inside a Docker container
# Directories are mounted from host:
#   /opencv - opencv source (persistent)
#   /output - build output

OPENCV_VERSION="4.10.0"
OPENCV_DIR="/opencv"
BUILD_DIR="/build"
OUTPUT_DIR="/output"

# Clone if not exists, otherwise pull
if [ ! -d "${OPENCV_DIR}/.git" ]; then
    echo "=== Cloning OpenCV ${OPENCV_VERSION} ==="
    git clone --depth 1 --branch ${OPENCV_VERSION} https://github.com/opencv/opencv.git ${OPENCV_DIR}
else
    echo "=== OpenCV source already exists, skipping clone ==="
fi

echo "=== Copying custom config ==="
cp /config/opencv_js_minimal.config.py ${OPENCV_DIR}/platforms/js/

echo "=== Building OpenCV.js (WASM + SIMD) ==="
cd ${OPENCV_DIR}
python3 ./platforms/js/build_js.py ${BUILD_DIR} \
    --build_wasm \
    --simd \
    --config ./platforms/js/opencv_js_minimal.config.py \
    --cmake_option="-DBUILD_opencv_dnn=OFF" \
    --cmake_option="-DBUILD_opencv_features2d=OFF" \
    --cmake_option="-DBUILD_opencv_calib3d=OFF" \
    --cmake_option="-DBUILD_opencv_video=OFF" \
    --cmake_option="-DBUILD_opencv_videoio=OFF" \
    --cmake_option="-DBUILD_opencv_objdetect=OFF" \
    --cmake_option="-DBUILD_opencv_ml=OFF" \
    --cmake_option="-DBUILD_opencv_flann=OFF" \
    --cmake_option="-DBUILD_opencv_highgui=OFF" \
    --cmake_option="-DBUILD_DOCS=OFF" \
    --cmake_option="-DBUILD_EXAMPLES=OFF" \
    --cmake_option="-DBUILD_TESTS=OFF" \
    --cmake_option="-DBUILD_PERF_TESTS=OFF" \
    --cmake_option="-DWITH_QUIRC=OFF" \
    --cmake_option="-DWITH_PROTOBUF=OFF" \
    --cmake_option="-DWITH_ADE=OFF"

echo "=== Copying output ==="
cp ${BUILD_DIR}/bin/opencv.js ${OUTPUT_DIR}/
if [ -f ${BUILD_DIR}/bin/opencv_js.wasm ]; then
    cp ${BUILD_DIR}/bin/opencv_js.wasm ${OUTPUT_DIR}/
fi

echo "=== Build complete! ==="
ls -lh ${OUTPUT_DIR}/
