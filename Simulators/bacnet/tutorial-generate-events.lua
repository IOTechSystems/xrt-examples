
function Run()
  bacnet.createNotificationClasses(1)
  bacnet.registerRecipient (101, 0, false)
end

local waitDuration = 15
local lastUpdate = os.time()

function Update()
  if os.time() - lastUpdate > waitDuration then
    bacnet.generateEvent(EventType.CHANGE_OF_BITSTRING, 0)
    bacnet.generateEvent(EventType.CHANGE_OF_STATE, 0)
    bacnet.generateEvent(EventType.CHANGE_OF_VALUE, 0)
    bacnet.generateEvent(EventType.COMMAND_FAILURE, 0)
    bacnet.generateEvent(EventType.FLOATING_LIMIT, 0)
    bacnet.generateEvent(EventType.OUT_OF_RANGE, 0)
    bacnet.generateEvent(EventType.CHANGE_OF_LIFE_SAFETY, 0)
    bacnet.generateEvent(EventType.BUFFER_READY, 0)
    bacnet.generateEvent(EventType.UNSIGNED_RANGE, 0)
    bacnet.generateEvent(EventType.ACCESS_EVENT, 0)
    bacnet.generateEvent(EventType.DOUBLE_OUT_OF_RANGE, 0)
    bacnet.generateEvent(EventType.SIGNED_OUT_OF_RANGE, 0)
    bacnet.generateEvent(EventType.UNSIGNED_OUT_OF_RANGE, 0)
    bacnet.generateEvent(EventType.CHANGE_OF_CHARACTERSTRING, 0)
    bacnet.generateEvent(EventType.CHANGE_OF_TIMER, 0)
    lastUpdate = os.time()
  end
end
