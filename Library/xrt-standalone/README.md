# EC Xrt (standalone container)

## Overview

This is the "EC Xrt" container in the [reference architecture](../README.md):
a **stock** `xrt` process - no custom C application, no library-linked code,
just plain JSON deployment config (`deployment/config/`) driving two
`XRT::BACnetIPDeviceService` instances (`Dev3`, `Dev4`), `XRT::MQTTBridge`
and `XRT::SparkplugNode`. It publishes real Sparkplug B traffic under its own
Edge Node identity (`${SPARKPLUG_NODE1}`, distinct from
[`../app1-colocated/`](../app1-colocated/README.md)'s `${SPARKPLUG_NODE}`) to
the same broker/group, so [`../app2-standalone/`](../app2-standalone/README.md)
and [`../xrt-opc-ua-server/`](../xrt-opc-ua-server/README.md) both see two
independent Edge Nodes on the bus.

## Image

`Dockerfile` is deliberately tiny: `FROM iotechsys/xrt-server:3.4.6` (the same public,
no-login image used for device-service Docker examples throughout
docs.iotechsys.com - mount a `deployment/` directory in, run `xrt
<config-dir>`), plus a small `entrypoint.sh` wrapper. There is nothing to
compile here.

`entrypoint.sh` resolves `bacnet-sim-dev3`/`bacnet-sim-dev4`'s addresses via
`getent hosts` (compose's embedded DNS - the equivalent of the `docker
inspect` step the host-run BACnet/IP examples elsewhere in this repo use) and
exports them as `BACNET_IP_DEV3_ADDRESS`/`BACNET_IP_DEV4_ADDRESS` before
running `xrt` - those are what `deployment/config/bacnet_ip_dev3.json`/
`bacnet_ip_dev4.json` use for their `Driver.BBMDAddress`.

> **Note:** the exact binary/config paths this wrapper calls
> (`/opt/iotech/xrt/3.4/bin/xrt /opt/iotech/xrt/3.4/deployment/config`) are
> corroborated by three independent sources: this repo's own existing
> READMEs (`/opt/iotech/xrt/3.4` as the typical install path), the sibling
> `xrt` source tree's own container entrypoint
> (`scripts/dockerfiles/xrt/entrypoint.sh`), and docs.iotechsys.com's
> device-service-docker pages (`-v <dir>/deployment:/opt/iotech/xrt/<ver>/deployment`).
> Still worth a first-run sanity check against whatever `iotechsys/xrt-server:3.4.6`
> tag actually resolves to.

## Where to look

- `deployment/config/bacnet_ip_dev3.json` / `bacnet_ip_dev4.json` - same
  shape as [`../app1-colocated/`](../app1-colocated/README.md)'s, differing
  only in local `Driver.Port` (47808/47809) and target `Driver.BBMDAddress`.
- `deployment/config/mqtt_bridge.json` / `sparkplug.json` / `sparkplug_node.json` -
  identical pattern to `app1-colocated`, just keyed off `${SPARKPLUG_NODE1}`
  instead of `${SPARKPLUG_NODE}` so the two Edge Nodes don't collide on the
  same Sparkplug topics.
