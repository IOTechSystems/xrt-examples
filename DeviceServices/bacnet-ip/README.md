# BACnet/IP Device Service Example

## Overview

This page shows you how to setup and run the BACnet/IP device service example.

For more information about the Device Service please review the [BACnet Device Service](https://docs.iotechsys.com/edge-connect33/xrt/devices/bacnet.html) documentation.

## Getting Started

### **Run the simulator**

_For more information about the BACnet device simulator, see [BACnet Simulator](https://docs.iotechsys.com/edge-connect33/xrt/simulators/bacnet/overview.html)._

```bash
./commands/start_device_sim.sh
```

The script starts four simulator containers, each a separate BACnet device with its own device instance: `bacnet-ip-sim` (instance 1234) for the single device example and `bacnet-ip-sim-01`, `bacnet-ip-sim-02` and `bacnet-ip-sim-03` (instances 1235, 1236 and 1237) for the batch device example. Use `./commands/stop_device_sim.sh` to stop them.

### **Set Environment Variables**

We have provided a script to easily set these environment variables. Run:

```bash
cd DeviceServices/bacnet-ip
. ../../set_env_vars.sh
export BACNET_IP_SIM_ADDRESS=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' bacnet-ip-sim)
```

_Note the dot before the path to the script, which is required to set the environment variables in the executing shell._

**To set them manually:**

`BACNET_IP_SIM_ADDRESS` - The address of the simulation server

```bash
export BACNET_IP_SIM_ADDRESS=<ip_of_sim>
```

> **Note** `BACNET_IP_SIM_ADDRESS` must be set in the environment that XRT is started from (for example in the run configuration of your IDE, if you do not start XRT from this shell), and must contain just the IP address of the `bacnet-ip-sim` simulator. The BACnet/IP device service registers with the BBMD at this address. If the variable is empty or wrong, the registration fails and none of the devices come online. The address changes whenever the simulators are recreated, so set the variable again and restart XRT after running `./commands/start_device_sim.sh`.

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

### Batch Operations

The batch commands are described in the [Basic Operations Walkthrough](../interactive-walkthrough/basic-operations.md). For this example:

- `commands/add_batch_devices.sh` adds the devices `bacnet-ip-sim-device-01`, `bacnet-ip-sim-device-02` and `bacnet-ip-sim-device-03`, which use the device instances of the simulators `bacnet-ip-sim-01`, `bacnet-ip-sim-02` and `bacnet-ip-sim-03`. The four simulators must be running first (see [Run the simulator](#run-the-simulator)).
- `commands/add_batch_schedules.sh` adds schedules for the default `bacnet-ip-sim` device.
- The `read_batch_*` and `remove_batch_*` scripts read and remove the batch devices and schedules.

#### Device instances and the profile

Each BACnet device is identified by its device instance, which is set with the `DeviceInstance` protocol property of the XRT device (1234 for the default `bacnet-ip-sim` device, and 1235, 1236 and 1237 for the batch devices). The device resources that read the properties of the device itself (for example `object-name` or `vendor-name`) address the BACnet Device object, whose `instance` attribute in the profile is also the device instance.

A profile with `instance` set to 1234 only works for the device with the device instance 1234. The other simulators have no Device object 1234, so reading these resources from the batch devices fails with `unknown-object` and the devices stay offline.

The Device object resources of the `bacnet-ip-sim-profile` use the wildcard device instance `4194303` to let the three batch devices share the one profile (the maximum BACnet instance number). Every BACnet device treats this value as itself, so the same profile works for devices with different device instances.

If you only want one device, you do not need the wildcard: add the device with the same instance as the default device (`1234`), and set the `instance` attribute of the Device object resources in `deployment/bacnet_ip/profiles/bacnet-ip-sim-profile.json` to `1234`. This matches `commands/add_device.sh`, which uses the device instance `1234`.

Another way to support several devices is to give each device its own profile, with the `instance` attribute of its Device object resources set to the device instance of that device. This needs a copy of the profile for every device, so instead, the wildcard is used in this example.

### Change of Value Subscriptions

Change of Value (COV) subscriptions are specific to the BACnet device service. You can read more about them [here](https://docs.iotechsys.com/edge-connect33/xrt/devices/bacnet.html#bacnet-change-of-value).

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

### Discovery & Profile Generation

For a walkthrough on device discovery and profile generation see the [Discovery](../interactive-walkthrough/discovery.md) guide.

### Additional Information

To communicate with devices on your local network, remove the `BBMDAddress` and `BBMDPort` driver  

If you have multiple network interfaces, add the driver option `NetworkInterface` to specify the name of the interface to use.
