# Virtual Device Service Example

## Example

This example starts the virtual device service.
Additionally, a complete virtual device profile for the virtual device is provided with a schedule to read all of its resources every 3 seconds.

## Steps

**Set Environment Variables**

XRT_PROFILE_DIR - This should be the path to the profile directory e.g

```bash
export XRT_PROFILE_DIR=/path/to/examples/DeviceServices/virtual/config/profiles/
```

XRT_STATE_DIR - This should be the path to the state directory e.g

```bash
export XRT_STATE_DIR=/path/to/examples/DeviceServices/virtual/state/
```

**Run XRT with the config folder:**

This is assuming that the following pre-requisites are satisfied:

* XRT is installed
* LD_LIBRARY_PATH has been correctly set
* XRT_LICENSE_FILE has been set to the location of the xrt license 

```bash
cd virtual
xrt config
```
