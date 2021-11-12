--Create a new namespace
ns = Server.addNamespace("Example")
--Create a Data Types folder to store our variable nodes under
folder = ObjectNode.newRootFolder("Data Types", ns)
Server.addObjectNode(folder)

--Create a variable node of each supported type
bool = VariableNode.newString("Bool", ns, folder:getNodeId(), true, DataType.BOOL, AccessLevel.READ | AccessLevel.WRITE)
sbyte = VariableNode.newString("SByte", ns, folder:getNodeId(), -128, DataType.SBYTE, AccessLevel.READ | AccessLevel.WRITE)
byte = VariableNode.newString("Byte", ns, folder:getNodeId(), 255, DataType.BYTE, AccessLevel.READ | AccessLevel.WRITE)
int16 = VariableNode.newString("Int16", ns, folder:getNodeId(), -32768, DataType.INT16, AccessLevel.READ | AccessLevel.WRITE)
uint16 = VariableNode.newString("UInt16", ns, folder:getNodeId(), 65535, DataType.UINT16, AccessLevel.READ | AccessLevel.WRITE)
int32 = VariableNode.newString("Int32", ns, folder:getNodeId(), -2147483648, DataType.INT32, AccessLevel.READ | AccessLevel.WRITE)
uint32 = VariableNode.newString("UInt32", ns, folder:getNodeId(), 4294967295, DataType.UINT32, AccessLevel.READ | AccessLevel.WRITE)
int64 = VariableNode.newString("Int64", ns, folder:getNodeId(), -9223372036854775808, DataType.INT64, AccessLevel.READ | AccessLevel.WRITE)
uint64 = VariableNode.newString("UInt64", ns, folder:getNodeId(), 9223372036854775807, DataType.UINT64, AccessLevel.READ | AccessLevel.WRITE) --lua does not support uint64
float = VariableNode.newString("Float", ns, folder:getNodeId(), 123456.78, DataType.FLOAT, AccessLevel.READ | AccessLevel.WRITE)
double = VariableNode.newString("Double", ns, folder:getNodeId(), 109876543.21, DataType.DOUBLE, AccessLevel.READ | AccessLevel.WRITE)
string = VariableNode.newString("String", ns, folder:getNodeId(), "Example string data type", DataType.STRING, AccessLevel.READ | AccessLevel.WRITE)
datetime = VariableNode.newString("Datetime", ns, folder:getNodeId(), os.time(os.date("!*t")), DataType.DATETIME, AccessLevel.READ | AccessLevel.WRITE)

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
Server.addVariableNode (string)
Server.addVariableNode (datetime)
