# BACnet/MSTP Device Service Example

## Overview

This page shows you how to setup and run the BACnet/MSTP device service example.

For more information about the Device Service please review the [BACnet Device Service](https://www.link.to.bacnet.device.service.docs) documentation.

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

An explanation for the setting of common device service environment variables can be found [here](../interactive-walkthrough/ds-getting-started-common.md/#Device-service-configuration-setup).

### **Common Device Service Setup**
Follow [Device Service Example Getting Started](../interactive-walkthrough/ds-getting-started-common.md) for the common device service example setup steps.


### **Run XRT with the config folder:**

See [Setup XRT](../interactive-walkthrough/setup-xrt.md)

```bash
cd bacnet-mstp
xrt config
```

## Walkthrough

### Basic Operations

For basic device service operations see the [Basic Operations Walkthrough](../interactive-walkthrough/basic-operations.md) guide.

### Change of Value Subscriptions

Change of Value (COV) subscriptions are specific to the BACnet device service. You can read more about them [here](https://www.link-to-bacnet-covs.documentation).

COV subscription requests are made on the same topics as Schedules. See [Schedule Management](../interactive-walkthrough/basic-operations.md#Schedule-Management)

**Create a COV subscription to a resource**

We can setup a COV subscriptions to monitored resources using auto events. When the value of a monitored property changes, if the delta is larger than the COV Increment 
property value then the device will send the device service a notification which includes this new value.


```bash
./commands/add_cov.sh
```

**Remove the COV subscription to the resource**

```bash
./commands/remove_cov.sh
```

### Discovery

For a walkthrough on device discovery and profile generation see the [Discovery](../interactive-walkthrough/discovery.md) guide.

### Additional Information

To communicate with externally connected serial devices, update the driver option `SerialInterface` in the 
`bacnet_mstp_device_service.json` file to the path of the RS-485 connection on your host.