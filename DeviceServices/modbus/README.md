# XRT Config Examples

## Overview

This page shows you how to setup and run the Modbus-TCP device service example.

For more information about the Device Service please review the [Modbus Device Service](https://www.link.to.modbus.device.service.docs) documentation.

## Getting Started

### **Run the simulator**

```bash
./commands/start_device_sim.sh
```

If you want to use Modbus-RTU rather than the default option of Modbus-TCP, simply add the argument '-rtu' to the end of this command, like so: 

```bash
./commands/start_device_sim.sh -rtu
```

This will run an RTU simulator with the adddress `/dev/ttyUSB0`. Any subsequent calls to the other scripts will also use RTU communication until the simulator is restarted. 

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
cd modbus
xrt deployment/config
```

## Walkthrough

### Basic Operations

For basic device service operations see the [Basic Operations Walkthrough](../interactive-walkthrough/basic-operations.md) guide.

