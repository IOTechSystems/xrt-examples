# Getting Started with Xrt - Step 3: See the Data

The completed project for Step 3 of the Edge Connect Getting Started with Xrt tutorial. The step-by-step guide is in
the [Edge Connect documentation](https://docs.iotechsys.com/), under **Getting Started > Tutorials > Getting Started
with Xrt**.

Adds a schedule, an MQTT broker, the MQTT Bridge and Sparkplug node, and the Sparkplug Client web UI to see
the office zone's data.

| Path | What it is |
|---|---|
| `deployment.pkl`, `PklProject` | PKL description the Xrt configuration is generated from |
| `deployment/virtual/profiles/` | Device profile for the office zone |
| `deployment/config/`, `deployment/state/virtual/` | Xrt configuration, devices and schedules, generated from `deployment.pkl` when you run it (not committed) |
| `docker-compose.yml`, `xrt.env` | Xrt, the MQTT broker and the Sparkplug Client web UI, and Xrt's environment variables |
| `mosquitto/mosquitto.conf` | Broker configuration (anonymous access - tutorial only) |

## Prerequisites

- Linux with Docker and the Docker Compose plugin
- An Edge Connect license file, copied to `license.json` in this directory
- The [PKL CLI](https://pkl-lang.org/main/current/pkl-cli/index.html), version 0.29 or later

## Run it

Follow the [Edge Connect documentation](https://docs.iotechsys.com/), under **Getting Started > Tutorials > Getting
Started with Xrt > See the Data**.
