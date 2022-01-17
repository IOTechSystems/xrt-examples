# Virtual Device Example

The Virtual Device allows you to generate random numbers that
can be pushed up to Azure IoT Hub. Values can also be sent
from the Azure IoT Hub and store them within the Virtual
Device.

## AzureSphere Hardware

The Virtual Device works on all XRT supported AzureSphere
hardware, that's listed on the main [readme](../README.md).

## Prerequisites 

Virtual Example doesn't require any prerequisites apart from the
ones listed on the main [readme](../README.md) page.

## Configuration 

In-order for the Virtual Example to work, you will need
to edit some of the configurations. The configurations
that are required to be edited will have "(required)"
within there title.

### Device Profile

Virtual Device profile can be found at: 
configs/profiles/virtual-device.json

The Device Profile contains a config different
deviceResources can to be sent or received from the Azure
IoT Hub.

### Azure (Required)
The Azure config file can be found at:
[deployment/configs/azure-virtual.json](../deployment/config/azure-virtual.json)

You will need to configure some values in azure.json to
be able to send values to the IoT Hub. You will need:

* DeviceID, can be found for a USB connected device with
  the command:

```bash
azsphere device list-attached
```

* HostName, is the IOT Hub host name and can be found
  using the [Azure Portal](https://portal.azure.com/) or
  using the command (replace HubName with the name of your
  IOT hub):

```bash
az iot hub show --name <HubName> | grep hostName
```

* ScopeID, The Device Provisioning Service ID Scope can be found
  using the portal or the command (replace DPSName with
  the name of your Device Provisioning Service):

```bash
az iot dps show --name <DPSName> | grep idScope
```

### App Manifest (Required)
* Edit the [app_manifest.json](../app_manifest.json) file and
  set DeviceAuthentication to your tenant id and replace
  IOTechHub with your IoT Hub name in AllowedConnections:

```bash
azsphere tenant list
```

## Building The Application

You can build the Virtual Device following the links below:

* [Building On Windows](windows-build.md)
* [Building On Ubuntu](ubuntu-build.md)

## Deploying and Debugging the Application

You can deploy and debug the Virtual Device following the
links below:

* [Deploy And Debug With Windows](windows-deploy-debug.md)
* [Deploy And Debug With Ubuntu](ubuntu-deploy-debug.md)

## Deploying From The Cloud

You can also deploy the Virtual Device Example from the cloud with
the link below:

[Deploy From The Cloud](deploy-from-the-cloud.md)

#### Changing A Virtual Device Output Values

The script update.sh can be used to send a payload of data
to Azure IoT hub to invoke a device method on a Device Twin. The
IoT Hub will send the payload to XRT which will be picked up by the
Azure component and push to the Virtual Device Service via an
XRT Bus.

To set the device resource `OutputBool` to true on the `device-virtual`
device, issue the method (replace IotHub-Name with the name of your
IoT Hub):

```bash
./update.sh <IotHub-Name> device-virtual OutputBool true
```
