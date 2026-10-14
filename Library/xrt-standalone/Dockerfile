# The same XRT image as app1/app2 (see ../README.md)
ARG XRT_VERSION=3.4.6
ARG XRT_IMAGE=iotechsys/xrt:${XRT_VERSION}-deb13

FROM ${XRT_IMAGE}

ENV XRT_STATE_DIR=/opt/iotech/xrt/3.4/deployment/state

# socat bridges Dev4's simulated MS/TP bus (see entrypoint.sh) in.
RUN apt-get update && apt-get install -y --no-install-recommends socat \
  && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
