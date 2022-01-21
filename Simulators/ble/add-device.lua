--setup devices & their properties
TST_SRVC1 = "0000180d-0000-1000-8000-00805f9b34fb"
TST_CHR1 = "00002a38-0000-1000-8000-00805f9b34fb"
TST_CHR2 = "00002a39-0000-1000-8000-00805f9b34fb"
TST_DESC1 = "12345678-1234-5678-1234-56789abcdef2"
TST_DESC2 = "12345678-1234-5678-1234-56789abcdef3"

dev1 = ble.createDevice ("lua-test-dev-1")
srvc1 = ble.createService (TST_SRVC1)
char1 = ble.createCharacteristic (TST_CHR1)
char2 = ble.createCharacteristic (TST_CHR2)
desc1 = ble.createDescriptor (TST_DESC1)
desc2 = ble.createDescriptor (TST_DESC2)

dev1:addService (srvc1)
srvc1:addCharacteristic (char1)
srvc1:addCharacteristic (char2)
char1:addDescriptor (desc1)
char2:addDescriptor (desc2)

ble.registerDevice (dev1)

char2:notifying (true)
dev1:powered (true)
dev1:discoverable (true)

number = 0
array = {0xde, 0xad, 0xbe, 0xef, 0xde, 0xad, 0xbe, 0xef, 0xde, 0xad, 0xbe, 0xef, 0xde, 0xad, 0xbe, 0xef}
char1:setValue(array, DataType.UINT8)
char2:setValue(number,DataType.UINT32)

function Update() 
  char2:setValue(number,DataType.UINT32)
  number = number + 1
end
