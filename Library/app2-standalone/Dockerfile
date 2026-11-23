# The app image is the XRT image plus the app, built against the headers from
# the image's XRT -dev package.
# XRT image to build on and run: a Debian or Ubuntu XRT image (see ../README.md).
ARG XRT_IMAGE=iotechsys/xrt:4.0-deb13

FROM ${XRT_IMAGE} AS builder

ARG IOTECH_APT_REPO=https://iotech.jfrog.io/iotech/debian-release
ARG IOTECH_APT_KEY=https://iotech.jfrog.io/artifactory/api/gpg/key/public

RUN apt-get update && apt-get install -y --no-install-recommends gcc libc6-dev

COPY common/install_headers.sh /tmp/
RUN /tmp/install_headers.sh

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

FROM ${XRT_IMAGE}

WORKDIR /app
COPY --from=builder /build/spg_standalone .

ENTRYPOINT ["./spg_standalone"]
