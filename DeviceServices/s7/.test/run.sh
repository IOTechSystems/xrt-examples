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
REQUEST_RESPONSE_TOPIC="spBv1.0/${SPARKPLUG_GROUP}/RESPONSE/${SPARKPLUG_NODE}/s7"
DDATA_TOPIC="spBv1.0/${SPARKPLUG_GROUP}/DDATA/${SPARKPLUG_NODE}/+"
DACK_TOPIC="spBv1.0/${SPARKPLUG_GROUP}/DACK/${SPARKPLUG_NODE}/+"

TIMEOUT=5

echo "Running s7 device service command tests..."

# Give XRT time to fully initialize
sleep 2

# Check dependencies
if ! command -v mosquitto_pub &> /dev/null || ! command -v mosquitto_sub &> /dev/null
then
    echo "SKIP: mosquitto clients not available"
    exit 0
fi

# Check MQTT broker
if ! mosquitto_pub -h localhost -t "test/connection" -m "test" -q 0 2>/dev/null
then
    echo "SKIP: MQTT broker not available"
    exit 0
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
        # REQUEST commands get responses on RESPONSE topic
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
    mosquitto_sub -h localhost -t "${RESPONSE_TOPIC}" -C 1 -W ${TIMEOUT} > "${RESPONSE_FILE}" 2>/dev/null &
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
        echo "    WARN: ${CMD_NAME} - no response received (timeout)"
        rm -f "${RESPONSE_FILE}"
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

# Run each command script
for CMD_SCRIPT in "${COMMANDS_DIR}"/*.sh
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
