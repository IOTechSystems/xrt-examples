-- Helper functions
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

--Create a new namespace
ns = Server.addNamespace("Static")
--Create a Data Types folder to store our variable nodes under
datatypes_folder = ObjectNode.newRootFolder("DataTypes", ns)
array_datatypes_folder = ObjectNode.newRootFolder("ArrayDataTypes", ns)
node_types_folder = ObjectNode.newRootFolder("NodeTypes", ns)
Server.addObjectNode(datatypes_folder)
Server.addObjectNode(array_datatypes_folder)
Server.addObjectNode(node_types_folder)

ns2 = Server.addNamespace("Simulation") --creates namespace 3

simulation_folder = ObjectNode.newRootFolder("Simulation", ns2) 
Server.addObjectNode (simulation_folder)

function add_suported_datatypes()

  --Create a variable node of each supported type
  bool_variant = Variant.new(DataType.BOOL)
  bool_variant:setScalar(true)
  bool = VariableNode.new(NodeId.newString("Bool",ns), "Bool", datatypes_folder:getNodeId(), bool_variant, AccessLevel.READ | AccessLevel.WRITE)

  byte_variant = Variant.new(DataType.BYTE)
  byte_variant:setScalar(-128)
  byte = VariableNode.new(NodeId.newString("Byte", ns),"Byte", datatypes_folder:getNodeId(), byte_variant, AccessLevel.READ | AccessLevel.WRITE)

  sbyte_variant = Variant.new(DataType.SBYTE)
  sbyte_variant:setScalar(255)
  sbyte = VariableNode.new(NodeId.newString("SByte", ns),"SByte", datatypes_folder:getNodeId(), sbyte_variant, AccessLevel.READ | AccessLevel.WRITE)

  int16_variant = Variant.new(DataType.INT16)
  int16_variant:setScalar(-32768)
  int16 = VariableNode.new(NodeId.newString("Int16", ns),"Int16", datatypes_folder:getNodeId(), int16_variant, AccessLevel.READ | AccessLevel.WRITE)

  uint16_variant = Variant.new(DataType.UINT16)
  uint16_variant:setScalar(65535)
  uint16 = VariableNode.new(NodeId.newString("UInt16", ns),"UInt16", datatypes_folder:getNodeId(), uint16_variant, AccessLevel.READ | AccessLevel.WRITE)

  int32_variant = Variant.new(DataType.INT32)
  int32_variant:setScalar(-2147483648)
  int32 = VariableNode.new(NodeId.newString("Int32", ns),"Int32", datatypes_folder:getNodeId(), int32_variant, AccessLevel.READ | AccessLevel.WRITE)

  uint32_variant = Variant.new(DataType.UINT32)
  uint32_variant:setScalar(-4294967295)
  uint32 = VariableNode.new(NodeId.newString("UInt32", ns),"UInt32", datatypes_folder:getNodeId(), uint32_variant, AccessLevel.READ | AccessLevel.WRITE)

  int64_variant = Variant.new(DataType.INT64)
  int64_variant:setScalar(-9223372036854775808)
  int64 = VariableNode.new(NodeId.newString("Int64", ns),"Int64", datatypes_folder:getNodeId(), int64_variant, AccessLevel.READ | AccessLevel.WRITE)

  uint64_variant = Variant.new(DataType.UINT64)
  uint64_variant:setScalar(9223372036854775807)
  uint64 = VariableNode.new(NodeId.newString("UInt64", ns),"UInt64", datatypes_folder:getNodeId(), uint64_variant, AccessLevel.READ | AccessLevel.WRITE)

  float_variant = Variant.new(DataType.FLOAT)
  float_variant:setScalar(-9223372036854775808)
  float = VariableNode.new(NodeId.newString("Float", ns),"Float", datatypes_folder:getNodeId(), float_variant, AccessLevel.READ | AccessLevel.WRITE)

  double_variant = Variant.new(DataType.DOUBLE)
  double_variant:setScalar(9223372036854775807)
  double = VariableNode.new(NodeId.newString("Double", ns),"Double", datatypes_folder:getNodeId(), double_variant, AccessLevel.READ | AccessLevel.WRITE)

  string_variant = Variant.new(DataType.STRING)
  string_variant:setScalar("String1")
  string_node = VariableNode.new(NodeId.newString("String", ns),"String", datatypes_folder:getNodeId(), string_variant, AccessLevel.READ | AccessLevel.WRITE)

  datetime_variant = Variant.new(DataType.DATETIME)
  datetime_variant:setScalar(os.time(os.date("!*t")))
  datetime = VariableNode.new(NodeId.newString("DateTime", ns),"DateTime", datatypes_folder:getNodeId(), datetime_variant, AccessLevel.READ | AccessLevel.WRITE)

  --Register the nodes with the server
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
  Server.addVariableNode (string_node)
  Server.addVariableNode (datetime)

end

function add_suported_datatypes_arrays()

  --Create an array variable node of each supported type
  bool_array = {true, false, true, false, false}
  int_array = {0,1,2,3,4,5}
  float_array = {0.0,1.1,2.2,3.3,4.4,5.5}

  bool_variant = Variant.new(DataType.BOOL)
  bool_variant:setArray(bool_array)
  bool = VariableNode.new(NodeId.newString("BoolArray",ns), "BoolArray", array_datatypes_folder:getNodeId(), bool_variant, AccessLevel.READ | AccessLevel.WRITE)

  byte_variant = Variant.new(DataType.BYTE)
  byte_variant:setArray(int_array)
  byte = VariableNode.new(NodeId.newString("ByteArray", ns),"ByteArray", array_datatypes_folder:getNodeId(), byte_variant, AccessLevel.READ | AccessLevel.WRITE)

  sbyte_variant = Variant.new(DataType.SBYTE)
  sbyte_variant:setArray(int_array)
  sbyte = VariableNode.new(NodeId.newString("SByteArray", ns),"SByteArray", array_datatypes_folder:getNodeId(), sbyte_variant, AccessLevel.READ | AccessLevel.WRITE)

  int16_variant = Variant.new(DataType.INT16)
  int16_variant:setArray(int_array)
  int16 = VariableNode.new(NodeId.newString("Int16Array", ns),"Int16Array", array_datatypes_folder:getNodeId(), int16_variant, AccessLevel.READ | AccessLevel.WRITE)

  uint16_variant = Variant.new(DataType.UINT16)
  uint16_variant:setArray(int_array)
  uint16 = VariableNode.new(NodeId.newString("UInt16Array", ns),"UInt16Array", array_datatypes_folder:getNodeId(), uint16_variant, AccessLevel.READ | AccessLevel.WRITE)

  int32_variant = Variant.new(DataType.INT32)
  int32_variant:setArray(int_array)
  int32 = VariableNode.new(NodeId.newString("Int32Array", ns),"Int32Array", array_datatypes_folder:getNodeId(), int32_variant, AccessLevel.READ | AccessLevel.WRITE)

  uint32_variant = Variant.new(DataType.UINT32)
  uint32_variant:setArray(int_array)
  uint32 = VariableNode.new(NodeId.newString("UInt32Array", ns),"UInt32Array", array_datatypes_folder:getNodeId(), uint32_variant, AccessLevel.READ | AccessLevel.WRITE)

  int64_variant = Variant.new(DataType.INT64)
  int64_variant:setArray(int_array)
  int64 = VariableNode.new(NodeId.newString("Int64Array", ns),"Int64Array", array_datatypes_folder:getNodeId(), int64_variant, AccessLevel.READ | AccessLevel.WRITE)

  uint64_variant = Variant.new(DataType.UINT64)
  uint64_variant:setArray(int_array)
  uint64 = VariableNode.new(NodeId.newString("UInt64Array", ns),"UInt64Array", array_datatypes_folder:getNodeId(), uint64_variant, AccessLevel.READ | AccessLevel.WRITE)

  float_variant = Variant.new(DataType.FLOAT)
  float_variant:setArray(float_array)
  float = VariableNode.new(NodeId.newString("FloatArray", ns),"FloatArray", array_datatypes_folder:getNodeId(), float_variant, AccessLevel.READ | AccessLevel.WRITE)

  double_variant = Variant.new(DataType.DOUBLE)
  double_variant:setArray(float_array)
  double = VariableNode.new(NodeId.newString("DoubleArray", ns),"DoubleArray", array_datatypes_folder:getNodeId(), double_variant, AccessLevel.READ | AccessLevel.WRITE)

  string_variant = Variant.new(DataType.STRING)
  string_variant:setArray({"String1", "String2", "String3", "String4", "String5"})
  string_node = VariableNode.new(NodeId.newString("StringArray", ns), "StringArray", array_datatypes_folder:getNodeId(), string_variant, AccessLevel.READ | AccessLevel.WRITE)

  datetime_variant = Variant.new(DataType.DATETIME)
  datetime_variant:setArray({os.time(os.date("!*t")), 2, 3, 4, 5})
  datetime = VariableNode.new(NodeId.newString("DateTimeArray", ns),"DateTimeArray", array_datatypes_folder:getNodeId(), datetime_variant, AccessLevel.READ | AccessLevel.WRITE)

  --Register the nodes with the server
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
  Server.addVariableNode (string_node)
  Server.addVariableNode (datetime)

end

function add_node_types()
  node_type_variant = Variant.new(DataType.UINT32)
  node_type_variant:setScalar(42)

  string_node = VariableNode.new(NodeId.newString("StringNode", ns), "StringNode", node_types_folder:getNodeId(), node_type_variant, AccessLevel.READ | AccessLevel.WRITE)
  numeric = VariableNode.new(NodeId.newNumeric(42,ns), "Numeric Node", node_types_folder:getNodeId(), node_type_variant, AccessLevel.READ | AccessLevel.WRITE)
  guid = VariableNode.new(NodeId.newGUID("deadbeef-cafe-babe-ca1f-baff1ed0bee5",ns),"GUID Node", node_types_folder:getNodeId(), node_type_variant, AccessLevel.READ | AccessLevel.WRITE)
  bytestring = VariableNode.new(NodeId.newByteString("M/RbKBsRVkePCePcx24oRA=='",ns), "Bytestring node", node_types_folder:getNodeId(), node_type_variant, AccessLevel.READ | AccessLevel.WRITE)
  
  Server.addVariableNode (string_node)
  Server.addVariableNode (numeric)
  Server.addVariableNode (guid)
  Server.addVariableNode (bytestring)
end

counter_variant = Variant.new(DataType.DOUBLE)
counter_variant:setScalar(0)
random_variant = Variant.new(DataType.DOUBLE)
random_variant:setScalar(0)
sawtooth_variant = Variant.new(DataType.DOUBLE)
sawtooth_variant:setScalar(0)
sinusoid_variant = Variant.new(DataType.DOUBLE)
sinusoid_variant:setScalar(0)
square_variant = Variant.new(DataType.DOUBLE)
square_variant:setScalar(0)
triangle_variant = Variant.new(DataType.DOUBLE)
triangle_variant:setScalar(0)

function add_simulation_nodes()
  counter = VariableNode.new(NodeId.newString("Counter",ns2), "Counter", simulation_folder:getNodeId(), counter_variant, AccessLevel.READ)
  random = VariableNode.new(NodeId.newString("Random",ns2), "Random", simulation_folder:getNodeId(), random_variant, AccessLevel.READ)
  sawtooth = VariableNode.new(NodeId.newString("Sawtooth",ns2), "Sawtooth", simulation_folder:getNodeId(), sawtooth_variant, AccessLevel.READ)
  sinusoid = VariableNode.new(NodeId.newString("Sinusoid",ns2), "Sinusoid",  simulation_folder:getNodeId(), sinusoid_variant, AccessLevel.READ)
  square = VariableNode.new(NodeId.newString("Square",ns2), "Square",  simulation_folder:getNodeId(), square_variant, AccessLevel.READ)
  triangle = VariableNode.new(NodeId.newString("Triangle",ns2), "Triangle", simulation_folder:getNodeId(), triangle_variant, AccessLevel.READ)
  
  Server.addVariableNode (counter)
  Server.addVariableNode (random)
  Server.addVariableNode (sawtooth)
  Server.addVariableNode (sinusoid)
  Server.addVariableNode (square)
  Server.addVariableNode (triangle)
end

add_suported_datatypes()
add_suported_datatypes_arrays()
add_node_types()
add_simulation_nodes()

--update the nodes values every 1 second
function Update()

  if not should_update() then
    return
  end
  t = t + 5

  --counter
  counter_variant:setScalar(counter_variant:getScalar() + 1)
  counter:updateValue()
  --random
  random_variant:setScalar(round(math.random(-20000,20000) / 10000, 8))
  random:updateValue()
  --sawtooth
  sawtooth_variant:setScalar(round(2 * (t % (2*math.pi) * 1/math.pi - 1), 8))
  sawtooth:updateValue()
  --sinusoid
  sinusoid_variant:setScalar(round(2 * math.sin(t), 8))
  sinusoid:updateValue()
  --square
  square_variant:setScalar(sign(math.sin(t)) * 2)
  square:updateValue()
  --triangle
  triangle_variant:setScalar(round(2 * math.abs((t-math.pi/2) % (2*math.pi) * 1/math.pi - 1) - 1, 8))
  triangle:updateValue()
end
