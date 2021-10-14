# XRT OPC-UA config example

This document is to help you run the example opc-ua XRT config.

## Example

This example uses an Local Discovery Server (LDS) to perform the discovery and profile generation of an opc-ua server.
In this example we use the iotech LDS and test server.

## Steps

**Run the LDS and test server:**

```bash
docker run --rm -d --name opc-ua-sim -e RUN_LDS=true -p 49947 -p 4840 iotechsys/dev-edgexpert-opc-ua-test-server:1.8.6.dev-x86_64
```

This will start the LDS server and the test server in the same container.

**Run XRT with the config folder:**

```bash
cd opc-ua
xrt config
```
