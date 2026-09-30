# Synced headers (not committed - manual step)

App1 and App2 are compiled against the XRT and IOT libraries of the XRT
docker image named by the `XRT_IMAGE` build argument (see
[`../README.md`](../README.md)), but that image doesn't include headers.
Headers for the same XRT build, and the IOT version it was built against,
go in `vendor/xrt/include` and `vendor/iot/include`.

`iot` headers are available from an installable package but TODO `xrt`
headers are manually copied in for now, from an XRT build.

```
apt-get install iotech-iot-1.6-dev
./vendor/sync-apt-headers.sh
```

To copy XRT headers manually, use the `include/` directory of the package
built from the `xrt` source tree, e.g. `iotech-xrt-3.4-3.4.6_x86_64/include`.
It must be an XRT build that includes XRT-4041: the 3.4.6 release headers lack
`xrt_spg_app_config_init`, and their `sparkplug/sparkplug_app.h` includes
`devsdk/spg.h`, which isn't installed. Only XRT's installed headers are
needed - nothing is copied from its source tree.

Total size: ~500KB of header text, no binaries.
