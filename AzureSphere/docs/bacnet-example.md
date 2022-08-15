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

## Prerequisites

Note: The prerequisites found on the main [readme.md](../README.md) are also required for this example.

* BACnet Simulator (Docker)

## Setup Configurations 

To get started with the BACnet example we have to first setup all
the configurations files by following the steps on [setup config files](./setup-config-files.md).

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
[here](./setup-config-files.md/#app-manifest-required).

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
in the following path */etc/dhcp/dhcpd.conf* and copy in the
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
