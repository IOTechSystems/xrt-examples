# BACnet Simulator examples

This folder contains examples showcasing some of the functionality that can be implemented in the BACnet simulator with Lua scripting.

## Examples

[**Device Service Example Script**](device-service-example.lua) 

Used within the BACnet IP and MSTP device service examples, see [Device Service Examples](https://github.com/IOTechSystems/xrt-examples/tree/v1.2-branch/DeviceServices).

Will run the simulator with 2 instances of the objects Analog Input, Analog Output and Analog Value.

The present value properties of Analog Input and Analog Value objects will update every 5 seconds with a random value
between 1 and 500.

[**Tutorial Script**](tutorial.lua) 

Used as a worked example script in the simulator lua scripting tutorial documentation, see [BACnet Simulator Lua Scripting Tutorial](https://www.link.to.bacnet-lua-scripting-tutorial.docs).

One instance of the Analog Input, Analog Output and Analog Value objects are created with their object names set.

Every second a value will be incremented by 1, setting the present value of instance 0 of the Analog Value object. Once the value reaches 15 it will wrap
around to 1 again. As lua does not provide a standard sleep function, one must be included.

Everytime the present value of Analog Output instance 0 is changed by a client, this change will be mirrored in the present value of Analog Input instance 0.