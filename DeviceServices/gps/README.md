# GPS Device Service Example

## Overview

This page shows you how to setup and run the GPS example.

For more information about the Device Service please review the [GPS Device Service](https://www.link-needs-updated.blah)

## Getting Started

### **Setup**

One of the following is needed before running the GPS component:

* An instance of GPSD connected to a GPS module
* A GPS simulator running (locally or in a container)

### **Set Environment Variables**

We have provided a script to easily set these environment variables. Run:
```bash
. ./commands/set_env_vars.sh
```
*Note the dot before the path to the script, which is required to set the environment variables in the executing shell.*

An explanation for the setting of common device service environment variables can be found [here](../interactive-walkthrough/ds-getting-started-common.md#Device-service-configuration-setup).

### **Common Device Service Setup**

Follow [Device Service Example Getting Started](../interactive-walkthrough/ds-getting-started-common.md) for the common device service example setup steps.

### **Run XRT with the config folder:**

See [Setup XRT](../interactive-walkthrough/setup-xrt.md)

```bash
cd gps
xrt deployment/config
```
## Walkthrough

### Basic Operations 

For basic device service operations see the [Basic Operations Walkthrough](../interactive-walkthrough/basic-operations.md) guide.
