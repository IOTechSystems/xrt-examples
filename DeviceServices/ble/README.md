# BLE Device Service Example

## Example

This example uses the ble device service to connect to the iotech ble device simulator.
Additionally, a complete profile for the ble simulator is provided with a schedule to read all of its resources every 3 seconds.

## Steps

**Ensure bluez and dbus are installed and running on your machine**

```bash
sudo apt install dbus bluez
sudo systemctl start bluetooth
```

**Start the BLE device simulator**

*note: This will not work correctly if there are any bluetooth adapters connected to the machine - if there are please remove them*

We need to create some fake metadata so that bluez can discover the simulator:

```bash
sudo mkdir -p /var/lib/bluetooth/00:AA:01:00:00:23/00:AA:01:01:00:24/ && \
printf "[General]\nName=test\nAddressType=public\nSupportedTechnologies=LE;\nTrusted=false\nBlocked=false" | \
sudo tee /var/lib/bluetooth/00:AA:01:00:00:23/00:AA:01:01:00:24/info
```

Run the simulator:

```bash
docker run -d --privileged -v /var/run/dbus/system_bus_socket/:/var/run/dbus/system_bus_socket/ iotechsys/ble-sim:1.0 --script /example-scripts/test-device.lua
```

**Set Environment Variables**

XRT_PROFILE_DIR - This should be the path to the profile directory e.g

```bash
export XRT_PROFILE_DIR=/path/to/examples/DeviceServices/ble/config/profiles/
```

XRT_STATE_DIR - This should be the path to the state directory e.g

```bash
export XRT_STATE_DIR=/path/to/examples/DeviceServices/ble/state/
```

**Run XRT with the config folder:**

This is assuming that the following pre-requisites are satisfied:

* XRT is installed
* LD_LIBRARY_PATH has been correctly set
* XRT_LICENSE_FILE has been set to the location of the xrt license 

```bash
cd ble
xrt config
```
