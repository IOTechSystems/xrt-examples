# Office Zone Tutorial - Part 1: Install, Configure and Run Xrt

The completed project for Part 1 of the Edge Connect Office Zone Tutorial. The step-by-step guide is in the Edge
Connect documentation, under **Getting Started > Tutorials > Office Zone Tutorial**.

Xrt reads a simulated BACnet office zone controller through the BACnet/IP Device Service, and publishes its
data on an MQTT broker as Sparkplug B.

| Path | What it is |
|---|---|
| `docker-compose.yml` | MQTT broker, BACnet Simulator and Sparkplug Client web UI. The simulator has a fixed address, `172.16.238.10` |
| `xrt.env` | Environment variables for the Xrt container |
| `mosquitto/mosquitto.conf` | Broker configuration (anonymous access - tutorial only) |
| `simulator/office-zone.lua` | Simulator script: zone temperature, setpoint, occupancy and fan |
| `PklProject`, `deployment.pkl` | PKL node description the Xrt configuration is generated from |
| `deployment/config/`, `deployment/state/bacnet_ip/` | Xrt configuration, generated from `deployment.pkl` when you run it (not committed) |
| `deployment/bacnet_ip/profiles/` | Device profile for the office zone controller |

## Prerequisites

- Linux with Docker and the Docker Compose plugin
- An Edge Connect license file, copied to `license.json` in this directory
- The [PKL CLI](https://pkl-lang.org/main/current/pkl-cli/index.html), version 0.29 or later

## Run it

Follow the Edge Connect documentation, under **Getting Started > Tutorials > Office Zone Tutorial > Part 1**: generate
the configuration in **Generate the Configuration**, then start the containers and Xrt in **Run Xrt**.
