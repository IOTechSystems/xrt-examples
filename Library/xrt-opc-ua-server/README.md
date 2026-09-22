# EC OPC UA Server (container)

## Overview

This is the "EC OPC UA Server" in the [reference architecture](../README.md):
an `XRT::OPCUAServer` component with `EnableSparkplug: true`, backed by an
`XRT::MQTTBridge` subscribed to the *whole* Sparkplug group with node and
device wildcards (`DBIRTH/+/+`, `DDATA/+/+`, `NBIRTH/+`, etc.) - so it sees
`Dev1`-`Dev4` regardless of which Edge Node (`app1-colocated` or
`xrt-standalone`) is publishing them - and publishing `NCMD/+`/`DCMD/+/+`
back out whenever the OPC UA browser writes a value.

No custom nodeset or mapping is used - `EnableSparkplug: true` on its own
makes the OPC UA Server auto-populate its address space directly from the
Sparkplug group/node/device/metric hierarchy as messages arrive.

## Image

No `Dockerfile`, no `deployment/` directory, **zero mounted JSON config
files** - this runs `iotechsys/connect-opc-ua-server` directly (see
[`../docker-compose.yml`](../docker-compose.yml)), a purpose-built image
distinct from the generic `iotechsys/xrt-server:3.4.6` that
[`../xrt-standalone/`](../xrt-standalone/README.md)/`app1-colocated` use.
It bakes in the same config shape [`../../Servers/opc-ua/federated/opc-ua/`](../../Servers/opc-ua/federated/opc-ua/README.md)
hand-authors (`XRT::MQTTBridge` + `XRT::Sparkplug` + `XRT::OPCUAServer`,
wired together) as its `deployment/config` at build time (from XRT's own
`templates/opcua-server-sparkplug`), entirely driven by environment
variables with sane defaults (`env.sh` in the image) - so this compose file
only needs to set the handful that matter for this stack:
`XRT_MQTT_BROKER`, `SPARKPLUG_GROUP`, `SPARKPLUG_APP_ID`, plus the shared
license/auth vars. Compare that to `xrt-standalone`'s/`app1-colocated`'s
11-ish hand-authored JSON files against the stock image.

It's also public - no registry login needed to pull it, unlike
`iotechsys/xrt-server`.

> **Pinned to `3.4.5-dev`, one patch behind the rest of the stack's
> `3.4.6`:** the `3.4.6-dev` build of this image links
> `libxrt-opc-ua-server.so` against a newer `libjwt` API
> (`jwt_checker_*`/`jwks_*`) than the `libjwt.so.2` it actually ships
> (confirmed via `ldd`/relocation errors at startup - the OPC UA Server,
> MQTTBridge and Sparkplug components all fail to load as a result). This
> looks like an upstream Alpine packaging bug in that particular tag, not
> anything wrong with this compose. Bump back to `3.4.6-dev` once IOTech
> republishes a working build for that version - `3.4.5-dev` doesn't have
> this bug and was confirmed to start cleanly and connect to `mosquitto`.

Unlike [`../xrt-standalone/`](../xrt-standalone/README.md) it needs no
startup wrapper either: it has no BACnet devices of its own to resolve
addresses for, it only talks Sparkplug over the broker.

## Connecting the OPC UA Browser

Open [`../README.md`](../README.md) for the full compose walkthrough. In
short: open the browser at `http://localhost:8080`, then connect to
`opc.tcp://xrt-opc-ua-server:4840` (the browser's own backend runs inside the
compose network, so the compose service name resolves - see
[`../../Servers/opc-ua/federated/README.md`](../../Servers/opc-ua/federated/README.md)
for the equivalent non-compose flow, where you'd type the host's own IP
instead). No security is configured, so click "SAVE AND CONNECT" through the
warning.

Once connected you should see `Dev1`-`Dev4` and their metrics under the
Sparkplug group/node hierarchy; writing a value from the browser publishes a
`DCMD` back out over the bus, same as `app1-colocated`'s own demo write.
