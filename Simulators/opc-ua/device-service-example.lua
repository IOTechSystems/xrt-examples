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
Server.addObjectNode (simulation_folder)

--initialise each node
counter = VariableNode.newNumeric(1001, "Counter", ns3, simulation_folder:getNodeId(), 0, DataType.DOUBLE, AccessLevel.READ)
random = VariableNode.newNumeric(1002, "Random", ns3, simulation_folder:getNodeId(), 0, DataType.DOUBLE, AccessLevel.READ)
sawtooth = VariableNode.newNumeric(1003, "Sawtooth", ns3, simulation_folder:getNodeId(), 0, DataType.DOUBLE, AccessLevel.READ)
sinusoid = VariableNode.newNumeric(1004, "Sinusoid", ns3, simulation_folder:getNodeId(), 0, DataType.DOUBLE, AccessLevel.READ)
square = VariableNode.newNumeric(1005, "Square", ns3, simulation_folder:getNodeId(), 0, DataType.DOUBLE, AccessLevel.READ)
triangle = VariableNode.newNumeric(1006, "Triangle", ns3, simulation_folder:getNodeId(), 0, DataType.DOUBLE, AccessLevel.READ)

writeable_1 = VariableNode.newString("WritableInt64", ns, folder:simulation_folder(), 0, DataType.INT64, AccessLevel.READ | AccessLevel.WRITE)
writeable_2 = VariableNode.newString("WritableFloat", ns, folder:simulation_folder(), 0.0, DataType.FLOAT, AccessLevel.READ | AccessLevel.WRITE)
writeable_3 = VariableNode.newString("WritableString", ns, folder:simulation_folder(), "", DataType.STRING, AccessLevel.READ | AccessLevel.WRITE)

--add the nodes to the server
Server.addVariableNode (counter)
Server.addVariableNode (random)
Server.addVariableNode (sawtooth)
Server.addVariableNode (sinusoid)
Server.addVariableNode (square)
Server.addVariableNode (triangle)
Server.addVariableNode (writeable_1)
Server.addVariableNode (writeable_2)
Server.addVariableNode (writeable_3)

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
end
