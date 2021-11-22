# BACnet/IP Device Service Example

## Overview

This page shows you how to setup and run the BACnet/IP device service example.

For more information about the Device Service please review the [BACnet Device Service](https://www.link.to.opc-ua.device.service.docs) documentation.

## Getting Started

### **Run the simulator**

*For more information about the BACnet device simulator, see [BACnet Simulator](https://www.fixthislink.please).*

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

`BACNET_SIM_ADDRESS` - The address of the simulation server

```bash
export BACNET_SIM_ADDRESS=localhost:49947
```

An explanation for the setting of common device service environment variables can be found [here](../interactive-walkthrough/ds-getting-started-common.md/#Device-service-configuration-setup).

### **Common Device Service Setup**
Follow [Device Service Example Getting Started](../interactive-walkthrough/ds-getting-started-common.md) for the common device service example setup steps.


### **Run XRT with the config folder:**

See [Setup XRT](../interactive-walkthrough/setup-xrt.md)

```bash
cd opc-ua
xrt config
```

## Walkthrough

### Basic Operations

For basic device service operations see the [Basic Operations Walkthrough](../interactive-walkthrough/basic-operations.md) guide.

### Change of Value Subscriptions

Change of Value (COV) Subscriptions are specific to the BACnet device service. You can read more about them [here](https://www.link-to-bacnet-cov-subscriptions.documentation).

BACnet COV subscription requests are made on the same topic as Schedules. See [Schedule Management](../interactive-walkthrough/basic-operations.md#Schedule-Management)

**Create a COV subscription to a resource**

We can setup a COV subscription to a monitored resource using auto events. This will produce a reading every time the value we have subscribed to changes.

```bash
./add_cov_subscription.sh
```

**Remove the subscription to the resource**

```bash
./remove_cov_subscription.sh
```

### Discovery

For a walkthrough on device discovery and profile generation see the [Discovery](../interactive-walkthrough/discovery.md) guide.
