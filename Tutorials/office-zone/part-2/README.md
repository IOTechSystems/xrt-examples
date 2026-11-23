# Office Zone Tutorial - Part 2: Develop a Sparkplug Client Application in C

The completed project for Part 2 of the Edge Connect Office Zone Tutorial. The step-by-step guide is in the [Edge
Connect documentation](https://docs.iotechsys.com/), under **Getting Started > Tutorials > Office Zone Tutorial**.

This folder contains everything from [Part 1](../part-1/README.md), plus the zone monitor: a Sparkplug
application written in C, using XRT's Sparkplug application library (`sparkplug/sparkplug_app.h`). It follows
the office zone published by the Xrt node, and switches the fan on when the zone is more than 1 °C above its
setpoint.

The zone monitor can learn about the office zone in three ways, each with its own configuration:

| Configuration | How the application learns about the zone |
|---|---|
| `app/deployment/dynamic` | Fully dynamic: from birth messages (NBIRTH and DBIRTH), asking the node to rebirth when it sees data it has no birth message for |
| `app/deployment/cached` | Partially dynamic: from birth messages, which it caches in `app/state` and reloads after a restart. It never asks for a rebirth |
| `app/deployment/static` | Static: from the birth records in `app/preload`, generated from the Xrt configuration. It ignores birth and death messages |

| Path | What it is |
|---|---|
| `app/main.c`, `app/zone_monitor.c`, `app/zone_monitor.h` | The zone monitor application |
| `app/Dockerfile` | Builds the application on the Xrt image |
| `app/app.pkl`, `app/zone_monitor.pkl`, `app/sparkplug_app.pkl` | PKL description the three configurations are generated from |
| `app/deployment/` | The three configurations, generated from `app/app.pkl` when you run it (not committed) |
| `app/preload/` | Birth records for static mode, generated from the Xrt configuration in `deployment/` |
| `xrt.env`, `app.env` | Environment variables for the Xrt and zone monitor containers |

Compared with Part 1, the Xrt node uses fixed Sparkplug aliases (`enable_fixed_aliases` in `deployment.pkl`,
and an `alias` for each resource in the device profile), which static mode needs.

## Prerequisites

As for Part 1, and copy your Edge Connect license file to `license.json` in this directory.

Building the zone monitor also needs the XRT `-dev` package for the same release as the Xrt image, `iotech-xrt-4.0-dev`,
which contains the XRT C headers. The Dockerfile installs the version that matches the image from the IOTech package
repository.

## Run it

Follow the [Edge Connect documentation](https://docs.iotechsys.com/), under **Getting Started > Tutorials > Office
Zone Tutorial > Part 2**: build the zone monitor in **Build the Zone Monitor**, then run it with each configuration in
**Run Fully Dynamically**, **Run Partially Dynamically** and **Run Statically**.
