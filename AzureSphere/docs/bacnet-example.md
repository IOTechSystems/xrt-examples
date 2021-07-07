# BACnet Device

In this BACnet example, XRT connects to a BACnet simulator that
simulates a BACnet device. A Lua script controls the logic
of the simulated BACnet device on the simulator side. Values
are read from the simulated BACnet device and pushed to a Azure
IoT Hub, values can also be sent from Azure IoT Hub to the
simulated BACnet device via XRT.

An example of connecting to the BACnet Simulator using WI-FI
is given and also an example of connecting to BACnet Simulator
via ethernet.

## AzureSphere Hardware

The BACnet Example works on all XRT supported AzureSphere
hardware, that's listed on the main [readme](../README.md).

## Prerequisites

*Note - The prerequisites found on the main
[readme.md](../README.md) are also required for this example.*

* BACnet Simulator (Docker)

## Configuration

In-order for the BACnet Example to work, you will need
to edit some of the configurations. The configurations
that are required to be edited will have "(required)"
within there title.

### Device Profile

BACnet Device profile can be found at:
configs/profiles/bacnet-simulator.json

The Device Profile contains a config of different
deviceResources that can to be sent or received from the Azure
IoT Hub.

### Azure (Required)

The Azure config file can be found at:
[configs/azure-bacnet.json](../config/azure-bacnet.json)

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

* Add the ip address of any BACnet devices, that will be
  communicating with XRT, to the `AllowedConnections` JSON
  array, and add the BACnet boardcast ip address of the
  subnet. For example, when using the subnet 192.168.4.0,
  the broadcast ip would be 192.168.4.255

  ```json
  ...
  "AllowedConnections" : [ <bacnet-device-ip>, "192.168.4.255", "global.azure-devices-provisioning.net", "IOTechHub.azure-devices.net" ],
  ...
  ```

## Building The Application

You can build the BACnet Example following the links below:

* [Building On Windows](windows-build.md)
* [Building On Ubuntu](ubuntu-build.md)

## Deploying and Debugging the Application

You can deploy and debug the BACnet Example following the
links below:

* [Deploy and Debug with Windows](windows-deploy-debug.md)
* [Deploy and Debug with Ubuntu](ubuntu-deploy-deploy.md)

## BACnet Simulator

The BACnet Simulator, simulates a BACnet device, which is
controlled via Lua script. The Lua script for this example
can be found in the [bacnet-simulator](../bacnet-simulator)
directory.

### Connecting To BACnet Over WI-FI

You will need to make sure to mount the bacnet-simulator
directory as a volume to the Docker Container running the
BACnet Simulator Docker Image. Make sure your current
directory set to xrt-examples/AzureSphere. Run the
following command to start the BACnet Simulator and
mount the bacnet-simulator directory:

```bash
docker run -it --rm --name=bacnet-server -e RUN_MODE=IP \
--network host \
-v $(pwd)/bacnet-simulator:/docker-lua-script/ \
iotechsys/bacnet-server:1.8.3 --script /docker-lua-script/example.lua --instance 2749
```

Within the [config/bacnet.json](../config/bacnet.json), make sure
to set `NetworkInterface` option to the WI-FI interface which will
be used in the Driver section of the config file, for example

```json
...
"Driver":{
  "NetworkInterface":"wlan0",
  "APDU_Timeout":"5000",
  "APDU_Retries":"2"
}
...
```

Also, the ip address of the machine running the simluator and
the BACnet broadcast ip should be included in the `AllowedConnections`
JSON array, as part of the app_manifest configuration as described
[here](#App Manifest (Required))

### Connecting To BACnet Over Ethernet

#### Hardware

The following hardware will be required in order to
run the BACnet simulator and connect to it over Ethernet:

* Raspberry Pi
* Ethernet Switch
* USB to Ethernet Adapter

#### Setup

First make sure to ssh in to the Raspberry Pi while its connected
to the local network via Ethernet. Install docker for the
Raspberry Pi with:

```bash
sudo apt-get install docker.io
```

After Docker been installed, pull the BACnet Simulator image with:

```bash
docker pull iotechsys/bacnet-server:1.8.3
```

Make a note of the Raspberry Pi eth0 MAC Address, as it will be
needed later in this section of the example. Use the following
in the command-line to obtain the MAC Address:

```bash
ifconfig | grep eth0 -A 3
```

Shutdown the Raspberry Pi and disconnect it from your local network.

The USB to Ethernet Adapter now needs to be plugged into your
machine via USB. The Raspberry Pi and the Azure Sphere hardware
should be connect to the Ethernet Switch via Ethernet cables. A
Ethernet cable should be connnect from the switch to the
USB to Ethernet Adapter connected to your machine.

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
config file in the following path `/etc/netplan/99-usb-eth-config.yaml`

With the following contents, inserting the interface name with
the <USB To Ethernet Adapter interface name> place mark.

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

From an other command-line terminal, scp over the BACnet Simulator
Lua script found in the bacnet-simulator directory of this
repository:

```bash
scp bacnet-simulator/example.lua pi@192.168.4.12:~/bacnet-simulator
```

Close this terminal and go back to the command-line terminal
that you ssh into the Raspberry Pi and start the BACnet
Simulator with the following:

```bash
docker run --rm --name=bacnet-server -e RUN_MODE=IP -e BACNET_IFACE=eth0 \
--network host -it --privileged -v $(pwd)/bacnet-simulator:/docker-lua-script/ \
iotechsys/bacnet-server:1.8.3 --script /docker-lua-script/example.lua --instance 2749
```

Make sure to add the ip address of the BACnet devices (in this case
the Raspberry Pi) and the BACnet broadcast ip to the app_manifest
configuration file as follows:

```json
...
"AllowedConnections" : [ "192.168.4.12", "192.168.4.2", "192.168.4.255", "global.azure-devices-provisioning.net", "IOTechHub.azure-devices.net" ],
...
```

You'll now be able to connect the BACnet Simulator once XRT has
been deployed.

## Changing A BACnet Device Output Values

The script update.sh can be used to send a payload of data
to Azure IoT hub to invoke a device method on a Device Twin.
The IoT Hub will send the payload to XRT which will be
picked up by the Azure component and push to the BACnet
Device Service via an XRT Bus.

To set the device resource `AnalogOutput0` to 1.0 on the
`bacnet-simulator` device, issue the method (replace
IotHub-Name with the name of your IoT Hub):

```bash
./update.sh <IotHub-Name> bacnet-simulator AnalogOutput0 1.0
```

