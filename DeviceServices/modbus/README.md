# XRT Config Examples

## Overview

This page shows you how to setup and run the Modbus-TCP device service example.

For more information about the Device Service please review the [Modbus Device Service](https://www.link.to.modbus.device.service.docs) documentation.

## Getting Started

### **Run the simulator**

*For more information about the Modbus device simulator, see [Modbus Simulator](https://www.fixthislink.please).*

```bash
./commands/start_device_sim.sh
```

### **Set Environment Variables**

We have provided a script to easily set these environment variables. Run:
```bash
. ./commands/set_env_vars.sh
```
*Note the dot before the path to the script, which is required to set the environment variables in the executing shell.*

<!--todo: update-->
**To set them manually:**

- `MODBUS_DEVICE_ADDRESS`
    - This variable contains the IP or serial address of the target modbus device. This could be a simulator or a physical device that supports modbus. This environment variable is used to update `devices.json` in the `state` directory of the example configs - without it, the device service won't be able to find the target modbus device.
      - Example for a locally-hosted Modbus TCP simulator: `export MODBUS_DEVICE_ADDRESS=127.0.0.1`
      - Example for a locally-hosted Modbus RTU simulator: `export MODBUS_DEVICE_ADDRESS=/dev/tty/usb0`
      - Example for Modbus TCP device hosted at another IP address: `export MODBUS_DEVICE_ADDRESS=192.168.10.100`



- `MODBUS_DEVICE_PORT`
  - This is an environment variable denoting the port used by the target modbus device.
  - It is typically port 502 or 1502 if running a simulated device, although any available port will work with ModbusPal when configured through the GUI. 
    - Example: `export MODBUS_DEVICE_PORT=1502`

An explanation for the setting of common device service environment variables can be found [here](../interactive-walkthrough/ds-getting-started-common.md#Device-service-configuration-setup).

### **Common Device Service Setup**

Follow [Device Service Example Getting Started](../interactive-walkthrough/ds-getting-started-common.md) for the common device service example setup steps.

<!--todo: consider whether the below should be used with rtu AND tcp (i.e. in 2 separate folders)-->

### **Run XRT with the config folder:**

See [Setup XRT](../interactive-walkthrough/setup-xrt.md)

```bash
cd modbus
xrt deployment/config
```

## Walkthrough

### Basic Operations

For basic device service operations see the [Basic Operations Walkthrough](../interactive-walkthrough/basic-operations.md) guide.

