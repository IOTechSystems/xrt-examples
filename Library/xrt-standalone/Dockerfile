# The same XRT image as app1/app2 (see ../README.md).
# XRT with the XRT-4041 changes isn't released yet, so this is its dev image.
# Once released, this should be the major.minor release: iotechsys/xrt:4.0-deb13
ARG XRT_IMAGE=iotechsys/xrt-server:3.4.6-deb13-headers-x86_64

FROM ${XRT_IMAGE}

ENV XRT_STATE_DIR=/opt/iotech/xrt/3.4/deployment/state

# socat bridges Dev4's simulated MS/TP bus (see entrypoint.sh) in.
RUN apt-get update && apt-get install -y --no-install-recommends socat \
  && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
