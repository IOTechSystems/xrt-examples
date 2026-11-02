# Getting Started with Xrt - Step 1: Your First Xrt Node

The completed project for Step 1 of the Edge Connect Getting Started with Xrt tutorial. The step-by-step guide
is in the Edge Connect documentation, under **Getting Started > Tutorials > Getting Started with Xrt**.

A node with only Xrt's core components: a logger, the bus, two thread pools and a scheduler.

| Path | What it is |
|---|---|
| `deployment.pkl`, `PklProject` | PKL description the Xrt configuration is generated from |
| `deployment/config/` | Xrt configuration, generated from `deployment.pkl` when you run it (not committed) |
| `docker-compose.yml`, `xrt.env` | The Xrt container and its environment variables |

## Prerequisites

- Linux with Docker and the Docker Compose plugin
- An Edge Connect license file, copied to `license.json` in this directory
- The [PKL CLI](https://pkl-lang.org/main/current/pkl-cli/index.html), version 0.29 or later

## Run it

Follow the Edge Connect documentation, under **Getting Started > Tutorials > Getting Started with Xrt > Your First Xrt Node**.
