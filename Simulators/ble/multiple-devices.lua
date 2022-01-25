--setup devices & their properties
TST_SRVC1 = "0000180d-0000-1000-8000-00805f9b34fb"
TST_CHR1 = "00002a38-0000-1000-8000-00805f9b34fb"
TST_DESC1 = "12345678-1234-5678-1234-56789abcdef2"

device_count = 5

for i=0, device_count, 1
do
  dev = ble.createDevice ("lua-test-dev-" .. tostring(i))
  srvc = ble.createService (TST_SRVC1)
  char = ble.createCharacteristic (TST_CHR1)
  desc = ble.createDescriptor (TST_DESC1)

  dev:addService (srvc)
  srvc:addCharacteristic (char)
  char:addDescriptor (desc)

  ble.registerDevice (dev)
  dev:powered (true)
  dev:discoverable (true)

  char:setValue (i,DataType.UINT32)
end

function Update() 

end
