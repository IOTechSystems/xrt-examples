#An example that use MQTT Bridge to export data over MQTT

## Example

This example use the virtual device service to produce readings to be exported by an mqtt exporter to post readings to a Mosquitto MQTT broker.
The example expect MQTT Broker to be setup and running.

## Steps

**Set Environment Variables:**

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

Set commonly used environment variables

```bash
cd Exporters/mqtt/mosquitto
. ../../../set_env_vars.sh
```

**Run XRT with the config folder:**

```bash
xrt deployment/config
```

> **Note** Xrt must be run from this context as the configuration files use relative pathnames
