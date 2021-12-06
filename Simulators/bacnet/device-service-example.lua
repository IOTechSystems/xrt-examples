
local instances = {}

instances["AnalogInput"] = {total = 2, update = true}
instances["AnalogValue"] = {total = 2, update = true}
instances["AnalogOutput"] = {total = 2, update = false}

function Run()
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
          local value = math.random(0,1000)
          bacnet["set" .. instanceType](instanceIterator, value, 1)
        end
      end
    end
    lastUpdate = os.time()
  end
end

