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
COPY app1-colocated/deployment_config.h app1-colocated/
RUN gcc common/main.c common/spg_demo_app.c \
      -Icommon -Iapp1-colocated \
      -I${XRT}/include -L${XRT}/lib \
      -I${IOT}/include -L${IOT}/lib \
      -Wl,-rpath-link,${XRT}/lib:${IOT}/lib \
      -lxrt-sparkplug-app -lxrt -liot \
      -o spg_demo

FROM ${XRT_IMAGE}

ENV XRT_DEPLOYMENT_DIR=/app/deployment
ENV XRT_STATE_DIR=/app/deployment/state

RUN apt-get update && apt-get install -y --no-install-recommends socat \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=builder /build/spg_demo .
COPY app1-colocated/deployment ./deployment
COPY app1-colocated/entrypoint.sh .
RUN chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
