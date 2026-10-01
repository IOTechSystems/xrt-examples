# XRT release to build against (see ../README.md): its libraries come from the
# XRT image, and its headers from the matching XRT -dev package
ARG XRT_VERSION=3.4.6
ARG XRT_IMAGE=iotechsys/xrt-server:${XRT_VERSION}

FROM ${XRT_IMAGE} AS xrt

# Headers to build against instead of the XRT_VERSION -dev packages, given as
# the xrt-include/iot-include build contexts (see ../README.md)
FROM scratch AS xrt-include
FROM scratch AS iot-include

FROM alpine:3.24 AS builder

ARG XRT_VERSION
ARG IOTECH_APK_REPO=https://iotech.jfrog.io/artifactory/alpine-release/v3.24/main
ARG IOTECH_APK_KEY=https://iotech.jfrog.io/artifactory/api/security/keypair/public/repositories/alpine-release

ENV XRT=/opt/iotech/xrt/3.4
ENV IOT=/opt/iotech/iot/1.6

RUN apk add --no-cache \
      build-base \
      yaml libcbor sqlite-libs protobuf-c libssl3 zlib libatomic

COPY --from=xrt-include / /tmp/xrt-include/
COPY --from=iot-include / /tmp/iot-include/
COPY common/install_headers.sh /tmp/
RUN /tmp/install_headers.sh

COPY --from=xrt ${XRT}/lib ${XRT}/lib
COPY --from=xrt ${IOT}/lib ${IOT}/lib
COPY --from=xrt /usr/lib/libsparkplug-b.so /usr/lib/

WORKDIR /build
COPY common/ common/
COPY app2-standalone/deployment_config.h app2-standalone/
RUN gcc common/main.c common/spg_demo_app.c \
      -Icommon -Iapp2-standalone \
      -I${XRT}/include -L${XRT}/lib \
      -I${IOT}/include -L${IOT}/lib \
      -Wl,-rpath-link,${XRT}/lib:${IOT}/lib \
      -lxrt-sparkplug-app -lxrt -liot \
      -o spg_standalone

FROM alpine:3.24

ENV XRT=/opt/iotech/xrt/3.4
ENV IOT=/opt/iotech/iot/1.6
ENV LD_LIBRARY_PATH=${XRT}/lib:${IOT}/lib

RUN apk add --no-cache \
      yaml libcbor sqlite-libs protobuf-c libssl3 zlib libatomic

COPY --from=xrt ${XRT}/lib ${XRT}/lib
COPY --from=xrt ${IOT}/lib ${IOT}/lib
COPY --from=xrt /usr/lib/libpaho-mqtt3as.so* /usr/lib/
COPY --from=xrt /usr/lib/libsparkplug-b.so /usr/lib/

WORKDIR /app
COPY --from=builder /build/spg_standalone .

ENTRYPOINT ["./spg_standalone"]
