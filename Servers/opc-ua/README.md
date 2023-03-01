# OPC-UA Server Example

## Overview

This page shows you how to setup and run the OPC-UA sever example.

The example consists of an OPC-UA Server component and an S7 Device Service component with a simulated S7 device.

For more information about the OPC-UA Server please review the [OPC-UA Server](https://docs.iotechsys.com/edge-xrt21/server-components/opc-ua-server-component.html) documentation.

For more information about the Device Service please review the [S7 Device Service](https://docs.iotechsys.com/edge-xrt21/device-service-components/s7-device-service-component.html) documentation.

## Getting Started

The following instructions assume your starting working directory is `/xrt-examples/`.

### **Run the S7 simulator**

_For more information about the S7 device simulator, see [S7 Simulator](https://docs.iotechsys.com/edge-xrt21/simulators/s7/overview.html)._

```bash
./DeviceServices/s7/commands/start_device_sim.sh
```

### **Set Environment Variables**

We have provided a script to easily set these environment variables. Run:

```bash
cd Servers/opc-ua
. ../../set_env_vars.sh
export S7_SIM_ADDRESS=0.0.0.0
```

_Note the dot before the path to the script, which is required to set the environment variables in the executing shell._

### **Run XRT with the config folder:**

See [Setup XRT](../interactive-walkthrough/setup-xrt.md)

```bash
xrt deployment/config
```

> **Note** Xrt must be run from this context as the configuration files use relative pathnames

## Interacting with the OPC-UA Server

See the [OPC-UA Server Documentation](https://docs.iotechsys.com/edge-xrt21/server-components/opc-ua-server-component.html)
