# Getting Started with Xrt - Step 5: Add a Device at Runtime

The completed project for Step 5 of the Edge Connect Getting Started with Xrt tutorial. The step-by-step guide
is in the Edge Connect documentation, under **Getting Started > Tutorials > Getting Started with Xrt**.

Adds a `meeting-room` device and its schedule while Xrt is running, with requests sent from the Sparkplug Client
web UI.

| Path | What it is |
|---|---|
| `requests/add-schedule.json` | The request that adds the `meeting-room` schedule. The device is added from the web UI's **Add a device** template |
| `deployment.pkl`, `PklProject` | PKL description the Xrt configuration is generated from |
| `deployment/virtual/profiles/` | Device profile for the office zone |
| `deployment/config/`, `deployment/state/virtual/` | Xrt configuration, devices and schedules, generated from `deployment.pkl` when you run it (not committed). Xrt adds the devices and schedules you add at runtime to `deployment/state/virtual/` |
| `docker-compose.yml`, `xrt.env` | Xrt, the MQTT broker and the Sparkplug Client web UI, and Xrt's environment variables |
| `mosquitto/mosquitto.conf` | Broker configuration (anonymous access - tutorial only) |

## Prerequisites

- Linux with Docker and the Docker Compose plugin
- An Edge Connect license file, copied to `license.json` in this directory
- The [PKL CLI](https://pkl-lang.org/main/current/pkl-cli/index.html), version 0.29 or later

## Run it

Follow the Edge Connect documentation, under **Getting Started > Tutorials > Getting Started with Xrt > Add a Device at Runtime**.
