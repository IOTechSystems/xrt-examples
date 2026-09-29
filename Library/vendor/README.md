# Synced headers (not committed - manual step)

Both App1 and App2 get compiled C binaries from the docker image
`COPY --from=iotechsys/xrt-server:3.4.6 ...`, but headers for functions are
not provided.

Only `iot` and `xrt` headers are needed. `iot` headers are available from an
installable package but TODO `xrt` headers are manually copied in for now,
from a CMake build.

```
apt-get install iotech-iot-1.6-dev
./vendor/sync-apt-headers.sh
```

To copy XRT headers manually use `xrt` source tree's local CMake build output,
e.g. `iotech-xrt-dev-3.4-3.4.6_amd64/include`.

Total size: ~500KB of header text, no binaries.
