# Multiple Device Service Example

## Overview

This page shows you how to run XRT with multiple device services. The following device services are included in this example:

- BACnet/IP
- OPC-UA
- Modbus-TCP

For more information about the Device Services included please review the [BACnet Device Service](https://docs.iotechsys.com/edge-xrt21/device-service-components/bacnet-device-service-component.html), [Modbus Device Service](https://docs.iotechsys.com/edge-xrt21/device-service-components/modbus-device-service-component.html) and [OPC-UA Device Service](https://docs.iotechsys.com/edge-xrt21/device-service-components/opc-ua-device-service-component.html) documentation.

## Getting Started

### Environment Variables

Set the environment variable `DIR_PATH` to the `DeviceServices` path in the xrt-examples directory, for example:

```shell
    export DIR_PATH=/xrt-examples/DeviceServices
```

### Setup Simulators

For each service included, setup the relevant simulator and environment variables by following the instructions in the individual device service guides.

### **Common Device Service Setup**

Follow [Device Service Example Getting Started](../interactive-walkthrough/ds-getting-started-common.md) for the common device service example setup steps.

### **Run XRT with the config folder:**

See [Setup XRT](../interactive-walkthrough/setup-xrt.md)

```bash
cd DeviceServices/multiple-services
xrt deployment/config
```

> **Note** Xrt must be run from this context as the configuration files use relative pathnames
