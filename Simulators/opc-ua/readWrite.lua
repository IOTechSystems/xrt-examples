tutorial_namespace = Server.addNamespace("Tutorial")

tutorial_folder = ObjectNode.newRootFolder("Tutorial", tutorial_namespace)
Server.addObjectNode(tutorial_folder)

-- Counter - variable node 
counter_node_id = NodeId.newString("Counter", tutorial_namespace)
counter_variant = Variant.new(DataType.DOUBLE)
counter_variant:setScalar(0.0)
display_name = "Counter"
parent_node = tutorial_folder:getNodeId()
print(parent_node)
access_level = AccessLevel.READ | AccessLevel.WRITE 
counter_node = VariableNode.new(counter_node_id, display_name, parent_node, counter_variant, access_level)
Server.addVariableNode(counter_node) 

-- Scale Factor - variable node 
sf_id = NodeId.newString("sf", tutorial_namespace)
sf_variant = Variant.new(DataType.DOUBLE)
sf_variant:setScalar(1.0)
display_name = "ScaleFactor"
access_level = AccessLevel.READ | AccessLevel.WRITE
sf_node = VariableNode.new(sf_id, display_name, parent_node, sf_variant, access_level)
Server.addVariableNode(sf_node)

-- Output - variable node 
out_id = NodeId.newString("out", tutorial_namespace)
out_variant = Variant.new(DataType.DOUBLE)
out_variant:setScalar(1.0)
display_name = "Output"
access_level = AccessLevel.READ | AccessLevel.WRITE
out_node = VariableNode.new(out_id, display_name, parent_node, out_variant, access_level)
Server.addVariableNode(out_node)

function Update()
  -- Attempt to get the current value of the counter node
  local counter_variant = Variant.new(DataType.DOUBLE)
  local counter_value_variant = counter_node:getValue()
  local counter_value
  counter_value = counter_value_variant:getScalar()
  counter_value = counter_value + 1
  counter_variant:setScalar(counter_value)
  counter_node:setValue(counter_variant)
  print("counter set to :",counter_value)

  -- Attempt to calculate the new output value based on the counter and scale factor
  local sf_value_variant = sf_node:getValue()
  local sf_value = sf_value_variant:getScalar()
  local variant = Variant.new(DataType.DOUBLE)
  variant:setScalar(counter_value * sf_value)
  out_node:setValue(variant)
  print("output set to  :",counter_value * sf_value)
end
