# GPS Device Service Example

## Overview
This page details how to setup and run the GPS example.

For more information about the Device Service please view the GPS Device Service documentation.

## Getting Started

### Before running GPS

One of the following is needed before running the GPS component:
* An instance of GPSD connected to a GPS module 
* A GPS simulator running (locally or in a container)

When one of the above conditions has been met the following Driver options should be updated:

* `GpsdHostname` : Updated to either the IP address of the GPSD instance or the container name
* `GpsdPort` : The default port for GPSD is 2947 however if changed this should be updated to match
* `GpsdMode` : Default is "poll" with "nopoll" being the other option

### Setting environment variables

`XRT_PROFILE_DIR` - This should be the path to the proile directory, for example:
```
export XRT_PROFILE_DIR=/path/to/examples/DeviceServices/gps/config/profiles/
```

`XRT_STATE_DIR` - This should be the path to the state directory, for example:
```
export XRT_STATE_DIR=/path/to/examples/DeviceServices/gps/state
```

### Running GPS

The following is required for running XRT:
* XRT is installed
* `LD_LIBRARY_PATH` has been set correctly
* `XRT_LICENSE_FILE` has been set to the location of the xrt license

The GPS component can be run using the following command:
```
xrt gps/config
```
