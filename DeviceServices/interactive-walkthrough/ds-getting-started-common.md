# Device Service Getting Started Common Setps

## Setup MQTT Broker

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

*Note: the script `set_env_vars.sh` will set these environment variables for you.*

`XRT_MQTT_BROKER` - This should be the address of the MQTT Broker: 
```bash
export XRT_MQTT_BROKER=tcp://localhost:1883
```

*Note: since we did not start our MQTT broker to require a password or username, these environment variables do not have an effect, as authentication is not required.
However, since the file `mqtt_bridge.json` expects both of these environment variables we should provide some value for them. Alternatively, we could remove the Username and Password 
options from the client config in the `mqtt_bridge.json` configuration file.

`XRT_MQTT_USERNAME` - The username to use in authentication and authorisation with the MQTT Broker
```bash
export XRT_MQTT_USERNAME=""
```

`XRT_MQTT_PASSWORD` - The password to use in authentication and authorisation with the MQTT Broker
```bash
export XRT_MQTT_PASSWORD=""
```

## Device Service Configuration Setup

*Note: the script `set_env_vars.sh` will set these environment variables for you.*

`XRT_PROFILE_DIR` - This should be the path to the profile directory e.g

*Assuming you are in a DeviceServices example folder e.g `xrt-examples/DeviceServices/opc-ua`*:

```bash
export XRT_PROFILE_DIR=$(pwd)/deployment/profiles/
```

`XRT_STATE_DIR` - This should be the path to the state directory e.g

```bash
export XRT_STATE_DIR=$(pwd)/deployment/state/
```
