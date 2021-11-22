# Bacnet IP Device Service Example

## Example

This example uses the bacnet device service to connect to the iotech bacnet simulator.
Additionally, a complete bacnet device profile for the test server is provided with a schedule to read all of its resources every 3 seconds.

## Steps

**Run Bacnet sim:**

```bash
docker run --rm -d --name=bacnet-sim -e RUN_MODE=IP -v /path/to/xrt-examples/DeviceServices/bacnet-ip/bacnet-simulator/:/docker-lua-script/ \
        iotechsys/bacnet-server:2.0 --script /docker-lua-script/example.lua --instance 1234 --name BacnetSimulator
```

This will start the bacnet simulator.

**Find the IP address of the server**

```bash
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' bacnet-sim
```

Add the following entries to the Driver options in the `bacnet_device_service.json` file:
```json
 "Driver":{
    ...     
    "BBMDAddress":"<BACNET_SIM_IP_ADDRESS>",
    "BBMDPort": 47808
  }
```

**Set Environment Variables**

XRT_PROFILE_DIR - This should be the path to the profile directory e.g

```bash
export XRT_PROFILE_DIR=/path/to/xrt-examples/DeviceServices/bacnet-ip/config/profiles/
```

XRT_STATE_DIR - This should be the path to the state directory e.g

```bash
export XRT_STATE_DIR=/path/to/xrt-examples/DeviceServices/bacnet-ip/state/
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
