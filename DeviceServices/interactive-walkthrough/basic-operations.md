# Device Service Basic Operations Interactive Walkthrough

This page provides a walkthrough of a device service example with scripts to allow you to interact with it. 
We encourage you to look at the scripts in the `commands` folder in your device service's example. Feel free to play around and modify them to get a feel of what is going on.

## Prerequisites

* The "Getting Started" section for your respective device service has been followed 
* Your present working directory is your chosen device service example folder e.g:

```bash
cd ~/xrt-examples/DeviceServices/opc-ua
```

* Mosquitto clients are installed:

```bash
apt-get install mosquitto-clients
```

## Topics

In our `device_service.json` file we have configured each topic that XRT will receive it's requests, post its replies, post telemetry data and post discovered devices on. 
For more about these topics please see [XRT Device service Topics](https://www.link.to.documentation.about.topics).   

All requests to an XRT Device Service are made through the `RequestTopic` and responses received on the `ReplyTopic` indicating success or failure.
Readings will also be included in this reply if a reading request was made.


## Device Management

### Remove the device
Since, with the example, a device has already been added to the device service with a schedule running we will first remove the device to give ourselves a clean slate.

```bash
./commands/remove_device.sh
```

In your other terminal window, you should see the request message that was sent and also response to this message indicating that the device was successfully removed. 

### Add a new device
Lets add the device back with a profile field defined. This will match the newly added device to a profile in the `profiles` folder.

```bash
./commands/add_device.sh
```

Again, you should be able to see the 'add request' message and it's reponse indicating that the device was successfully added. 

## Reading 

### Get request
Let's read a single resource from the device profile:

```bash
./commands/get_request.sh
```
This will perform a reading on one of the resources defined in the newly added device's profile. In the request message you should see the name of 
the device that the request is being performed on and the name of the resource that being requested. 

In the reply you should be able to see the value of this resource along with other information about the get request that was performed. 

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

In the request message you should be able to see the name of the device that the request is being performed on, 
and the name of the resource that we are writing to, along with the value we are writing. 

In the reply you should be able to see a message indicating that the put request was successful. 

### Multi put request
Similarly to the multi get request, we can also write to multiple resources in one operation.

```bash
./commands/put_multi_request.sh
```

## Schedule Management

Schedules can be set up to automatically perform get or put operations on a defined interval.

### Set up schedule
Let's add our own schedule:
```bash
./commands/add_schedule.sh
```

In the request message you should see information about the schedule we are wanting to add, such as the name of the schedule, the name of the device, 
the resource, and the interval we are wanting to read this resource at. 

The reply should indicate if the schedule add request was successful or not. 
You should then also start to see readings being published in a similar format to a get request reply but on the `TelemetryTopic`.

### Delete schedule
Once we have received a few readings we can then remove the schedule:
```bash
./commands/remove_schedule.sh
```

In the request message you should see that we include the name of the schedule that we are wanting to remove. 

The response to this message should indicate that the deletion of the schedule was successful. The readings that were previously being published should now have stopped.
