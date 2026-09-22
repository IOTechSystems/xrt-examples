# App2 - Standalone Sparkplug Client (container)

## Overview

This is "App2" in the [reference architecture](../README.md): unlike
[`../app1-colocated/`](../app1-colocated/README.md), this process has **no
XRT bus, no `iot_container_t`, no XRT Sparkplug node or application object**.
It is a plain MQTT client:

1. It connects directly to the MQTT broker using Paho MQTT C (`MQTTAsync`),
   the same client library XRT itself uses.
2. It subscribes to `spBv1.0/<group>/#`, receiving whatever Sparkplug B *any*
   Edge Node publishes on that broker/group - in this compose, that means
   both [`../app1-colocated/`](../app1-colocated/README.md) (`Dev1`, `Dev2`)
   and [`../xrt-standalone/`](../xrt-standalone/README.md) (`Dev3`, `Dev4`),
   even though they're two entirely separate processes/containers with two
   separate Sparkplug node identities.
3. Each message's raw payload is decoded with `xrt_xform_spb_decode()` - a
   bus-free, container-free function that turns Sparkplug B protobuf bytes
   into an `iot_data_t` map. This is the same codec XRT's own Sparkplug node
   and Sparkplug Application use internally, just called directly.
4. When it sees `Dev1` birth, it builds a `DCMD` metric with
   `xrt_spg_metric_add()`, encodes it back to protobuf with
   `xrt_xform_spb_encode()`, and publishes it to
   `spBv1.0/<group>/DCMD/<node>/Dev1` - the same write-back pattern as
   `app1-colocated`'s own demo write, but issued from a completely separate
   process with no shared memory or bus.

This whole example only runs as a container - see
[`../docker-compose.yml`](../docker-compose.yml). Real Sparkplug traffic is
always on the bus by the time this starts (from `app1-colocated` and
`xrt-standalone`), so unlike the old host-run version of this example there
is no bundled minimal publisher to fall back on - it's no longer needed.

Trade-off versus the colocated example: this program has to do its own topic
parsing and has *no alias table* (see the top-of-file comment in
`spg_standalone.c`) - Sparkplug allows later `DATA` messages to reference a
metric by a numeric alias set during `BIRTH`, and resolving that requires
tracking per-node/device alias maps, which is exactly what `xrt_spg_app_t`
does for you in the colocated example. This example only prints whatever
`name`/`alias`/`value` fields are actually present on each message.

## Prerequisites

- Docker and Docker Compose (see [`../README.md`](../README.md) for the full
  compose walkthrough)
- A valid XRT license file, mounted per [`../README.md`](../README.md#license)

Like [`../app1-colocated/`](../app1-colocated/README.md), this image's
`Dockerfile` compiles against headers vendored in from
[`../vendor/`](../vendor/README.md) (this one also needs `vendor/paho/` and
`vendor/sparkplug-b/`, since this binary links `paho-mqtt3as`/`sparkplug-b`
directly rather than getting them transitively through `xrt_spg_app_t`) -
but every `.so` comes straight from `iotechsys/xrt-server:3.4.6` via
`COPY --from=`, same as `app1-colocated`. Note it uses `context: .` in
[`../docker-compose.yml`](../docker-compose.yml) to reach `vendor/`, and
`FROM alpine:3.24` to match that image's Alpine/musl base - see
`app1-colocated/README.md`'s Building section for the full story on both.
`docker build` + a standalone `docker run` of the resulting binary were both
actually exercised: it starts, connects out via Paho, and cleanly logs a
connect failure against a nonexistent broker rather than crashing on a
missing symbol.

## Where to look

- `spg_standalone.c` - everything lives in one file: Paho setup/callbacks,
  `parse_topic` (splits `spBv1.0/<group>/<TYPE>/<node>[/<device>]`),
  `process_sparkplug_payload` (decodes + logs each metric, triggers the demo
  write), `publish_write_cmd` (builds and encodes the `DCMD`).
- No `deployment/` folder - there's no `iot_container_t` and therefore no
  container config to load; the only configuration is environment variables
  (`XRT_MQTT_BROKER`, `SPARKPLUG_GROUP`, `XRT_MQTT_USERNAME`/`PASSWORD`), set
  in [`../docker-compose.yml`](../docker-compose.yml).
