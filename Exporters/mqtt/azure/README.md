# Azure example that use MQTT Bridge to export data over MQTT

## Example

These examples use the virtual device service to produce readings to be exported by an mqtt exporter to post readings to an Azure MQTT broker.

## Steps

**Set Environment Variables:**

AZURE_MQTT_SERVER_URI - The uri of your Azure mqtt server e.g

```bash
  export AZURE_MQTT_SERVER_URI=ssl://<iot_hub>.azure-devices.net:8883
```

AZURE_DEVICE_ID - Device name e.g

```bash
  export AZURE_DEVICE_ID=<device_id>
```

AZURE_MQTT_USERNAME - MQTT Client Username e.g

```bash
  export AZURE_MQTT_USERNAME=<iot_hub>.azure-devices.net/<device_id>
```

AZURE_MQTT_SAS_PASSWORD - SAS based Password e.g

```bash
  export AZURE_MQTT_SAS_PASSWORD=SharedAccessSignature sr=<SAS>
```

AZURE_MQTT_ROOT_CA - Your Azure Root CA e.g

```bash
  export AZURE_MQTT_ROOT_CA=/path/to/your/azure.pem
```

AZURE_MQTT_REPLY_TOPIC - Send messages from Device to Cloud

```bash
  export AZURE_MQTT_REPLY_TOPIC=devices/{device_id}/messages/events/readpipe
```

AZURE_MQTT_REQUEST_TOPIC - Subscribe to receive messages from Cloud to Device

```bash
  export AZURE_MQTT_REQUEST_TOPIC=devices/{device_id}/messages/devicebound/#
```

Set commonly used environment variables

```bash
cd Exporters/mqtt/azure
. ../../../set_env_vars.sh
```

**Run XRT with the config folder:**

```bash
xrt deployment/config
```

> **Note** Xrt must be run from this context as the configuration files use relative pathnames
