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

  local status = data.schedule_status
  local response
  if status == "active" then
    response = (schedule_active and "Schedule already active") or "Activated schedule"
    schedule_active = true
  elseif status == "inactive" then
    response = (schedule_active and "Deactivated schedule") or "Schedule already inactive"
    schedule_active = false
  end

  local reply = xrt_map()
  reply.response = (status and response) or "Invalid schedule status"
  return reply
end

local function set_transform(data)
  print("set_transform")

  local transform = data.transform
  local status = data.status
  local response

  if transform == "dcmd_transform" then
    if status == "active" then
      response = (apply_dcmd_transform and "Transform already active") or "Activated transform"
      apply_dcmd_transform = true
    elseif transform == "inactive" then
      response = (apply_dcmd_transform and "Deactivated transform") or "Transform already inactive"
      apply_dcmd_transform = false

  elseif transform == "ddata_transform" then
    if status == "active" then
        response = (apply_ddata_transform and "Transform already active") or "Activated transform"
        apply_ddata_transform = true
    elseif transform == "inactive" then
      response = (apply_ddata_transform and "Deactivated transform") or "Transform already inactive"
      apply_ddata_transform = false

   reply = xrt_map()
   reply.response = (transform and status and response) or "Invalid transform request"
   return reply


local function add_cmd_id(data)
  local metrics = data.metrics
  local metric = xrt_map()
  metric.name = "Device Control/CommandId"
  metric.value = "7cdbce61-941b-4a92-99ff-6ad976b87ad2"
  metrics[#metrics + 1] = metric
  return metric, true
end

function dcmd_transform(data)
  print("dcmd_transform")
  if not apply_dcmd_transform then return data, false end
  fix_array_metrics(data)
  add_cmd_id(data)
  return data, true
end


function handle_request(data, topic)
  print("handle_request", topic)

  if topic == "spBv1.0/iotech/DCMD/lua" then
    xrt_bus_publish(dcmdpub, data)
  elseif topic == "spBv1.0/iotech/DACK/xrt-dev/Lua-Device" then
    xrt_bus_publish(echopub, data)
    xrt_bus_publish(dackpub, data)
  elseif topic == "spBv1.0/iotech/DDATA/xrt-dev/Lua-Device" then
    xrt_bus_publish(echopub, data)
    xrt_bus_publish(ddatapub, data)
  elseif topic == "spBv1.0/iotech/REQUEST/lua" then
    reply = ddata.schedule_status and set_schedule(data) or set_transform(data)
    xrt_bus_publish(replypub, reply)
  end
end

function remove_msg(data)
  print("remove_msg")
  return nil, true
end

function ddata_transform(data)
  print("ddata_transform")
  if not apply_ddata_transform then return data, false end

  local metrics = data.metrics
  if metrics and not (metrics[#metrics] and metrics[#metrics].value == "Extra special metric") then
--   if metrics then
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

echopub = echopub or xrt_bus_pub_alloc(xrt_bus, "lua/echo")
dcmdpub = dcmdpub or xrt_bus_pub_alloc(xrt_bus, "spBv1.0/iotech/DCMD/xrt-dev/Lua-Device")
dackpub = dackpub or xrt_bus_pub_alloc(xrt_bus, "spBv1.0/iotech/DACK/lua")
ddatapub = ddatapub or xrt_bus_pub_alloc(xrt_bus, "spBv1.0/iotech/DDATA/lua")
replypub = replypub or xrt_bus_pub_alloc(xrt_bus, "spBv1.0/iotech/REPLY/lua")

sub = sub or xrt_bus_sub_alloc(xrt_bus, handle_request, "spBv1.0/iotech/#")

resources = resources or xrt_list()
resources[1] = "uint8"
resources[2] = "int64"
resources[3] = "bool"
resources[4] = "array"

-- xrt_schedule_alloc (scheduler, callback, arg, period, delay, repeat)
schedule = schedule or xrt_schedule_alloc(xrt_scheduler, read_request, resources, 1000)
schedule_active = false

dcmd_xform = dcmd_xform or xrt_bus_topic_transform(xrt_bus, dcmd_transform, "spBv1.0/iotech/DCMD/xrt-dev/Lua-Device")
ddata_xform = ddata_xform or xrt_bus_topic_transform(xrt_bus, ddata_transform, "spBv1.0/iotech/DDATA/lua")
-- Enable to filter out all messages on DACK topic
-- dack_xform = dack_xform or xrt_bus_topic_transform(xrt_bus, remove_msg, "spBv1.0/iotech/DACK/lua")

apply_dcmd_transform = true
apply_ddata_transform = true


print("Loaded Lua Script")