# BLE Device Service Example

## Overview

This page shows you how to setup and run the BLE device service example.

For more information about the Device Service please review the [BLE Device Service](https://docs.iotechsys.com/edge-xrt20/device-service-components/ble-device-service-component.html) documentation.

## Getting Started

### **Run the simulator**

_For more information about the BLE device simulator, see [BLE Simulator](https://docs.iotechsys.com/edge-xrt20/simulators/ble/overview.html)._

```bash
./commands/start_device_sim.sh
```

The simulator runs its own BlueZ daemon and creates two virtual Bluetooth controllers, which must be `hci0` and `hci1`. To make this possible, the script prepares the host before starting the simulator and asks for your `sudo` password:

- The host `bluetooth` service is stopped and masked until the next reboot, as the simulator's BlueZ daemon cannot start while it is running.
- Every Bluetooth controller on the host is released by unbinding it from its driver (for example `btusb` for USB adapters), so that none of them takes `hci0`.

While the simulator is running, the host's own Bluetooth is unavailable. Only the changes the script actually makes are recorded, in `/tmp/ble-sim-host-state`. If any step fails, the script restores these changes before exiting.

The script also mounts [ble-sim-main.conf](commands/ble-sim-main.conf) into the simulator, which disables Enhanced ATT (EATT). Without it, GATT discovery between the simulator and the device service can stall and the device service does not find the device's characteristics.

> **Note** If the script reports a virtual controller or a controller with no driver to unbind, that controller cannot be released and the simulator is not started. Remove that controller and run the script again.

> **Note** The simulator provides a single device, with the MAC address `00:AA:01:01:00:24`. The batch device scripts add three devices, but only `ble-sim-01` uses this address and comes online. The simulator cannot serve more than one device to the device service at the same time, so increasing `DEVICE_COUNT` does not help.

### **Stop the simulator**

```bash
./commands/stop_device_sim.sh
```

This stops the simulator and restores the host changes recorded by `start_device_sim.sh`: the released controllers are bound to their drivers again, and the `bluetooth` service is unmasked and started again.

### **Set Environment Variables**

We have provided a script to easily set these environment variables. Run:

```bash
cd DeviceServices/ble
. ../../set_env_vars.sh
```

_Note the dot before the path to the script, which is required to set the environment variables in the executing shell._

**To set them manually:**

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
