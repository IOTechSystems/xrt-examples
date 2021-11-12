# OPC-UA Device Service Example

## Overview

This example uses a Local Discovery Server (LDS) to perform the discovery of an opc-ua server.
Additionally, a complete opc-ua profile for the test server is provided with a schedule to read all of its resources every 3 seconds.
In this example, we use the iotech LDS and test server.

## Getting Started

### **Run the simulator**

*For more information about the OPC-UA device simulator, see [OPC-UA Simulator](https://www.fixthislink.please).*

```bash
./commands/start_device_sim.sh
```

### **Set Environment Variables**

*We have provided a script to easily set these environment variables:*
```bash
. ./commands/set_env_vars.sh
```

*To set them manually:*

`OPCUA_SIM_ADDRESS` - The address of the simulation server

```bash
export OPCUA_SIM_ADDRESS=localhost:49947
```

`OPCUA_LDS_ADDRESS` - The address of the Local Discovery Server
```bash
export OPCUA_LDS_ADDRESS=localhost:4840
```

`XRT_PROFILE_DIR` - This should be the path to the profile directory e.g

*Assuming you are in the opc-ua DeviceServices folder*

```bash
export XRT_PROFILE_DIR=$(pwd)/profiles/
```

`XRT_STATE_DIR` - This should be the path to the state directory e.g

```bash
export XRT_STATE_DIR=$(pwd)/state/
```

### **Run XRT with the config folder:**

This is assuming that the following pre-requisites are satisfied:

* XRT is installed
* LD_LIBRARY_PATH has been correctly set
* Environment variable XRT_LICENSE_FILE has been set to the location of the xrt license 

```bash
cd opc-ua
xrt config
```

## Walkthrough

### Setup MQTT Broker

*Ensure the Mosquitto MQTT broker is installed and running*

```bash
apt-get update
apt-get install mosquitto
systemctl status mosquitto
```

*Subscribe to all xrt topics in a new terminal so that we can see all of our requests and their replies.*
```bash
mosquitto_sub -t xrt/#
```

### Basic Operations 

For basic device service operations see the basic operations walkthrough guide: [Basic Operations Walkthrough](../interactive-walkthrough/basic-operations.md).

### Subscriptions


### Discovery


