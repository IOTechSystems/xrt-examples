-- Simulates one office zone:
--   Analog Input 0  zone-temperature  (°C, moves towards the setpoint while the fan is on)
--   Analog Value 0  zone-setpoint     (°C, writable)
--   Binary Input 0  zone-occupancy    (0 = unoccupied, 1 = occupied)
--   Binary Output 0 fan-command       (0 = off, 1 = on, writable)

local priority = 16
local lastUpdate = os.time()

function Run()
  bacnet.createAnalogInputs(1)
  bacnet.createAnalogValues(1)
  bacnet.createBinaryInputs(1)
  bacnet.createBinaryOutputs(1)

  bacnet.setAnalogInputName(0, "zone-temperature")
  bacnet.setAnalogValueName(0, "zone-setpoint")
  bacnet.setBinaryInputName(0, "zone-occupancy")
  bacnet.setBinaryOutputName(0, "fan-command")

  bacnet.setAnalogInputPresentValue(0, 24.0)
  bacnet.setAnalogValuePresentValue(0, 21.0, priority)
  bacnet.setBinaryInputPresentValue(0, 1)
  bacnet.setBinaryOutputPresentValue(0, 1, priority)
end

function Update()
  if os.time() - lastUpdate < 5 then
    return
  end
  lastUpdate = os.time()

  local temperature = bacnet.getAnalogInputPresentValue(0)
  local setpoint = bacnet.getAnalogValuePresentValue(0)
  local fanOn = bacnet.getBinaryOutputPresentValue(0) == 1

  if fanOn then
    -- Close 20% of the gap to the setpoint every update
    temperature = temperature + (setpoint - temperature) * 0.2
  else
    -- Without the fan the zone slowly warms up
    temperature = temperature + 0.1
  end
  bacnet.setAnalogInputPresentValue(0, temperature + (math.random() - 0.5) * 0.1)

  -- Occupancy changes now and then
  if math.random() < 0.1 then
    bacnet.setBinaryInputPresentValue(0, 1 - bacnet.getBinaryInputPresentValue(0))
  end
end
