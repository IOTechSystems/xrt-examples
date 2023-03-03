# EtherNet/IP Device Service Examples

## Overview

This page shows you how to setup and run the EtherNet/IP Device Service Example.

For more information about the Device Service please review the [EtherNet/IP Device Service](https://docs.iotechsys.com/edge-xrt20/device-service-components/ethernet-ip-device-service-component.html) documentation.

_Note if connecting to the EtherNet/IP docker simulator change the NetworkInterface driver option (`deployment/config/ethernet_ip.json`) to docker0 otherwise set it to the name of the network interface used on your host to communicate with EtherNet/IP devices on your local network._

## Getting Started

### Run the simulator

_for more information about the EtherNet/IP device simulator, see [EtherNet/IP Simulator](https://docs.iotechsys.com/edge-xrt20/simulators/ethernet-ip/overview.html)._

```bash
cd DeviceServices/ethernet-ip
./commands/start_device_sim.sh
```

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

An explanation for the setting of common device service enviroment variables can be found [here](../interactive-walkthrough/ds-getting-started-common.md#Device-service-configuration-setup).

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

### Discovery & Profile Generation

For a walkthrough on device discovery and profile generation see the [Discovery](../interactive-walkthrough/discovery.md) guide.
