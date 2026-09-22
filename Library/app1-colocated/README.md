# App1 - Colocated Sparkplug Client (container)

## Overview

This is "App1" in the [reference architecture](../README.md): a Virtual-free
BACnet/IP pipeline where a Virtual Device Service is *not* used - instead two
independent `XRT::BACnetIPDeviceService` instances (`Dev1`, `Dev2`, each
talking to its own `bacnet-sim-dev1`/`bacnet-sim-dev2` container),
`XRT::MQTTBridge` and `XRT::SparkplugNode` all run inside one process,
alongside a Sparkplug Application (`xrt_spg_app_t`) created directly in C via
`sparkplug/sparkplug_app.h`. The C program (`spg_demo.c`) reaches decoded
Sparkplug Node/Device/Metric state through in-process callbacks - no
request/reply protocol involved - and the whole pipeline round-trips through
the real MQTT broker (`mosquitto`, see [`../README.md`](../README.md)) using
real Sparkplug B protobuf.

This whole example only runs as a container - see
[`../docker-compose.yml`](../docker-compose.yml). There is no host-run
variant; `docker compose up` builds and starts it alongside everything else.

## What it demonstrates

Two BACnet/IP devices of the *same* protocol, each reached by its own
`XRT::BACnetIPDeviceService` instance (`Dev1` on local port 47808, `Dev2` on
47809 - both instances live in the same `iot_container_t`, so they each need
their own local UDP port), aggregated under one Sparkplug node identity. Once
`Dev1` births, the app issues a demo `DCMD` write to
`Dev1`/`analog_output_0:present-value` - a genuinely commandable BACnet point
(`AnalogOutput` objects in the simulator's Lua script are created with
`update=false`, i.e. not auto-randomized, so a write actually sticks and is
visible on the next scheduled read).

## Prerequisites

- Docker and Docker Compose (see [`../README.md`](../README.md) for the full
  compose walkthrough)
- A valid XRT license file, mounted per [`../README.md`](../README.md#license)

## Building

Built automatically by `docker compose up --build` from [`../`](../), using
`../` (not this directory) as the build context - the `Dockerfile` needs to
reach [`../vendor/`](../vendor/README.md) too. To build just this image
directly:

```bash
cd Library
docker build -t app1-colocated -f app1-colocated/Dockerfile .
```

> **FOR NOW:** the `Dockerfile` compiles against XRT/IOT headers vendored in
> from [`../vendor/`](../vendor/README.md) (that part's still a stopgap -
> see that directory's README for why), but every `.so` - both linked
> directly and `dlopen()`ed at runtime (the BACnet/IP device service, MQTT
> bridge, Sparkplug node, plus their own transitive deps like
> `libsparkplug-b`/`libpaho-mqtt3as`/`libbacnet-ip-1.3`) - comes straight
> from `iotechsys/xrt-server:3.4.6` via `COPY --from=iotechsys/xrt-server:3.4.6`,
> the same public image `../xrt-standalone/` already runs unmodified
> (`../xrt-opc-ua-server/` runs a separate, purpose-built image instead -
> see its README). No `.so`s are vendored into this repo.
>
> That image turned out to be **Alpine/musl, not Debian/glibc** (confirmed
> by actually inspecting it - `/etc/os-release` says Alpine 3.24.1), so this
> `Dockerfile` uses `FROM alpine:3.24` to match: a musl `.so` can't be
> linked into a glibc binary. `docker build` + a standalone `docker run` of
> the resulting binary were both actually exercised on this exact image -
> every `dlopen()`ed module loads and initializes cleanly (it gets as far as
> a real `XRT_LICENSE_FILE` check, which is expected to fail without a real
> license - see [`../README.md#license`](../README.md#license)). One real
> portability bug turned up along the way and is fixed in `spg_demo.c`
> itself: `ATOMIC_VAR_INIT` was removed in newer C standards and this
> image's gcc (15.2.0) rejects it outright, so the three uses were replaced
> with plain initializers (`= false`/`= 0u`), which is equivalent for a
> static/global atomic.

## Where to look

- `spg_demo.c` - `init_xrt`/container setup, and the three Sparkplug
  Application callbacks (`on_device_added`, `on_device_metric_added`,
  `on_metric_value_updated`). `on_device_added` fires for either device
  service and just logs the birth; the demo `DCMD` write is issued from
  `on_device_metric_added` instead, since a device's metric store isn't
  populated yet when `on_device_added` fires (so
  `xrt_spg_app_device_get_metric` would always return NULL there).
- `entrypoint.sh` - resolves `bacnet-sim-dev1`/`bacnet-sim-dev2`'s addresses
  via `getent hosts` (compose's embedded DNS) into `BACNET_IP_DEV1_ADDRESS`/
  `BACNET_IP_DEV2_ADDRESS`, then execs `spg_demo`.
- `deployment/config/mqtt_bridge.json` - the merged bridge config: outgoing
  patterns for the local node's births/data, and incoming patterns covering
  both the node's control-plane (`NCMD`/`DCMD`, decoded) and the
  application's data-plane (birth/data/ack, left as raw binary for the
  Sparkplug Application to decode).
- `deployment/config/sparkplug.json` / `sparkplug_node.json` - the
  `XRT::Sparkplug` config and `XRT::SparkplugNode` factory config
  respectively.
- `deployment/config/bacnet_ip_dev1.json` / `bacnet_ip_dev2.json` - the two
  device service instances feeding the same Sparkplug node; both share
  `"Group": "${SPARKPLUG_GROUP}"` so the node discovers them, and differ only
  in their local `Driver.Port` and target `Driver.BBMDAddress`.
