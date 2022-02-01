last_update = os.time()
math.randomseed(os.time())
wait_time = 1 --seconds

t = 0;

--helper functions 
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

function sign(x)
  return x>0 and 1 or x<0 and -1 or 0
end

--rounds to n decimal places
function round(x, n)
 return tonumber(string.format("%." .. (n or 0) .. "f", x))
end

--create the namespaces
ns = Server.addNamespace("SimulationServer") --creates namespace 2
ns3 = Server.addNamespace("SimulationNodes") --creates namespace 3

--create the folder to store the nodes under
simulation_folder = ObjectNode.newRootFolder("Simulation", ns3) 
datatypes_folder = ObjectNode.newRootFolder("DataTypes", ns3) 
events_folder = ObjectNode.newRootFolder("Events", ns3)

Server.addObjectNode (simulation_folder)
Server.addObjectNode (datatypes_folder)
Server.addObjectNode (events_folder)

--initialise each node
counter = VariableNode.newString("Counter", ns3, simulation_folder:getNodeId(), 0, DataType.DOUBLE, AccessLevel.READ)
random = VariableNode.newString("Random", ns3, simulation_folder:getNodeId(), 0, DataType.DOUBLE, AccessLevel.READ)
sawtooth = VariableNode.newString("Sawtooth", ns3, simulation_folder:getNodeId(), 0, DataType.DOUBLE, AccessLevel.READ)
sinusoid = VariableNode.newString("Sinusoid", ns3, simulation_folder:getNodeId(), 0, DataType.DOUBLE, AccessLevel.READ)
square = VariableNode.newString("Square", ns3, simulation_folder:getNodeId(), 0, DataType.DOUBLE, AccessLevel.READ)
triangle = VariableNode.newString("Triangle", ns3, simulation_folder:getNodeId(), 0, DataType.DOUBLE, AccessLevel.READ)

--Create a variable node of each supported type
bool = VariableNode.newString("Bool", ns3, datatypes_folder:getNodeId(), true, DataType.BOOL, AccessLevel.READ | AccessLevel.WRITE)
sbyte = VariableNode.newString("SByte", ns3, datatypes_folder:getNodeId(), -128, DataType.SBYTE, AccessLevel.READ | AccessLevel.WRITE)
byte = VariableNode.newString("Byte", ns3, datatypes_folder:getNodeId(), 255, DataType.BYTE, AccessLevel.READ | AccessLevel.WRITE)
int16 = VariableNode.newString("Int16", ns3, datatypes_folder:getNodeId(), -32768, DataType.INT16, AccessLevel.READ | AccessLevel.WRITE)
uint16 = VariableNode.newString("UInt16", ns3, datatypes_folder:getNodeId(), 65535, DataType.UINT16, AccessLevel.READ | AccessLevel.WRITE)
int32 = VariableNode.newString("Int32", ns3, datatypes_folder:getNodeId(), -2147483648, DataType.INT32, AccessLevel.READ | AccessLevel.WRITE)
uint32 = VariableNode.newString("UInt32", ns3, datatypes_folder:getNodeId(), 4294967295, DataType.UINT32, AccessLevel.READ | AccessLevel.WRITE)
int64 = VariableNode.newString("Int64", ns3, datatypes_folder:getNodeId(), -9223372036854775808, DataType.INT64, AccessLevel.READ | AccessLevel.WRITE)
uint64 = VariableNode.newString("UInt64", ns3, datatypes_folder:getNodeId(), 9223372036854775807, DataType.UINT64, AccessLevel.READ | AccessLevel.WRITE) --lua does not support uint64
float = VariableNode.newString("Float", ns3, datatypes_folder:getNodeId(), 123456.78, DataType.FLOAT, AccessLevel.READ | AccessLevel.WRITE)
double = VariableNode.newString("Double", ns3, datatypes_folder:getNodeId(), 109876543.21, DataType.DOUBLE, AccessLevel.READ | AccessLevel.WRITE)
string = VariableNode.newString("String", ns3, datatypes_folder:getNodeId(), "Example string data type", DataType.STRING, AccessLevel.READ | AccessLevel.WRITE)
datetime = VariableNode.newString("Datetime", ns3, datatypes_folder:getNodeId(), os.time(os.date("!*t")), DataType.DATETIME, AccessLevel.READ | AccessLevel.WRITE)

--add the datatype nodes with the server
Server.addVariableNode (bool)
Server.addVariableNode (sbyte)
Server.addVariableNode (byte)
Server.addVariableNode (int16)
Server.addVariableNode (uint16)
Server.addVariableNode (int32)
Server.addVariableNode (uint32)
Server.addVariableNode (int64)
Server.addVariableNode (uint64)
Server.addVariableNode (float)
Server.addVariableNode (double)
Server.addVariableNode (string)
Server.addVariableNode (datetime)

--add the simulation nodes to the server
Server.addVariableNode (counter)
Server.addVariableNode (random)
Server.addVariableNode (sawtooth)
Server.addVariableNode (sinusoid)
Server.addVariableNode (square)
Server.addVariableNode (triangle)

--Create event type nodes
event_type_node_id = NodeId.newString ("SimpleEventType", 0) --We need to create the Node ID of our new type
base_event_type_node_id = NodeId.newNumeric(ObjectType.BASEEVENTTYPE, 0) --We need to get the Node ID of the parent node of our new type - In this case this is the 'BASEEVENTTYPE'
event_type_node = ObjectTypeNode.new(event_type_node_id, "SimpleEventType", base_event_type_node_id) --Actually create our Object Type node

--Event origin node, this is the node that will produce the notification
event_origin_node = ObjectNode.newFolder ("EventOriginNode", ns3, events_folder:getNodeId())
event_origin_node:setEventNotifier(true) --For an Object node to be able to produce notifications we need to set this to true

--Add our nodes to the server
Server.addObjectTypeNode(event_type_node)
Server.addObjectNode(event_origin_node)


--update the nodes values every 1 second
function Update()

  if not should_update() then
    return
  end
  t = t + 5

  --counter
  local counter_val = counter:getValue()
  counter_val = counter_val + 1
  counter:updateValue(counter_val)
  --random
  local random_val = round(math.random(-20000,20000) / 10000, 8)
  random:updateValue(random_val)
  --sawtooth
  local sawtooth_val = round(2 * (t % (2*math.pi) * 1/math.pi - 1), 8)
  sawtooth:updateValue(sawtooth_val)
  --sinusoid
  local sinusoid_val = round(2 * math.sin(t), 8)
  sinusoid:updateValue(sinusoid_val)
  --square
  local square_val = sign(math.sin(t)) * 2
  square:updateValue(square_val)
  --triangle
  local triangle_val = round(2 * math.abs((t-math.pi/2) % (2*math.pi) * 1/math.pi - 1) - 1, 8)
  triangle:updateValue(triangle_val)

  Server.triggerEvent(event_type_node, event_origin_node, 100, "AN EVENT MESSAGE", "Simulator")
  
end
