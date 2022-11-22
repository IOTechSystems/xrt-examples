# Zigbee Device Service Example

## Overview

This page shows you how to set up and run the Zigbee Device Service example.

For more information about the Device Service please review the [Zigbee Device Service](https://docs.iotechsys.com/edge-xrt21/device-service-components/zigbee-device-service-component.html) documentation.

## Getting Started


### Example Devices

Unlike many of the examples for the other Device Services, there is no readily available Zigbee device simulator. Therefore, this example is instead based off two real world devices which are required to run the example. The devices used are an [OSRAM Flex RGBW LED Light Strip](https://www.zigbee2mqtt.io/devices/4052899926110.html) and an [Immax Intelligent Motion Sensor](https://www.zigbee2mqtt.io/devices/07047L.html). Click on each device to view their respective pages within the Zigbee2MQTT documentation.

### Start Zigbee2MQTT

*For more information on Zigbee2MQTT, please read the [Zigbee2MQTT documentation](https://www.zigbee2mqtt.io/)*

The following script simplifies the process of starting Zigbee2MQTT. To proceed, the Zigbee adapter location and the MQTT broker address are required. 

Run:

```bash
. ./commands/start_zigbee2mqtt.sh
```

### Stop Zigbee2MQTT

To stop Zigbee2MQTT, run the following:

```bash
. ./commands/stop_zigbee2mqtt.sh
```

### **Set Environment Variables**

We have provided a script to easily set these environment variables. Run:
```bash
. ./commands/set_env_vars.sh
```
*Note the dot before the path to the script, which is required to set the environment variables in the executing shell.*

An explanation for the manual setting of common device service environment variables can be found [here](../interactive-walkthrough/ds-getting-started-common.md/#Device-service-configuration-setup).

### **Common Device Service Setup**
Follow [Device Service Example Getting Started](../interactive-walkthrough/ds-getting-started-common.md) for the common device service example setup steps.


### **Run XRT with the config folder:**

See [Setup XRT](../interactive-walkthrough/setup-xrt.md)

```bash
cd zigbee
xrt deployment/config
```

## Walkthrough

### Basic Operations

For basic device service operations see the [Basic Operations Walkthrough](../interactive-walkthrough/basic-operations.md) guide.

### Discovery & Profile Generation

For a walkthrough on device discovery and profile generation see the [Discovery](../interactive-walkthrough/discovery.md) guide.

### Device Reporting

The Immax sensor used within this example is capable of device reporting. More information about Zigbee device reporting can be found within the [Xrt Documentation](https://docs.iotechsys.com/edge-xrt21/device-service-components/zigbee-device-service-component.html#zigbee-device-reporting).

For an example which enables reporting for two resources, run:

```bash
. ./commands/add_reporting_schedule.sh
```

The above command enables reporting of the `illuminance` and `illuminance_lux` resources belonging to the Immax sensor. The reported values can be seen in the telemetry topic.

To disable the reporting of these resources, run:

```bash
. ./commands/remove_reporting_schedule.sh
```


### Network Management Commands

The Zigbee Device Service also implements certain Zigbee2MQTT network management commands. More information and a full list of these network commands can be found in the [Xrt Documentation](https://docs.iotechsys.com/edge-xrt21/device-service-components/zigbee-device-service-component.html#network-management-commands).

For each of these network commands, there is a shell script to demonstrate an example request. These all refer to the `coordinator` device which implements the `coordinator_profile`. Within this profile, you can see each of the network commands being represented by a resource.

An example of one of these commands is `permit_join`, which determines whether new devices are allowed to join the network. For an example of this command being used, run:

```bash
. ./commands/permit_join_network_command.sh
```

Another network command is `configure_reporting`. This command allows you to configure reporting at the device level on a cluster-attribute basis. The example request within `configure_reporting_network_command.sh` configures the `measuredValue` attribute belonging to the `msIlluminanceMeasurement` cluster to report every 8 seconds as long as the value has changed by at least 1.

To use this example request, run:

```bash
. ./commands/configure_reporting_network_command.sh
```