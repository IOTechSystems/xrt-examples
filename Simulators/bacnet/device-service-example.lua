
local instances = {}
local priority = 1

instances["AnalogInput"] = {total = 2, update = true}
instances["AnalogValue"] = {total = 2, update = true}
instances["AnalogOutput"] = {total = 2, update = false}
instances["BinaryInput"] = {total = 2, update = true}
instances["BinaryValue"] = {total = 2, update = true}
instances["BinaryOutput"] = {total = 2, update = false}
instances["IntegerValue"] = {total = 2, update = true}
instances["PositiveIntegerValue"] = {total = 2, update = false}

function Run()
  bacnet.createNotificationClasses(1)
  for instanceType, instance in pairs(instances) do
    if instance.total > 0 then
      print("Create " .. instance.total .. " " .. instanceType .. " instances")
      -- Create instances using meta programming.
      bacnet["create" .. instanceType .. "s"](instance.total)
    end
  end
end

local waitDuration = 5 -- Update every 5s
local lastUpdate = os.time()

function Update()
  if os.time() - lastUpdate > waitDuration then
    for instanceType, instance in pairs(instances) do
      if instance.total > 0 and instance.update == true then
        for instanceIterator = 0, instance.total - 1 do
          local value = instanceType == "IntegerValue" and math.random(-500,500) or math.random(0,500)
          bacnet["set" .. instanceType .. "PresentValue"](instanceIterator, value, priority)
        end
      end
    end
    lastUpdate = os.time()
  end
end
