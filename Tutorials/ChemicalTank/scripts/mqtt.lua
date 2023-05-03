function sub_callback (data)
  data.device = {}
  data.device = "modbus-sim"
  publish (pub, data)
end

sub_modbus = sub_modbus or sub_alloc (iot_bus, sub_callback, "xrt/devices/modbus/reply")

pub = pub or pub_alloc (iot_bus, "xrt/lua/transformed_data")
