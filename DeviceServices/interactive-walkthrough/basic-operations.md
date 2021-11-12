# Device Service Basic Operations Interactive Walkthrough

This page provides a walkthrough of a device service example with scripts to allow you to interact with it. 
We encourage you to look at the scripts in the `commands` folder in your device service's example. Feel free to play around and modify them to get a feel of what is going on.

## Prerequisites

* The "Getting Started" section for your respective device service has been followed 
* Your present working directory is your chosen device service's example folder e.g:

```bash
cd ~/xrt-examples/DeviceServices/opc-ua
```

## Device Management

### Remove the device
Since, with the example, a device has already been added to the device service with a schedule running we will first remove the device to give ourselves a clean slate.

```bash
./commands/remove_device.sh
```

### Add a new device
Lets add the device back with a profile field defined. This will match the newly added device to the profile in the `profiles` folder.

```bash
./commands/add_device.sh
```

## Reading 

### Get request
Let's read a single resource from the device profile:

```bash
./commands/get_request.sh
```

### Multi get request
We also can read multiple resources in one operation:

```bash
./commands/get_multi_request.sh
```

## Writing

### Put request
Now let's write some data to our device with a put command:

```bash
./commands/put_request.sh
```

### Multi put request
Similarly to the multi get request, we can also write to multiple resources in one operation.

```bash
./commands/put_multi_request.sh
```

## Schedule Management

Schedules can be set up to automatically perform get or put requests on an defined interval.

### Set up schedule
Let's add our own schedule:
```bash
./commands/add_schedule.sh
```

### Delete schedule
Once we have recieved a few readings we can then remove the schedule:
```bash
./commands/remove_schedule.sh
```
