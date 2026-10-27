# EtherNet/IP Device Service Examples

## Overview

This page shows you how to setup and run the EtherNet/IP Device Service Example.

For more information about the Device Service please review the [EtherNet/IP Device Service](https://docs.iotechsys.com/edge-xrt20/device-service-components/ethernet-ip-device-service-component.html) documentation.

_Note the `NetworkInterface` driver option in `deployment/config/10-ethernet_ip.json` is set to `docker0`, which is the interface used to reach the EtherNet/IP docker simulators. To connect to real EtherNet/IP devices, change it to the name of the network interface used on your host to communicate with them on your local network._

## Getting Started

### Run the simulator

_for more information about the EtherNet/IP device simulator, see [EtherNet/IP Simulator](https://docs.iotechsys.com/edge-xrt20/simulators/ethernet-ip/overview.html)._

```bash
cd DeviceServices/ethernet-ip
./commands/start_device_sim.sh
```

The script starts four simulator containers: `ethernetip-sim` for the single device example and `ethernetip-sim-01`, `ethernetip-sim-02` and `ethernetip-sim-03` for the batch device example. Each device needs its own simulator, as the device service does not support multiple devices at the same IP address. Use `./commands/stop_device_sim.sh` to stop them.

### Set Environment Variables

We have provided a script to easily set these environment variables. Run:

```bash
. ../../set_env_vars.sh
export ETHERNETIP_SIM_ADDRESS=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ethernetip-sim)
```

_Note the dot before the path to the script, which is required to set the environment variables in the executing shell._

#### To set them manually:

`ETHERNETIP_SIM_ADDRESS` - The address of the EtherNet/IP Simulator

```
export ETHERNETIP_SIM_ADDRESS=<IP-Address>
```

An explanation for the setting of common device service environment variables can be found [here](../interactive-walkthrough/ds-getting-started-common.md#Device-service-configuration-setup).

### Common Device Service Setup

Follow [Device Service Example Getting Started](../interactive-walkthrough/ds-getting-started-common.md) for the common device service example setup steps.

### Run XRT with the config folder:

See [Setup XRT](../interactive-walkthrough/setup-xrt.md)

```bash
xrt deployment/config
```

> **Note** Xrt must be run from this context as the configuration files use relative pathnames

## Walkthrough

### Basic Operations

For basic device service operations see the [Basic Operations Walkthrough](../interactive-walkthrough/basic-operations.md) guide.

### Batch Operations

The batch commands are described in the [Basic Operations Walkthrough](../interactive-walkthrough/basic-operations.md). For this example:

- `commands/add_batch_devices.sh` adds the devices `ethernetip-sim-device-01`, `ethernetip-sim-device-02` and `ethernetip-sim-device-03`, which connect to the simulators `ethernetip-sim-01`, `ethernetip-sim-02` and `ethernetip-sim-03`. The four simulators must be running first (see [Run the simulator](#run-the-simulator)).
- `commands/add_batch_schedules.sh` adds schedules for the default `ethernetip-sim` device.
- The `read_batch_*` and `remove_batch_*` scripts read and remove the batch devices and schedules.

### Digital Inputs

The `ethernetip-sim-profile` exposes the eight digital inputs as the individual `Bool` resources `DI0`-`DI7`. Digital outputs `DO0`-`DO6` are read/write.

### Discovery & Profile Generation

For a walkthrough on device discovery and profile generation see the [Discovery](../interactive-walkthrough/discovery.md) guide.
