
--function adds one device
function addDevice(dev_number, ns)
    dev_name = "Device" .. dev_number
    readings_name = "Readings" .. dev_number
    vendorid_name = "VendorId" .. dev_number
    vendorid_value = "IoTech device " .. dev_number
    reset_name = "Reset" .. dev_number
    temperature_name = "Temperature" .. dev_number
    humidity_name = "Humidity" .. dev_number

    device = ObjectNode.newRootFolder(dev_name, ns)

    vendorid_node = VariableNode.newString(vendorid_name, ns, device:getNodeId(), vendorid_value, DataType.STRING, AccessLevel.READ)
    vendorid_node:setDescription("VendorId")
    vendorid_node:setDisplayName("VendorId")

    reset_node = VariableNode.newString(reset_name, ns, device:getNodeId(), 1, DataType.UINT32, AccessLevel.WRITE)
    reset_node:setDescription("Reset")
    reset_node:setDisplayName("Reset")

    readings = ObjectNode.newFolder(readings_name, ns, device:getNodeId())
    readings:setDescription("Readings")
    readings:setDisplayName("Readings")

    temperature_node = VariableNode.newString(temperature_name, ns, readings:getNodeId(), 5 * dev_number, DataType.UINT32, AccessLevel.READ)
    temperature_node:setDescription("Temperature")
    temperature_node:setDisplayName("Temperature")

    humidity_node = VariableNode.newString(humidity_name, ns, readings:getNodeId(), 2 * dev_number, DataType.UINT32, AccessLevel.READ)
    humidity_node:setDescription("Humidity")
    humidity_node:setDisplayName("Humidity")

    Server.addObjectNode (device)
    Server.addObjectNode (readings)
    Server.addVariableNode (vendorid_node)
    Server.addVariableNode (reset_node)
    Server.addVariableNode (temperature_node)
    Server.addVariableNode (humidity_node)
end

--create a new namespace
namespace = Server.addNamespace("Multi devices")

NUMBER_OF_DEVICES = 5

for i=1,NUMBER_OF_DEVICES,1 do
    addDevice (i, namespace)
end

