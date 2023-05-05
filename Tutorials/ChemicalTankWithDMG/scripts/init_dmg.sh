#!/bin/bash

# Replace these with your actual values
username="iotech"
password="dmgAdmin123@"

. ./env-file.env
# Construct the GraphQL query
authQuery=$(cat authQuery.json)
modbusAddProfileMutation=$(cat modbusAddProfileMutation.json)
echo "$query"

# Send the GraphQL query to the endpoint and extract the token field
authReponse=$(curl -s -H "Content-Type: application/json" -X POST -d "$authQuery" http://localhost:9096/graphql)
token=$(echo $authReponse | sed -n 's/.*"result":"\([^"]*\)".*/\1/p')

addModbusProfileResponse=$(curl -s -H "Authorization: Bearer $token" -H "Content-Type: application/json" -X POST -d "$modbusAddProfileMutation" http://localhost:9096/graphql)
echo $addModbusProfileResponse

# Output the token value (optional)
echo $token