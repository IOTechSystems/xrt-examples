# App1 - colocated Sparkplug client: XRT (bus, a BACnet/IP device service for
# Dev1 and a BACnet MSTP device service for Dev2, MQTT bridge, Sparkplug
# node) baked into spg_demo.c as a library, built and run inside this one
# container.
#
# Dev1 (IP) and Dev2 (MSTP) deliberately use different BACnet datalinks, not
# just for variety: running two XRT::BACnetIPDeviceService instances in one
# process was confirmed (via gdb/tcpdump) to silently break, because the
# underlying bacnet-stack library keeps its BACnet/IP datalink (UDP socket)
# as process-wide global state - two IP instances fight over the one shared
# socket and only the second ever actually sends/receives. BACnet/IP and
# BACnet MSTP are separately compiled bacnet-stack artifacts
# (libbacnet-ip-*.so vs libbacnet-mstp-*.so), so one of each per process
# doesn't hit that collision.
#
# Dev2's MSTP "serial" link is actually a virtual PTY bridged over TCP to
# bacnet-sim-dev2 (see entrypoint.sh) - iotechsys/bacnet-sim's own
# RUN_MODE=MSTP entrypoint exposes its simulated RS-485 bus this way
# specifically for this kind of network-bridged testing.
FROM alpine:3.24 AS builder

RUN apk add --no-cache \
      build-base \
      yaml libcbor sqlite-libs protobuf-c libssl3 zlib libatomic

ENV XRT=/opt/iotech/xrt/3.4
ENV IOT=/opt/iotech/iot/1.6

COPY vendor/xrt/include ${XRT}/include
COPY vendor/iot/include ${IOT}/include

COPY --from=iotechsys/xrt-server:3.4.6 ${XRT}/lib ${XRT}/lib
COPY --from=iotechsys/xrt-server:3.4.6 ${IOT}/lib ${IOT}/lib
COPY --from=iotechsys/xrt-server:3.4.6 /usr/lib/libsparkplug-b.so /usr/lib/

WORKDIR /build
COPY app1-colocated/spg_demo.c .
RUN gcc spg_demo.c \
      -I${XRT}/include -L${XRT}/lib \
      -I${IOT}/include -L${IOT}/lib \
      -rdynamic \
      -lxrt-sparkplug-app -lxrt-devsdk -lxrt-sparkplug-xform -lxrt -liot \
      -o spg_demo

FROM alpine:3.24

ENV XRT=/opt/iotech/xrt/3.4
ENV IOT=/opt/iotech/iot/1.6
ENV LD_LIBRARY_PATH=${XRT}/lib:${IOT}/lib
ENV XRT_CONFIG_DIR=/app/deployment/config
ENV XRT_STATE_DIR=/app/deployment/state

RUN apk add --no-cache \
      yaml libcbor sqlite-libs protobuf-c libssl3 zlib libatomic \
      socat

COPY --from=iotechsys/xrt-server:3.4.6 ${XRT}/lib ${XRT}/lib
COPY --from=iotechsys/xrt-server:3.4.6 ${IOT}/lib ${IOT}/lib

COPY --from=iotechsys/xrt-server:3.4.6 /usr/lib/libsparkplug-b.so /usr/lib/
COPY --from=iotechsys/xrt-server:3.4.6 /usr/lib/libpaho-mqtt3as.so* /usr/lib/
COPY --from=iotechsys/xrt-server:3.4.6 /usr/lib/libbacnet-ip-1.3.so /usr/lib/
COPY --from=iotechsys/xrt-server:3.4.6 /usr/lib/libbacnet-mstp-1.3.so /usr/lib/

WORKDIR /app
COPY --from=builder /build/spg_demo .
COPY app1-colocated/deployment ./deployment
COPY app1-colocated/entrypoint.sh .
RUN chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
