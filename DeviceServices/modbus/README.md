# XRT Config Examples

This document is to help you run the example XRT configs provided which will allow
you to communicate with a Modbus simulator via TCP or RTU. 

First, navigate to `src/c/examples/xrt-examples/DeviceServices`

## Modbus

This guide is for the `modbus` configuration using the profile for Network Power Meter - this profile can be found in the file `DENT.Mod.PS6037.profile.json`

Start a modbus simulator:
```
docker run --rm -p 1502:1502 --name=modbus-simulator iotechsys/dev-testing-edgex-modbus-simulator:2.0.0
```

Note that another modbus simulator may be used (e.g. ModbusPal) and may offer more extensive configuration. So long as the simulator and the device service go via the same port (for TCP) when making/receiving requests, the functionality should be consistent. If you want a value that fluctuates to repeatedly fetch, we recommend setting up a device and tying it to a linear generator in ModbusPal; see [this page for an example set-up of a Simulator)](https://plc4x.apache.org/users/getting-started/virtual-modbus.html).

Ensure that the register addresses being requested are available in the simulator; this can be specified in ModbusPal by pressing the eye icon next to the chosen device, and all registers up to 60,000 are available in the IoTech modbus simulator. The data addresses used by this example can be found in `DENT.Mod.PS6037.profile.json`. 

Find out the IP address of the server:
```
$ docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' modbus-simulator
```


### Set Environment Variables for XRT
The XRT user guide provides instructions on how to simply install XRT as a package, or it can be cloned from the repository and built manually.

An environment variable pointing towards the location of the IoTech license will need set to run the Modbus device service:

- `XRT_LICENSE_FILE`
  - This variable points to the location of license.json, as the name implies. A development license can be obtained for the purposes of testing. 
  - Example command to export this environment variable:
```
export XRT_LICENSE_FILE=/home/peter/license.json
```
- `MODBUS_DEVICE_ADDRESS`
  - This variable contains the IP or serial address of the target modbus device. This could be a simulator or a physical device that supports modbus. This environment variable is used to update `devices.json` in the `state` directory of the example configs - without it, the device service won't be able to find the target modbus device. 

  - Example for a locally-hosted Modbus TCP simulator: `export MODBUS_DEVICE_ADDRESS=127.0.0.1`
  - Example for a locally-hosted Modbus RTU simulator: `export MODBUS_DEVICE_ADDRESS=/dev/tty/usb0`
  - Example for Modbus TCP device hosted at another IP address: `export MODBUS_DEVICE_ADDRESS=192.168.10.100`

- `XRT_PROFILE_DIR`
    - This is an environment variable pointing towards the directory containing device profiles to be used.
    - For the default example configuration, this should be set using `export XRT_PROFILE_DIR=/path/to/xrt-examples/DeviceServices/modbus/config/profiles`

- `XRT_STATE_DIR`
    - This is an environment variable pointing towards the directory containing state information to be used.
    - For the default example configuration, this should be set using `export XRT_STATE_DIR=/path/to/xrt-examples/DeviceServices/modbus/state`

### Run XRT

```
$ xrt modbus/config
```
where 'xrt' is the shared library outputted following a build of XRT. 
If done correctly, this will start a loop in which readings are obtained over regular intervals from registers specified in the profile. Note that the values returned from the simulator will be default '0' readings, unless updated in the simulator via a GUI like the one bundled with ModbusPal. 
