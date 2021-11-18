# XRT Device Service Examples

This section contains examples for the IOTech XRT Device Services.

## About

Each of these examples contain a profiles directory, state directory, and a config for that respective device service so that it can be run out of the box with XRT. A device service's config will contain:
  
* Device service configured so that Discovery and Profile generation can be performed (if the device service supports these features).
* [MQTT Bridge](https://www.link.to.mqtt-bridge.docs) configuration so that XRT can be controlled through the MQTT API.
* [Logger](https://www.link.to.logger.docs)   configured at level INFO.
* Configured Core Components: [Scheduler](https://www.link.to.scheduler.docs), [Threadpool](https://www.link.to.threadpool.docs), and [Bus](https://www.link.to.bus.docs).  
* A profile for the device service simulated device.
* An added device.
* An added schedule for the device to read one or more of it's resources at a specified interval.

The device that the configs will connect to will be a simulated device, which will run on the same host as XRT. See the specific device service example's README for how to set the simulator up.

Additionally, a number of example scripts are provided that can be used to interact with XRT and the running device service through the MQTT bridge. These scripts perform typical operations, such as adding a device or performing a get request on some of it's resources.

## Examples

* [BACnet IP](bacnet-ip)
* [BACnet MSTP](bacnet-mstp)
* [Modbus](modbus)
* [OPC-UA](opc-ua)
* [Virtual](virtual)
