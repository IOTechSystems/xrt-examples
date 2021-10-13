# XRT OPC-UA config example

This document is to help you run the example opc-ua XRT config.

## Running with the Prosys Server

You must have a locally installed version of the Prosys Simulation Server,
found at https://downloads.prosysopc.com/opc-ua-simulation-server-downloads.php.

This example assumes that v5 of the Prosys Simulation Server is installed and is running. 
To perform discovery: all servers should be registered with a local discovery server and in state/devices.json "${OPCUA_LDS_ADDRESS}"
should be replaced with the address and port of the LDS e.g 0.0.0.0:4840. This can also be set as an environment variable and xrt will subsitute this in.

"${PROSYS_SIM_ADDRESS}" should also be set in a similar fashion.

## Steps

Run the LDS and Prosys Sim

Run XRT with the config folder:

```
$ cd opc-ua
$ xrt config
```
