# OPC UA Server Federated example

## Overview

This example shows an example of multiple Xrt Device Service instances and a separate Xrt instance with an OPC UA server component that communicate via MQTT. Note the existance of a `Command` component which is used by the OPC UA Server component to discover the running device services.

## Running the Example

The following instructions assume your starting working directory is `/xrt-examples/`.

### **Set Environment Variables**

We have provided a script to easily set these environment variables. Run:

```bash
. ./set_env_vars.sh
cd Servers/opc-ua/federated
```

### **Starting a Device Service Instance**

See [Setup XRT](../../DeviceServices/interactive-walkthrough/setup-xrt.md)

We have provided a script to run a Device Service instance of Xrt.

```bash
./command/start_instance.sh <xrt_executable> <instance_id>
```

Where `xrt_executable` is the path and name to the xrt executable and `instance_id` is the unique id of the instance being started.

```bash
./command/start_instance.sh xrt 1
```

User this script to create mulitple instances, but ensure to provide a unique instance id.
See `instance_template` for the configuration files for the instance.

### **Run XRT OPC UA Server:**

See [Setup XRT](../../DeviceServices/interactive-walkthrough/setup-xrt.md)

```bash
cd deployment
xrt config
```

## Interacting with the OPC UA Server

See the [OPC UA Server Documentation](https://docs.iotechsys.com/edge-xrt22/server-components/opc-ua-server-component.html)
