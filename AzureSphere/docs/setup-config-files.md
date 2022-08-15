## AzureSphere Hardware

The device service examples work on all XRT supported AzureSphere
hardware, that's listed on the main [readme](../README.md).

## Configuration

In-order for the examples to work, you will need
to edit some of the configurations.

A script has been created to automate the editing of most of the required
configurations. To launch the script ensure you are in the root *AzureSphere* Directory:

``` console
cd AzureSphere
```

and run *setup_configs.sh*

```console
./setup_configs.sh
```

to restore changes that have been made by the script:

```console
git restore .
```

The configurations that are required to be edited will have "(required)"
within their title.

### Device Profile

The Device Profile contains a config of different deviceResources that
can to be sent or received from the Azure IoT Hub.

Sample device service profiles can be found here:

- [BACnet/IP XRT Example](../../DeviceServices/bacnet-ip/deployment/profiles/bacnet-ip-sim-profile.json)
- [EtherNet/IP XRT Example](../../DeviceServices/ethernet-ip/deployment/profiles/ethernetip-sim-profile.json)
- [Modbus XRT Example](../../DeviceServices/modbus-tcp/deployment/profiles/modbus-sim-profile.json)
- [Virtual XRT Example](../../DeviceServices/virtual/deployment/profiles/device-virtual.json)

Example profiles are already included within the desired twin examples:

- [example desired-bacnet.json](../twin/desired-bacnet.json)
- [example desired-ethernetip.json](../twin/desired-ethernetip.json)
- [example desired-modbus.json](../twin/desired-modbus.json)
- [example desired-virtual.json](../twin/desired-virtual.json)

Device Profiles and DTDL for Digital Twins files can also be created
using IOTech’s [Device Configuration Tool](https://dct.iotechsys.com/).
A video showing you how to do this can for the Damocles2 Mini device using the modbus device service 
can be viewed at [DCT Modbus Tutorial Video](https://www.youtube.com/watch?v=sj1hC7S4uE4).


### Azure (Required)

The Azure config file can be found at:
[configs/azure.json](../config/azure.json)

You will need to configure some values in azure.json to
be able to send values to Azure IoT Hub. You will need:

- DeviceID, can be found for a USB connected device with
  the command:

```bash
azsphere device list-attached
```

- HostName, is the Azure IoT Hub host name and can be found
  using the [Azure Portal](https://portal.azure.com/) or
  using the command (replace HubName with the name of your
  IOT hub):

```bash
az iot hub show --name <HubName> | grep hostName
```

- ScopeID, The Device Provisioning Service ID Scope can be found
  using the portal or the command (replace DPSName with
  the name of your Device Provisioning Service):

```bash
az iot dps show --name <DPSName> | grep idScope
```

### Device Twin (Required)

The configuration files compiled into the application are only used
for initial connection to Azure. The "desired" properties setting on
the device twin are automatically downloaded and persisted to the
Azure Sphere device. An example set of "desired" properties can be
found within the: [*AzureSphere/twin/*](../twin/desired-bacnet.json)
directory.

The Microsoft Azure Device Twin corresponding to the Azure Sphere
development board will need updating to include the same "azure"
component settings. This is found in the Device twin JSON at
"properties" / "desired" / "Components" / "azure". This can be
accessed via the Azure portal, or via the azure extension within VScode.

#### Setting up Device Service Component

The device twin "main" has the device service component referenced and the
properties for "properties" / "desired" / "Components" / "*<device_service_name>*" must
be configured to match the actual deployment.

The configuration for the device service is found under
"properties" / "desired" / "Services" / "*<device_service_name>*".

#### Setting Up Schedules

Schedules have to be setup before deploying and running XRT, schedules require 3 parameters:

- The Device name
- The Desired Resource(s)
- The Desired Interval

These are added to the desired properties under "Schedules":

``` json
"Schedules": [
      {
          "device": "Allen-Bradley-Azure",
          "resource": [
              "DINT_ARRAY"
          ],
          "interval": 4000000,
          "name": "schedule1"
      }
  ]
```

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

### App Manifest (Required)

- Edit the *app_manifest.json* found under the subdirectory of
    the Azure Board being used e.g [*mt3620-g100/app_manifest.json*](../mt3620-g100/app_manifest.json).

    replace the DeviceAuthentication value \<tenant-uuid-identifier\> with your tenant id which can be found using the following command:

    ```bash
    azsphere tenant list
    ```

   Replace *<IOTHub>* with your IoT Hub name in AllowedConnections

- Add the ip address of any devices, that will be
  communicating with XRT, to the `AllowedConnections` JSON
  array.
  
- Optionally add the IP address of a PC to receive XRT logging output sent over UDP.

- Enter all the required TCP and UDP port numbers that will be needed
    within the `AllowedTcpServerPorts` and `AllowedUdpServerPorts` 
    JSON arrays.

*NOTE:* If following any device service examples ensure you enter all the required IP Addresses
of any simulators or devices you wish to use within the allowed connections.

### Remote Logging (Optional)

The example main.c includes a remote logging component to publish logging
messages over UDP. This needs to be configured by editing
[configs/udp-logger.json](../config/udp-logger.json)
and changing the "To:" value to use the IP address of the host PC.
The Makefile contains an example of using the socat command to monitor
the log output.

The udp-logger configuration will also need to be updated in the desired
json example:

``` json
"udp-logger": {
    "Name": "udp-logger",
    "Level": "Trace",
    "To": "udp:<host-ip>:1999",
    "Start": true
}
```

## Building and Debugging The Application

You can build the Example following the links below:

- [Building, Deploying and Debugging on Windows](windows-build.md)
- [Building, Deploying and Debugging On Ubuntu](ubuntu-build.md)

## Deploying From The Cloud

You can also deploy the Azure Device Service examples from the cloud with
the link below:

[Deploy From The Cloud](deploy-from-the-cloud.md)