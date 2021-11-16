# Device Service Basic Operations Interactive Walkthrough

This page provides a walkthrough of a device service example with scripts to allow you to interact with it. 
We encourage you to look at the scripts in the `commands` folder in your device service's example. Feel free to play around and modify them to get a feel of what is going on.

## Prerequisites

* The "Getting Started" section for your respective device service has been followed 
* Your present working directory is your chosen device service's commands folder e.g:

```bash
cd ~/xrt-examples/DeviceServices/opc-ua/commands
```

* Mosquitto clients are installed:

```bash
apt-get install mosquitto-clients
```

## Device Management

Device management requests will be made on the `RequestTopic` and the response to the request indicating the success of the operation will be received on the `ReplyTopic`. The names of these topics can be seen and set in the device service configuration file.

### Remove the device
Since, with the example, a device has already been added to the device service with a schedule running we will first remove the device to give ourselves a clean slate.

```bash
./remove_device.sh
```

### Add a new device
Lets add the device back with a profile field defined. This will match the newly added device to a profile in the `profiles` folder.

```bash
./add_device.sh
```

## Reading 

Reading requests will be made on the `RequestTopic`. The response indicating success or failure will be received on the `ReplyTopic`. If the request was successful the readings and other relevant infomation will be included.

### Get request
Let's read a single resource from the device profile:

```bash
./get_request.sh
```
This will perfom a reading on one of the resources defined in the newly added device's profile. 

### Multi get request
We also can read multiple resources in one operation:

```bash
./get_multi_request.sh
```

## Writing

Writing requests will be made on the `RequestTopic` and a response indicating the success of the put request will be received on the `ReplyTopic`.

### Put request
Now let's write some data to our device with a put command:

```bash
./put_request.sh
```

### Multi put request
Similarly to the multi get request, we can also write to multiple resources in one operation.

```bash
./put_multi_request.sh
```

## Schedule Management

Schedules can be set up to automatically perform get or put requests on an defined interval.

Schedule requests will be made on the `ScheduleRequestTopic` and the response indicating the success of the request will be received on the `ScheduleReplyTopic`. Furthermore, the data from the schedule is recieved on the topic `Topic`. The names of these topics can be seen and set in the device service configuration file.

### Set up schedule
Let's add our own schedule:
```bash
./add_schedule.sh
```

### Delete schedule
Once we have recieved a few readings we can then remove the schedule:
```bash
./remove_schedule.sh
```
