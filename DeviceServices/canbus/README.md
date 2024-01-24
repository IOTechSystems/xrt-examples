# CANbus Device Service Example

## Overview

This page shows you how to setup and run the CANbus example. Note that the CANbus example requires hardware as no simulator is available at present.

For more information about the Device Service please review the [CANbus Device Service](https://docs.iotechsys.com/edge-xrt21/device-service-components/canbus-device-service-component.html)

## Getting Started

### Hardware Configuration
The scenario implemented in this example features the following hardware:

[M5Stack Basic Kit](https://shop.m5stack.com/products/basic-core-iot-development-kit?variant=16804801937498) running a CANbus data streaming program

USR-CANET200 CAN to Ethernet adaptor

### **Setup**

Follow the instructions in [CANbus Device Service](https://docs.iotechsys.com/edge-xrt21/device-service-components/canbus-device-service-component.html) for setting up a CANbus device Service.

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
cd canbus
xrt deployment/config
```
## Walkthrough

### Basic Operations 

For basic device service operations see the [Basic Operations Walkthrough](../interactive-walkthrough/basic-operations.md) guide.

note!!!
  To use the commands that include 'string' in the name, update the *profiles.json* to include the profile *canbus-profile-strings*.
