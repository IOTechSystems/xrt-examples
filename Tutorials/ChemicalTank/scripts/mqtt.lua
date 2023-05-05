function modbus_sub_callback (data)
  newData = {}
  newData.device = {}
  newData.device = "modbus-sim"
  newData.readings = data.result.readings
  newData.request_id = data.request_id

  publish (pub, newData)
end

function s7_sub_callback (data)
  if data.result.readings then
    newData = {}
    newData.device = {}
    newData.device = "S7-Server"
    newData.readings = data.result.readings
    newData.request_id = data.request_id

    publish (pub, newData)
  end
end

sub = sub or sub_alloc (iot_bus, modbus_sub_callback, "xrt/devices/modbus/reply")
sub_2 = sub_2 or sub_alloc (iot_bus, s7_sub_callback, "xrt/devices/s7/reply")

pub = pub or pub_alloc (iot_bus, "xrt/influxdb/message")
