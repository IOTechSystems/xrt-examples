# MQTT Bridge Example

## Example

This example uses the MQTT bridge component in conjunction with the virtual device service to demonstrate the publishing/subscription model used.

**Required Environment Variables**

You will need to set the following environment variables prior to running the example:

XRT_PROFILE_DIR - This should be the path to the profile directory e.g

```bash
export XRT_PROFILE_DIR=/path/to/examples/Bridges/mqtt/pub/config/profiles/
```

XRT_STATE_DIR - This should be the path to the state directory e.g

```bash
export XRT_STATE_DIR=/path/to/examples/Bridges/mqtt/pub/state/
```

**Run XRT with the config folder:**

This is assuming that the following pre-requisites are satisfied:

* XRT is installed
* LD_LIBRARY_PATH has been correctly set
* XRT_LICENSE_FILE has been set to the location of the xrt license

```bash
$ /path/to/xrt/executable/xrt /path/to/xrt-examples/Bridges/mqtt/pub/config
```

