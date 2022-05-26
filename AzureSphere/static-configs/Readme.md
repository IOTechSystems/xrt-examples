# Azure Sphere Static Configurations

This document describes, and gives examples on how to build a
connected IoT application using IOTech's Edge XRT deployed on
supported Azure Sphere hardware statically.

## Prerequisites

* For Windows [Visual Studio](https://visualstudio.microsoft.com/downloads/)
  or Linux (Ubuntu 20.04) [Visual Studio Code](https://code.visualstudio.com/download).
  Once installed open Visual Studio and install Visual
  Studio Extensions for Azure Sphere
* The [Azure Sphere SDK](https://docs.microsoft.com/en-us/azure-sphere/install/overview)
  as appropriate for the target environment
* You must have your Azure Sphere module claimed to your Azure
  Sphere Cloud Tenant in order for a XRT example to communicate
  with your Azure Cloud Resources. You can claim your device
  with the following [guide](https://docs.microsoft.com/en-gb/azure-sphere/install/claim-device?tabs=cliv1).
  You will also need to enable development on the
  Azure Sphere Model with:

  ```bash
  azsphere device enable-development
  ```

* The [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
  with the azure-iot extension installed. You can install
  azure-iot extension with the following:

  ```bash
  az extension add --name azure-iot
  ```

## First time configuration setup

For first time configuration setup (right after cloning), run the setup_configs.sh script within the `static-configs` Directory:

```bash
cd AzureSphere/static-configs
./setup_configs.sh
```

## Building and deploying

### Settings.json

To build and deploy xrt with the static configurations, first edit the `.vscode/settings.json` file and update the `"DEVICE"` and `"BOARD"` values to suit your needs.

`"DEVICE"` can be set to the following values:
- `"bacnet"`
- `"ethernetip"`
- `"modbus"`
- `"virutal"`

`"BOARD"` can be set to the following values:
- `"mt3620-dk"`
- `"mt3620-g100"`
- `"mt3620-sr620`
- `"mt3620-sr620"`

### Configuration files

To configure files automaticly, run the script as described in [First time configuration setup](#first-time-configuration-setup).


If you are unable to run the script here are the following files that need editing:
- [`azure-<DEVICE_SERVICE_NAME>.json`](./config/)
- [`<DEVICE_SERVICE_NAME>.json`](./config/)
- [`mt3620.json`](./config/mt3620.json)
- [`udp-logger.json`](./config/udp-logger.json) (optional)
- `<BOARD>/app_manifest.json`

Each file has place holders that need to be updated. To find out more see the readme for the standard examples [here](../README.md)

### Building

Once the settings.json file has been set up, and all the configuration files have been edited. we can build on vscode using the CMake extension panel and clicking on the "build all projects" icon on the top left.

### Deploying

To deploy the azuresphere app image, press the F5 key making sure the azuresphere board is connected to the development machine. You should start seeing logs within VScode and also the UDP logger if set up correctly.