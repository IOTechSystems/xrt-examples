# Google example that use MQTT Bridge to export data over MQTT

## Example

These examples use the virtual device service to produce readings to be exported by an mqtt bridge to post readings to a Google MQTT broker.


## Steps

**Set Environment Variables:**

XRT_PROFILE_DIR - This should be the path to the profile directory e.g

```bash
export XRT_PROFILE_DIR=/path/to/xrt-examples/Exporters/mqtt/google/deployment/profiles/
```

XRT_STATE_DIR - This should be the path to the state directory e.g

```bash
export XRT_STATE_DIR=/path/to/xrt-examples/Exporters/mqtt/google/deployment/state/
```

MQTT_EXPORT_GOOGLE_TRUST_STORE - Your Google Trust Store file e.g

```bash
export MQTT_EXPORT_GOOGLE_TRUST_STORE=/path/to/your/GoogleTrustStore.pem
```

MQTT_EXPORT_GOOGLE_PRIVATE_KEY - Your Google Private Key e.g

```bash
export MQTT_EXPORT_GOOGLE_PRIVATE_KEY=/path/to/your/GooglePrivateKey.pem
```

MQTT_EXPORT_GOOGLE_PROJECT_ID - Your Google Project ID e.g

```bash
export MQTT_EXPORT_GOOGLE_PROJECT_ID=my-project-id-42
```

MQTT_EXPORT_GOOGLE_PUB_TOPIC - The MQTT topic to publish on

```bash
export MQTT_EXPORT_GOOGLE_PUB_TOPIC=/devices/test-device-xrt-mqttexport/events/test
```
MQTT_EXPORT_GOOGLE_CLIENT_ID

```bash
export MQTT_EXPORT_GOOGLE_CLIENT_ID=projects/light-trail-249010/locations/europe-west1/registries/xrt-mqtt-export-test/devices/test-device-xrt-mqttexport
```

**Run XRT with the config folder:**

```bash 
cd mqtt/google/
xrt deployment/config
```

