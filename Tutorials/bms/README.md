# Battery Management System Tutorial

The completed project for the Edge Connect Battery Management System (BMS) tutorial. The step-by-step guide is in the
[Edge Connect documentation](https://docs.iotechsys.com/), under **Getting Started > Tutorials > Battery Management
System**.

The project runs a simulated battery energy storage system (BESS) and the Edge Connect components that monitor
it, all as Docker containers on one host:

| Container | What it does |
|---|---|
| `modbus-sim` | Modbus simulator: two battery racks (`rack-01`, `rack-02`) and an enclosure sensor |
| `opcua-sim` | OPC UA simulator: the site's grid connection meter (`site-meter`) |
| `xrt` | Edge Xrt: reads the devices and publishes them over Sparkplug B as node `bess-node` |
| `mqtt-broker` | EMQX MQTT broker |
| `alarm-service` | Alarm Service, with its OPC UA Server on port 4840 |
| `sparkplug-historian` | Stores the Sparkplug data in TimescaleDB |
| `timescaledb` | Database for the Historian and the Alarm Service |
| `grafana` | Dashboard of the stored data |
| `ekuiper` | Rules engine: averages rack-01's module temperatures for the Alarm Service |
| `connect-ui` | Edge Connect UI: OPC UA Browser and alarm management |
| `sparkplug-client` | Sparkplug Client web UI |

| Path | What it is |
|---|---|
| `docker-compose.yml`, `.env` | The containers, and the Sparkplug names and tutorial credentials they share |
| `deployment.pkl` | Description of the Xrt node, used to generate `deployment/config` and `deployment/state` |
| `deployment/` | The device profiles, and the Xrt configuration and devices once generated (not committed) |
| `simulators/` | The Modbus simulator script and the OPC UA simulator script |
| `alarm-service/` | Alarm definitions and the eKuiper message bus source |
| `ekuiper/` | The OPC UA source plugin for eKuiper, and scripts to install it and create the rule |
| `grafana/`, `timescaledb/` | Grafana data source and dashboard, and the database setup script |

## Prerequisites

* A Linux host with Docker and the Docker Compose plugin, and `curl` and `python3`
* An Edge Connect license that includes the Alarm Service, copied to `license.json` in this directory
* The [PKL CLI](https://pkl-lang.org/main/current/pkl-cli/index.html), version 0.29 or later

## Run it

Follow the [Edge Connect documentation](https://docs.iotechsys.com/), under **Getting Started > Tutorials > Battery
Management System**: start the system in **Set Up and Start the System**, then follow the data and raise alarms in
**Follow the Data** and **Work with Alarms**.
