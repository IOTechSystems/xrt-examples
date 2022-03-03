# Rest exporter example

## Example

These examples use the virtual device service to produce readings to be exported by a REST exporter to post readings to a REST endpoint.

## Steps

**Set Environment Variables:**

XRT_PROFILE_DIR - This should be the path to the profile directory e.g

```bash
export XRT_PROFILE_DIR=/path/to/xrt-examples/Exporters/rest/deployment/profiles/
```

XRT_STATE_DIR - This should be the path to the state directory e.g

```bash
export XRT_STATE_DIR=/path/to/xrt-examples/Exporters/rest/deployment/state/
```

XRT_REST_ENDPOINT - The address of the rest endpoint the readings are exported to e.g

```bash
export XRT_REST_ENDPOINT=0.0.0.0:1234
```

REST_EXPORTER_CA_FILE - The Certificate Authority file for the rest endpoint e.g

```bash 
export REST_EXPORTER_CA_FILE=/path/to/ca/root.pem
```

REST_EXPORTER_SSL_CERT - The SSL certificate for the rest endpoint e.g
```bash 
export REST_EXPORTER_SSL_CERT=/path/to/client.crt
```

REST_EXPORTER_SSL_KEY - The SSL key for the rest endpoint e.g
```bash 
export REST_EXPORTER_SSL_KEY=/path/to/client.key
```

**Run XRT with the config folder:**

```bash 
cd rest/
xrt deployment/config
```
