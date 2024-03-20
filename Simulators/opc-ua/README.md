# OPC UA Simulator examples

This folder contains a number of examples showcasing some of the functionality that can be implemented in the OPC UA simulator with Lua scripting.

## Examples

[**Simulation**](simulation.lua) 

- Creates a scalar and array variable node for each of the supported datatypes.
- Mimics the simulation nodes found on the popular prosys OPC UA simulator.
- Creates a variable node for each of the supported node types. 

[**Read and Write to Server**](readwrite.lua)

- Creates a Counter, Scale_factor and Output Variable node
- Increments the Counter by 1 every update
- Sets Output to be Counter * ScaleFactor every update
- You can modify ScaleFactor in your OPC UA browser to change the value in output

[**Method Node Example**](methodnodes.lua) 

Creates four different method nodes: One to return the square of an input, one to return the sum of two inputs, one to concatenate two strings and one to add an input to each value of an input array and return the resulting array.

[**Event**](event.lua) 

Creates an event that can be triggered by a Method Node. The method node's method is called every 10 seconds.
