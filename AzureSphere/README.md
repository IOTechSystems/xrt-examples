# Azure Sphere

This document describes, and gives examples on how to build a
connected IoT application using IOTech's Edge XRT deployed on
supported Azure Sphere hardware.

## Supported Hardware

The examples currently support the following hardware:

* The Avnet Guardian 100 Azure Sphere Module
* The Avnet Azure Sphere Starter Kit
* The Seed Azure Sphere Development Kit
* The AILink SR620 Guardian Gateway

## Azure Sphere Development Process

The process for creating a connected Azure Sphere IoT
application using XRT is illustrated in the following graphic.

![Azure Development Process](docs/images/AzureDevProcess.png)

The development process flow follows a standard sequence of
steps:

1. Install the XRT for Azure Sphere package on either a [Windows](./docs/windows-installation.md) or Linux [(Ubuntu)](./docs/ubuntu-installation.md) host PC and open the xrt-examples/AzureSphere directory with Visual Studio Code.

2. Using the [Device Configuration Tool](https://dct.iotechsys.com/) create a Device Profile.json configuration file representing the IoT device type. Using the same device definition, DCT can also be used to generate a Digital Twins Definition Language (DTDL) file representation for use with Azure Digital Twins.

    *Note:* Example profiles for each supported Device Services are provided in their respective device twin examples in the [*AzureSphere/twin/*](/AzureSphere/twin/) directory.

3. Create a *main.json* file and specify all of the components you want to include in your XRT application. Then create configuration files for each component defined in the *main.json* file.

    All of the standard XRT examples provided are based on configuring your XRT deployment dynamically via the standard Azure Device Twin configuration mechanism as described in [Device Twin Configuration](https://docs.iotechsys.com/edge-xrt20/azuresphere/configuration/device-twin-configuration.html).In this case all individual XRT configuration files are combined into a single Device Twin configuration file which can be loaded into the Device Twin configuration on Azure IoT Hub.
    
    Device Twin configuration files for all of the Azure Sphere examples are provided in the [*xrt-examples/AzureSphere/twin/*](/AzureSphere/twin/) directory. These files also includes the Device Profile created in the previous step.

4. For any of the standard XRT examples all that is required is to modify the appropriate Device Twin configuration file (e.g. [BACnet Device Twin configuration file](/AzureSphere/twin/desired-bacnet.json) to run the examples in your environment as follows:

    * Modify the “Components”: "\<Device Service>" e.g. bacnet, section to specify the network configuration details required by the Device Service.
    * Modify the “Components”:”azure” section to specify the endpoint information needed by the XRT Azure Sphere Export Service to send data to and from Azure IoT Hub.

    The one exception to this is that you must also configure a separate *<azure_application_manifest>.json*  file that describes the resources, also called application capabilities, that an application requires. Every application has an application manifest. For example modify the example [mt3620-g100/app_manifest.json](https://github.com/IOTechSystems/xrt-examples/blob/XRT-666-branch/AzureSphere/mt3620-g100/app_manifest.json) provided.  

5. Copy the contents of the Device Twin Configuration file created previously and load in into the Azure Sphere Device Twin running on Azure IoT Hub as described in the [Device Twin Configuration](https://docs.iotechsys.com/edge-xrt20/azuresphere/configuration/device-twin-configuration.html) section.

6. Using Visual Studio code or cmake from the command line build the XRT Azure Application including the *<azure_application_manifest>.json* file. The Device Twin Configuration file should not be included in the XRT application build image.

7. Deploy the XRT Azure Application onto the Azure Sphere Module (you can deploy from Visual Studio Code using the azsphere utility).

8. Visualize the data on Azure IoT Hub and optionally send data back to the connected IoT device.

Each of the above steps are covered in detail in the subsequent parts for each example. We have also created a [demonstration video](https://youtu.be/H1bE4oUG7FI) which illustrates this process.

## Prerequisites

* For Windows or Linux (Ubuntu) [Visual Studio Code](https://code.visualstudio.com/download)

* To deploy Azure functions (only required if using Azure Digital Twins), also install:
  * [Net 3.1 Core SDK](https://dotnet.microsoft.com/en-us/download)
  
  * [Azure Functions Extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azurefunctions)

* The [Azure Sphere SDK](https://docs.microsoft.com/en-us/azure-sphere/install/overview) as appropriate for the target environment

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

*Note - [Examples](#examples) might have prerequisites of
there own.*

## Install XRT On A Development Machine

You will need to install XRT onto your development machine to
build the examples:

* [Installing the XRT Package on Windows](docs/windows-installation.md)
* [Installing the XRT Package on Ubuntu](docs/ubuntu-installation.md)

## First time configuration setup

For first time configuration setup, run the setup_configs.sh script within the AazureSphere Directory:

```bash
cd AzureSphere
./setup_configs.sh
```

and follow on screen instructions.

This will replace all of the required placeholders within the provided example configuration files automatically.

## Examples

* [BACnet Device](docs/bacnet-example.md)
* [Modbus Device](docs/modbus-example.md)
* [Ethernet/IP Device](docs/ethernetip-example.md)

## Using Azure Digital Twins With XRT Examples

To setup Azure Digital Twins refer to the XRT for [Azure Sphere Guide](https://docs.iotechsys.com/edge-xrt20/index.html).

As described in the guide complete the following steps:

* Setup Azure Cloud for Digital Twins – Create a Function App
* Setup Azure Cloud for Digital Twins – Create an Event Grid System Topic
* Create and Manage Digital Twins – Create Digital Twins Instance
* Create and Manage Digital Twins – Export Digital Twins Changes
* Create and Manage Digital Twins – Send Digital Twin Changes to IoT Hub
* Create and Manage Digital Twins – Add a Digital Twin

A video showing how to create a digital twin using the Explorer
Tool as described in "Add a Digital Twin" above can be viewed at
[Create a Digital Twin using the Explorer Tool](https://www.youtube.com/watch?v=CqTDkRXtsUU&feature=youtu.be).
