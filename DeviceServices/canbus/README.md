# XRT Config Examples

## Overview

This page shows you how to setup and run the CANbus device service example.

For more information about the Device Service please review the [CANbus Device Service](https://docs.iotechsys.com/edge-connect30/xrt/devices/canbus.html) documentation.

## Getting Started

### **Run the simulator**

The example device connects to the CANbus simulator at `192.168.50.7:20001`. The script creates a docker network, `canbus-sim-net` (subnet `192.168.50.0/24`), if it does not exist yet, and starts four simulator containers on it: `canbus-sim` (`192.168.50.7`) for the single device example and `canbus-sim-01`, `canbus-sim-02` and `canbus-sim-03` (`192.168.50.8` to `192.168.50.10`) for the batch device example. Each device needs its own simulator, as a simulator serves only one client at a time:

```bash
cd DeviceServices/canbus
./commands/start_device_sim.sh
```

### **Stop the simulator**

```bash
./commands/stop_device_sim.sh
```

### **Set Environment Variables**

We have provided a script to easily set these environment variables. Run:

```bash
cd DeviceServices/canbus
. ../../set_env_vars.sh
```

_Note the dot before the path to the script, which is required to set the environment variables in the executing shell._

An explanation for the setting of common device service environment variables can be
found [here](../interactive-walkthrough/ds-getting-started-common.md#Device-service-configuration-setup).

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

### Batch Operations

The batch commands are described in the [Basic Operations Walkthrough](../interactive-walkthrough/basic-operations.md). For this example:

- `commands/add_batch_devices.sh` adds `canbus-device-01`, `canbus-device-02` and `canbus-device-03`, which connect to the simulators `canbus-sim-01`, `canbus-sim-02` and `canbus-sim-03`. The four simulators must be running first (see [Run the simulator](#run-the-simulator)).
- `commands/add_batch_schedules.sh` adds schedules for the default `canbus-device` device.
- The `read_batch_*` and `remove_batch_*` scripts read and remove the batch devices and schedules.

The `ID` of the batch devices is the same as the default device's, as it identifies the CAN message the device decodes (J1939 EEC2 here), not the device itself. The devices are told apart by their network address.

