# The app image is the XRT image plus the app, built against the headers from
# the image's XRT -dev package.
# XRT image to build on and run: a Debian or Ubuntu XRT image (see ../README.md).
# XRT with the XRT-4041 changes isn't released yet, so this is its dev image.
# Once released, this should be the major.minor release: iotechsys/xrt:4.0-deb13
ARG XRT_IMAGE=iotechsys/xrt-server:3.4.6-deb13-headers-x86_64

# Headers to build against instead of the -dev packages, given as
# the xrt-include/iot-include build contexts (see ../README.md)
FROM scratch AS xrt-include
FROM scratch AS iot-include

FROM ${XRT_IMAGE} AS builder

# XRT package whose -dev package has the headers, by default the image's
ARG XRT_PACKAGE
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
