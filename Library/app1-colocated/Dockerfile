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
