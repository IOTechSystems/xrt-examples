# EC Xrt - Standalone XRT (container)

Stock XRT running as a plain docker container, with no custom code. It sits
alongside [`app1-colocated`](../app1-colocated/README.md), which links XRT in as
a library, so the two approaches can be compared side by side on the same
Sparkplug bus.

This instance:

- talks to **Dev3** (BACnet/IP, `bacnet-sim-dev3`) and **Dev4** (BACnet/MSTP,
  `bacnet-sim-dev4`)
- publishes their data as Sparkplug `DDATA` under node `xrt1` (set with
  `SPARKPLUG_NODE1`), and accepts `DCMD` writes back, through the
  `mosquitto` broker

## Contents

| File | Purpose |
|---|---|
| `Dockerfile` | Adds `socat` and the entrypoint to the Debian/Ubuntu XRT image (`iotechsys/xrt:<XRT_VERSION>-deb13` by default, see [`../README.md`](../README.md)) |
| `entrypoint.sh` | Resolves Dev3's IP for BBMD, bridges Dev4's simulated MS/TP serial link over TCP to `/tmp/dev4-mstp`, then starts XRT |
| `deployment.pkl` | Source of all XRT config: the components (Sparkplug bridge + the two BACnet components) and their devices and schedules |
| `deployment/config/` | Component JSON config generated from `deployment.pkl` (gitignored) |
| `deployment/state/` | `devices.json`/`schedules.json` generated from `deployment.pkl` (gitignored), plus the BACnet device profiles |

`deployment/` is mounted into the container at
`/opt/iotech/xrt/3.4/deployment`.

## Generating config

The generated files aren't committed. Before the first run, and after editing
`deployment.pkl`, run:

```bash
cd Library
./generate-pkl-config.sh xrt-standalone
```

See [`../generate-pkl-config.sh`](../generate-pkl-config.sh) for what it needs.

## Running

Started as the `xrt-standalone` service by `docker compose up --build` from
[`../`](../README.md). Its logs should show `Dev3`/`Dev4` being birthed under
Sparkplug node `xrt1`.
