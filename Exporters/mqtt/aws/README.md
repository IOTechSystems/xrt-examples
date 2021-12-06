# AWS example that use MQTT Bridge to export data over MQTT

## Example

These examples use the virtual device service to produce readings to be exported by an mqtt exporter to post readings to an AWS MQTT broker.

## Steps

**Set Environment Variables:**

XRT_PROFILE_DIR - This should be the path to the profile directory e.g

```bash
export XRT_PROFILE_DIR=/path/to/xrt-examples/Exporters/mqtt/aws/config/profiles/
```

XRT_STATE_DIR - This should be the path to the state directory e.g

```bash
export XRT_STATE_DIR=/path/to/xrt-examples/Exporters/mqtt/aws/state/
```

MQTT_EXPORT_AWS_SERVER_URI - The uri of your amazon mqtt server e.g

```bash
  export MQTT_EXPORT_AWS_SERVER_URI=ssl://server-uri.us-east-1.amazonaws.com:8883
```

MQTT_EXPORT_AWS_CLIENT_ID - Your AWS client ID e.g

```bash
  export MQTT_EXPORT_AWS_CLIENT_ID=client_id
```

MQTT_EXPORT_AWS_TRUST_STORE - Your AWS trust store file e.g

```bash
  export MQTT_EXPORT_AWS_TRUST_STORE=/path/to/your/AWSTrustStore.pem
```

MQTT_EXPORT_AWS_KEY_STORE - Your AWS key store certificate e.g

```bash
  export MQTT_EXPORT_AWS_KEY_STORE=/path/to/your/AWSKeyStore.pem.crt
```

MQTT_EXPORT_AWS_PRIVATE_KEY - Your AWS private key e.g

```bash
  export MQTT_EXPORT_AWS_PRIVATE_KEY=/path/to/your/AWSPrivateKey.pem.key
```

**Run XRT with the config folder:**

```bash 
cd mqtt/aws/
xrt config
```
