# OPC-UA Simulator examples

This folder contains a number of examples showcasing some of the functionality that can be implemented in the OPC-UA simulator with Lua scripting.

## Examples

[**Data types**](datatypes.lua) 

Creates a variable node for each of the supported datatypes.

[**Prosys**](prosys.lua) 

Mimics the default nodes found on the popular prosys OPC-UA simulator. Device profiles for the Prosys simulator should be re-usable when this script is running.

[**Multi Device**](multi-devices.lua) 

Nodes are added to the server to mimic the addition of 5 instances of the same device, which share the same profile.

[**Node Types**](nodetypes.lua) 

Creates a variable node for each of the supported node types. 

[**Method Node Example**](methodnodes.lua) 

Creates four different method nodes: One to return the square of an input, one to return the sum of two inputs, one to concatenate two strings and one to add an input to each value of an input array and return the resulting array.

[**Event**](event.lua) 

Creates an event that can be triggered by a Method Node. The method node's method is called every 10 seconds.
