# Standalone Sparkplug Client (XRT 3.4)

## Overview

Unlike [`sparkplug-colocated/`](../sparkplug-colocated/README.md), this
example has **no XRT bus, no `iot_container_t`, no XRT Sparkplug node or
application object**. It is a plain MQTT client:

1. It connects directly to the MQTT broker using Paho MQTT C
   (`MQTTAsync`), the same client library XRT itself uses.
2. It subscribes to `spBv1.0/<group>/#`, receiving whatever Sparkplug B
   XRT (or anything else) is publishing on that broker/group — for
   example, [`sparkplug-colocated/`](../sparkplug-colocated/README.md)
   pointed at the same broker and group.
3. Each message's raw payload is decoded with `xrt_xform_spb_decode()` — a
   bus-free, container-free function that turns Sparkplug B protobuf bytes
   into an `iot_data_t` map. This is the same codec XRT's own Sparkplug
   node and Sparkplug Application use internally, just called directly.
4. When it sees the demo device (`Virtual-Device`) birth, it builds a
   `DCMD` metric with `xrt_spg_metric_add()`, encodes it back to protobuf
   with `xrt_xform_spb_encode()`, and publishes it to
   `spBv1.0/<group>/DCMD/<node>/<device>` — the same write-back pattern as
   the colocated example, but issued from a completely separate process
   with no shared memory or bus.

This is the design point sketched as "concept, not yet implemented" in
[`Library/README.md`](../README.md): rather than the client owning its own
`iot_container_t` + `xrt_spg_app_t` (a second, smaller XRT SDK footprint),
it uses only the lowest-level pieces — IOT's `iot_data_t` and XRT's
Sparkplug B transform/metric-builder functions — directly against a plain
MQTT client. No `xrt_bus_t`, no component factories, no container config.

Trade-off versus the colocated example: this program has to do its own
topic parsing and has *no alias table* (see the top-of-file comment in
`spg_standalone.c`) — Sparkplug allows later `DATA` messages to reference a
metric by a numeric alias set during `BIRTH`, and resolving that requires
tracking per-node/device alias maps, which is exactly what `xrt_spg_app_t`
does for you in the colocated example. This example only prints whatever
`name`/`alias`/`value` fields are actually present on each message.

## Prerequisites

- XRT 3.4.6 library and headers installed (typically in `/opt/iotech/xrt/3.4`),
  built/installed with its Sparkplug module enabled
- IOT 1.6.5 library and headers installed (typically in `/opt/iotech/iot/1.6`)
- Paho MQTT C 1.3.162 (`paho-mqtt3as`) library and headers — linked directly,
  since this example calls `MQTTAsync_*` itself rather than going through
  XRT's own MQTT bridge
- Sparkplug B 1.0.1 (`sparkplug-b`) library and headers — linked directly,
  since this example calls `xrt_xform_spb_*` itself
- C compiler (gcc)
- An MQTT broker reachable at `XRT_MQTT_BROKER` (e.g. a local Mosquitto)
- Something publishing Sparkplug B to that broker/group to see any output
  — e.g. run [`sparkplug-colocated/`](../sparkplug-colocated/README.md)
  against the same broker first

See [`../README.md`](../README.md#dependencies) for the full dependency
breakdown and versions.

> **Packaging gap:** as with `sparkplug-colocated/`, `devsdk/spg.h` (needed
> here for `xrt_spg_metric_add`/`xrt_spg_msg`/the `xrt_spg_consts` table)
> lives only at `src/c/devsdk/spg.h` in the XRT source tree and is not
> copied into `include/devsdk/` by any install rule, so it's missing from
> an installed `/opt/iotech/xrt/3.4` package. Vendor it manually:
> ```bash
> cp /path/to/xrt/src/c/devsdk/spg.h /opt/iotech/xrt/3.4/include/devsdk/
> ```
> (Confirmed against the real v3.4-branch and IOT 1.6 headers, plus the
> system's installed Paho/`sparkplug-b` headers: with that one file
> vendored in, `spg_standalone.c` passes a clean `gcc -fsyntax-only -Wall
> -Wextra`. No linking/build was attempted, since no v3.4 install was
> available to test against here.)

## Compiling

```bash
gcc ./spg_standalone.c \
  -I/opt/iotech/xrt/3.4/include -L/opt/iotech/xrt/3.4/lib \
  -I/opt/iotech/iot/1.6/include -L/opt/iotech/iot/1.6/lib \
  -lxrt-sparkplug-xform -lxrt-devsdk -lxrt -lsparkplug-b -liot -lpaho-mqtt3as \
  -o spg_standalone
```

## Running

```bash
export XRT_MQTT_BROKER=tcp://localhost:1883
export SPARKPLUG_GROUP=iotech   # match the group of whatever is publishing
./spg_standalone
```

`XRT_MQTT_USERNAME`/`XRT_MQTT_PASSWORD` are read too, if the broker needs
credentials. If `sparkplug-colocated/` is already running against the same
broker, this program should log its `Virtual-Device` and BACnet/IP
metrics, then issue the `DCMD` write once it sees `Virtual-Device` birth.

## Where to look

- `spg_standalone.c` — everything lives in one file: Paho setup/callbacks,
  `parse_topic` (splits `spBv1.0/<group>/<TYPE>/<node>[/<device>]`),
  `process_sparkplug_payload` (decodes + logs each metric, triggers the
  demo write), `publish_write_cmd` (builds and encodes the `DCMD`).
- No `deployment/` folder — there's no `iot_container_t` and therefore no
  container config to load; the only configuration is the environment
  variables above.
