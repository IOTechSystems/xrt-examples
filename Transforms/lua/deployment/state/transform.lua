local ARRAY_METRIC_SPECS = {
  list = { size = 1, fmt = "<i1", type = xrt_int8 },
  vector = { size = 2, fmt = "<i2", type = xrt_int16 },
  array = { size = 4, fmt = "<i4", type = xrt_int32 },
}

local function binary_to_vector(bytes, spec)
  local v = xrt_vector()
  for i = 1, (#bytes / spec.size) do
    v[i] = spec.type((string.unpack(spec.fmt, bytes, (i - 1) * spec.size + 1)))
  end
  return v
end

local function fix_array_metrics(data)
  if data.metrics then
    for _, metric in ipairs(data.metrics) do
      local spec = metric.name and ARRAY_METRIC_SPECS[metric.name]
      if spec and metric.value and metric.value.value then
        metric.value = binary_to_vector(metric.value.value, spec)
      end
    end
  end
end

local function read_request(resources)
  if not schedule_active then
    return
  end

  print("read_request")

  local payload = xrt_map()
  payload.timestamp = xrt_uint64(iot_time_msecs())
  payload.metrics = xrt_list()

  for i, resource in ipairs(resources) do
    local metric = xrt_map()
    metric.name = resource
    metric.is_null = true
    payload.metrics[i] = metric
  end

  xrt_bus_publish(echopub, payload)
  xrt_bus_publish(dcmdpub, payload)
end

local function set_schedule(data)
  print("set_schedule")

  if data.schedule_status then
    local response = "Invalid schedule status"
    if data.schedule_status == "active" then
      response = (schedule_active and "Schedule already active") or "Activated schedule"
      schedule_active = true
    elseif data.schedule_status == "inactive" then
      response = (schedule_active and "Deactivated schedule") or "Schedule already inactive"
      schedule_active = false
    end

    local reply = xrt_map()
    reply.response = response
    return reply
  end
end

function handle_request(data, topic)
  print("handle_request", topic)

  if topic == "spBv1.0/iotech/DCMD/lua" then
    fix_array_metrics(data)
    xrt_bus_publish(dcmdpub, data)
  elseif topic == "spBv1.0/iotech/DACK/xrt-dev/Lua-Device" then
    xrt_bus_publish(echopub, data)
    xrt_bus_publish(dackpub, data)
  elseif topic == "spBv1.0/iotech/DDATA/xrt-dev/Lua-Device" then
    xrt_bus_publish(echopub, data)
    xrt_bus_publish(ddatapub, data)
  elseif topic == "spBv1.0/iotech/REQUEST/lua" then
    reply = set_schedule(data)
    xrt_bus_publish(replypub, reply)
  end
end

function add_metric(data)
  print("add_metric")
  local metrics = data.metrics
--   if metrics and not (metrics[#metrics] and metrics[#metrics].value == "Extra special metric") then
  if metrics then
    local len = #metrics
    local metric = xrt_map()
    metric.alias = xrt_uint64(99)
    metric.value = "Extra special metric"
    metric.timestamp = xrt_uint64(111)
    metric.datatype = xrt_uint32(SPARKPLUG_STRING)
    metrics[len + 1] = metric
    print(metrics)
    return data, true
  end
  return data, false
end

echopub = xrt_bus_pub_alloc(xrt_bus, "lua/echo")
dcmdpub = xrt_bus_pub_alloc(xrt_bus, "spBv1.0/iotech/DCMD/xrt-dev/Lua-Device")
dackpub = xrt_bus_pub_alloc(xrt_bus, "spBv1.0/iotech/DACK/lua")
ddatapub = xrt_bus_pub_alloc(xrt_bus, "spBv1.0/iotech/DDATA/lua")
replypub = xrt_bus_pub_alloc(xrt_bus, "spBv1.0/iotech/REPLY/lua")

sub = xrt_bus_sub_alloc(xrt_bus, handle_request, "spBv1.0/iotech/#")

resources = xrt_list()
resources[1] = "uint8"
resources[2] = "int64"
resources[3] = "bool"
resources[4] = "array"

-- xrt_schedule_alloc (scheduler, callback, arg, period, delay, repeat)
schedule = xrt_schedule_alloc(xrt_scheduler, read_request, resources, 1000)
schedule_active = false

xrt_bus_topic_transform(xrt_bus, add_metric, "spBv1.0/iotech/DDATA/lua")

print("Loaded Lua Script")