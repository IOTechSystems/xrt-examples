# OPC UA Server Colocated example

## Overview

This example shows an example of a colocated Virtual Device Service and an OPC UA Server running on the same Xrt instance, communicating via the internal bus. Note the existance of a `Command` component which is used by the OPC UA Server component to discover the running device service.

## Running the Example

The following instructions assume your starting working directory is `/xrt-examples/`.

### **Set Environment Variables**

We have provided a script to easily set these environment variables. Run:

```bash
. ./set_env_vars.sh
cd Servers/opc-ua/colocated/deployment
```

### **Run XRT with the config folder:**

See [Setup XRT](../../DeviceServices/interactive-walkthrough/setup-xrt.md)

```bash
xrt config
```

## Interacting with the OPC UA Server

See the [OPC UA Server Documentation](https://docs.iotechsys.com/edge-xrt22/server-components/opc-ua-server-component.html)
