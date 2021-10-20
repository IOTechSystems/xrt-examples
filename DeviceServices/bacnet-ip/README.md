# Bacnet Device Service Example

## Example

This example uses the bacnet device service to connect to the iotech bacnet simulator.
Additionally, a complete bacnet device profile for the test server is provided with a schedule to read all of its resources every 3 seconds.
In this example, we use the iotech LDS and test server.

## Steps

**Run Bacnet sim:**

```bash
docker run --rm -d --name=bacnet-sim -e RUN_MODE=IP -v /path/to/xrt-examples/DeviceServices/bacnet-ip/bacnet-simulator/:/docker-lua-script/ \
        iotechsys/bacnet-server:2.0.dev --script /docker-lua-script/example.lua --instance 1234 --name BacnetSimulator
```

This will start the bacnet simulator.

**Set Environment Variables**

XRT_PROFILE_DIR - This should be the path to the profile directory e.g

```bash
export XRT_PROFILE_DIR=/path/to/xrt-examples/DeviceServices/opc-ua/config/profiles/
```

XRT_STATE_DIR - This should be the path to the state directory e.g

```bash
export XRT_STATE_DIR=/path/to/xrt-examples/DeviceServices/opc-ua/state/
```

**Run XRT with the config folder:**

This is assuming that the following pre-requisites are satisfied:

* XRT is installed
* LD_LIBRARY_PATH has been correctly set
* XRT_LICENSE_FILE has been set to the location of the xrt license 

```bash
cd bacnet-ip
xrt config
```
