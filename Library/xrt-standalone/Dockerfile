FROM iotechsys/xrt-server:3.4.6

ENV XRT_STATE_DIR=/opt/iotech/xrt/3.4/deployment/state

# socat bridges Dev4's simulated MS/TP bus (see entrypoint.sh) in.
RUN apk add --no-cache socat

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
