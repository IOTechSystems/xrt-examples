# Device Service Discovery Interactive Walkthrough

This page provides a walkthrough of a device service's device discovery features. In this example, we will use the device service to discover devices. Using this discovery information, we will add a discovered device to the service which the device service will automatically generate a new profile for.

## Prerequisites

* The "Getting Started" section for your respective device service has been followed 
* Your present working directory is your chosen device service example folder e.g:

```bash
cd ~/xrt-examples/DeviceServices/opc-ua
```

## Setup

Let's start with a clean slate: first remove the existing device from xrt:

```bash
./commands/remove_device.sh
```

## Trigger Discovery

Discovery requests will be made on the `RequestTopic`, a reply to the request will be received on the `ReplyTopic`, and the discovered devices will be received on the `DiscoveryTopic`.

We can trigger discovery to receive information about available devices.

```bash
./commands/trigger_discovery.sh
```

On your MQTT message subscription, you will be able to see the discovery request, a message indicating the success of the request, and then subsequently a list of devices, and their properties, that the device service has discovered.

## Adding a discovered device

We can use the information received above to create a new add device request.

```bash
./commands/add_discovered_device.sh
```

If you inspect this script, you will see that the protocol information matches one of the discovered devices that we received from our discovery request. Notice that we have omitted the device profile from this add device request. This is because we can scan the device for resources and automatically generate profiles from them.

We can trigger a device scan for the discovered device we have just added.

```bash
./commands/scan_discovered_device.sh
```

The device service will query the device for it's resources; if there is a profile that matches then xrt will use this existing profile, if there is no matching profile a new one will be generated.  

In this case there is already a profile that matches, so XRT will use this. We can perform a get request to show that the device has matched to this profile:

```bash
./commands/get_request.sh
```

**Extra**

To generate a profile for the device instead of using the existing one, we can follow the above steps but additionally delete the existing profile:

```bash
./commands/remove_device.sh
```

```bash
./commands/remove_device_profile.sh
```

We trigger discover again to find our device:

```bash
./commands/trigger_discovery.sh
```

Then add our discovered device:

```bash
./commands/add_discovered_device.sh
```

and scan the device for new resources:

```bash
./commands/scan_discovered_device.sh
```

If you take a look in `profiles` you should notice that there is a new `json` file named with a UUID. This file is the newly generated profile.

## Additional information

If the device service config option `AutoRegister` was set to `true`, any device discovered will automatically have a profile matched/generated for them and will be automatically added to the device service.
