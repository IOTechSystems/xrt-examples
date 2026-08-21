# Using XRT as a Library

This folder contains examples of embedding XRT directly into your own C
program, rather than running XRT as its own `xrt` process. Baking XRT into
your process this way lets you start it, exchange data with it, and cleanly
stop it as part of your own application's lifecycle — useful for
integrating XRT into existing business logic rather than treating it as an
external service you talk to.

## sparkplug-colocated

[`sparkplug-colocated/`](sparkplug-colocated/README.md) is the current
example: a Virtual Device Service, a BACnet/IP Device Service,
`XRT::MQTTBridge` and `XRT::SparkplugNode` all run inside one process,
alongside a Sparkplug Application (`xrt_spg_app_t`) created directly in C
via `sparkplug/sparkplug_app.h`. The C program reaches decoded Sparkplug
Node/Device/Metric state through in-process callbacks — no request/reply
protocol involved — and the whole pipeline round-trips through a real MQTT
broker using real Sparkplug B protobuf. Two different source protocols
(Virtual, BACnet/IP) feed into the same Sparkplug node, showing multiple
device services aggregated under one Sparkplug identity. See its README for
the full data-flow diagram, prerequisites and build/run instructions.

## sparkplug-standalone

[`sparkplug-standalone/`](sparkplug-standalone/README.md) is a companion to
`sparkplug-colocated/`: rather than being baked into the same process as
XRT, it runs as its own separate binary/process, talking to XRT (or any
other Sparkplug B publisher) purely over MQTT — no `iot_container`, no XRT
bus, no `xrt_spg_app_t`.

- **Colocated**: one process, one `iot_container`, everything sharing
  memory — the app reads decoded Sparkplug state in-process via
  `xrt_spg_app_t`.
- **Standalone**: a plain MQTT client (Paho `MQTTAsync`) connecting to the
  broker directly. It decodes Sparkplug B payloads with `xrt_xform_spb_decode`
  and builds outgoing metrics/`DCMD`s with `xrt_spg_metric_add` +
  `xrt_xform_spb_encode` — XRT's lowest-level Sparkplug B codec and IOT's
  `iot_data_t`, with no bus/container/component-factory machinery at all.

That's a deliberate middle ground for now: using XRT's own Sparkplug B
transform and IOT's data functions directly for encode/decode, rather than
depending on the full `xrt_spg_app_t` SDK (which would need its own
`iot_container`) or reimplementing Sparkplug B protobuf decode from scratch
with no XRT/IOT dependency at all. See its README for the trade-offs (in
particular: no alias-table tracking) and build/run instructions.

## Dependencies

Both examples use Sparkplug B, which pulls in two libraries beyond the
base XRT/IOT install:

| Dependency | Version | Why |
|---|---|---|
| XRT | **3.4.6**, `/opt/iotech/xrt/3.4` | core library |
| IOT | **1.6.5**, `/opt/iotech/iot/1.6` | core library |
| Paho MQTT C (`paho-mqtt3as`) | **1.3.162** | Sparkplug B rides on real MQTT |
| Sparkplug B (`sparkplug-b`) | **1.0.1** | the actual protobuf schema/codec for Sparkplug B |

(Versions read directly from `dependencies/PAHO_MQTT_VERSION`,
`dependencies/SPARKPLUG_B_VERSION`, `dependencies/IOT_VERSION` and the
top-level `VERSION` file in the `xrt` source tree, v3.4-branch.)

Whether you need to install Paho/Sparkplug B yourself depends on how you
obtain XRT:

- **IOTech XRT install package/installer**: normally bundles every module
  it was built with (MQTT, Sparkplug, BACnet, etc.) including their
  third-party libraries, so a stock XRT 3.4 install should already provide
  `libpaho-mqtt3as`/`libsparkplug-b` alongside `libxrt*`. Check your
  installer's release notes/docs for which modules are enabled.
- **Building XRT from source yourself**: you need the Paho MQTT C and
  Sparkplug B *dev* packages (headers + `.so`) on the build machine before
  configuring CMake with `XRT_BUILD_MODULE_MQTT`/`XRT_BUILD_MODULE_SPARKPLUG`
  enabled (see `src/c/CMakeLists.txt`, `src/cmake/FindPAHO.cmake`,
  `src/cmake/FindSPARKPLUG_B.cmake` in the `xrt` source tree).

`sparkplug-standalone/` links directly against `paho-mqtt3as` and
`sparkplug-b` (it calls `MQTTAsync_*`/`xrt_xform_spb_*` itself).
`sparkplug-colocated/` never links them directly — it only calls
`xrt_spg_app_*` — but still needs them present at runtime, since
`libxrt-mqtt-bridge.so`, `libxrt-sparkplug.so` and `libxrt-sparkplug-app.so`
are dynamically loaded and pull those libraries in transitively.
`sparkplug-colocated/` additionally needs `libxrt-bacnet-ip-device-service.so`
and its own third-party dependency, the BACnet stack library — same as the
existing `DeviceServices/bacnet-ip/` example, and likewise expected to come
bundled with a BACnet-enabled XRT install rather than something to install
separately.

Beyond libraries, both examples need something actually running to talk
to: an MQTT broker reachable at `XRT_MQTT_BROKER` (a local Mosquitto is
enough), and `sparkplug-colocated/` additionally needs Docker to run the
BACnet/IP simulator container. Neither of those is an XRT/IOT dependency —
they're just what the demo talks to.
