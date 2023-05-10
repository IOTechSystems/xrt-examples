#!/bin/bash

# Default admin login
username="iotech"
password="dmgAdmin123@"
dmgGQL=http://localhost:9096/graphql

# Source the demo's env file
. ./env-file.env

# When you use `envsubst` to substitute environment variables in a file, it
# needs you to provide a format string that tells it which variables to
# substitute. Else, it will blank out unknown environment variables. This
# function creates the format string for the envsubst command.
create_shell_format_string() {
  local file_path="$1"
  local shell_format_string=""

  # Read the file line by line
  while IFS= read -r line; do
    # Check if the line starts with "export" keyword
    if [[ $line == export* ]]; then
      # Remove the "export" keyword and whitespace from the line
      trimmed_line="${line#export }"

      # Extract the variable name from the line
      variable_name="${trimmed_line%%=*}"

      # Append the variable name to the shell format string
      shell_format_string+="\\\$${variable_name}, "
    fi
  done < "$file_path"

  # Remove the trailing comma and whitespace from the shell format string
  shell_format_string="${shell_format_string%, }"

  echo "${shell_format_string}"
}
envFormatString=$(create_shell_format_string ./env-file.env)

# Construct the GraphQL query
authQuery=$(envsubst "$envFormatString" < graphQLqueries/authQuery.json)
modbusAddProfileMutation=$(envsubst "$envFormatString" < graphQLqueries/modbusAddProfileMutation.json)
modbudAddDeviceMutation=$(envsubst "$envFormatString" < graphQLqueries/modbusAddDeviceMutation.json)
s7AddProfileMutation=$(envsubst "$envFormatString" < graphQLqueries/s7AddProfileMutation.json)
s7AddDeviceMutation=$(envsubst "$envFormatString" < graphQLqueries/s7AddDeviceMutation.json)

# Send the GraphQL query to the endpoint and extract the token field
authReponse=$(curl -s -H "Content-Type: application/json" \
                      -X POST \
                      -d "$authQuery" $dmgGQL)
token=$(echo $authReponse | sed -n 's/.*"result":"\([^"]*\)".*/\1/p')

addModbusProfileResponse=$(curl -s -H "Authorization: $token" \
                                   -H "Content-Type: application/json" \
                                   -X POST \
                                   -d "$modbusAddProfileMutation" $dmgGQL)
echo -e "ADD MODBUS PROFILE RESPONSE: \n$addModbusProfileResponse"

addModbusDeviceResponse=$(curl -s -H "Authorization: $token" \
                                  -H "Content-Type: application/json" \
                                  -X POST \
                                  -d "$modbudAddDeviceMutation" $dmgGQL)
echo -e "ADD MODBUS DEVICE RESPONSE: \n$addModbusDeviceResponse"

addS7ProfileResponse=$(curl -s -H "Authorization: $token" \
                                -H "Content-Type: application/json" \
                                -X POST \
                                -d "$s7AddProfileMutation" $dmgGQL)
echo -e "ADD S7 PROFILE RESPONSE: \n$addS7ProfileResponse"

addS7DeviceResponse=$(curl -s -H "Authorization: $token" \
                               -H "Content-Type: application/json" \
                               -X POST \
                               -d "$s7AddDeviceMutation" $dmgGQL)
echo -e "ADD S7 DEVICE RESPONSE: \n$addS7DeviceResponse"