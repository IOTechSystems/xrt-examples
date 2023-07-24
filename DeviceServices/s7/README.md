# S7 Device Service Example

## Overview

This page shows you how to setup and run the S7 device service example.

For more information about the Device Service please review the [S7 Device Service](https://docs.iotechsys.com/edge-xrt22/device-service-components/s7-device-service-component.html) documentation.

## Getting Started

### **Run the simulator**

_For more information about the S7 device simulator, see [S7 Simulator](https://docs.iotechsys.com/edge-xrt22/simulators/s7/overview.html)._

```bash
./commands/start_device_sim.sh
```

### **Set Environment Variables**

We have provided a script to easily set these environment variables. Run:

```bash
cd DeviceServices/s7
. ../../set_env_vars.sh
export S7_SIM_ADDRESS=0.0.0.0
```

_Note the dot before the path to the script, which is required to set the environment variables in the executing shell._

An explanation for the setting of common device service environment variables can be found [here](../interactive-walkthrough/ds-getting-started-common.md#Device-service-configuration-setup).

### **Common Device Service Setup**

Follow [Device Service Example Getting Started](../interactive-walkthrough/ds-getting-started-common.md) for the common device service example setup steps.

### **Run XRT with the config folder:**

See [Setup XRT](../interactive-walkthrough/setup-xrt.md)

```bash
xrt deployment/config
```

> **Note** Xrt must be run from this context as the configuration files use relative pathnames

## Walkthrough

### Basic Operations

For basic device service operations see the [Basic Operations Walkthrough](../interactive-walkthrough/basic-operations.md) guide.
