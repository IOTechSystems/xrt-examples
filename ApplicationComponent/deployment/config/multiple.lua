CHANGE = 10

function sub_callback(data)

  -- access the values of Random-Device1 and Random-Device2
  local original_value_device1 = data.readings.RandomInt8.value
  local original_value_device2 = data.readings.RandomInt8.value

  if (original_value_device1 ~= nil and original_value_device2 ~= nil) then
    -- update the values
    new_value_device1 = data.readings.RandomInt8.value * CHANGE
    new_value_device2 = data.readings.RandomInt8.value * CHANGE

    -- overwrite the values in the data structure
    data.readings.RandomInt8.value = new_value_device1
    data.readings.RandomInt8.value = new_value_device2
  end

  -- publish the updated data values back to the bus
  publish(pub, data)
end

sub = sub or sub_alloc(iot_bus, sub_callback, "virtual_device_service/data")
pub = pub or pub_alloc(iot_bus, "virtual_device_service/transformed_data")