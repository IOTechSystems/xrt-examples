--create the example namespace
ns = Server.addNamespace("Example")

--create the folder to store the nodes under
folder = ObjectNode.newRootFolder("Node Types", ns)
Server.addObjectNode(folder)

--create a one node of each node type
string = VariableNode.newString("StringNode", ns, folder:getNodeId(), "String node test value", DataType.STRING, AccessLevel.READ | AccessLevel.WRITE)
numeric = VariableNode.newNumeric(42, "Numeric Node", ns, folder:getNodeId(), "Numeric node test value", DataType.STRING, AccessLevel.READ | AccessLevel.WRITE)
guid = VariableNode.newGUID("deadbeef-cafe-babe-ca1f-baff1ed0bee5","GUID Node", ns, folder:getNodeId(), "GUID node test value", DataType.STRING, AccessLevel.READ | AccessLevel.WRITE)
bytestring = VariableNode.newBytestring("M/RbKBsRVkePCePcx24oRA=='", "Bytestring node", ns, folder:getNodeId(), "Bytestring node test value", DataType.STRING, AccessLevel.READ | AccessLevel.WRITE)

--register the nodes with the server
Server.addVariableNode (string)
Server.addVariableNode (numeric)
Server.addVariableNode (guid)
Server.addVariableNode (bytestring)
