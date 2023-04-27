# OPC-UA Device Service Example

## Overview

This page shows you how to setup and run the OPC-UA device service example. 

For more information about the Device Service please review the [OPC-UA Device Service](https://docs.iotechsys.com/edge-xrt20/device-service-components/opc-ua-device-service-component.html) documentation. 

## Getting Started

### **Run the simulator**

*For more information about the OPC-UA device simulator, see [OPC-UA Simulator](https://docs.iotechsys.com/edge-xrt20/simulators/opc-ua/overview.html).*

```bash
./commands/start_device_sim.sh
```

### **Set Environment Variables**

We have provided a script to easily set these environment variables. Run:

```bash
. ./commands/set_env_vars.sh
export OPCUA_SIM_ADDRESS=$(hostname):49947/
export OPCUA_LDS_ADDRESS=$(hostname):4840/
```

*Note the dot before the path to the script, which is required to set the environment variables in the executing shell.*

An explanation for the setting of common device service environment variables can be found [here](../interactive-walkthrough/ds-getting-started-common.md#Device-service-configuration-setup).

### **Common Device Service Setup**

Follow [Device Service Example Getting Started](../interactive-walkthrough/ds-getting-started-common.md) for the common device service example setup steps.

### **Run XRT with the config folder:**

See [Setup XRT](../interactive-walkthrough/setup-xrt.md)

```bash
cd opc-ua
xrt deployment/config
```

## Walkthrough

### Basic Operations 

For basic device service operations see the [Basic Operations Walkthrough](../interactive-walkthrough/basic-operations.md) guide.

### Subscriptions

Subscriptions are specific to the OPC-UA device service. You can read more about them [here](https://docs.iotechsys.com/edge-xrt20/device-service-components/opc-ua-device-service-component.html#opc-ua-subscriptions).

OPC-UA subscription requests are made on the same topics as Schedules. See [Schedule Management](../interactive-walkthrough/basic-operations.md#Schedule-Management)

**Create a subscription to a resource**

We can setup a subscription to a monitored resource using auto events. This will produce a reading every time the value we have subscribed to changes.

```bash
./commands/add_subscription.sh
```

**Remove the subscription to the resource**

```bash
./commands/remove_subscription.sh
```

### Discovery & Profile Generation

For a walkthrough on device discovery and profile generation see the [Discovery](../interactive-walkthrough/discovery.md) guide.
