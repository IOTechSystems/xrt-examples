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

server_id = os.getenv("XRT_SERVER_ID")
modbus_topic = "xrt/" .. server_id .. "/devices/modbus_tcp/reply"
s7_topic = "xrt/" .. server_id .. "/devices/s7/reply"
influx_topic = "xrt/" .. server_id .. "/influxdb/message"


modbus_sub = modbus_sub or sub_alloc (iot_bus, modbus_sub_callback, modbus_topic)
s7_sub = s7_sub or sub_alloc (iot_bus, s7_sub_callback, s7_topic)

pub = pub or pub_alloc (iot_bus, influx_topic)
