# Device Service Discovery Interactive Walkthrough

This page provides a walkthrough of a device service's device discovery features. In this example, we will use the device service to discover devices. Using this discovery information, we will add a discovered device to the service which the device service will automatically generate a new profile for.

## Prerequisites

* The "Getting Started" section for your respective device service has been followed 
* Your present working directory is your chosen device service's commands folder e.g:

```bash
cd ~/xrt-examples/DeviceServices/opc-ua/commands
```

## Setup

Let's start with a clean slate: first remove the existing device from xrt:

```bash
./remove_device.sh
```

## Trigger Discovery

Discovery requests will be made on the `DiscoveryRequestTopic`, a reply if the request is successful or not will be received on the `DiscoveryReplyTopic`, and a list of discovered devices will be received on the `DiscoveryTopic`. These values can be seen and set in the device service configuration file.

We can trigger discovery to recieve information about available devices.
```bash
./trigger_discovery.sh
```

On the xrt reply topic we have subscribed to, we should see information and protocol properties about devices that have been discovered.

## Adding a discovered device

We can use the information received above to create a new add device request.

```bash
./add_discovered_device.sh
```
If you inspect this script, you will see that the protocol information matches one of the discovered devices that we received from our discovery request. Notice that we have omitted the device profile from this add device request. This is because the device service will query the device for it's resources; if there is a profile that matches then xrt will use this existing profile, if there is no matching profile a new one will be generated.  

Since there is already a profile that matches in this case, xrt will use this. We can perform a get request to verify that the device has matched correctly:

```bash
./get_request.sh
```

**Extra**

To generate a profile for the device instead of using the exsiting one, we can follow the above steps but additionally delete the existing profile: 

```bash
./remove_device.sh
```

```bash
./remove_device_profile.sh
```

Then add our device:

```bash
./add_discovered_device.sh
```

If you take a look in `profiles` you should notice that there is a new `json` file named with an uuid. This file is the newly generated profile.

## Additional information

If the device service config option `AutoRegister` was set to `true`, any device discovered will automatically have a profile matched/generated for them and will be automatically added to the device service.
