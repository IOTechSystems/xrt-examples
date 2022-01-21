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

dev1 = ble.createDevice ("ble-service-example-device")

service = ble.createService ("deadbeee-eeee-eeee-eeee-eeeeeeeeeeef")

counter = ble.createCharacteristic ("deadbeef-0000-1000-0000-008cafebabe1")
random = ble.createCharacteristic ("deadbeef-0000-1000-0000-008cafebabe2")
sawtooth = ble.createCharacteristic ("deadbeef-0000-1000-0000-008cafebabe3")
sinusoid = ble.createCharacteristic ("deadbeef-0000-1000-0000-008cafebabe4")
square = ble.createCharacteristic ("deadbeef-0000-1000-0000-008cafebabe5")
triangle = ble.createCharacteristic ("deadbeef-0000-1000-0000-008cafebabe6")
static = ble.createCharacteristic ("deadbeef-0000-1000-0000-008cafebabe7")

counter_desc = ble.createDescriptor ("12345678-1234-5678-1234-56789abcdef1")
random_desc = ble.createDescriptor ("12345678-1234-5678-1234-56789abcdef2")
sawtooth_desc = ble.createDescriptor ("12345678-1234-5678-1234-56789abcdef3")
sinusoid_desc = ble.createDescriptor ("12345678-1234-5678-1234-56789abcdef4")
square_desc = ble.createDescriptor ("12345678-1234-5678-1234-56789abcdef5")
triangle_desc = ble.createDescriptor ("12345678-1234-5678-1234-56789abcdef6")
static_desc = ble.createDescriptor ("12345678-1234-5678-1234-56789abcdef7")

dev1:addService (service)

service:addCharacteristic (counter)
service:addCharacteristic (random)
service:addCharacteristic (sawtooth)
service:addCharacteristic (sinusoid)
service:addCharacteristic (square)
service:addCharacteristic (triangle)
service:addCharacteristic (static)
service:addCharacteristic (static2)

counter:addDescriptor (counter_desc)
random:addDescriptor (random_desc)
sawtooth:addDescriptor (sawtooth_desc)
sinusoid:addDescriptor (sinusoid_desc)
square:addDescriptor (square_desc)
triangle:addDescriptor (triangle_desc)
static:addDescriptor (static_desc)

ble.registerDevice (dev1)

dev1:powered (true)
dev1:discoverable (true)

counter:notifying(true)
random:notifying(true)
sawtooth:notifying(true)
sinusoid:notifying(true)
square:notifying(true)
triangle:notifying(true)

static:setValue({0xde,0xad,0xbe,0xef,0xca,0xfe,0xba,0xbe}, DataType.UINT8)

counter_val = 0

--update the nodes values every 1 second
function Update()
    if not should_update() then
        return
    end
    t = t + 5

    --counter
    counter_val = counter_val + 1
    counter:setValue(counter_val, DataType.UINT32)
    --random
    local random_val = round(math.random(-20000,20000) / 10000, 8)
    random:setValue(random_val, DataType.DOUBLE)
    --sawtooth
    local sawtooth_val = round(2 * (t % (2*math.pi) * 1/math.pi - 1), 8)
    sawtooth:setValue(sawtooth_val, DataType.DOUBLE)
    --sinusoid
    local sinusoid_val = round(2 * math.sin(t), 8)
    sinusoid:setValue(sinusoid_val, DataType.DOUBLE)
    --square
    local square_val = sign(math.sin(t)) * 2
    square:setValue(square_val, DataType.DOUBLE)
    --triangle
    local triangle_val = round(2 * math.abs((t-math.pi/2) % (2*math.pi) * 1/math.pi - 1) - 1, 8)
    triangle:setValue(triangle_val, DataType.DOUBLE)
end
