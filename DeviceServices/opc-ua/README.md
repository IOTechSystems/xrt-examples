# OPC-UA Device Service Example

## Overview

This example uses a Local Discovery Server (LDS) to perform the discovery of an opc-ua server.
Additionally, a complete opc-ua profile for the test server is provided with a schedule to read all of its resources every 3 seconds.
In this example, we use the iotech LDS and test server.

## Getting Started

### **Run the simulator**

*For more information about the OPC-UA device simulator, see [OPC-UA Simulator](https://www.fixthislink.please).*

```bash
./commands/start_device_sim.sh
```

### **Set Environment Variables**

We have provided a script to easily set these environment variables. Run:
```bash
. ./commands/set_env_vars.sh
```
*Note the dot before the path to the script, which is required to set the environment variables in the executing shell.*

**To set them manually:**

`OPCUA_SIM_ADDRESS` - The address of the simulation server

```bash
export OPCUA_SIM_ADDRESS=localhost:49947
```

`OPCUA_LDS_ADDRESS` - The address of the Local Discovery Server
```bash
export OPCUA_LDS_ADDRESS=localhost:4840
```

An explanation for the setting of common device service environment variables can be found [here.](../interactive-walkthrough/ds-getting-started-common.md/#Device-service-configuration-setup)

### **Common device service setup**
**Follow [Device Service Example Getting Started](../interactive-walkthrough/ds-getting-started-common.md) for the common device service example setup steps.**


### **Run XRT with the config folder:**

This is assuming that the following pre-requisites are satisfied:

* XRT is installed
* `LD_LIBRARY_PATH` has been correctly set
* Environment variable `XRT_LICENSE_FILE` has been set to the location of the xrt license 

```bash
cd opc-ua
xrt config
```

## Walkthrough

### Basic Operations 

For basic device service operations see the [Basic Operations Walkthrough](../interactive-walkthrough/basic-operations.md) guide.

### Subscriptions

**Create a subscription to a resource**

We can setup a subscription to a monitored resource using auto events. This will produce a reading every time the value we have subscribed to changes.

```bash
./add_subscription.sh
```

**Remove the subscription to the resource**

```bash
./remove_subscription.sh
```

### Discovery

For a walkthrough on device discovery and profile generation see the [Discovery](../interactive-walkthrough/discovery.md) guide.
