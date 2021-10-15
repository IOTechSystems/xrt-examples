# OPC-UA Device Service Example

## Example

This example uses a Local Discovery Server (LDS) to perform the discovery of an opc-ua server.
Additionally, a complete opc-ua profile for the test server is provided with a schedule to read all of its resources every 3 seconds.
In this example, we use the iotech LDS and test server.

## Steps

**Run the LDS and test server:**

```bash
docker run --rm -d --name opc-ua-sim -e RUN_LDS=true -p 49947 -p 4840 iotechsys/dev-edgexpert-opc-ua-test-server:1.8.6.dev-x86_64
```

This will start the LDS server and the test server in the same container.

**Set Environment Variables**

OPCUA_SIM_ADDRESS - The address of the simulation server

```bash
export OPCUA_SIM_ADDRESS=localhost:49947
```

OPCUA_LDS_ADDRESS
```bash
export OPCUA_LDS_ADDRESS=localhost:4840
```

XRT_PROFILE_DIR - This should be the path to the profile directory e.g

```bash
export XRT_PROFILE_DIR=/path/to/examples/DeviceServices/opc-ua/config/profiles/
```

XRT_STATE_DIR - This should be the path to the state directory e.g

```bash
export XRT_STATE_DIR=/path/to/examples/DeviceServices/opc-ua/state/
```

XRT_MQTT_BROKER - This should be the server uri of the mqtt broker e.g

```bash
export XRT_MQTT_BROKER=tcp://0.0.0.0:1883
```

XRT_MQTT_USERNAME - Username for the above MQTT broker e.g

```bash
export XRT_MQTT_USERNAME=test
```

XRT_MQTT_PASSWORD - Password for the above MQTT broker e.g

```bash
export XRT_MQTT_PASSWORD=tube
```

**Run XRT with the config folder:**

This is assuming that the following pre-requisites are satisfied:

* XRT is installed
* LD_LIBRARY_PATH has been correctly set
* XRT_LICENSE_FILE has been set to the location of the xrt license 

```bash
cd opc-ua
xrt config
```