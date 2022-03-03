## Run the Example Subscriber

**Required Environment Variables**

You will need to set the following environment variables prior to running the example:

XRT_PROFILE_DIR - This should be the path to the profile directory e.g.

```bash
export XRT_PROFILE_DIR=/path/to/xrt-examples/Bridge/mqtt/sub/deployment/profiles/
```

XRT_STATE_DIR - This should be the path to the state directory e.g.

```bash
export XRT_STATE_DIR=/path/to/xrt-examples/Bridge/mqtt/sub/deployment/state/
```

**Run XRT with the config folder:**

This is assuming that the following pre-requisites are satisfied:

* XRT is installed
* LD_LIBRARY_PATH has been correctly set
* XRT_LICENSE_FILE has been set to the location of the xrt license

```bash
$ xrt deployment/config
```
