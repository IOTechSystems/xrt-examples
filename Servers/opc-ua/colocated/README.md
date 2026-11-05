# OPC-UA Server Example

## Overview

This page shows you how to setup and run the OPC-UA sever example.

The example consists of an OPC-UA Server component and four Device Service components that run in the same XRT process: S7, Modbus, BACnet/IP and Virtual. The S7, Modbus and BACnet/IP device services each read a simulated device. The Virtual device service generates its own values and needs no simulator.

For more information about the OPC-UA Server please review the [OPC-UA Server](https://docs.iotechsys.com/edge-xrt21/server-components/opc-ua-server-component.html) documentation.

For more information about the Device Services please review the [S7 Device Service](https://docs.iotechsys.com/edge-xrt21/device-service-components/s7-device-service-component.html) documentation.

## Getting Started

The following instructions assume your starting working directory is `/xrt-examples/`.

### **Run the S7 simulator**

_For more information about the S7 device simulator, see [S7 Simulator](https://docs.iotechsys.com/edge-xrt21/simulators/s7/overview.html)._

```bash
./DeviceServices/s7/commands/start_device_sim.sh
```

### **Run the Bacnet simulator**

_For more information about the Bacnet device simulator, see [Bacnet Simulator](https://docs.iotechsys.com/edge-xrt21/simulators/bacnet/overview.html)._

```bash
./DeviceServices/bacnet-ip/commands/start_device_sim.sh
```

### **Run the Modbus simulator**

_For more information about the Modbus device simulator, see [Modbus Simulator](https://docs.iotechsys.com/edge-xrt21/simulators/modbus/overview.html)._

```bash
./DeviceServices/modbus-tcp/commands/start_device_sim.sh
```

### **Set Environment Variables**

We have provided a script to easily set these environment variables. Run:

```bash
cd Servers/opc-ua/colocated/
. ../../../set_env_vars.sh
export S7_SIM_ADDRESS=0.0.0.0
export BACNET_IP_SIM_ADDRESS=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' bacnet-ip-sim)
export MODBUS_SIM_ADDRESS=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' pymodbus-sim)
```

_Note the dot before the path to the script, which is required to set the environment variables in the executing shell._

> **Note** The simulator addresses change whenever the simulator containers are recreated, so set `BACNET_IP_SIM_ADDRESS` and `MODBUS_SIM_ADDRESS` again and restart XRT after running the `start_device_sim.sh` scripts.

### **Run XRT with the config folder:**

See [Setup XRT](../../DeviceServices/interactive-walkthrough/setup-xrt.md)

```bash
xrt deployment/config
```

> **Note** Xrt must be run from this context as the configuration files use relative pathnames

### Running with multiple services
To run the opc-ua server with multiple services or to change which services are ran, the following changes are required:

* Add the service and component to the `main.json` file
* Add a `<service_name>.json` file
* Update the `opc_ua_server.json` file

## Interacting with the OPC-UA Server

See the [OPC-UA Server Documentation](https://docs.iotechsys.com/edge-xrt21/server-components/opc-ua-server-component.html)
