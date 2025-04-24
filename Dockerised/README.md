# Dockerised XRT instances Example

## Overview

This is an example of a configuration of multiple instances of XRT running within their own containers.

These containers run using the configuration from other examples, it may be helpful to be familiar with these examples before beginning this one:

- [BACnet IP](../DeviceServices/bacnet-ip)
- [Modbus TCP](../DeviceServices/modbus-tcp)
- [Virtual](../DeviceServices/virtual)
- [S7](../DeviceServices/s7)
- [Federated OPC-UA Server](../Servers/opc-ua/federated/)

## Getting Started

### **Common Device Service Setup**

Follow [Device Service Example Getting Started](../DeviceServices/interactive-walkthrough/ds-getting-started-common.md) for the common device service example setup steps for installing and using `mosquitto` MQTT client.

### Docker Compose

[docker compose](https://docs.docker.com/compose/install/) is required to control the multiple containers for this example easily.

## Walkthrough

### Stopping/Starting profiles

Each component can be controlled through docker compose profiles, which can all be stopped or started independently.
These profiles are:

- `mqtt` for the MQTT broker
- `opcua` for the OPC-UA server and browser
- `exporter` for InfluxDB/Grafana instances with data storage and visualisation
- `devices` for *ALL* of the following devices, to control them simultaneously
    - `virtual` for the [Virtual](../DeviceServices/virtual) device service
    - `s7` for the [S7](../DeviceServices/s7) device service and simulator
    - `modbus-tcp` for the [Modbus TCP](../DeviceServices/modbus-tcp) device service and simulator
    - `bacnet-ip` for the [BACnet IP](../DeviceServices/bacnet-ip) device service and simulator

```bash
# All profiles
COMPOSE_PROFILES=* docker compose up -d
COMPOSE_PROFILES=* docker compose down

# Alternatively
docker compose --profiles "*" up -d
docker compose --profiles "*" down
```

The `-d`/`--detach` flag on `compose up` commands starts the session detached, allowing you to stop/start other profiles easily.
Without the `-d` flag you will be attached to the docker session and view the logs in the console.
A useful tool to view the logs for multiple detached docker containers is [lazydocker](https://github.com/jesseduffield/lazydocker).

These profiles don't all have to be run at once.
For example after starting up all devices, you could decide to stop `s7`, then later start up the `exporter` profile for the grafana dashboard:

```bash
COMPOSE_PROFILES=mqtt,devices docker compose up -d
COMPOSE_PROFILES=s7 docker compose down
COMPOSE_PROFILES=exporter docker compose up -d
```

**Note that mqtt profile is required for any of the containers to communicate with each other, but this can also be stopped/started independently if desired.**

### MQTT

When the `mqtt` profile is up, subscribe to all xrt topics in a new terminal to see all of our requests and their replies.

```bash
mosquitto_sub -v -t "#"
```

### OPC-UA Browser

When the `opcua` profile is up, view the OPC-UA Browser by visiting [localhost:8080](localhost:8080) in the browser of your choice.
Enter `10.10.0.30` as the connection address to the OPC-UA Server.
This IP address is configured in the docker-compose.yml file.

From here we can see all the running devices, with the current values in their resources.
Resources that are configured to be writable can also be modified from this can also be modified from the OPC-UA Browser.

### Device Commands

The commands from each DeviceService example can still be used to modify the device values, schedules or status.

```bash
../DeviceServices/virtual/commands/get_request.sh
```

### Grafana Dashboard

When the `exporter` profile is up, view the Grafana dashboard by visitng [localhost:3000](localhost:3000) in the browser of your choice.

View the pre-configured dashboard by going to Dashboards on the left nav bar, and selecting Dockerised Examples Dash.
This dashboard will show saved data from devices running and saved to InfluxDB by another containerised instance of XRT.

The Grafana config files are held in `./deployment/grafana`.
The Exporter XRT instance config files are held in `./deployment/deployment`.