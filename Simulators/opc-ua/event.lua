last_update = os.time()
wait_time = 10 --seconds

t = 0;

function get_elapsed()
  current = os.time()
  elapsed =  current - last_update
  return elapsed
end

function should_update()
  if get_elapsed() < wait_time then
    return false
  end
  last_update = os.time()
  return true
end

--Create a new namespace
ns = Server.addNamespace("Events")

--Create a new folder to hold the events
events_folder = ObjectNode.newRootFolder("Events", ns)
Server.addObjectNode (events_folder)

--Create event type node, this is the type of notification that will be produced
event_type_node_id = NodeId.newString ("SimpleEventType", 0) --We need to create the Node ID of our new type
base_event_type_node_id = NodeId.newNumeric(ObjectType.BASEEVENTTYPE, 0) --We need to get the Node ID of the parent node of our new type - In this case this is the 'BASEEVENTTYPE'
event_type_node = ObjectTypeNode.new(event_type_node_id, "SimpleEventType", base_event_type_node_id) --Actually create our Object Type node

--Event origin node, this is the node that will produce the notification
event_origin_node = ObjectNode.newFolder ("EventOriginNode", ns, events_folder:getNodeId())
event_origin_node:setEventNotifier(true) --For an Object node to be able to produce notifications we need to set this to true

--Define the method nodes method
function trigger_event(inputs, outputs)
  Server.triggerEvent(event_type_node, event_origin_node, 100, "AN EVENT MESSAGE", "Lua script")
end
--Define the method node to trigger the event
event_method_node = MethodNode.new("EventMethodNode", ns, events_folder:getNodeId(), trigger_event, {}, {})

--Add our nodes to the server
Server.addObjectTypeNode(event_type_node)
Server.addMethodNode(event_method_node)
Server.addObjectNode(event_origin_node)

function Update()
  if not should_update() then
      return
  end

  outputs = Server.callMethodNode(event_method_node, {})
end
