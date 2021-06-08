function sub_callback(data)

  local device1_data_to_pub = 0
  local device1_data_to_pub_array = {}

  -- 1/ access the value of Random-Device1
  device1_value = data.readings.RandomInt8.value
  print(device1_value)

  -- 2/ update the value of Random-Device1
--  device1_data_to_pub.values.RandomInt8 = device1_value * 10
  
  device1_data_to_pub = device1_value * 10
--  device1_data_to_pub_array.values.RandomInt8 = device1_data_to_pub
--  print(device1_data_to_pub_array)
  
  -- 3/ publish the updated value of Random-Device1
  -- FIXME publish does not seem to work this way
  publish(pub, device1_data_to_pub)

end

sub = sub or sub_alloc(iot_bus, sub_callback, "virtual_device_service/data")
pub = pub or pub_alloc(iot_bus, "device/transformed_data")