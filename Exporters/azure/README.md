# Azure exporter example

## Example

These examples use the virtual device service to produce readings to be exported by an Azure exporter to post readings to an Azure service.

## Steps

**Set Environment Variables:**

XRT_PROFILE_DIR - This should be the path to the profile directory e.g

```bash
export XRT_PROFILE_DIR=/path/to/xrt-examples/Exporters/azure/config/profiles/
```

XRT_STATE_DIR - This should be the path to the state directory e.g

```bash
export XRT_STATE_DIR=/path/to/xrt-examples/Exporters/azure/state/
```

AZURE_EXPORTER_HOSTNAME 

```bash
export AZURE_EXPORTER_HOSTNAME=IOTechHub.azure-devices.net
```

AZURE_EXPORTER_DEVICE_ID - Your Azure Device ID e.g

```bash 
export AZURE_EXPORTER_DEVICE_ID=device-42
```

AZURE_EXPORTER_CERTIFICATE - Your Azure Device Certificate e.g

```bash 
export AZURE_EXPORTER_CERTIFICATE=/path/to/device-42.cert.pem
```

AZURE_EXPORTER_KEY - Your Azure Device Key e.g
```bash 
export AZURE_EXPORTER_KEY=/path/to/device-42.key.pem
```

**Run XRT with the config folder:**

```bash 
cd azure/
xrt config
```

