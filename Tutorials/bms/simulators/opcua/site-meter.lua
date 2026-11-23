-- Simulates the grid connection meter of the battery energy storage site:
--   ns=2;s=GridFrequency  grid frequency (Hz), around 50 Hz
--   ns=2;s=GridVoltage    grid line-to-line voltage (V), around 400 V
--   ns=2;s=SitePower      active power at the grid connection (kW), positive when exporting

math.randomseed(os.time())
local lastUpdate = os.time()
local t = 0

local ns = Server.addNamespace("SiteMeter")
local folder = ObjectNode.newRootFolder("SiteMeter", ns)
Server.addObjectNode(folder)

local function addVariable(name, value)
  local variant = Variant.new(DataType.DOUBLE)
  variant:setScalar(value)
  local node = VariableNode.new(NodeId.newString(name, ns), name, folder:getNodeId(), variant, AccessLevel.READ)
  Server.addVariableNode(node)
  return { node = node, variant = variant }
end

local frequency = addVariable("GridFrequency", 50.0)
local voltage = addVariable("GridVoltage", 400.0)
local power = addVariable("SitePower", 0.0)

local function set(variable, value, places)
  variable.variant:setScalar(tonumber(string.format("%." .. places .. "f", value)))
  variable.node:setValue(variable.variant)
end

-- Called repeatedly by the simulator; values change once a second
function Update()
  if os.time() - lastUpdate < 1 then
    return
  end
  lastUpdate = os.time()
  t = t + 1

  set(frequency, 50.0 + 0.05 * math.sin(t / 20) + (math.random() - 0.5) * 0.01, 3)
  set(voltage, 400.0 + 4 * math.sin(t / 45) + (math.random() - 0.5) * 1.0, 1)
  set(power, 150 * math.sin(t / 120) + (math.random() - 0.5) * 5, 1)
end
