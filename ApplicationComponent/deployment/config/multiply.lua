CHANGE = 10
SUB_TOPIC = "xrt/devices/virtual/telemetry"
PUB_TOPIC = "xrt/lua/transformed_data"

local device1_reading
local device2_reading

function sub_callback(data)
    -- This sub callback is called everytime something is published to the topic specified in SUB_TOPIC

    -- The data object allows access to the fields of the json object published to the bus
    local device_name = data.device
    local device_reading = data.readings.StoreInt32Value.value

    -- The below code is not used to generate the transformed_data, but illustrate how data can be stored between lua runs
    if device_name == "Random-Device1" then
        device1_reading = device_reading
    elseif device_name == "Random-Device2" then
        device2_reading = device_reading
    end

    -- New fields can be added to the data object to control what is published to the topic specified in PUB_TOPIC
    data.lua = {}
    data.lua.transformed_data = device_reading * CHANGE

    -- publish the updated data values back to the bus
    publish(pub, data)
end

sub = sub or sub_alloc(iot_bus, sub_callback, SUB_TOPIC)
pub = pub or pub_alloc(iot_bus, PUB_TOPIC)
