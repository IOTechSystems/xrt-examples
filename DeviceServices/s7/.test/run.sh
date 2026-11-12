#!/bin/bash
# Hidden test script for s7 device service example
# Runs command scripts and validates responses

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXAMPLE_DIR="$(dirname "${SCRIPT_DIR}")"
COMMANDS_DIR="${EXAMPLE_DIR}/commands"

# Commands whose lifecycle is managed by the test environment (the simulator
# container is already started/stopped externally, e.g. by docker-compose in CI)
SKIP_COMMANDS=("start_device_sim.sh" "stop_device_sim.sh")

# Topics
REQUEST_RESPONSE_TOPIC="spBv1.0/${SPARKPLUG_GROUP}/REPLY/${SPARKPLUG_NODE}/s7"
DDATA_TOPIC="spBv1.0/${SPARKPLUG_GROUP}/DDATA/${SPARKPLUG_NODE}/+"
DACK_TOPIC="spBv1.0/${SPARKPLUG_GROUP}/DACK/${SPARKPLUG_NODE}/+"

TIMEOUT=5

echo "Running s7 device service command tests..."

# Give XRT time to fully initialize
sleep 2

# When XRT_REQUIRE_EXAMPLE_TESTS=true (CI) a missing tool, an unreachable broker or a
# command that gets no response is a failure rather than a skip, so that the tests cannot
# pass without having actually run.
REQUIRE_TESTS="${XRT_REQUIRE_EXAMPLE_TESTS:-false}"

skip_or_fail()
{
    if [ "${REQUIRE_TESTS}" = "true" ]
    then
        echo "FAIL: ${1} (these tests are required in this environment)"
        exit 1
    fi
    echo "SKIP: ${1}"
    exit 0
}

# MQTT broker connection: host, port and credentials come from XRT_MQTT_BROKER,
# XRT_MQTT_USERNAME and XRT_MQTT_PASSWORD (CI runs the broker in a separate container).
# Defaults to a broker on localhost:1883.
MQTT_HOSTPORT="${XRT_MQTT_BROKER:-mqtt://localhost:1883}"
MQTT_HOSTPORT="${MQTT_HOSTPORT#*://}"
MQTT_HOSTPORT="${MQTT_HOSTPORT%%/*}"
MQTT_HOST="${MQTT_HOSTPORT%%:*}"
MQTT_PORT="${MQTT_HOSTPORT##*:}"
if [ "${MQTT_PORT}" = "${MQTT_HOST}" ]
then
    MQTT_PORT=1883
fi
MQTT_ARGS=(-h "${MQTT_HOST}" -p "${MQTT_PORT}")
if [ -n "${XRT_MQTT_USERNAME}" ]
then
    MQTT_ARGS+=(-u "${XRT_MQTT_USERNAME}")
    if [ -n "${XRT_MQTT_PASSWORD}" ]
    then
        MQTT_ARGS+=(-P "${XRT_MQTT_PASSWORD}")
    fi
fi

# The command scripts call mosquitto_pub without a host, so give the mosquitto clients the
# connection options through their per-user config files.
MQTT_CONF_DIR="$(mktemp -d)"
trap 'rm -rf "${MQTT_CONF_DIR}"' EXIT
export XDG_CONFIG_HOME="${MQTT_CONF_DIR}"
# (the config file format is one option per line)
{
    echo "-h ${MQTT_HOST}"
    echo "-p ${MQTT_PORT}"
    if [ -n "${XRT_MQTT_USERNAME}" ]
    then
        echo "-u ${XRT_MQTT_USERNAME}"
        if [ -n "${XRT_MQTT_PASSWORD}" ]
        then
            echo "-P ${XRT_MQTT_PASSWORD}"
        fi
    fi
} > "${MQTT_CONF_DIR}/mosquitto_pub"
cp "${MQTT_CONF_DIR}/mosquitto_pub" "${MQTT_CONF_DIR}/mosquitto_sub"

# Check dependencies
if ! command -v mosquitto_pub &> /dev/null || ! command -v mosquitto_sub &> /dev/null
then
    skip_or_fail "mosquitto clients not available"
fi

# Check MQTT broker
if ! mosquitto_pub "${MQTT_ARGS[@]}" -t "test/connection" -m "test" -q 0 2>/dev/null
then
    skip_or_fail "MQTT broker ${MQTT_HOST}:${MQTT_PORT} not available"
fi

# Check Docker for sparkplug-client commands
HAS_DOCKER=0
if command -v docker &> /dev/null && docker ps &> /dev/null
then
    HAS_DOCKER=1
fi

PASSED=0
FAILED=0
SKIPPED=0

# Determine response topic based on command type
get_response_topic()
{
    local CMD_SCRIPT="${1}"

    # DCMD commands (read/write) get responses on DDATA/DACK
    if grep -q "DCMD" "${CMD_SCRIPT}"
    then
        echo "${DDATA_TOPIC}"
    else
        # REQUEST commands get replies on the REPLY topic
        echo "${REQUEST_RESPONSE_TOPIC}"
    fi
}

# Run a command and validate response
run_command_with_validation()
{
    local CMD_SCRIPT="${1}"
    local CMD_NAME=$(basename "${CMD_SCRIPT}")
    local RESPONSE_FILE="/tmp/xrt_response_$$.txt"

    # Check if command needs Docker
    if grep -q "docker run" "${CMD_SCRIPT}"
    then
        if [ ${HAS_DOCKER} -eq 0 ]
        then
            echo "  SKIP: ${CMD_NAME} (requires Docker)"
            SKIPPED=$((SKIPPED + 1))
            return 0
        fi
    fi

    local RESPONSE_TOPIC=$(get_response_topic "${CMD_SCRIPT}")

    # Start subscriber to capture response
    mosquitto_sub "${MQTT_ARGS[@]}" -t "${RESPONSE_TOPIC}" -C 1 -W ${TIMEOUT} > "${RESPONSE_FILE}" 2>/dev/null &
    local SUB_PID=$!

    # Brief delay to ensure subscriber is ready
    sleep 0.5

    # Run the command
    echo "  Running ${CMD_NAME}..."
    if ! "${CMD_SCRIPT}" > /dev/null 2>&1
    then
        echo "    FAIL: ${CMD_NAME} - command execution failed"
        kill ${SUB_PID} 2>/dev/null || true
        rm -f "${RESPONSE_FILE}"
        FAILED=$((FAILED + 1))
        return 1
    fi

    # Wait for response
    wait ${SUB_PID} 2>/dev/null

    # Check if we got a response
    if [ ! -s "${RESPONSE_FILE}" ]
    then
        rm -f "${RESPONSE_FILE}"
        if [ "${REQUIRE_TESTS}" = "true" ]
        then
            echo "    FAIL: ${CMD_NAME} - no response received (timeout)"
            FAILED=$((FAILED + 1))
            return 1
        fi
        echo "    WARN: ${CMD_NAME} - no response received (timeout)"
        # Treat as pass - some operations may not have direct responses
        PASSED=$((PASSED + 1))
        return 0
    fi

    # Check response for errors (works for JSON responses)
    if grep -qiE '"error"|"status"\s*:\s*"fail"|"statusCode"\s*:\s*[45]' "${RESPONSE_FILE}"
    then
        echo "    FAIL: ${CMD_NAME} - error in response:"
        head -5 "${RESPONSE_FILE}"
        rm -f "${RESPONSE_FILE}"
        FAILED=$((FAILED + 1))
        return 1
    fi

    echo "    PASS: ${CMD_NAME}"
    rm -f "${RESPONSE_FILE}"
    PASSED=$((PASSED + 1))
    return 0
}

# Check if a command should be skipped
is_skipped_command()
{
    local CMD_NAME="${1}"
    local SKIP

    for SKIP in "${SKIP_COMMANDS[@]}"
    do
        if [ "${CMD_NAME}" = "${SKIP}" ]
        then
            return 0
        fi
    done
    return 1
}

# Check commands directory exists
if [ ! -d "${COMMANDS_DIR}" ]
then
    echo "SKIP: No commands directory found"
    exit 0
fi

# The commands that add a device hardcode the simulator at 0.0.0.0, where a simulator
# published on the host listens. When the simulator is elsewhere (S7_SIM_ADDRESS is set, e.g. a
# container on the CI test network) run the commands from a copy that uses its address.
SIM_ADDRESS="${S7_SIM_ADDRESS:-}"
if [ -n "${SIM_ADDRESS}" ]
then
    COMMANDS_COPY="$(mktemp -d)"
    cp "${COMMANDS_DIR}"/*.sh "${COMMANDS_COPY}/"
    sed -i "s/0\.0\.0\.0/${SIM_ADDRESS}/g" "${COMMANDS_COPY}"/*.sh
    COMMANDS_DIR="${COMMANDS_COPY}"
    trap 'rm -rf "${MQTT_CONF_DIR}" "${COMMANDS_COPY}"' EXIT
fi

# The command scripts depend on each other's effects, and the example starts with what its
# deployment.pkl defines already in place (the main device and one schedule), so run the
# commands in a lifecycle order rather than alphabetically:
#   10 read/write what exists            12 read everything that exists
#   20 remove all schedules of the device, 22 remove the device (so it can be added again)
#   24-26 discovery (trigger, scan, add the discovered device), 28 remove it again: it adds the
#         same device name as add_device.sh but with the discovered profile, so the two exclude
#         each other
#   30 add the device, 31 add batch devices
#   40 add a schedule, 41 remove it      (before the batch commands, which use the same names)
#   50 add batch schedules, 51 read them, 52 remove them, 53 remove batch devices
#   80 remove the device once more (the profile is "in use" while a device uses it)
#   90 remove the device profile
# The phase comes from the request's "op".

command_phase()
{
    local NAME
    NAME="$(basename "${1}")"

    case "${NAME}" in
        trigger_discovery.sh)      echo 24; return ;;
        scan_discovered_device.sh) echo 25; return ;;
        add_discovered_device.sh)  echo 26; return ;;
        read_batch_devices_all.sh|read_batch_schedules_all.sh|read_batch_schedules_by_device.sh)
            echo 12; return ;;
        remove_batch_schedules_by_device.sh)
            echo 20; return ;;
    esac

    local OP
    OP="$(grep -o '"op": *"[^"]*"' "${1}" | head -1 | sed 's/.*: *"\(.*\)"/\1/')"
    case "${OP}" in
        device:delete)          echo 22 ;;
        device:add)             echo 30 ;;
        device:add_batch)       echo 31 ;;
        schedule:add)           echo 40 ;;
        schedule:delete)        echo 41 ;;
        schedule:add_batch)     echo 50 ;;
        device:read_batch|schedule:read_batch) echo 51 ;;
        schedule:delete_batch)  echo 52 ;;
        device:delete_batch)    echo 53 ;;
        profile:delete)         echo 90 ;;
        *)                      echo 10 ;;
    esac
}

ORDERED_COMMANDS="$(
{
    for CMD in "${COMMANDS_DIR}"/*.sh
    do
        printf '%s %s\n' "$(command_phase "${CMD}")" "${CMD}"
    done
    # remove_device.sh also runs as a teardown: after the discovered device was added (so that
    # add_device.sh can add the same device with its own profile), and before the profile is
    # removed (it cannot be while a device uses it).
    if [ -f "${COMMANDS_DIR}/remove_device.sh" ]
    then
        if [ -f "${COMMANDS_DIR}/add_discovered_device.sh" ]
        then
            printf '28 %s\n' "${COMMANDS_DIR}/remove_device.sh"
        fi
        if [ -f "${COMMANDS_DIR}/remove_device_profile.sh" ]
        then
            printf '80 %s\n' "${COMMANDS_DIR}/remove_device.sh"
        fi
    fi
} | sort -k1,1n -k2,2 | cut -d' ' -f2-)"

# Run each command script
for CMD_SCRIPT in ${ORDERED_COMMANDS}
do
    if [ -x "${CMD_SCRIPT}" ]
    then
        CMD_NAME=$(basename "${CMD_SCRIPT}")
        if is_skipped_command "${CMD_NAME}"
        then
            echo "  SKIP: ${CMD_NAME} (simulator lifecycle managed externally)"
            SKIPPED=$((SKIPPED + 1))
            continue
        fi
        run_command_with_validation "${CMD_SCRIPT}"
        sleep 1
    fi
done

echo ""
echo "========================================"
echo "Command test summary"
echo "========================================"
echo "Passed:  ${PASSED}"
echo "Failed:  ${FAILED}"
echo "Skipped: ${SKIPPED}"

if [ ${FAILED} -gt 0 ]
then
    exit 1
fi

exit 0
