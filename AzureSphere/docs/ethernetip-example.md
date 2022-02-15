# Ethernet-IP Device

In this Ethernet-IP example, XRT connects to a Allen Bradley PLC that is assumed to have preprogrammed tags. Values are read from the PLC and pushed to Azure IoT Hub.

An example of connecting to the Allen Bradley PLC using wired Ethernet is given in this guide.

## AzureSphere Hardware

## Prerequisites

Note: The prerequisites found on the main [readme.md](https://github.com/IOTechSystems/xrt-examples/blob/v1.1-branch/AzureSphere/README.md) are required for this example

- Allen Bradley PLC or other EthernetIP device

## Configuration

In-order for the Ethernet-IP Example to work, you will need to edit some of the configurations. The configurations that are required to be edited will have "(required)" within their title.

### Device Profile

A sample Ethernet-IP device profile for an Allen Bradley PLC can be found at: [configs/profiles/Allen-Bradley-Azure.json](../config/profiles/Allen-Bradley-Azure.json).

The Device profile contains a config of different deviceResources that can be sent or received from the Azure IoT Hub.

Edit this file with the corresponding tag names you wish to read/write to within the desired PLC

### Azure (Required)

The Azure config file can be found at: [configs/azure.json](../config/azure.json).

You will need to configure some values in azure.json to be able to send values to the IoT Hub. You will need:

- DeviceID, can be found for a USB connected device with the command:

  ```
  azsphere device list-attached
  ```
- HostName, is the IOT Hub host name and can be found using the Azure Portal or using the command (replace HubName with the name of your IOT hub):

  ```
  az iot hub show --name <HubName> | grep hostName
  ```

- ScopeID, the Device Provisioning Service ID Scope can be found using the portal or the command (replace DPSName with the name of your Device Provisioning Service):

  ```
  az iot dps show --name <DPSName> | grep idScope
  ```

### App Manifest (Required)

- Edit the [mt3620-g100/app_manifest.json](../mt3620-g100/app_manifest.json) file and set DeviceAuthentication to your tenant id and replace IOTechHub with your Azure IoT Hub name in AllowedConnections:

  ```
  azsphere tenant list
  ```

- Add the ip address of the Allen Bradley PLC device that will be communicating with XRT, to the `AllowedConnections` JSON array.

### Device Twin (Required)

The configuration files compiled into the application are only used
for initial connection to Azure. The "desired" properties setting on
the device twin are automaticallly downloaded and persisted to the
Azure Sphere device. An example set of "desired" properties can be
found at:
[twin/desired-ethernetip.json](../twin/desired-ethernetip.json)

The Microsoft Azure Device Twin corresponding to the Azure Sphere
development board will need updating to include the same "azure"
component settings. This is found in the Device twin JSON at
"properties" / "desired" / "Components" / "azure". This is can be
accessed via the Azure portal.

The device twin "main" has the bacnet component referenced and the
properties for "properties" / "desired" / "Components" / "bacnet" must
be configured to match the actual deployment.

The configuration for the BACnet device service is found under
"properties" / "desired" / "Services" / "bacnet_device_service".

The Azure Sphere board on first boot will wait indefinitely until a
complete configuration update is received from the device twin. The
board will then reboot. After reconnecting to the Azure cloud service
the device service will start processing any configured schedules and
publish the data to Azure.

If the desired properties are changed then the Azure Sphere board will
reboot after receiving notification of the change.

### Remote Logging (Optional)

The example main.c includes a remote logging component to publish logging
messages over UDP. This needs to be configured by editing
[configs/udp-logger.json](../config/udp-logger.json)
and changing the "To:" value to use the IP address of the host PC.
The Makefile contains an example of using the socat command to monitor
the log output.

### Configure Pool Component (Optional)

- If many schedules have been set it will be a good idea to edit the desired properties pool component configuration file and set maxjobs to a lower number and reduce threads to 1 to avoid crashes and memory issues.

### Ethernet/IP Azure Driver Options

The Azure version of the Ethernet/IP device service has some extra driver options that need to be configured before deploying and running on the Azure Sphere device:

```
"Driver": {
        "NetworkInterface": "eth0",
        "MacAddress": "c2:25:80:93:36:98",
        "FullDuplex": true,
        "NetworkSpeed": 1000
    },
```

- **NetworkInterface** - the wired network interface on the Azure Sphere device - can be found using 
```
azsphere device network list-interfaces
```
- **MacAddress** - the mac address of the chosen network interface on the azure device - can be found using
```
azsphere device network list-interfaces
```
- **FullDuplex** - state if the device is full-duplex or not - this can usually be found from the webpage of the PLC or other device that is connected to the same network - see image below.
- **NetworkSpeed** - the network speed of which the device is connected to - can be found from the http webpage of the PLC or other device that is connected to the same network - see image below.

![Logix](images/Logix.png)

### Adding Devices

To provision a device on XRT with the Ethernet/IP device service, two things are needed

- The Device Profile
- The IP Adress of the device

These are added to the desired properties under "Devices":

```
 "Devices":{
        "Allen-Bradley-Azure": {
            "profile": "Allen-Bradley-Azure",
            "protocols": {
                "IP": {
                    "Address": "192.168.4.18"
                }
            }
        }
    },
```

 ### Setting Up Schedules

Schedules have to be setup before deploying and running XRT, schedules require 3 parameters:

- The Device name
- The Desired Resource
- The Desired Interval

These are added to the desired properties under "Schedules":

```
 "Schedules": [
        {
            "device": "Allen-Bradley-Azure",
            "resource": "test_dint",
            "interval": 100000
        }
  ]
```

## Building and Debugging The Application

You can build the BACnet Example following the links below:

* [Building, Deploying and Debugging on Windows](windows-build.md)
* [Building, Deploying and Debugging On Ubuntu](ubuntu-build.md)

## Deploying From The Cloud

You can also deploy the BACnet Example from the cloud with
the link below:

[Deploy From The Cloud](deploy-from-the-cloud.md)

## Python Script

A Python BacNET example can be found at [twin/device-twin.py](../twin/device-twin.py)
which shows how to use the Azure IoT SDK to update a device twin on
an IoT Hub.