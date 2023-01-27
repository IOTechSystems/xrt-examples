# XRT Device Service Examples

This section contains examples for the IOTech XRT Device Services.

## About

Each of these examples contain a profiles directory, state directory, and a config for that respective device service so that it can be run out of the box with XRT. A device service's config will contain:
  
* Device service configured so that Discovery and Profile generation can be performed (if the device service supports these features).
* [MQTT Bridge](https://docs.iotechsys.com/edge-xrt20/bridge-components/mqtt-bridge-component.html) configuration so that XRT can be controlled through the MQTT API.
* [Logger](https://docs.iotechsys.com/edge-xrt20/core-components/logger-component.html)   configured at level INFO.
* Configured Core Components: [Scheduler](https://docs.iotechsys.com/edge-xrt20/core-components/scheduler-component.html), [Threadpool](hhttps://docs.iotechsys.com/edge-xrt20/core-components/threadpool-component.html), and [Bus](https://docs.iotechsys.com/edge-xrt20/core-components/bus-component.html).
* A profile for the device service simulated device.
* An added device.
* An added schedule for the device to read one or more of it's resources at a specified interval.

The device that the configs will connect to will be a simulated device, which will run on the same host as XRT. See the specific device service example's README for how to set the simulator up.

Additionally, a number of example scripts are provided that can be used to interact with XRT and the running device service through the MQTT bridge. These scripts perform typical operations, such as adding a device or performing a get request on some of it's resources.

## Examples

* [BACnet IP](bacnet-ip)
* [BACnet MSTP](bacnet-mstp)
* [Modbus RTU](modbus-rtu)
* [Modbus TCP](modbus-tcp)
* [OPC-UA](opc-ua)
* [Virtual](virtual)
* [EtherNet/IP](ethernet-ip)
* [BLE](ble)
* [EtherCAT](ethercat)
* [GPS](gps)
* [S7](s7)
* [PROFINET](profinet)
