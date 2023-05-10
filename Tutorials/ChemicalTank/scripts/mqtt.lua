function modbus_sub_callback (data)
  newData = {}
  newData.device = {}
  newData.device = "ChemicalTank"
  newData.readings = data.result.readings
  newData.request_id = data.request_id

  publish (pub, newData)
end

function s7_sub_callback (data)
  if data.result.readings then
    newData = {}
    newData.device = {}
    newData.device = "OutletValve"
    newData.readings = data.result.readings
    newData.request_id = data.request_id

    publish (pub, newData)
  end
end

modbus_sub = modbus_sub or sub_alloc (iot_bus, modbus_sub_callback, "xrt/devices/modbus/reply")
s7_sub = s7_sub or sub_alloc (iot_bus, s7_sub_callback, "xrt/devices/s7/reply")

pub = pub or pub_alloc (iot_bus, "xrt/influxdb/message")
