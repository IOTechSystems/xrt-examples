# XRT Config Examples

This document is to help you run the example XRT configs provided which will allow
you to communicate with a Modbus simulator via TCP or RTU. 

First, navigate to `src/c/examples/xrt-examples/DeviceServices`

## Modbus

This guide is for the `modbus` configuration using the profile for Network Power Meter - this profile can be found in the file `modbus-sim-profile.json`

Start a modbus simulator:
```
docker run --rm -p 1502:1502 --name=modbus-simulator iotechsys/dev-testing-edgex-modbus-simulator:2.0.0
```

Note that another modbus simulator may be used (e.g. ModbusPal) and may offer more extensive configuration. So long as the simulator and the device service go via the same port (for TCP) when making/receiving requests, the functionality should be consistent. If you want a value that fluctuates to repeatedly fetch, we recommend setting up a device and tying it to a linear generator in ModbusPal; see [this page for an example set-up of a Simulator)](https://plc4x.apache.org/users/getting-started/virtual-modbus.html).

Ensure that the register addresses being requested are available in the simulator; this can be specified in ModbusPal by pressing the eye icon next to the chosen device, and all registers up to 60,000 are available in the IoTech modbus simulator. The data addresses used by this example can be found in `modbus-sim-profile.json`. 

Find out the IP address of the server:
```
$ docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' modbus-simulator
```

### Set Environment Variables for XRT

The XRT user guide provides instructions on how to simply install XRT as a package, or it can be cloned from the repository and built manually.

An environment variable pointing towards the location of the IoTech license will need set to run the Modbus device service:

- `MODBUS_DEVICE_ADDRESS`
  - This variable contains the IP or serial address of the target modbus device. This could be a simulator or a physical device that supports modbus. This environment variable is used to update `devices.json` in the `state` directory of the example configs - without it, the device service won't be able to find the target modbus device. 

  - Example for a locally-hosted Modbus TCP simulator: `export MODBUS_DEVICE_ADDRESS=127.0.0.1`
  - Example for a locally-hosted Modbus RTU simulator: `export MODBUS_DEVICE_ADDRESS=/dev/tty/usb0`
  - Example for Modbus TCP device hosted at another IP address: `export MODBUS_DEVICE_ADDRESS=192.168.10.100`

- `MODBUS_DEVICE_PORT`
    - This is an environment variable denoting the port used by the target modbus device.
    - It is typically port 502 or 1502 if running a simulated device, although any available port will work with ModbusPal when configured through the GUI

An explanation for the setting of common device service environment variables can be found [here](../interactive-walkthrough/ds-getting-started-common.md#Device-service-configuration-setup).

### Run XRT

```
$ xrt deployment/config
```

where 'xrt' is the shared library outputted following a build of XRT. 
If done correctly, this will start a loop in which readings are obtained over regular intervals from registers specified in the profile. Note that the values returned from the simulator will be default '0' readings, unless updated in the simulator via a GUI like the one bundled with ModbusPal. 

## Walkthrough

### Basic Operations

For basic device service operations see the [Basic Operations Walkthrough](../interactive-walkthrough/basic-operations.md) guide.

