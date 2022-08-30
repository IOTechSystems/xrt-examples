# EtherNet/IP Device

In this EtherNet/IP example, XRT connects to a Allen Bradley PLC
that is assumed to have preprogrammed tags. Values are read from
the PLC and pushed to Azure IoT Hub.

An example of connecting to the Allen Bradley PLC using wired
Ethernet is given in this guide.

## Prerequisites

*Note: The prerequisites found on the main [readme.md](../../README.md)
are required for this example

- Allen Bradley PLC or other EthernetIP device

## Setup Configurations 

To get started with the Ethernet/IP example we have to first setup all
the configurations files by following the steps on [setup config files](./setup-config-files.md).

### Ethernet/IP Azure Driver Options

The Azure version of the Ethernet/IP device service has some extra
driver options that need to be configured before deploying and
running on the Azure Sphere device:

``` json
"Driver": {
        "NetworkInterface": "eth0",
        "MacAddress": "c2:25:80:93:36:98",
        "FullDuplex": true,
        "NetworkSpeed": 1000
    },
```

- **NetworkInterface** - the wired network interface on the Azure
Sphere device - can be found using

``` console
azsphere device network list-interfaces
```

- **MacAddress** - the mac address of the chosen network interface on the azure device - can be found using

``` console
azsphere device network list-interfaces
```

- **FullDuplex** - state if the device is full-duplex or not - this can usually be found from the webpage of the PLC or other device that is connected to the same network - see image below.
- **NetworkSpeed** - the network speed of which the device is connected to - can be found from the http webpage of the PLC or other device that is connected to the same network - see image below.

![Logix](images/Logix.png)

