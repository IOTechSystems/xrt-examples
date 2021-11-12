--Create a new namespace
ns = Server.addNamespace("Example")

--Create a folder to store the method nodes under
folder = ObjectNode.newRootFolder("Methods examples", ns)
Server.addObjectNode(folder)

--Define the Arguments to be used for the square and add method nodes
input1 = Argument.newStandardType("input1", DataType.INT32, ValueRank.SCALAR, nil)
input2 = Argument.newStandardType("input2", DataType.INT32, ValueRank.SCALAR, nil)
output1 = Argument.newStandardType("output1", DataType.INT32, ValueRank.SCALAR, nil)

--Define the square method nodes callback method
function node_square_method (inputs, outputs)
  local val = inputs[1]:getScalar() --get the value of input 1
  val = val ^ 2
  outputs[1]:setScalar(val, DataType.INT32) --set the output value to the square of input one
end
--Create our Square method node
node_square = MethodNode.new("Square", ns, folder:getNodeId(), node_square_method, {input1}, {output1})

function node_add_method (inputs, outputs)
  local a = inputs[1]:getScalar()
  local b = inputs[2]:getScalar()
  outputs[1]:setScalar(a + b, DataType.INT32)
end
node_add = MethodNode.new("Add", ns, folder:getNodeId(), node_add_method, {input1, input2}, {output1})

function node_concat_strings (inputs, outputs)
  local a = inputs[1]:getScalar()
  local b = inputs[2]:getScalar()
  local c = a .. b --concatenate the two strings
  outputs[1]:setScalar(c, DataType.STRING)
end
--Define the Arguments to the string concatenate function
str_input1 = Argument.newStandardType("string input1", DataType.STRING, ValueRank.SCALAR, nil)
str_input2 = Argument.newStandardType("string input2", DataType.STRING, ValueRank.SCALAR, nil)
str_output1 = Argument.newStandardType("string output1", DataType.STRING, ValueRank.SCALAR, nil)
node_concat = MethodNode.new("Concat", ns, folder:getNodeId(), node_concat_strings, {str_input1, str_input2}, {str_output1})

function node_add_array_method (inputs, outputs)
  local array = inputs[1]:getArray()
  local delta = inputs[2]:getScalar()
  local out = {}

  for k,v in pairs(array) do --loop through each value in the input array
    out[k] = v + delta
  end

  outputs[1]:setArray(out, DataType.INT32)
end

--Define the add array method inputs
--Note how we set the value_rank parameter as ValueRank.ONE_DIMENSION and define the first dimension of the input and output to be of size 5
arr_input1 = Argument.newStandardType("Array input1", DataType.INT32, ValueRank.ONE_DIMENSION, {5}) 
delta_input2 = Argument.newStandardType("Delta input2", DataType.INT32, ValueRank.SCALAR, nil)
arr_output1 = Argument.newStandardType("Array input1", DataType.INT32, ValueRank.ONE_DIMENSION, {5})
node_add_array = MethodNode.new("AddArray", ns, folder:getNodeId(), node_add_array_method, {arr_input1, delta_input2}, {arr_output1})

--Register the method nodes with the server
Server.addMethodNode(node_square)
Server.addMethodNode(node_add)
Server.addMethodNode(node_concat)
Server.addMethodNode(node_add_array)
