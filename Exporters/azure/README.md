# Azure exporter example

## Example

These examples use the virtual device service to produce readings to be exported by an Azure exporter to post readings to an Azure service.

## Steps

**Set Environment Variables:**

XRT_PROFILE_DIR - This should be the path to the profile directory e.g

```bash
export XRT_PROFILE_DIR=/path/to/xrt-examples/Exporters/azure/deployment/profiles/
```

XRT_STATE_DIR - This should be the path to the state directory e.g

```bash
export XRT_STATE_DIR=/path/to/xrt-examples/Exporters/azure/deployment/state/
```

AZURE_EXPORTER_HOSTNAME 

```bash
export AZURE_EXPORTER_HOSTNAME=IOTechHub.azure-devices.net
```

AZURE_EXPORTER_DEVICE_ID - Azure Device ID - A device identifier used during the creation of CA certificates e.g

```bash
export AZURE_EXPORTER_DEVICE_ID=device-42
```

AZURE_EXPORTER_SCOPE_ID - Azure ID scope to a Device Provisioning Service used to uniquely identify the specific provisioning service the device with register through e.g

```bash
export AZURE_EXPORTER_SCOPE_ID=0ne0017479D
```

AZURE_EXPORTER_CERTIFICATE - Azure Full chain Device Certificate e.g

```bash 
export AZURE_EXPORTER_CERTIFICATE=/path/to/device-42.cert.pem
```

AZURE_EXPORTER_KEY - Azure Device Key e.g
```bash 
export AZURE_EXPORTER_KEY=/path/to/device-42.key.pem
```

**Run XRT with the config folder:**

```bash 
cd azure
xrt deployment/config
```

