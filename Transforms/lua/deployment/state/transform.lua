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
  end
end

echopub = xrt_bus_pub_alloc(xrt_bus, "lua/echo")
dcmdpub = xrt_bus_pub_alloc(xrt_bus, "spBv1.0/iotech/DCMD/xrt-dev/Lua-Device")
dackpub = xrt_bus_pub_alloc(xrt_bus, "spBv1.0/iotech/DACK/lua")
ddatapub = xrt_bus_pub_alloc(xrt_bus, "spBv1.0/iotech/DDATA/lua")

sub = xrt_bus_sub_alloc(xrt_bus, handle_request, "spBv1.0/iotech/#")

print("Loaded Lua Script")