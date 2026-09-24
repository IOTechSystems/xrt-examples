# Synced headers (not committed - manual step)

Both App1 and App2 get compiled C binaries from the docker image
`COPY --from=iotechsys/xrt-server:3.4.6 ...`, but headers for functions are
not provided.

`iot`, `paho` and `sparkplug-b` headers are available from installable packages
but TODO `xrt` headers are manually copied in for now, from a CMake build.

```
apt-get install iotech-iot-1.6-dev iotech-libpaho-mqtt-1.3 libsparkplug-b-1.0
./vendor/sync-apt-headers.sh
```

To copy XRT headers manually use `xrt` source tree's local CMake build output,
e.g. `iotech-xrt-dev-3.4-3.4.6_amd64/include`.

Total size: ~800KB of header text, no binaries.
