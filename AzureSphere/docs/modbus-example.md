# Modbus Example

In this example, XRT is used to communicate with a Modbus TCP/IP Device ([Damocles2 Mini](https://www.hw-group.com/device/damocles2-mini)
or a [simulated Modbus device](#using-modbuspal-simulator-with-the-example)),
values read from the Modbus Device are then sent to its
Azure IoT Hub Device Twin in the Cloud. Methods can also be sent back from
the cloud to the Modbus Device using the Device Twin from the Azure IoT Hub.

![Azure Sphere Modbus Example](images/AzureSphereModbusExample.jpg)

The example reads the digital inputs from a Modbus Device via
the Modbus Device Service component and publishes the data onto the
[internal XRT bus with duplicates filter turn on](../config/bus.json).

If a new data value is the same as the previous value then the
duplicates filter will prevent the unchanged data value from being
published onto the bus and sent to the Azure IoT Hub via the
Azure Export component. Otherwise all new data values are
automatically sent to Azure IoT Hub.

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

## AzureSphere Hardware

The Modbus Example works on all XRT supported AzureSphere
hardware. See [readme](../README.md).

### Modbus Device

The [Damocles2 Mini](https://www.hw-group.com/device/damocles2-mini)
is a smart I/O controller used for remote monitoring and
control of sensors and devices. It provides 4 digital dry
contact inputs and 2 digital relay outputs that can be
accessed via a Modbus interface.

If you do not have access to a physical device, a Java
[Modbus simulator](#using-modbuspal-simulator-with-the-example)
called ModbusPal, can be used instead of the real hardware.

If the Damocles hardware is used then it must be connected to
the Guardian 100 module via a wired Ethernet connection.

If the simulator is used it can be installed on your PC. 
Wired Ethernet or WiFi can be used to communicate with XRT.

## Prerequisites

*Note - The prerequisites found on the main
[readme.md](../README.md) are also required for this example.*

* The ModbusPal Java [Modbus simulator](#using-modbuspal-simulator-with-the-example),
  or a Damocles2 Mini connected by wired EtherNet to a AzureSphere module
* Azure IoT Hub setup using the same tenant as your claimed Azure Sphere
  Module
* Connected to host via a micro-USB cable. Note to access this port
      the top casing must be removed

## Configuration

The following section describes the configuration used by the Modbus example.

### Device Profile

To connect to a new device via XRT you must first create a
Device Profile for the specific device type.

The Device Profile contains a config of different
deviceResources that can to be sent or received from the Azure
IoT Hub.

Device Profiles and DTDL for Digital Twins files can created
using IOTech’s [Device Configuration Tool](https://dct.iotechsys.com/).
A video showing you how to do this can for the Damocles2 Mini device
can be viewed at [DCT Modbus Tutorial Video](https://www.youtube.com/watch?v=sj1hC7S4uE4).

### Azure (required)

To connect the example to your IoT Hub endpoint you must also
configure Azure Export Service component.

* Edit [config/azure.json](../config/azure.json) and the
  value for the "HostName", "DeviceID" and "ScopeID" values.

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

### Device Twin (Required)

The configuration files compiled into the application are only used
for initial connection to Azure. The "desired" properties setting on
the device twin are automatically downloaded and persisted to the
Azure Sphere device. An example set of "desired" properties can be
found at:
[twin/desired-modbus.json](../twin/desired-modbus.json)

The Microsoft Azure Device Twin corresponding to the Azure Sphere
development board will need updating to include the same "azure"
component settings. This is found in the Device twin JSON at
"properties" / "desired" / "Components" / "azure". This is can be
accessed via the Azure portal.

The device twin "main" has the modbus component referenced and the
properties for "properties" / "desired" / "Components" / "modbus" must
be configured to match the actual deployment.

The configuration for the modbus device service is found under
"properties" / "desired" / "Services" / "modbus_device_service".

The Azure Sphere board on first boot will wait indefinitely until a
complete configuration update is received from the device twin. The
board will then reboot. After reconnecting to the Azure cloud service
the device service will start processing any configured schedules and
publish the data to Azure.

If the desired properties are changed then the Azure Sphere board will
reboot after receiving notification of the change.

#### Python Script

A Python example can be found at [twin/device-twin.py](../twin/device-twin.py)
which shows how to use the Azure IoT SDK, to alter a device twin on
an IoT Hub. You will need a connection string for the
[Azure IoT Hub connection/auth](https://docs.microsoft.com/en-us/cli/azure/iot/hub/connection-string?view=azure-cli-latest)
and the device id of the device you wish to use. Both of these
will need to be set as environment variables as shown below.

```bash
export IOTHUB_CONNECTION_STRING=<connection_string>
export IOTHUB_DEVICE_ID=<device_id>
```

### Remote Logging (Optional)

The example main.c includes a remote logging component to publish logging
messages over UDP. This needs to be configured by editing
[configs/udp-logger.json](../config/udp-logger.json)
and changing the "To:" value to use the IP address of the host PC.
The Makefile contains an example of using the socat command to monitor
the log output.


### App Manifest (required)

You will need to edit the app manifest file at [mt3620-g100/app_manifest.json](../mt3620-g100/app_manifest.json)
with the following:

* In AllowedConnections, replace IOTechHub with the name of
  your hostname of your IoT Hub, you can find this via the
  [Azure Portal](https://portal.azure.com/) or using the
  command (replace <iothub-name> with the name of your IoT Hub):
  ```bash
  az iot hub show --name <iothub-name> | grep hostName
  ```
* If your using the [Modbus Simulator](#using-modbuspal-simulator-with-the-example)
  you will need to replace 10.0.0.1 in AllowedConnections with
  the IP address of your PC running the Modbus Simulator,
  otherwise 10.0.0.1 can be removed from AllowedConnections
* Set DeviceAuthentication, to your tenant id:
  ```bash
  azsphere tenant list
  ```

![Application Manifest](images/AppManifest.svg)

## Using the Modbus Simulator With The Example

 To use ModbusPal Simulator with this example you will
 need to:

* Download the [ModbusPal.jar](https://iotech.jfrog.io/artifactory/public/ModbusPal.jar) file.

For both Windows and Ubuntu the Firewall may need to be disabled
or a new rule needs to be added to allow incoming TCP connections
on port 1502 to the simulator:

* For Windows add a new rule following the steps below:
    * Find "Firewall & network protection"
    * Select "Advanced settings"
    * Right click "Inbound Rules" and select "New Rule"
    * Select "Port" and click "Next"
    * Select "TCP", set port number to 1502 and click "Next"
    * Select "Allow the connection" and click "Next"
    * Set Name to "ModbusPal" and click "Finish"

* For Ubuntu add a new rule following the steps below:
    * Run the Firewall Configuration UI
    * Select "Rules" and add a new rule with "+"
    * Select "Simple"
    * Set "Name" to "ModbusPal"
    * Set "Policy" to "Allow"
    * Set "Direction" to "In"
    * Set "Protocol" to "TCP"
    * Set "Port" to "1502"
    * Select "+Add"

* Run the simulator by clicking on downloaded ModbusPal.jar file 
  (Windows) or by running it via the command line:

  ```bash
  java -jar ModbusPal.jar
  ```

* Use the "Load" button and select the [damocles.xmpp](../damocles.xmpp)
  file. This provides a simulation of a Damocles 2 Mini Modbus
  Device with 4 binary inputs and 2 binary outputs.

![ModbusPal Load](images/ModbusPalLoad.svg)

* Start the simulator with the "Run" button,

![ModbusPal Run](images/ModbusPalRun.svg)

## Building and Debugging The Application

You can build the BACnet Example following the links below:

* [Building, Deploying and Debugging on Windows](windows-build.md)
* [Building, Deploying and Debugging On Ubuntu](ubuntu-build.md)

## Deploying From The Cloud

You can also deploy the Modbus Example from the cloud with
the link below:

[Deploy From The Cloud](deploy-from-the-cloud.md)

## Inputs & Outputs With A Modbus Device

This section explains how to change:
* Change the Output values from the IoT Hub in the Cloud
* Change the Input values of a simulated device with ModbusPal

With a real Modbus Device, the input values will be changed by the
device, then pushed up to the IoT Hub in the Cloud. However, if your
using ModbusPal Simulator, you will need to change the Input value from
the UI to simulate a Input value being changed, the value will then be
sent up to the IoT Hub in the Cloud.

Make sure that you've deployed XRT to Azure Sphere hardware to
see changes taking place with the IoT Hub in the Cloud.

#### Changing A Modbus Device Output Values

This section applies to a simulated device and a real device.

The script update.sh can be used to send a payload of data
to Azure IoT hub to invoke a device method on a Device Twin. The
IoT Hub will send the payload to XRT which will be picked up by
the Azure component and push to the Modbus Device Service
via an XRT Bus.

To set the device resource `BinaryOutput1` to true on the
`damocles-virt1` device, issue the method (replace IotHub-Name
with the name of your IoT Hub):

```bash
./update.sh <IotHub-Name> damocles-virt1 BinaryOutput1 true
```

#### Changing A Modbus Device Input Values On ModbusPal Simulator

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
