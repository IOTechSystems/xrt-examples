# XRT Azure Sphere Tutorial

This tutorial shows how to build a connected IoT application using IOTech Edge XRT deployed on an Azure Sphere Guardian 100 module. For this tutorial the XRT application is used to communicate with a Modus TCP/IP Device ([Damocles2 Mini](https://www.hw-group.com/device/damocles2-mini)), reading data values which are then sent to its digital twin running on Azure IoT Hub. Via the digital twin commands can also be sent back to the Modbus Device connected to the Guardian Module.

The tutorial is split into two parts. Part 1 describes how to create an XRT application that can send data from the Modbus device connected to the Guardian 100 to Azure IoT Hub and receive commands in the reverse direction. Part two shows how to interact with the Modbus Device via Azure Digital Twins.

## Part 1

### Prerequisites

1.	All hands-on and setup are based on either Windows and Visual Studio or Linux (Ubuntu 20.4) and [Visual Studio Code](https://code.visualstudio.com/download})
2.	Up to date Visual Studio and [Azure Sphere SDK](https://docs.microsoft.com/en-us/azure-sphere/install/install-sdk?pivots=visual-studio#azure-sphere-sdk-for-visual-studio) for Visual Studio are installed on your host PC
3.	Either [ModbusPal](https://iotech.jfrog.io/artifactory/public/ModbusPal.jar) Java Modbus simulator installed on your Windows or Linux host PC, or a Damocles2 Mini connected by wired EtherNet to Guardian 100 module
4.	Azure IoT Hub setup (insert link to XRT Azure Sphere User Guide)
5.	Guardian 100 module hardware claimed by Azure Sphere Cloud Tenant


### Hardware
This tutorial can be used with the Avnet Guardian 100 Azure Sphere module.

The Guardian 100 is a wireless edge module that uses Azure Sphere to deliver secure connectivity to devices. It includes Avnet Azure Sphere MT3620 module and connects to existing equipment via Ethernet or USB. Guardian-enabled devices also receive automatic security updates through the Azure Sphere Security Service.

![Guardian 100](Guardian100.png)

### XRT for Azure Sphere Development Process

XRT enables users to create connected Azure Sphere applications for a range of industrial protocols (e.g. Modbus, BACNet, OPC UA etc). XRT provides users with the ability to create IoT applications by easily configuring a set of “deployment ready” components. XRT application development is supported by the IOTech Device Configuration Tool (DCT) which is a graphical tool that enables the definition and creation configuration files called Device Profiles which are used to define new OT device endpoint types and their properties. The tool can be accessed as an online service at [Device Configuration Tool](https://dct.iotechsys.com/).

The process for creating a connected Azure Sphere IoT application using XRT is illustrated in the following graphic.

![Azure Development Process](AzureDevProcess.jpg)  

The development process flow follows a standard sequence of steps:

Step 1:
*	Install the XRT for Azure Sphere package on either a Windows or Linux (Ubuntu) host PC and then install the Azure Sphere demo project into Visual Studio.

Step 2:
*	Using the IOTech [Device Configuration Tool](https://dct.iotechsys.com/) create a *Device Profile.json* configuration file representing the IoT device type. For example in this tutorial we will create a Device Profile for the [Damocles2 Mini](https://www.hw-group.com/device/damocles2-mini) Modbus device. Using the same device definition, DCT can also be used to generate a Digital Twins Definition Language (DTDL) file representation for use with Azure IoT Hub.

Step 3:
*	Configure the appropriate *Device Service.json* (e.g. [modbus.json](config/modbus.json)) file specifying the device instance(s) that the XRT Device Service (e.g. Modbus) component will create at runtime based on the *Device Profile.json* file (e.g. [Damocles2-Mini.json](Damocles2-Mini.json)) created in the previous step. Also configure the *Azure Export Service.json* file (e.g [azure.json](config/azure.json)) to specify the endpoint information needed by the XRT Azure Sphere Export Service to send data to and accept commands from IoT Hub. Finally Configure an a *Azure Apllication Manifest.json* (e.g [app_manifest.json](app_manifest.json)) file that describes the resources, also called application capabilities, that an application requires. Every application has an application manifest.

Step 4:
*	Using Visual Studio (or cmake from the command line) build the XRT Azure Application.

Step 5:
*	From Visual Studio using the azsphere utility  deploy the XRT Azure Application onto the Azure Sphere hardware module (e.g. Guardian 100)

Step 6:
* Visualize the data on Azure IoT Hub and optionally send commands back to the connected IoT device. **TO BE COMPLETED**

Each of the above steps are covered in detail in the subsequent parts of this tutorial.


### Development Host Setup

#### Installing the  XRT Package on Ubuntu

To install XRT Azure Sphere, complete the following steps.

1. Install the packages, using the following command:

`apt-get install lsb-release apt-transport-https curl gnupg2`

2. Add the key for the IOTech repository, using the following command:

`curl -fsSL https://iotech.jfrog.io/artifactory/api/gpg/key/public | apt-key add - `

3. Register the IOTech repository, using the following command:

`echo "deb https://iotech.jfrog.io/iotech/debian-release $(lsb_release -cs) main" | tee
-a /etc/apt/sources.list.d/iotech.list`

4.  Update the repositories, using the following command:

`apt update`

5. Install XRT using the following command:

`apt-get install iotech-xrt-azsphere7`


#### Installing the XRT Package on Windows

To install XRT Azure Sphere, complete the following steps:

1. Install the Azure Sphere SDK. For further information on installing the Azure SDK on Windows 10, refer to the [Windows installation quickstart](https://docs.microsoft.com/en-gb/azure-sphere/install/install-sdk?pivots=visual-studio) section of the Azure Sphere documentation

2. Download the XRT .zip package from the IOTech repository, using the following command:

`curl -L -O https://iotech.jfrog.io/artifactory/windows-release/iotech-xrt-1.1.0.zip`

3. Open Windows File Explorer

4. Select the downloaded .zip package and extract the files to the following location:

`C:\Program Files (x86)\Microsoft Azure Sphere SDK\Sysroots\7`


#### Visual Studio Setup

1. Open Visual Studio and install Visual Studio Extensions for Azure Sphere

2. Create a new Project. Search for the "azure sphere" template, then select "Azure Sphere Blink"

3. In the generated project directory from this example:

* Copy the config directory
* Overwrite CMakeLists.txt, app_manifest.json and main.c
* Edit app_manifest.json and set "DeviceAuthentication" to the UUID of your Tenant. This can be found by:

`azsphere tenant list`

* Build the application

### Example Application

The Azure Sphere example application demonstrates how to use XRT to communicate with a Modus TCP/IP Device (Damocles2 Mini) or alternatively if you do not have access to a physical device a Java Modbus simulator (ModbusPal) can be used instead of the real hardware.

If the Damocles hardware is used then it must be connected to the Guardian 100 module via a wired Ethernet connection.

If the simulator is used it can be installed on a PC (e.g. the host running Visual Studio) and accessed via either wired Ethernet or WiFi.

![Azure Sphere Modbus Example](AzureSphereModbusExample.jpg)

The Damocles2 mini is a smart I/O controller used for remote monitoring and control of sensors and devices. It provides 4 digital dry contact inputs and 2 digital relay outputs that can be accessed via a Modbus interface.

The Azure Sphere example application reads the digital input from the Modbus device via the Modbus Device Service component and publishes the data onto the internal XRT bus. A Lua Scripting component subscribes to these values and checks for any digital input states changes. Only if changes are detected is the data re-published onto the bus. An Azure Export component subscribes to these changes and pushes the data values to an Azure IoT Hub endpoint.

From Azure IoT Hub methods can be called to send commands back down to the XRT application running on the Azure Sphere module to set the digital output values.

Command values are received by the Azure Export component and published onto the XRT bus. The Modbus Device Service subscribes to these commands and sets the value of the two digital outputs on the Damocles2 Mini.

In Part 2 of this tutorial we show how to use a Damocles2 Mini digital twin instantiation on IoT Hub, methods can be called to send commands back down to the physical device.

Note the digital outputs on the device are wired to the digital inputs on the device. In this way output values are automatically mirrored by the digital inputs.   

#### Creating a Modbus Device Profile and DTDL generation using the DCT

As described in the previous section (Step 2) to connect to a new device via XRT you must first create a Device Profile for the specific device type and in the case of this example a corresponding DTDL file.
Device Profiles and DTDL files can created using IOTech’s [Device Configuration Tool](https://dct.iotechsys.com/). A video showing you how to do this can for the Damocles2 Mini device can be accessed at [DCT Modbus Tutorial Video](https://www.youtube.com/watch?v=sj1hC7S4uE4).
The configuration files generated from the tool are as follows:
*	[Damocles2 Mini Device Profile](Damocles2-Mini.json)
*	[Damocles2 Mini DTDL file](Damocles2-Mini.dtdl)

#### Running the ModbusPal Simulator

* Download the [ModbusPal.jar](https://iotech.jfrog.io/artifactory/public/ModbusPal.jar) file.

* Run the simulator with the command:

`java -jar ModbusPal.jar`

* Use the "Load" button and select the [damocles.xmpp](damocles.xmpp) file. This provides a simulation of a simple Modbus devices with 4 binary inputs and two binary outputs.

![ModbusPal Load](ModbusPalLoad.svg)

* Start the simulator with the "Run" button.
Configuring XRT for use with Guardian 100 or Modbus simulator
In order to deploy the example application and enable it connect to the Modbus simulator (or a real Damocles2 Mini device)  then you must configure the following config files for the XRT Modbus Device Service component and the Azure Sphere manifest to use the IP address of your PC.

![ModbusPal Run](ModbusPalRun.svg)

* Edit the [app_manifest.json](app_manifest.json) file and replace 10.0.0.1 with the IP address of your PC

![Application Manifest](AppManifest.svg)

* Edit the [config/modbus.json](config/modbus.json) file and  replace 10.0.0.1 with the IP address of your PC

![Device Service Config](DeviceServiceConfig.svg)  

To connect the example to your IoT Hub endpoint you must also configure Azure Export Service component.

* Edit [config/azure.json](config/azure.json) and the value for the "HostName", "DeviceID" and "ScopeID" values.

* The DeviceID can be found for a USB connected device with the command:

`azsphere device list-attached`

* The HostName is the IOT Hub host name and can be found using the
  [Azure Portal](https://portal.azure.com/) or using the command (replace
  HubName with the name of your IOT hub):

`az iot hub show --name HubName | grep hostName`

* The Device Provisioning Service ID Scope can be found using the
  portal or the command (replace DPSName with the name of your Device
  Provisioning Service):

`az iot dps show --name DPSName | grep idScope`

![Azure Export Config](AzureExportConfig.svg)

#### Building The Application

Issue the command:

`make`

#### Deploying the Application

In another shell issue the command:

`/opt/azurespheresdk/Sysroots/7/tools/sysroots/x86_64-pokysdk-linux/usr/bin/arm-poky-linux-musleabi/arm-poky-linux-musleabi-gdb xrt-app.out`

#### Debugging the Application

In gdb issue the commands:

`set sysroot /opt/azurespheresdk/Sysroots/7`

`target remote 192.168.35.2:2345`

`continue`

Observe the debug output in the terminal where the make command was issued. The simulated Modbus device inputs are read at an interval specified in the Modbus device service configuration.

### Change Modbus Device Input Values

* Open the Slave Editor by pressing the button with the "eye" icon and
  then select the "Coils" tab in the dialog that appears.

![Open Slave Editor](ModbusPalEye.svg)

![Select Coils](ModbusPalCoils.svg)

* Change the value of "Input 1" by double clicking in the table value
  entry and entering a value of "1".

![Change Value](ModbusPalChangeValue.svg)

* Observe the debug output to see the new value being read from the
  simulated Modbus device and then published to the Azure Cloud.

### Changing the Modbus Device Outputs

The script update.sh can be used to update device resources the Azure
IOT hub to invoke a device method.

* To set the resource BinaryOutput1 to true issue the command (replace
  HubName with the name of your IOT hub):

`./update.sh HubName BinaryOutput1 true`

## Tutorial Part 2 – Setting Up Digital Twins
