# Getting Started with Xrt - Step 2: Add a Virtual Device

The completed project for Step 2 of the Edge Connect Getting Started with Xrt tutorial. The step-by-step guide is in
the [Edge Connect documentation](https://docs.iotechsys.com/), under **Getting Started > Tutorials > Getting Started
with Xrt**.

Adds the Virtual device service, and an `office-zone` device whose `zone-temperature` follows a sine wave.

| Path | What it is |
|---|---|
| `deployment.pkl`, `PklProject` | PKL description the Xrt configuration is generated from |
| `deployment/virtual/profiles/` | Device profile for the office zone |
| `deployment/config/`, `deployment/state/virtual/` | Xrt configuration and devices, generated from `deployment.pkl` when you run it (not committed) |
| `docker-compose.yml`, `xrt.env` | The Xrt container and its environment variables |

## Prerequisites

- Linux with Docker and the Docker Compose plugin
- An Edge Connect license file, copied to `license.json` in this directory
- The [PKL CLI](https://pkl-lang.org/main/current/pkl-cli/index.html), version 0.29 or later

## Run it

Follow the [Edge Connect documentation](https://docs.iotechsys.com/), under **Getting Started > Tutorials > Getting
Started with Xrt > Add a Virtual Device**.
