# MQTT exporter Mosquitto example

## Example

These examples use the virtual device service to produce readings to be exported by an mqtt exporter to post readings to a Mosquitto MQTT broker.


## Steps

**Set Environment Variables:**

XRT_PROFILE_DIR - This should be the path to the profile directory e.g

```bash
export XRT_PROFILE_DIR=/path/to/xrt-examples/Exporters/mqtt/mosquitto/config/profiles/
```

XRT_STATE_DIR - This should be the path to the state directory e.g

```bash
export XRT_STATE_DIR=/path/to/xrt-examples/Exporters/mqtt/mosquitto/state/
```
XRT_MQTT_BROKER - The Server URI of the Mosquitto broker e.g

```bash
export XRT_MQTT_BROKER=tcp://0.0.0.0:1883
```

XRT_MQTT_USERNAME - The Username for the Mosquitto broker e.g
```bash
export XRT_MQTT_USERNAME=admin
```

XRT_MQTT_PASSWORD - The Password for the Mosquitto broker e.g
```bash
export XRT_MQTT_PASSWORD=password
```

**Run XRT with the config folder:**

```bash 
cd mqtt/mosquitto/
xrt config
```


