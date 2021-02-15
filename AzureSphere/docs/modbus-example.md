# Modbus Example

In this example, XRT is used to communicate with a Modbus TCP/IP Device ([Damocles2 Mini](https://www.hw-group.com/device/damocles2-mini)
or a [simulated Modbus device](#Using A ModbusPal Simulator With The Example)),
values read from the Modbus Device are then sent to its
Azure IoT Hub Device Twin in the Cloud. Methods can also be sent back from
the cloud to the Modbus Device using the Device Twin from the Azure IoT Hub.

![Azure Sphere Modbus Example](images/AzureSphereModbusExample.jpg)

The example reads the digital inputs from a Modbus Device via
the Modbus Device Service component and publishes the data onto
an internal XRT bus.

A Lua Scripting component subscribes to these values and check
to see if the current value now different from the previous one. When
the new value is different from the previous value, it will be pushed
to the Azure IoT Hub via a Azure Export component, However, if the value
hasn't changed, the value won't be pushed to the Azure IoT Hub. The
reason for this method to stop an unchanged value being repeatedly
sent to the IoT Hub.

From the Azure IoT Hub methods can be called on Device Twins
to send values back down to XRT running on the Azure Sphere
hardware. Values are received by the Azure Export component
and published onto the XRT bus. The Modbus Device Service subscribes
to these values and sets the value of the digital outputs on a ModBus
Device.

*Note - The digital outputs on the device are wired to the digital
inputs on the device. In this way output values are automatically
mirrored by the digital inputs.*

## Hardware

### Azure Sphere

This example uses a Azure Sphere Guardian 100 Module.
The Guardian 100 is a wireless edge module that uses
Azure Sphere to deliver secure connectivity to devices.

It includes Avnet Azure Sphere MT3620 module and connects
to existing equipment via Ethernet or USB. Guardian-enabled
devices also receive automatic security updates through the
Azure Sphere Security Service.

![Guardian 100](images/Guardian100.png)

### Modbus Device

The [Damocles2 Mini](https://www.hw-group.com/device/damocles2-mini)
is a smart I/O controller used for remote monitoring and
control of sensors and devices. It provides 4 digital dry
contact inputs and 2 digital relay outputs that can be
accessed via a Modbus interface.

If you do not have access to a physical device, a Java
[Modbus simulator](#Using A ModbusPal Simulator With The Example)
called ModbusPal, can be used instead of the real hardware.

If the Damocles hardware is used then it must be connected to
the Guardian 100 module via a wired Ethernet connection.

If the simulator is used it can be installed on your PC. 
Wired Ethernet or WiFi can be used to communicate with XRT.

## Prerequisites

*Note - The prerequisites found on the main
[readme.md](../README.md) are also required for this example.*

* The ModbusPal Java [Modbus simulator](#Using A ModbusPal Simulator With The Example),
  or a Damocles2 Mini connected by wired EtherNet to a Guardian 100 module
* Azure IoT Hub setup using the same tenant as your claimed Azure Sphere
  Module
* Telnet is installed on Ubuntu or enabled on Windows
  (unless debugging via Visual Studio)
* Connected to host via a micro-USB cable. Note to access this port
      the top casing must be removed

## Configuration

In-order for the Modbus Example to work, you will need
to the configurations listed below.

### Device Profile

To connect to a new device via XRT you must first create a
Device Profile for the specific device type.

Device Profiles and DTDL for Digital Twins files can created
using IOTech’s [Device Configuration Tool](https://dct.iotechsys.com/).
A video showing you how to do this can for the Damocles2 Mini device
can be viewed at [DCT Modbus Tutorial Video](https://www.youtube.com/watch?v=sj1hC7S4uE4).

The configuration files generated from the tool are provided
as follows:
*	[Damocles2 Mini Device Profile](../config/profiles/Damocles2-Mini.json)
*	[Damocles2 Mini DTDL file](../Damocles2-Mini.dtdl)

### Device Service

* Edit the [config/modbus.json](../config/modbus.json) file and 
  replace 10.0.0.1 with the IP address of your Modbus Device
  (If your using ModbusPal Simulator, this should be the
  IP Address of your PC currently running the
  Simulator)

![Device Service Config](images/DeviceServiceConfig.svg)  

### Azure

To connect the example to your IoT Hub endpoint you must also
configure Azure Export Service component.

* Edit [config/azure.json](../config/azure.json) and the value
  for the "HostName", "DeviceID" and "ScopeID" values.

* The DeviceID can be found for a USB connected device with
  the command:

  ```bash
  azsphere device list-attached
  ```

* The HostName is the IoT Hub host name and can be found using
  the [Azure Portal](https://portal.azure.com/) or using the
  command (replace <iothub-name> with the name of your IoT Hub):

  ```bash
  az iot hub show --name <iothub-name> | grep hostName
  ```

* The Device Provisioning Service ID Scope can be found using
  the [Azure Portal](https://portal.azure.com/) or the command
  (replace <DPSName> with the name of your Device Provisioning
  Service):

  ```bash
  az iot dps show --name <DPSName> | grep idScope
  ```

![Azure Export Config](images/AzureExportConfig.svg)

### App Manifest

You will need to edit app manifest file [app_manifest.json](../app_manifest.json)
with the following:

* In AllowedConnections, replace IOTechHub with the name of
  your hostname of your IoT Hub, you can find this via the
  [Azure Portal](https://portal.azure.com/) or using the
  command (replace <iothub-name> with the name of your IoT Hub):
  ```bash
  az iot hub show --name <iothub-name> | grep hostName
  ```
* If your using the [Modbus Simulator](#Using A ModbusPal Simulator With The Example)
  you will need to replace 10.0.0.1 in AllowedConnections with
  the IP address of your PC running the Modbus Simulator,
  otherwise 10.0.0.1 can be removed from AllowedConnections
* Set DeviceAuthentication, to your tenant id:
  ```bash
  azsphere tenant list
  ```

![Application Manifest](images/AppManifest.svg)

## Using A ModbusPal Simulator With The Example

 To use ModbusPal Simulator with this example you will
 need to:

* Download the [ModbusPal.jar](https://iotech.jfrog.io/artifactory/public/ModbusPal.jar) file.

* Run the simulator by clicking on downloaded ModbusPal.jar file 
  (Windows) or by running it via the command line:

  ```bash
  java -jar ModbusPal.jar
  ```

* Use the "Load" button and select the [damocles.xmpp](damocles.xmpp)
  file. This provides a simulation of a Damocles 2 Mini Modbus
  Device with 4 binary inputs and 2 binary outputs.

![ModbusPal Load](images/ModbusPalLoad.svg)

* Start the simulator with the "Run" button,

![ModbusPal Run](images/ModbusPalRun.svg)

## Building The Application

You can build the Modbus Example with following the links below:

* [Building On Windows](windows-build.md)
* [Building On Ubuntu](ubuntu-build.md)

## Deploying and Debugging the Application

You can deploy and debug the Modbus Example following the
links below:

* [Deploy and Debug with Windows](windows-deploy-debug.md)
* [Deploy and Debug with Ubuntu](ubuntu-deploy-deploy.md)

## Inputs & Outputs With A Modbus Device

This section explains how to change:
* Change the Output states from the IoT Hub in the Cloud
* Change the Input states of a simulated device with ModbusPal.

With a real Modbus Device, the input values will be changed by the
device, then pushed up to the IoT Hub in the Cloud. However, if your
using ModbusPal Simulator, you will need to change the Input value from
the UI to simulate a Input value being changed, the value will then be
sent up to the IoT Hub in the Cloud.

Make sure that you've deployed XRT to Azure Sphere hardware to
see changes taking place with the IoT Hub in the Cloud.

#### Changing A Modbus Device Output State

This section applies to a simulated device and a real device.

The script update.sh can be used to update device resources in the Azure
IoT hub to invoke a device method on a Device Twin.

To set the resource BinaryOutput1 to true issue the method (replace
IotHub-Name with the name of your IoT Hub):

```bash
./update.sh <IotHub-Name> BinaryOutput1 true
```

#### Changing A Modbus Device Input State On ModbusPal Simulator

*Note - Only follow this section if your using ModbusPal Simulator
and not an actual Modbus Device.*  

* Open the Slave Editor by pressing the button with the "eye" icon and
  then select the "Coils" tab in the dialog that appears.

![Open Slave Editor](images/ModbusPalEye.svg)

![Select Coils](images/ModbusPalCoils.svg)

* Change the value of "Input 1" by double clicking in the table value
  entry and entering a value of "1".

![Change Value](images/ModbusPalChangeValue.svg)

* Observe the debug output from XRT to see the new value being read from the
  simulated Modbus device and then published to the Azure IoT Hub.
