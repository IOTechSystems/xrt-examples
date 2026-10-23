# Basic Tutorial - Part 3: Link Xrt as a Shared Library

The completed project for Part 3 of the Edge Connect Basic Tutorial. The step-by-step guide is in the Edge
Connect documentation, under **Getting Started > Tutorials > Basic Tutorial**.

This folder contains the [Part 1](../part-1/README.md) project, plus the zone monitor from
[Part 2](../part-2/README.md), built into an application that links Xrt as a shared library. The application runs
the Part 1 Xrt configuration (BACnet/IP Device Service, Sparkplug node and MQTT Bridge) and the zone monitor in
the same process:

- the zone monitor follows the office zone and switches its fan on over the internal Xrt bus, without going
  through the MQTT broker
- the MQTT Bridge still publishes the office zone's data on the broker, as in Part 1

| Path | What it is |
|---|---|
| `app/main.c`, `app/zone_monitor.c`, `app/zone_monitor.h` | The application. As in Part 2, plus an `AppId` option for the zone monitor |
| `app/Dockerfile` | Builds the application on the Xrt image |
| `app/zone_monitor.pkl`, `app/sparkplug_app.pkl` | PKL class for the zone monitor component, and the Sparkplug application settings it uses |
| `deployment.pkl` | The Part 1 node description, plus the zone monitor |
| `app.env` | Environment variables for the application container |
| `deployment/bacnet_ip/` | The office zone device profile |
| `deployment/config/`, `deployment/state/bacnet_ip/` | The configuration, generated from `deployment.pkl` when you run it (not committed) |

## Prerequisites

As for Part 1, and copy your Edge Connect license file to `license.json` in this directory.

## Run it

Generate the configuration from `deployment.pkl`:

```bash
pkl project resolve .
pkl eval -m deployment deployment.pkl
```

Then start the supporting containers, and build and run the application:

```bash
docker compose up -d
docker build -t zone-app app

docker run -d --name zone-app --user "$(id -u):$(id -g)" --network xrt-tutorial --env-file app.env \
  -v "$PWD/deployment:/app/deployment" \
  -v "$PWD/license.json:/app/license.json:ro" \
  zone-app

docker logs -f zone-app
```

There is no separate Xrt container: the application is the Xrt node. Open the Sparkplug Client web UI at
<http://localhost:8090> to see the office zone's data.

After changing `deployment.pkl`, generate the configuration again and restart the application:

```bash
pkl eval -m deployment deployment.pkl
docker restart zone-app
```

Stop everything with:

```bash
docker rm -f zone-app
docker compose down
```
