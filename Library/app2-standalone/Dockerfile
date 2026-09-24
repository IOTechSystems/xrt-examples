FROM alpine:3.24 AS builder

RUN apk add --no-cache \
      build-base \
      yaml libcbor sqlite-libs protobuf-c libssl3 zlib libatomic

ENV XRT=/opt/iotech/xrt/3.4
ENV IOT=/opt/iotech/iot/1.6

COPY vendor/xrt/include ${XRT}/include
COPY vendor/iot/include ${IOT}/include
COPY vendor/paho/include/ /usr/include/
COPY vendor/sparkplug-b/include/ /usr/include/

COPY --from=iotechsys/xrt-server:3.4.6 ${XRT}/lib ${XRT}/lib
COPY --from=iotechsys/xrt-server:3.4.6 ${IOT}/lib ${IOT}/lib
COPY --from=iotechsys/xrt-server:3.4.6 /usr/lib/libpaho-mqtt3as.so* /usr/lib/
COPY --from=iotechsys/xrt-server:3.4.6 /usr/lib/libsparkplug-b.so /usr/lib/

WORKDIR /build
COPY app2-standalone/spg_standalone.c .
RUN gcc spg_standalone.c \
      -I${XRT}/include -L${XRT}/lib \
      -I${IOT}/include -L${IOT}/lib \
      -lxrt-sparkplug-xform -lxrt-devsdk -lxrt -lsparkplug-b -liot -lpaho-mqtt3as \
      -o spg_standalone

FROM alpine:3.24

ENV XRT=/opt/iotech/xrt/3.4
ENV IOT=/opt/iotech/iot/1.6
ENV LD_LIBRARY_PATH=${XRT}/lib:${IOT}/lib

RUN apk add --no-cache \
      yaml libcbor sqlite-libs protobuf-c libssl3 zlib libatomic

COPY --from=iotechsys/xrt-server:3.4.6 ${XRT}/lib ${XRT}/lib
COPY --from=iotechsys/xrt-server:3.4.6 ${IOT}/lib ${IOT}/lib
COPY --from=iotechsys/xrt-server:3.4.6 /usr/lib/libpaho-mqtt3as.so* /usr/lib/
COPY --from=iotechsys/xrt-server:3.4.6 /usr/lib/libsparkplug-b.so /usr/lib/

WORKDIR /app
COPY --from=builder /build/spg_standalone .

ENTRYPOINT ["./spg_standalone"]
