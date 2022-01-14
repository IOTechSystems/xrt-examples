# Device SDK

This example illustrates use of the device SDK (`devsdk`) to build an XRT
component which connects a device. For simplicity this will be a virtual
device, so no additional hardware is required to use it.

## Requirements

In order to build the component, the XRT developer package must be installed
on the system.

## Setup

An `envs.sh` file is provided for setting up environment variables. This sets
the locations of XRT and the IOT utils to their default installations, ie
`/opt/iotech/xrt` and `/opt/iotech/iot` respectively. If you have a custom
installation with the packages held elsewhere, you'll need to edit this file.

## Build

Open a terminal window in the directory containing the example. Run

`. ./envs.sh`

to set up the environment, then

`make`

to build the example component.

## Run

A configuration is provided which sets up one device with three accessible
values. Run

`xrt deployment/config`

to start the XRT instance with the example component. The logs should indicate
a value being published every two seconds.

## Writing a Device Service

The example described here is a cut-down version of the virtual device service
provided in XRT. It supports simple sequence generators (random number sequences
and arithmetic sequences) and also values which may be written to and
subsequently retrieved. The values available and their characteristics are
defined in device profiles.

A large amount of functionality common to device services is provided by the
Device SDK. The implementation-specific parts are supplied as a set of callback
functions. These functions are supplied to the SDK via the `devsdk_callbacks`
structure. Not all of these need be implemented by every device service; the
required functions are described here.

### Init

The init function (`example_init` in the example) is where any data structures
required by the device service can be set up. It is also where the service is
given its logger and its configuration, if there is any.

In our example we seed the random number generator, initialize a mutex and
allocate the map structure in which we will maintain the current state of each
value.

The configuration passed to the init function is a string-keyed map
representing the contents of the `Driver` section of the component's
configuration file. In the example the seed for the RNG is configurable
in order to support repeatability.

We store our state in the `example_driver` structure which is defined at the
top of the source file. An instance of this is allocated when the device
service component starts, and is passed as the first (`impldata`) parameter to
each of the callback functions.

The init function may return `false` to indicate failure; the example has no
failure conditions here so always returns `true`.

### Stop

This is essentially the reverse of `init`. The device service should free any
resources being held and close any open connections. The `force` parameter to
this function is currently undefined and may be ignored.

In the example (`example_stop`) we free the mutex and our value map.

### Get and Put

These represent the main functionality of the service, reading and writing from
devices.

In each case the following parameters are given:

#### `devname`

This is the name of the device being accessed. Normally this should only be
useful for logging purposes, but in the example we use it to distinguish one
device from another.

#### `protocols`

This is what should usually be used to address a device. It represents the
`protocols` structure in the JSON which defines the device in the service
configuration.

A device service should define one or more named protocols which are to be used
to address the supported devices. Examples of protocols could be:

`"MAC": { "Address": "42:e6:e5:ba:13:3f" }`

or

`"URL": { "Protocol": "http", "Host": "example.com", "Port": 80, "Path": "/d1" }`

#### `nreadings / nvalues`

The number of read or write operations being requested.

#### `requests`

An array, each `request` represents an individual value ("resource") on the
device which is to be read or written. 

The request structure contains the following:

* `resname`: The name of the resource, for logging purposes. The example uses this to distinguish one resource from another.
* `attributes`: Name-value pairs which identify the resource within the device (defined in the device profile).
* `type`: The expected datatype (for readings).
* `mask`: A (bitwise) mask to be applied for writes.

Support for `mask` operations is optional. If implemented, then if `mask` is
nonzero the handler should lock the resource against concurrent writes, read
the current value and apply the following calculation:

`new-value = (current-value & mask) | request-value`

In the example, the `example_get_handler` and `example_put_handler` functions
inspect the supplied attributes and look for the `sequenceType` specifier. If
this is not present, the value is one which may simply be stored and retrieved.
Otherwise the two sequence types `random` and `arithmetic` are supported.

#### `readings / values`

For the get handler, the results of the read operations should be placed in
`readings`. For the put handler, the values to be written are given in `values`.

The `devsdk_commandresult` structure allows for a timestamp to be returned with
the reading. This is optional and should only be set if the supported devices
supply such information with their readings. Time should be represented as
nanoseconds from the UNIX epoch.

#### `qparams` (get handler only)

Not yet defined in XRT.

#### `exception`

If the service is unable to perform the requested operation, the handler
function should allocate an `IOT_DATA_STRING` containing an appropriate error
message in `*exception`, and return `false`.


### Putting it together

The callback functions are collected in a `devsdk_callbacks` structure for
passing them to the SDK.

Device services, like any other component in XRT, need to provide a factory
function for instantiation. Here it is `xrt_example_device_service_factory`.
Note that the factory structure defined uses `xrt_device_free` - this is a
function in the SDK which frees the SDK's structures and calls through to the
device service's `Stop` function.

The configure function specified in the factory structure
(`xrt_example_device_service_config`) starts the service via the SDK, by
allocating the `example_driver` structure and passing it, along with the
callbacks structure, to the SDK.
