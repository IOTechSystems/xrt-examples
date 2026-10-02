# XRT release to build against (see ../README.md). The app image is the
# Debian or Ubuntu XRT image plus the app, built against the headers from the
# matching XRT -dev package.
ARG XRT_VERSION=3.4.6
ARG XRT_IMAGE=iotechsys/xrt-server:${XRT_VERSION}-deb13

# Headers to build against instead of the XRT_VERSION -dev packages, given as
# the xrt-include/iot-include build contexts (see ../README.md)
FROM scratch AS xrt-include
FROM scratch AS iot-include

FROM ${XRT_IMAGE} AS builder

ARG XRT_VERSION
# XRT package name, whose -dev package has the headers
ARG XRT_PACKAGE=iotech-xrt-3.4
ARG IOTECH_APT_REPO=https://iotech.jfrog.io/iotech/debian-release
ARG IOTECH_APT_KEY=https://iotech.jfrog.io/artifactory/api/gpg/key/public

RUN apt-get update && apt-get install -y --no-install-recommends gcc libc6-dev

COPY --from=xrt-include / /tmp/xrt-include/
COPY --from=iot-include / /tmp/iot-include/
COPY common/install_headers.sh /tmp/
RUN /tmp/install_headers.sh

WORKDIR /build
COPY common/ common/
COPY app1-colocated/deployment_config.h app1-colocated/
RUN gcc common/main.c common/spg_demo_app.c \
      -Icommon -Iapp1-colocated \
      -I${XRT}/include -L${XRT}/lib \
      -I${IOT}/include -L${IOT}/lib \
      -Wl,-rpath-link,${XRT}/lib:${IOT}/lib \
      -lxrt-sparkplug-app -lxrt -liot \
      -o spg_demo

FROM ${XRT_IMAGE}

ENV XRT_STATE_DIR=/app/deployment/state

RUN apt-get update && apt-get install -y --no-install-recommends socat \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=builder /build/spg_demo .
COPY app1-colocated/deployment/state ./deployment/state
COPY app1-colocated/entrypoint.sh .
RUN chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
