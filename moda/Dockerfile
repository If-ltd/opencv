FROM emscripten/emsdk:3.1.64

RUN apt-get update && apt-get install -y \
    git \
    python3 \
    cmake \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

# Create config directory and copy files
RUN mkdir -p /config
COPY opencv_js_minimal.config.py /config/
COPY build.sh /build.sh
RUN chmod +x /build.sh

CMD ["/build.sh"]
