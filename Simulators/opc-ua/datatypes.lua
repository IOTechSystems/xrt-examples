--Create a new namespace
ns = Server.addNamespace("Simulator")
--Create a Data Types folder to store our variable nodes under
datatypes_folder = ObjectNode.newRootFolder("DataTypes", ns)
array_datatypes_folder = ObjectNode.newRootFolder("ArrayDataTypes", ns)
Server.addObjectNode(datatypes_folder)
Server.addObjectNode(array_datatypes_folder)

function add_suported_datatypes()

  node_id_start = 0

  --Create a variable node of each supported type
  bool_variant = Variant.new(DataType.BOOL)
  bool_variant:setScalar(true)
  bool = VariableNode.new(NodeId.newNumeric(node_id_start+1,ns), "Bool", datatypes_folder:getNodeId(), bool_variant, AccessLevel.READ | AccessLevel.WRITE)

  byte_variant = Variant.new(DataType.BYTE)
  byte_variant:setScalar(-128)
  byte = VariableNode.new(NodeId.newNumeric(node_id_start+2, ns),"Byte", datatypes_folder:getNodeId(), byte_variant, AccessLevel.READ | AccessLevel.WRITE)

  sbyte_variant = Variant.new(DataType.SBYTE)
  sbyte_variant:setScalar(255)
  sbyte = VariableNode.new(NodeId.newNumeric(node_id_start+3, ns),"SByte", datatypes_folder:getNodeId(), sbyte_variant, AccessLevel.READ | AccessLevel.WRITE)

  int16_variant = Variant.new(DataType.INT16)
  int16_variant:setScalar(-32768)
  int16 = VariableNode.new(NodeId.newNumeric(node_id_start+4, ns),"Int16", datatypes_folder:getNodeId(), int16_variant, AccessLevel.READ | AccessLevel.WRITE)

  uint16_variant = Variant.new(DataType.UINT16)
  uint16_variant:setScalar(65535)
  uint16 = VariableNode.new(NodeId.newNumeric(node_id_start+5, ns),"UInt16", datatypes_folder:getNodeId(), uint16_variant, AccessLevel.READ | AccessLevel.WRITE)

  int32_variant = Variant.new(DataType.INT32)
  int32_variant:setScalar(-2147483648)
  int32 = VariableNode.new(NodeId.newNumeric(node_id_start+6, ns),"Int32", datatypes_folder:getNodeId(), int32_variant, AccessLevel.READ | AccessLevel.WRITE)

  uint32_variant = Variant.new(DataType.UINT32)
  uint32_variant:setScalar(-4294967295)
  uint32 = VariableNode.new(NodeId.newNumeric(node_id_start+7, ns),"UInt32", datatypes_folder:getNodeId(), uint32_variant, AccessLevel.READ | AccessLevel.WRITE)

  int64_variant = Variant.new(DataType.INT64)
  int64_variant:setScalar(-9223372036854775808)
  int64 = VariableNode.new(NodeId.newNumeric(node_id_start+8, ns),"Int64", datatypes_folder:getNodeId(), int64_variant, AccessLevel.READ | AccessLevel.WRITE)

  uint64_variant = Variant.new(DataType.UINT64)
  uint64_variant:setScalar(9223372036854775807)
  uint64 = VariableNode.new(NodeId.newNumeric(node_id_start+9, ns),"UInt64", datatypes_folder:getNodeId(), uint64_variant, AccessLevel.READ | AccessLevel.WRITE)

  float_variant = Variant.new(DataType.FLOAT)
  float_variant:setScalar(-9223372036854775808)
  float = VariableNode.new(NodeId.newNumeric(node_id_start+10, ns),"Float", datatypes_folder:getNodeId(), float_variant, AccessLevel.READ | AccessLevel.WRITE)

  double_variant = Variant.new(DataType.DOUBLE)
  double_variant:setScalar(9223372036854775807)
  double = VariableNode.new(NodeId.newNumeric(node_id_start+11, ns),"Double", datatypes_folder:getNodeId(), double_variant, AccessLevel.READ | AccessLevel.WRITE)

  string_variant = Variant.new(DataType.STRING)
  string_variant:setScalar("String1")
  string_node = VariableNode.new(NodeId.newNumeric(node_id_start+12, ns),"String", datatypes_folder:getNodeId(), string_variant, AccessLevel.READ | AccessLevel.WRITE)

  datetime_variant = Variant.new(DataType.DATETIME)
  datetime_variant:setScalar(os.time(os.date("!*t")))
  datetime = VariableNode.new(NodeId.newNumeric(node_id_start+13, ns),"DateTime", datatypes_folder:getNodeId(), datetime_variant, AccessLevel.READ | AccessLevel.WRITE)

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
  node_id_start = 20
  int_array = {0,1,2,3,4,5}
  float_array = {0.0,1.1,2.2,3.3,4.4,5.5}

  bool_variant = Variant.new(DataType.INT32)
  bool_variant:setArray(int_array, {6})
  bool = VariableNode.new(NodeId.newNumeric(111,ns), "BoolArray", array_datatypes_folder:getNodeId(), bool_variant, AccessLevel.READ | AccessLevel.WRITE)

  byte_variant = Variant.new(DataType.BYTE)
  byte_variant:setArray(int_array)
  byte = VariableNode.new(NodeId.newNumeric(node_id_start+2, ns),"ByteArray", array_datatypes_folder:getNodeId(), byte_variant, AccessLevel.READ | AccessLevel.WRITE)

  sbyte_variant = Variant.new(DataType.SBYTE)
  sbyte_variant:setArray(int_array)
  sbyte = VariableNode.new(NodeId.newNumeric(node_id_start+3, ns),"SByteArray", array_datatypes_folder:getNodeId(), sbyte_variant, AccessLevel.READ | AccessLevel.WRITE)

  int16_variant = Variant.new(DataType.INT16)
  int16_variant:setArray(int_array)
  int16 = VariableNode.new(NodeId.newNumeric(node_id_start+4, ns),"Int16Array", array_datatypes_folder:getNodeId(), int16_variant, AccessLevel.READ | AccessLevel.WRITE)

  uint16_variant = Variant.new(DataType.UINT16)
  uint16_variant:setArray(int_array)
  uint16 = VariableNode.new(NodeId.newNumeric(node_id_start+5, ns),"UInt16Array", array_datatypes_folder:getNodeId(), uint16_variant, AccessLevel.READ | AccessLevel.WRITE)

  int32_variant = Variant.new(DataType.INT32)
  int32_variant:setArray(int_array)
  int32 = VariableNode.new(NodeId.newNumeric(node_id_start+6, ns),"Int32Array", array_datatypes_folder:getNodeId(), int32_variant, AccessLevel.READ | AccessLevel.WRITE)

  uint32_variant = Variant.new(DataType.UINT32)
  uint32_variant:setArray(int_array)
  uint32 = VariableNode.new(NodeId.newNumeric(node_id_start+7, ns),"UInt32Array", array_datatypes_folder:getNodeId(), uint32_variant, AccessLevel.READ | AccessLevel.WRITE)

  int64_variant = Variant.new(DataType.INT64)
  int64_variant:setArray(int_array)
  int64 = VariableNode.new(NodeId.newNumeric(node_id_start+8, ns),"Int64Array", array_datatypes_folder:getNodeId(), int64_variant, AccessLevel.READ | AccessLevel.WRITE)

  uint64_variant = Variant.new(DataType.UINT64)
  uint64_variant:setArray(int_array)
  uint64 = VariableNode.new(NodeId.newNumeric(node_id_start+9, ns),"UInt64Array", array_datatypes_folder:getNodeId(), uint64_variant, AccessLevel.READ | AccessLevel.WRITE)

  float_variant = Variant.new(DataType.FLOAT)
  float_variant:setArray(float_array)
  float = VariableNode.new(NodeId.newNumeric(node_id_start+10, ns),"FloatArray", array_datatypes_folder:getNodeId(), float_variant, AccessLevel.READ | AccessLevel.WRITE)

  double_variant = Variant.new(DataType.DOUBLE)
  double_variant:setArray(float_array)
  double = VariableNode.new(NodeId.newNumeric(node_id_start+11, ns),"DoubleArray", array_datatypes_folder:getNodeId(), double_variant, AccessLevel.READ | AccessLevel.WRITE)

  string_variant = Variant.new(DataType.STRING)
  string_variant:setArray({"String1", "String2", "String3", "String4", "String5"})
  string_node = VariableNode.new(NodeId.newNumeric(node_id_start+12, ns), "StringArray", array_datatypes_folder:getNodeId(), string_variant, AccessLevel.READ | AccessLevel.WRITE)

  datetime_variant = Variant.new(DataType.DATETIME)
  datetime_variant:setArray({os.time(os.date("!*t")), 2, 3, 4, 5})
  datetime = VariableNode.new(NodeId.newNumeric(node_id_start+13, ns),"DateTimeArray", array_datatypes_folder:getNodeId(), datetime_variant, AccessLevel.READ | AccessLevel.WRITE)

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

add_suported_datatypes()
add_suported_datatypes_arrays()

