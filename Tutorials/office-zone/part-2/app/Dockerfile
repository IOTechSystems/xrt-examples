# Builds the zone monitor application against XRT linked as a library. The
# image is the Xrt Debian image plus the application, compiled against the
# headers from the matching XRT and IOT -dev packages.
ARG XRT_IMAGE=iotechsys/xrt:4.0

FROM ${XRT_IMAGE} AS builder

ARG XRT_VERSION=4.0.0
ARG IOTECH_APT_REPO=https://iotech.jfrog.io/iotech/debian-release
ARG IOTECH_APT_KEY=https://iotech.jfrog.io/artifactory/api/gpg/key/public

# Compiler, and the XRT and IOT headers. The -dev packages must match the
# XRT and IOT versions already installed in the image.
RUN apt-get update \
  && apt-get install -y --no-install-recommends gcc libc6-dev curl gnupg lsb-release ca-certificates \
  && curl -fsSL "${IOTECH_APT_KEY}" | gpg --dearmor -o /usr/share/keyrings/iotech.gpg \
  && echo "deb [signed-by=/usr/share/keyrings/iotech.gpg] ${IOTECH_APT_REPO} $(lsb_release -cs) main" > /etc/apt/sources.list.d/iotech.list \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
       "iotech-xrt-4.0-dev=${XRT_VERSION}" \
       "iotech-iot-1.6-dev=$(dpkg-query -W -f '${Version}' iotech-iot-1.6)"

WORKDIR /build
COPY main.c zone_monitor.c zone_monitor.h ./
RUN gcc main.c zone_monitor.c \
      -I${XRT}/include -L${XRT}/lib \
      -I${IOT}/include -L${IOT}/lib \
      -Wl,-rpath-link,${XRT}/lib:${IOT}/lib \
      -lxrt-sparkplug-app -lxrt -liot \
      -o zone_monitor

FROM ${XRT_IMAGE}

WORKDIR /app
COPY --from=builder /build/zone_monitor .
# Default location of the BIRTH cache
RUN mkdir -p /app/state

ENTRYPOINT ["./zone_monitor"]
CMD ["/app/deployment/config"]
