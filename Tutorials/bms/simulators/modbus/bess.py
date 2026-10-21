# Simulates a small battery energy storage system on one Modbus server:
#   unit 1  enclosure-sensor  (enclosure air temperature and humidity)
#   unit 2  rack-01           (battery rack controller)
#   unit 3  rack-02           (battery rack controller)
#
# Each rack follows its writable current-setpoint (A, positive to charge, negative to discharge).
# The current changes the rack's state of charge, cell voltages and module temperatures, and the
# racks' combined current warms the enclosure. A rack trips to fault (rack-status 3) when its highest
# cell voltage reaches 3.65 V or a module reaches 55 °C, and stays there until its current-setpoint
# is set back to 0.
#
# update_values() runs once a second. The state of charge moves much faster than in a real
# system, so that alarms can be reached within a minute or two.

import random

CELLS = 240               # cells in series per rack
SOC_PER_AMP = 0.004       # % state of charge per A per update
CELL_RESISTANCE = 0.0005  # Ω per cell
MAX_CELL_VOLTAGE = 3.65   # V, rack trips above this
MAX_TEMPERATURE = 55.0    # °C, rack trips above this

STANDBY, CHARGING, DISCHARGING, FAULT = 0, 1, 2, 3

racks = {
    2: {"soc": 85.0, "current": 0.0, "temps": [25.0, 25.5], "status": STANDBY},
    3: {"soc": 80.0, "current": 0.0, "temps": [25.5, 26.0], "status": STANDBY},
}
enclosure = {"temperature": 24.0, "humidity": 45.0}


def open_circuit_voltage(soc):
    # Flat in the middle, rising steeply above 90 %, as for a lithium iron phosphate cell
    return 3.20 + 0.0012 * soc + 0.03 * max(0.0, soc - 90.0)


def noise(amplitude):
    return random.uniform(-amplitude, amplitude)


def update_rack(rack, res):
    setpoint = res["current-setpoint"].get_value()

    if rack["status"] == FAULT:
        if setpoint == 0:
            rack["status"] = STANDBY
        target = 0.0
    else:
        target = setpoint
        # Stop charging when full and discharging when empty
        if (target > 0 and rack["soc"] >= 100.0) or (target < 0 and rack["soc"] <= 5.0):
            target = 0.0

    rack["current"] += (target - rack["current"]) * 0.5
    if abs(rack["current"]) < 0.5 and target == 0:
        rack["current"] = 0.0
    current = rack["current"]

    rack["soc"] = min(100.0, max(0.0, rack["soc"] + current * SOC_PER_AMP))
    cell = open_circuit_voltage(rack["soc"]) + current * CELL_RESISTANCE
    cell_max = cell + 0.012 + noise(0.002)
    cell_min = cell - 0.015 + noise(0.002)

    # Modules settle towards a temperature that rises with the current, with a 30 s time constant
    for i, offset in enumerate((0.0, 0.5)):
        settle = 25.0 + offset + 0.1 * abs(current)
        rack["temps"][i] += (settle - rack["temps"][i]) / 30.0

    if rack["status"] != FAULT:
        if cell_max >= MAX_CELL_VOLTAGE or max(rack["temps"]) >= MAX_TEMPERATURE:
            rack["status"] = FAULT
        elif current > 1.0:
            rack["status"] = CHARGING
        elif current < -1.0:
            rack["status"] = DISCHARGING
        else:
            rack["status"] = STANDBY

    res["rack-voltage"].set_value(round(cell * CELLS, 1))
    res["rack-current"].set_value(round(current, 1))
    res["state-of-charge"].set_value(round(rack["soc"], 2))
    res["cell-voltage-max"].set_value(round(cell_max, 3))
    res["cell-voltage-min"].set_value(round(cell_min, 3))
    res["module-1-temperature"].set_value(round(rack["temps"][0] + noise(0.05), 2))
    res["module-2-temperature"].set_value(round(rack["temps"][1] + noise(0.05), 2))
    res["rack-status"].set_value(rack["status"])


def update_enclosure(res):
    # The enclosure warms with the racks' combined current, with a 60 s time constant
    total_current = sum(abs(r["current"]) for r in racks.values())
    settle = 23.0 + 0.03 * total_current
    enclosure["temperature"] += (settle - enclosure["temperature"]) / 60.0
    enclosure["humidity"] = min(60.0, max(35.0, enclosure["humidity"] + noise(0.2)))
    res["enclosure-temperature"].set_value(round(enclosure["temperature"] + noise(0.05), 2))
    res["enclosure-humidity"].set_value(round(enclosure["humidity"], 1))


def set_initial(resources):
    for unit_id in racks:
        resources[unit_id]["current-setpoint"].set_value(0.0)
    update_values(resources)


def update_values(resources):
    for unit_id, rack in racks.items():
        update_rack(rack, resources[unit_id])
    update_enclosure(resources[1])
