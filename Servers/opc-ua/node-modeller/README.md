# OPC-UA Server Node Modeller Example

## Overview

This example shows you how to run the OPC-UA server with a custom node model. The model uses the [EUROMAP77](https://www.euromap.org/euromap77) nodeset and creates an instance of an IMM (Injection Moulding Machines) and MES (Manufacturings Execurtions Systems) interface. Additionally, the model maps resources from a simulated s7 device to this interface.

For more information about the OPC-UA Server and Node Modelling please review the [OPC-UA Server](https://docs.iotechsys.com/edge-xrt22/server-components/opc-ua-server-component.html) documentation.

For more information about the Device Service please review the [S7 Device Service](https://docs.iotechsys.com/edge-xrt22/device-service-components/s7-device-service-component.html) documentation.

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
cd ./Servers/opc-ua/
. ./commands/set_env_vars.sh
```

> The dot before the path to the script, which is required to set the environment variables in the executing shell.*

### **Run XRT with the config folder:**

See [Setup XRT](../../DeviceServices/interactive-walkthrough/setup-xrt.md)

```bash
xrt deployment/config
```

## Interacting with the OPC-UA Server

See the [OPC-UA Server Documentation](https://docs.iotechsys.com/edge-xrt21/server-components/opc-ua-server-component.html)
