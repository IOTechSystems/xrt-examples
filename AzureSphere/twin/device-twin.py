#!/usr/bin/python3

import sys
import os
from azure.iot.hub import IoTHubRegistryManager
from azure.iot.hub.models import Twin, TwinProperties

iothub_connection_str = os.getenv("IOTHUB_CONNECTION_STRING")
device_id = os.getenv("IOTHUB_DEVICE_ID")

try:

  # Change udp-logger level to debug

  registry_manager = IoTHubRegistryManager.from_connection_string(iothub_connection_str)

  device_twin = registry_manager.get_twin(device_id)

  logger_twin_patch = Twin()
  logger_twin_patch.properties = TwinProperties(
    desired={
      "Components": {
        "udp-logger": {
          "Level":"debug"
        }
      }
    }
  )

  registry_manager.update_twin(device_id, logger_twin_patch)

  # Add a device resource

  twin_profiles = device_twin.properties.desired["Services"]["bacnet_device_service"]["Profiles"]

  for key, profile in enumerate(twin_profiles):
    if profile.get("name") == "bacnet-simulator":
      profile["deviceResources"].append({
        "attributes": {
           "instance": "100",
           "property": "85",
           "type": "0"
        },
        "name": "BinaryInput100",
        "properties": {
          "value": {
          "readWrite": "R",
          "type": "float32"
          }
        }
      })

  profiles_twin_patch = Twin()
  profiles_twin_patch.properties = TwinProperties(
    desired={
      "Services": {
        "bacnet_device_service": {
          "Profiles": twin_profiles
        }
      }
    }
  )

  registry_manager.update_twin(device_id, profiles_twin_patch)

  # Add a Schedule

  twin_schedules = device_twin.properties.desired["Services"]["bacnet_device_service"]["Schedules"]
  twin_schedules.append({
    "device": "bacsim2",
    "resource": "InputsValues",
    "interval": 6000000
  })

  schedule_twin_patch = Twin()
  schedule_twin_patch.properties = TwinProperties(
    desired={
      "Services": {
        "bacnet_device_service": {
          "Schedules": twin_schedules
        }
      }
    }
  )

  registry_manager.update_twin(device_id, schedule_twin_patch)

  # Remove a Schedule

  device_twin = registry_manager.get_twin(device_id)

  twin_schedules = device_twin.properties.desired["Services"]["bacnet_device_service"]["Schedules"]

  schedules_to_keep = []

  for twin_schdeule in twin_schedules:
    if twin_schdeule.get("device") != "bacsim2":
      schdeules_to_keep.append(twin_schdeule)

  schedule_twin_patch = Twin()
  schedule_twin_patch.properties = TwinProperties(
    desired={
      "Services": {
        "bacnet_device_service": {
          "Schedules": schedules_to_keep
        }
      }
    }
  )

  registry_manager.update_twin(device_id, schedule_twin_patch)

except Exception as ex:
  print("Unexpected error {0}".format(ex))
except KeyboardInterrupt:
  print("device twin stopped")

