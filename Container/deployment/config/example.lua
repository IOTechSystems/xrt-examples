local local_data = {}

function mod_uptime (uptime)
  base = base or uptime
  return (uptime - base) * 0.5 .. " seconds"
end

function sub_callback (data)
  data.readings.Uptime.value = mod_uptime (data.readings.Uptime.value)
  data.readings.Uptime.type = "string"
  publish (pub, data)
end

function sch_callback (data_cb)
  print ("In sch_callback:", data_cb, local_data)
end

sub = sub or sub_alloc (iot_bus, sub_callback, "device/data")
pub = pub or pub_alloc (iot_bus, "device/processed")

-- lua_engine, schedule_callback, argument, period, delay, repeat
sch = sch or schedule_create (xrt_lua, sch_callback, local_data, 5, 1, 6)
