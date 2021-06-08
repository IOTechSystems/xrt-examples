# Simple XRT Component Example

This example uses the Virtual Device Service to generate some data with the help of two devices created from the same profile. The data is published under "virtual_device_service/data" topic to the bus.
A Lua component is attached which subscribes to both data streams and transforms the data (multiplies each data value by 10) before re-publishing the new values under the topic "device/transformed_data". There is also a C component attached which subscribes to the topic "device/transformed_data" and then adds the two data values together before re-publishing the final result back to the bus under "device/result" topic. Lastly, an MQTT exporter component - which subscribes to the final result published on the bus by the C component - re-publishes it to a Mosquito topic so that the data can be accessed by any client subscribed to the MQTT topic "device/result".

Below an illustration of the scenario described above:
![Simple XRT Component Example illustration](Simple_XRT_Component_Example.jpg)