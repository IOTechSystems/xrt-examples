# Device Service Getting Started Common Setps

### Setup MQTT Broker

*Ensure the Mosquitto MQTT broker is installed and running*

```bash
apt-get update
apt-get install mosquitto
systemctl status mosquitto
```

*Subscribe to all xrt topics in a new terminal so that we can see all of our requests and their replies.*
```bash
mosquitto_sub -t xrt/#
```

## XRT MQTT Bridge configuration

`XRT_MQTT_BROKER` - This should be the address of the MQTT Broker: 
```bash
export XRT_MQTT_BROKER=tcp://localhost:1883
```

`XRT_MQTT_USERNAME` - The username to use in authentication and authorisation
```bash
export XRT_MQTT_USERNAME=test
```

`XRT_MQTT_PASSWORD` - The password to use in authentication and authorisation
```bash
export XRT_MQTT_PASSWORD=tube
```

## Device service configuration setup

`XRT_PROFILE_DIR` - This should be the path to the profile directory e.g

*Assuming you are in a DeviceServices example folder e.g `xrt-examples/DeviceServices/opc-ua`*:

```bash
export XRT_PROFILE_DIR=$(pwd)/profiles/
```

`XRT_STATE_DIR` - This should be the path to the state directory e.g

```bash
export XRT_STATE_DIR=$(pwd)/state/
```
