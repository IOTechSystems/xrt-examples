# BACnet Device

In this BACnet example, XRT connects to a BACnet simulator that
simulates a BACnet device. A Lua script controls the logic
of the simulated BACnet device on the simulator side. Values
are read from the simulated BACnet device and pushed to Azure
IoT Hub, values can also be sent from Azure IoT Hub to the
simulated BACnet device via XRT.

An example of connecting to the BACnet Simulator using WI-FI
is given and also an example of connecting to BACnet Simulator
via ethernet.

## AzureSphere Hardware

The BACnet Example works on all XRT supported AzureSphere
hardware, that's listed on the main [readme](../README.md).

## Prerequisites

Note: The prerequisites found on the main [readme.md](../README.md) are also required for this example.

* BACnet Simulator (Docker)

## Configuration

In-order for the BACnet example to work, you will need
to edit some of the configurations. The configurations
that are required to be edited will have "(required)"
within there title.

### Device Profile

BACnet Device profile can be found at:
[configs/profiles/bacnet-simulator.json](../config/profiles/bacnet-simulator.json)

The Device Profile contains a config of different
deviceResources that can to be sent or received from the Azure
IoT Hub.

### Azure (Required)

The Azure config file can be found at:
[configs/azure-bacnet.json](../config/azure.json)

You will need to configure some values in azure.json to
be able to send values to Azure IoT Hub. You will need:

* DeviceID, can be found for a USB connected device with
  the command:

```bash
azsphere device list-attached
```

* HostName, is the Azure IoT Hub host name and can be found
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

### Device Twin (Required)

The configuration files compiled into the application are only used
for initial connection to Azure. The "desired" properties setting on
the device twin are automaticallly downloaded and persisted to the
Azure Sphere device. An example set of "desired" properties can be
found at:
[twin/desired-bacnet.json](../twin/desired-bacnet.json)

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

### App Manifest (Required)

* Edit the [app_manifest.json](../app_manifest.json) file and
  replace the DeviceAuthentication value \<tenant-uuid-identifier\> with
  your tenant id and replace <IOTHub> with your IoT Hub name
  in AllowedConnections

  ```bash
  azsphere tenant list
  ```

* Add the ip address of any BACnet devices, that will be
  communicating with XRT, to the `AllowedConnections` JSON
  array, and add the BACnet broadcast ip address of the
  subnet. For example, when using the subnet 192.168.4.0,
  the broadcast ip would be 192.168.4.255

  ```json
  ...
  "AllowedConnections" : [ "<bacnet-device-ip>", "<bacnet-broadcast-ip>", "global.azure-devices-provisioning.net", "IOTechHub.azure-devices.net" ],
  ...
  ```
  
* Optionally add the IP address of a PC to receive XRT logging output sent over UDP.

## Building and Debugging The Application

You can build the BACnet Example following the links below:

* [Building, Deploying and Debugging on Windows](windows-build.md)
* [Building, Deploying and Debugging On Ubuntu](ubuntu-build.md)

## Deploying From The Cloud

You can also deploy the BACnet Example from the cloud with
the link below:

[Deploy From The Cloud](deploy-from-the-cloud.md)

## BACnet Simulator

The BACnet Simulator, simulates a BACnet device, which is
controlled via a Lua script. The Lua script for this example
can be found in the [bacnet-simulator](../bacnet-simulator)
directory. The simulator is supplied as a Docker image.

### Connecting To BACnet Simulator

You will need to make sure to mount the bacnet-simulator
directory as a volume to the Docker Container running the
BACnet Simulator Docker Image. Make sure your current
directory is set to xrt-examples/AzureSphere. Run the
following command to start the BACnet Simulator and
mount the bacnet-simulator directory:

```bash
docker run -it --rm --name=bacnet-sim -e RUN_MODE=IP \
--network host \
-v $(pwd)/bacnet-simulator:/docker-lua-script/ \
iotechsys/bacnet-sim:2.0 --script /docker-lua-script/example.lua --instance 2749
```

Within the Device twin desired properties make sure
to select the required `NetworkInterface` option in the Driver section of the config file. For example the WI-FI interface:

```json
...
"Driver":{
  "NetworkInterface":"wlan0",
  "APDU_Timeout":"5000",
  "APDU_Retries":"2"
}
...
```

Also, the IP address of the machine running the simluator and
the BACnet broadcast IP should be included in the `AllowedConnections`
JSON array, as part of the app manifest configuration as described
[here](#app-manifest-required).

## Changing A BACnet Device Output Values

The script update.sh can be used to send a payload of data
to Azure IoT hub to invoke a device method on a Device Twin.
The IoT Hub will send the payload to XRT which will be
picked up by the Azure component and pushed to the BACnet
Device Service via an XRT Bus.

To set the device resource `AnalogOutput0` to the value 1.0 on the
`bacnet-simulator` device, issue the method (replace
IotHub-Name with the name of your IoT Hub):

```bash
./update.sh <IotHub-Name> bacnet-simulator AnalogOutput0 1.0
```

## Example Test Network with Rasberry Pi Docker Host

#### Hardware

The following hardware will be used in this example.

* Raspberry Pi (used to host simulator)
* Ethernet Switch
* USB to Ethernet Adapter

#### Setup

First make sure to ssh in to the Raspberry Pi while its connected
to the local network via Ethernet. Install docker for the
Raspberry Pi with:

```bash
sudo apt-get install docker.io
```

After docker has been installed, pull the BACnet Simulator image with:

```bash
docker pull iotechsys/bacnet-sim:2.0
```

Make a note of the Raspberry Pi eth0 MAC Address, as it will be
needed later in this section of the example. Use the following
in the command-line to obtain the MAC Address:

```bash
ifconfig | grep eth0 -A 3
```

Shutdown the Raspberry Pi and disconnect it from your local network.

The USB to Ethernet Adapter now needs to be plugged into your development
machine. The Raspberry Pi and the Azure Sphere hardware
should be connected to the Ethernet Switch using Ethernet cables. A
Ethernet cable should be connnected from the switch to the
USB to Ethernet Adapter connected to your development machine.

Turn the Ethernet Switch on to give power to the USB to Ethernet
Adapter, the machine should now pick up on the Adapter as a new
interface. Using netplan, a static ip needs to be set for the
machine using the USB to Ethernet Adapter interface. Use `ifconfig`
on the command-line to find the interface name as follows (If you
can't determine which interface the USB adaptor, unplug the adaptor
from the machine, then run ifconfig, plug the adaptor back in,
re-run ifconfig and compare the current ifconfig output with the
previous unplugged adaptor ifconfig output to deduce the
interface name):

```bash
ifconfig
```

After you've found the USB Adapter interface name, create a
config file at `/etc/netplan/99-usb-eth-config.yaml`
with the following contents, inserting the interface name where indicated.

```conf
network:
  ethernets:
    <USB to Ethernet Adapter interface name>:
      addresses:
        - 192.168.4.1/24
```

Apply the new config file with the following:

```bash
sudo netplan apply
```

Then restart the netplan service

```bash
sudo systemctl restart network-manager
```

In order to ssh into the Raspberry Pi on the new 192.168.4.0
subnet, the Raspberry Pi will need an ip address. Create a file
in the following path `/etc/dhcp/dhcpd.conf` and copy in the
below contents, replace the <MAC address of the raspberry pi>
place holder with the MAC Address of the Raspberry Pi you
obtained earlier:

```conf
subnet 192.168.4.0 netmask 255.255.255.0 {
  range 192.168.4.3 192.168.4.20;
}

host raspberry-pi {
  hardware ethernet <MAC address of the raspberry pi>;
  fixed-address 192.168.4.12;
}
```

Now, restart the dhcp service with the following:

```bash
sudo systemctl restart isc-dhcp-server.service
```

SSH to the Raspberry Pi with the following command

```bash
ssh pi@192.168.4.12
```

Create a bacnet-simulator directory
```bash
mkdir bacnet-simulator
```

From another command-line terminal, copy over the BACnet Simulator
Lua script found in the bacnet-simulator directory of using scp:

```bash
scp bacnet-simulator/example.lua pi@192.168.4.12:~/bacnet-simulator
```

On the terminal with the ssh connection to the Rasberry Pi start the BACnet Simulator with the following command:

```bash
docker run --rm --name=bacnet-sim -e RUN_MODE=IP -e BACNET_IFACE=eth0 \
--network host -it --privileged -v $(pwd)/bacnet-simulator:/docker-lua-script/ \
iotechsys/bacnet-sim:2.0 --script /docker-lua-script/example.lua --instance 2749
```

Make sure to add the IP address of the BACnet devices (in this case
the Raspberry Pi) and the BACnet broadcast IP are added to the app_manifest configuration file as follows:

```json
...
"AllowedConnections" : [ "192.168.4.12", "192.168.4.2", "192.168.4.255", "global.azure-devices-provisioning.net", "IOTechHub.azure-devices.net" ],
...
```

You'll now be able to connect the BACnet Simulator once XRT has
been deployed.
