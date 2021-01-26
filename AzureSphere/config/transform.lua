-- This script subscribes to the "device/output" topic to receive scheduled
-- readings from the Modbus device service and when readings change republishes
-- the readings to the "transform/lua/filtered-output" topic.
-- The Azure Sphere export component is configured to export events
-- published on the "transform/lua/filtered-output" topic.

-- deepcompare MIT/X11 License
-- https://web.archive.org/web/20131225070434/http://snippets.luacode.org/snippets/Deep_Comparison_of_Two_Values_3

function deepcompare(t1,t2,ignore_mt)
  local ty1 = type(t1)
  local ty2 = type(t2)
  if ty1 ~= ty2 then return false end
  -- non-table types can be directly compared
  if ty1 ~= 'table' and ty2 ~= 'table' then return t1 == t2 end
  -- as well as tables which have the metamethod __eq
  local mt = getmetatable(t1)
  if not ignore_mt and mt and mt.__eq then return t1 == t2 end
  for k1,v1 in pairs(t1) do
    local v2 = t2[k1]
    if v2 == nil or not deepcompare(v1,v2) then return false end
  end
  for k2,v2 in pairs(t2) do
    local v1 = t1[k2]
    if v1 == nil or not deepcompare(v1,v2) then return false end
  end
  return true
end

function sub_callback (input)
  local old_readings = readings
  readings = input.readings

  -- Republish readings that have changed
  if (not deepcompare(readings, old_readings)) then
    publish (pub, input)
  end
end

-- Empty table for initial state. First readings will not match and therefore
-- will be published.
readings = {}

-- If sub exists delete before recreating. Supports reloading Lua code.
if (sub) then
  sub_free (sub)
end
sub = sub_alloc (iot_bus, sub_callback, "device/output")

-- Allocate publisher if it does not exist.
pub = pub or pub_alloc (iot_bus, "transform/lua/filtered-output")
