### Running Publication

**Required Environment Variables**

You will need to set the following environment variables prior to running the example:

XRT_PROFILE_DIR - This should be the path to the profile directory e.g.

```bash
export XRT_PROFILE_DIR=/path/to/xrt-examples/Bridge/thrift/pub/config/profiles/
```

XRT_STATE_DIR - This should be the path to the state directory e.g.

```bash
export XRT_STATE_DIR=/path/to/xrt-examples/Bridge/thrift/pub/state/
```

PUB_SERVER_ADDRESS - The IP address of the server, e.g.
```bash
export PUB_SERVER_ADDRESS="127.0.0.1"
```

PUB_CLIENT_ADDRESS - The IP address of the client device, e.g.
```bash
export PUB_CLIENT_ADDRESS="127.0.0.1"
```

PUB_SERVER_PORT - The port used by the server, e.g.
```bash
export PUB_SERVER_PORT=99999
```

PUB_CLIENT_PORT - The port used by the server, e.g.
```bash
export PUB_CLIENT_PORT=9998
```

**Run XRT with the config folder:**

This is assuming that the following pre-requisites are satisfied:

* XRT is installed
* LD_LIBRARY_PATH has been correctly set
* XRT_LICENSE_FILE has been set to the location of the xrt license

```bash
$ xrt /path/to/xrt-examples/Bridge/thrift/pub/config
```