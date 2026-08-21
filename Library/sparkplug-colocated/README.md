# Colocated Sparkplug Client (XRT 3.4)

## Overview

XRT is baked into a single C program rather than run as its own `xrt`
process. This example wires up a full local Sparkplug B pipeline and lets
the C program consume it via the Sparkplug Application client API
(`sparkplug/sparkplug_app.h`, `xrt_spg_app_*`), reaching decoded Node/Device/
Metric state through in-process callbacks rather than any request/reply
protocol.

Everything below runs in one OS process, started and owned by `spg_demo.c`:

1. Two device services generate data on their own schedules: a Virtual
   Device Service (random values, no external dependencies) and a
   BACnet/IP Device Service (talking to a real BACnet/IP simulator over the
   network) — showing two different source protocols aggregated under one
   Sparkplug identity.
2. `XRT::SparkplugNode` (`xrt_sparkplug_factory`) picks that telemetry up off
   the bus and encodes it as Sparkplug B (`NBIRTH`/`DBIRTH`/`DDATA`), one
   Sparkplug Device per XRT device regardless of which service produced it.
3. `XRT::MQTTBridge` publishes those messages to a real MQTT broker, and
   subscribes back to the broker for the same topics (raw, undecoded
   protobuf) plus incoming `NCMD`/`DCMD`.
4. A Sparkplug Application (`xrt_spg_app_t`), created directly in
   `spg_demo.c` via `xrt_spg_app_new`, decodes those messages off the bus and
   tracks Node/Device/Metric state, firing callbacks straight into the C
   program.
5. When the application sees the Virtual Device birth, it calls
   `xrt_spg_app_device_send_cmd` to write a metric — a `DCMD` that flows back
   out through the bridge, round-trips the broker, and is applied to the
   Virtual Device by the local Sparkplug node.

This full loopback (through a real broker, using real Sparkplug B protobuf)
is the pattern recommended for Sparkplug Applications in XRT — see
`overview.md` under `src/docs/internal/sparkplug-application/` in the XRT
source tree.

Only the `XRT::Sparkplug` config type is registered statically in
`spg_demo.c` (`xrt_sparkplug_config_factory`); the two device services,
`XRT::MQTTBridge` and `XRT::SparkplugNode` are all loaded dynamically per
their `Library`/`Factory` config fields.

## Prerequisites

- XRT 3.4.6 library and headers installed (typically in `/opt/iotech/xrt/3.4`),
  built/installed with its MQTT, Sparkplug and BACnet/IP modules enabled
  (pulls in Paho MQTT C 1.3.162, Sparkplug B 1.0.1 and the BACnet stack
  library transitively — see [`../README.md`](../README.md#dependencies)
  for the full dependency breakdown)
- IOT 1.6.5 library and headers installed (typically in `/opt/iotech/iot/1.6`)
- C compiler (gcc)
- An MQTT broker reachable at `XRT_MQTT_BROKER` (e.g. a local Mosquitto)
- Docker, to run the BACnet/IP simulator container

> **Note:** the Sparkplug Application config struct has a field literally
> named `namespace`, which is a reserved keyword in C++. This example is
> C only for that reason.

> **Packaging gap:** `include/sparkplug/sparkplug_app.h` does `#include
> "devsdk/spg.h"`, but that header only lives at `src/c/devsdk/spg.h` in the
> XRT source tree — it is not copied into `include/devsdk/` by any install
> rule, so it is missing from an installed `/opt/iotech/xrt/3.4` package.
> Until that's fixed upstream, copy it in manually before compiling:
> ```bash
> cp /path/to/xrt/src/c/devsdk/spg.h /opt/iotech/xrt/3.4/include/devsdk/
> ```
> (Confirmed against the real v3.4-branch and IOT 1.6 headers: with that one
> file vendored in, `spg_demo.c` passes a clean `gcc -fsyntax-only -Wall
> -Wextra` — no linking/build was attempted, since no v3.4 build/install was
> available to test against here.)

## Compiling

```bash
gcc ./spg_demo.c \
  -I/opt/iotech/xrt/3.4/include -L/opt/iotech/xrt/3.4/lib \
  -I/opt/iotech/iot/1.6/include -L/opt/iotech/iot/1.6/lib \
  -lxrt-sparkplug-app -lxrt-devsdk -lxrt-sparkplug-xform -lxrt -liot \
  -o spg_demo
```

## Setting Up the Environment

### Run the BACnet/IP simulator

```bash
cd Library/sparkplug-colocated
./commands/start_device_sim.sh
```

Stop it later with `./commands/stop_device_sim.sh`.

### Environment variables

```bash
. ../../set_env_vars.sh
export BACNET_IP_SIM_ADDRESS=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' bacnet-ip-sim)
```

Make sure `XRT_MQTT_BROKER` points at a running broker (defaults to
`tcp://localhost:1883`), and `XRT_LICENSE_FILE`/`LD_LIBRARY_PATH` are set as
per the other examples in this repository. If you already have another
example's Sparkplug node running against the same broker, override
`SPARKPLUG_NODE` and/or `SPARKPLUG_GROUP` first so the two don't collide on
the same topics.

## Running

```bash
XRT_CONFIG_DIR=deployment/config ./spg_demo
```

> **Note:** run from this directory — the configuration files use relative
> paths (`${XRT_STATE_DIR}` etc, set by `set_env_vars.sh`).

Expected log output: both device services birth (`Virtual-Device` and
`bacnet-ip-sim`) and start publishing values every 3 seconds; once the
Sparkplug application sees the `Virtual-Device` birth it issues a `DCMD`
setting `StoreInt32Value` to `456`, which shows up in a subsequent metric
log line once it round-trips back through the broker.

## Where to look

- `spg_demo.c` — `init_xrt`/container setup, and the two Sparkplug
  Application callbacks (`on_device_added`, `on_metric_value_updated`).
  `on_device_added` fires for both device services, but only issues the
  demo `DCMD` write for the named `Virtual-Device` (the BACnet/IP profile
  has no matching writable metric).
- `deployment/config/mqtt_bridge.json` — the merged bridge config: outgoing
  patterns for the local node's births/data, and incoming patterns covering
  both the node's control-plane (`NCMD`/`DCMD`, decoded) and the
  application's data-plane (birth/data/ack, left as raw binary for the
  Sparkplug Application to decode).
- `deployment/config/sparkplug.json` / `sparkplug_node.json` — the
  `XRT::Sparkplug` config and `XRT::SparkplugNode` factory config
  respectively.
- `deployment/config/virtual.json` / `bacnet_ip.json` — the two device
  services feeding the same Sparkplug node; both share `"Group":
  "${SPARKPLUG_GROUP}"` so the node discovers them.
