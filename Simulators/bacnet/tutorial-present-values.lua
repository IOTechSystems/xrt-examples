
local increment = 0
local priority = 1
local mod = 15

function sleep(time)
    local duration = os.time() + time
    while os.time() < duration do end
end

function Run()
  bacnet.createAnalogInputs(1)
  bacnet.createAnalogValues(1)
  bacnet.createAnalogOutputs(1)

  bacnet.setAnalogInputName(0, "ANALOG_INPUT_0")
  bacnet.setAnalogValueName(0, "ANALOG_VALUE_0")
  bacnet.setAnalogOutputName(0, "ANALOG_OUTPUT_0")

  while isBacnetRunning() do
    increment = math.fmod (increment, mod) + 1
    bacnet.setAnalogValuePresentValue(0, increment, priority)
    sleep(1)
  end
end

function Update()
  value = bacnet.getAnalogOutputPresentValue(0)
  bacnet.setAnalogInputPresentValue(0, value, priority)
end
