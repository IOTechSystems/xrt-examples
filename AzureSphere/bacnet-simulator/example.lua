
local instances = {}

instances["AnalogInput"] = {total = 1, readOnly = true}
instances["AnalogOutput"] = {total = 1, readOnly = false}
instances["AnalogValue"] = {total = 1, readOnly = false}
instances["BinaryInput"] = {total = 1, readOnly = true}
instances["BinaryOutput"] = {total = 1, readOnly = false}
instances["BinaryValue"] = {total = 1, readOnly = false}
instances["PositiveIntegerValue"] = {total = 1, readOnly = false}
instances["Accumulator"] = {total = 1, readOnly = false}

binaryOptions = {0, 1, 255}

function sleep(time)
  local duration = os.time() + time
  while os.time() < duration do end
end

function Run() --run once
  for instanceType, instance in pairs(instances) do
    if instance.total > 0 then
      print("Create " .. instance.total .. " " .. instanceType .. " instances")
      -- Create instances using meta programming.
      bacnet["create" .. instanceType .. "s"](instance.total)
    end
  end

  local increment = 0
  local binaryIncrement = 1

  while isBacnetRunning() do
    for instanceType, instance in pairs(instances) do
      if instance.total > 0 and instance.readOnly == true then
	for instanceIterator = 0, instance.total - 1 do
          local value = increment

          if instanceType == "Accumulator" then
            instanceType = "AccumulatorValue"
	  elseif instanceType == "BinaryInput" then
	    value = binaryOptions[binaryIncrement]
	  end

          bacnet["set" .. instanceType](instanceIterator, value, 1)
	end
      end
    end

    increment = increment + 1
    binaryIncrement = binaryIncrement + 1

    if binaryIncrement == 4 then
      binaryIncrement = 1
    end

    sleep(1)
  end
end

function Update()
end
