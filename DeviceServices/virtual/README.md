# Virtual Device Service Example

## Overview

This page shows you how to set up and run the virtual device service example.

For more information about the Device Service please review the [Virtual Device Service](https://docs.iotechsys.com/edge-xrt22/device-service-components/virtual-device-service-component.html) documentation.

## Getting Started

### **Set Environment Variables**

We have provided a script to easily set these environment variables. Run:

```bash
cd DeviceServices/virtual
. ../../set_env_vars.sh
```

_Note the dot before the path to the script, which is required to set the environment variables in the executing shell._

An explanation for the manual setting of common device service environment variables can be found [here](../interactive-walkthrough/ds-getting-started-common.md/#Device-service-configuration-setup).

### **Common Device Service Setup**

Follow [Device Service Example Getting Started](../interactive-walkthrough/ds-getting-started-common.md) for the common device service example setup steps.

### **Run XRT with the config folder:**

See [Setup XRT](../interactive-walkthrough/setup-xrt.md)

```bash
xrt deployment/config
```

> **Note**
> 1. Xrt must be run from this context as the configuration files use relative pathnames
> 2. Only resources that have changed by more than the set bounds (in `schedules.json`) will be published.

## Walkthrough

### Basic Operations

For basic device service operations see the [Basic Operations Walkthrough](../interactive-walkthrough/basic-operations.md) guide.
