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

* Sparkplug client docker container is installed:

```bash
docker pull iotechsys/sparkplug-client
```

## Topics

In our `7-mqtt.json` file we have configured a pattern for each topic that XRT will receive it's requests, post its replies, post metric data and post discovered devices on. 
For more about these patterns please see [Sparkplug MQTT Configuration](https://docs.iotechsys.com/edge-connect33/xrt/sparkplug.html#mqtt-configuration).

The Read and Write requests to an XRT device are made through the DCMD topic and responses, which indicate the command's success, are received on the DDATA topic. 
Please see [Sparkplug Specification](https://sparkplug.eclipse.org/specification/version/3.0/documents/sparkplug-specification-3.0.0.pdf) for more information on Sparkplug messages and their payloads.

All other requests are made through the `RequestTopic` and responses received on the `ReplyTopic` indicating success or failure.
Readings will also be included in this reply if a reading request was made.


## Device Management

### Remove the device
Since, with the example, a device has already been added to the device service with a schedule running we will first remove the device to give ourselves a clean slate.

```bash
./commands/remove_device.sh
```

In your other terminal window, you should see the request message that was sent and also response to this message indicating that the device was successfully removed.
You should also see a DDEATH message after successfully removing a device.

### Add a new device
Lets add the device back with a profile field defined. This will match the newly added device to a profile in the `profiles` folder.

```bash
./commands/add_device.sh
```

Again, you should be able to see the 'add request' message and it's reponse indicating that the device was successfully added. 
You should also see a DBIRTH message containing all the metrics of the newly added device.

## Reading 

### DCMD Read Commands

In some device service examples the `get_request.sh` and `get_multi_request.sh` commands are replaced with `read.sh` and `multi_read.sh` commands. 
For these device services, the data is read using DCMDs (protobuf endoced) instead of Request/Reply topics.

The topic for sending DCMD commands is defined in the `7-mqtt.json` file in the config. To specify the device which we are reading from we add its `Device ID` 
to the end of the DCMD topic. The Device ID of each device can be found in `deployment/state/devices.json` in the `"name":` field. 
An example topic would be: "spBv1.0/iotech/DCMD/xrt-dev/virtual-device", where "virtual-device" is the Device ID of the device we are reading data from.

The DCMD message payload for a read message should consist of an array of metrics with each metric having a name or an alias of a device resource and an `is_null` field set 
to "true". Unlike the write DCMD message payload, the `datatype` field is not mandatory in read commands.

* `alias`: The alias of the metric to be read, represented as an integer ID. Its value can be retrieved by looking at the DBIRTH message of the corresponding device.
* `name`: The name of the metric to read, corresponds to the resource name string in the device profile. Can be used instead of the alias.
* `is_null`: Boolean field used to specify that the metric's value is null when set to `true`. By default, when set to 'true', it indicates the intent to read the metric's value.

If the DCMD command was successful, you should see a `DDATA` message with the resource values you requested. 

## Writing

### DCMD Write Commands

In some device service examples the `put_request.sh` and `put_multi_request.sh` commands are replaced with `write.sh` and `multi_write.sh` commands. 
For these device services, the data is written using DCMDs (protobuf endoced) instead of Request/Reply topics.

The topic for sending DCMD commands is defined in the `7-mqtt.json` file in the config. To specify the device which we are writing to we add its `Device ID` 
to the end of the DCMD topic. The Device ID of each device can be found in `deployment/state/devices.json` in the `"name":` field. 
An example topic would be: "spBv1.0/iotech/DCMD/xrt-dev/virtual-device", where "virtual-device" is the Device ID of the device we are writing data to.

The DCMD message payload for a write message should consist of an array of metrics with each metric having a name/alias of a device resource, its new value, 
and the type of the resource's value, specified with a datatype field. 

* `alias`: The alias of the metric to write to, represented as an integer ID. Its value can be retrieved by looking at the DBIRTH message of the corresponding device.
* `name`: The name of the metric to write to, corresponds to the resource name string in the device profile. Can be used instead of the alias.
* `datatype`: The type of the metric's value, represented as an integer. See [Edge Connect User Documentation](https://docs.iotechsys.com/edge-connect33/xrt/sparkplug.html#metric-types) for the full list of datatypes.
The datatypes for each metric are also included in the DBIRTH message.
* `value`: The value being written. Its type has to match the datatype specified.

If the DCMD command was successful, you should see a `DDATA` message sent by the device echoing the metrics you changed.
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
You should then also start to see readings being published on the `DDATA` Topic.

### Delete schedule
Once we have received a few readings we can then remove the schedule:
```bash
./commands/remove_schedule.sh
```

In the request message you should see that we include the name of the schedule that we are wanting to remove. 

The response to this message should indicate that the deletion of the schedule was successful. The readings that were previously being published should now have stopped.

