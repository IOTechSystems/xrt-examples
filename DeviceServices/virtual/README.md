# Virtual Device Service Example

## Overview

This page shows you how to set up and run the virtual device service example.

For more information about the Device Service please review the [Virtual Device Service](https://docs.iotechsys.com/edge-xrt20/device-service-components/virtual-device-service-component.html) documentation.

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

> **Note** Xrt must be run from this context as the configuration files use relative pathnames

## Walkthrough

### Basic Operations

For basic device service operations see the [Basic Operations Walkthrough](../interactive-walkthrough/basic-operations.md) guide.

### DCMD Write Operations

In this example the put_request.sh and put_multi_request.sh commands are using the Sparkplug API to send write commands to the device. 

These work by adding the device's name on the message topic and specifying the properties you want to change as separate metrics.

Each metric needs to have a name/alias of the property to alter, a value, and a datatype of the property. The datatype currently can only be specified by an integer. 

See [Chapter 6.4.16 of Sparkplug Specification](https://sparkplug.eclipse.org/specification/version/3.0/documents/sparkplug-specification-3.0.0.pdf#page=83) for the full list of datatypes 