cmake_minimum_required (VERSION 3.10)
project (xrt-app C)

if (IS_DIRECTORY "/opt/azurespheresdk")
  set (SDK_ROOT "/opt/azurespheresdk")
else ()
  set (SDK_ROOT "C:/Program Files (x86)/Microsoft Azure Sphere SDK")
endif ()

azsphere_configure_tools (TOOLS_REVISION "${AZURE_SPHERE_TARGET_TOOLS_REVISION}")
azsphere_configure_api (TARGET_API_SET "${AZURE_SPHERE_TARGET_API_SET}")
set (SYSROOT "${SDK_ROOT}/Sysroots/${AZURE_SPHERE_TARGET_API_SET}")

#########################################
# Copying of Device Specific Config JSON
#########################################
set(DEVICE_CONFIGS_DIR "${CMAKE_SOURCE_DIR}/config")

##############################################
# Copying of Board Specific App Manifest JSON
##############################################
set(BOARD_APP_MANIFEST_FILENAME "app_manifest.json")
set(BOARD_APP_MANIFEST_SRC_DIR "${CMAKE_SOURCE_DIR}/${BOARD}/${BOARD_APP_MANIFEST_FILENAME}")
set(BOARD_APP_MANIFEST_DST_DIR "${CMAKE_SOURCE_DIR}/${BOARD_APP_MANIFEST_FILENAME}")
set(MAIN_FILENAME "main.json")
set(MAIN_CFG_DIR_SRC "${CMAKE_SOURCE_DIR}/config/main-${DEVICE}.json")
set(MAIN_CFG_DIR_DST "${CMAKE_SOURCE_DIR}/config/${MAIN_FILENAME}")
set(AZURE_FILENAME "azure.json")
set(AZURE_CFG_DIR_SRC "${CMAKE_SOURCE_DIR}/config/azure-${DEVICE}.json")
set(AZURE_CFG_DIR_DST "${CMAKE_SOURCE_DIR}/config/${AZURE_FILENAME}")

add_custom_command(
  OUTPUT ${BOARD_APP_MANIFEST_DST_DIR}
  OUTPUT ${MAIN_CFG_DIR_DST} 
  OUTPUT ${AZURE_CFG_DIR_DST}
  PRE_BUILD
  COMMAND ${CMAKE_COMMAND} ARGS -E copy_if_different ${BOARD_APP_MANIFEST_SRC_DIR} ${BOARD_APP_MANIFEST_DST_DIR}
  COMMAND ${CMAKE_COMMAND} ARGS -E copy_if_different ${MAIN_CFG_DIR_SRC} ${MAIN_CFG_DIR_DST}
  COMMAND ${CMAKE_COMMAND} ARGS -E copy_if_different ${AZURE_CFG_DIR_SRC} ${AZURE_CFG_DIR_DST}
)

add_executable (${PROJECT_NAME} main.c)

target_link_libraries (${PROJECT_NAME} ${SYSROOT}/opt/iotech/xrt/${XRT_VERSION}/lib/libxrt-azure-exporter.a)
target_link_libraries (${PROJECT_NAME} ${SYSROOT}/opt/iotech/xrt/${XRT_VERSION}/lib/libxrt-log-exporter.a)

message (STATUS "Building for ${BOARD} with ${DEVICE} device service")

if (${BOARD} STREQUAL "mt3620-g100")
  target_link_libraries (${PROJECT_NAME} ${SYSROOT}/opt/iotech/xrt/${XRT_VERSION}/lib/libxrt-mt3620-g100-device.a)
  set (TARGET_CONFIG "mt3620.json")
elseif (${BOARD} STREQUAL "mt3620-dk")
  target_link_libraries (${PROJECT_NAME} ${SYSROOT}/opt/iotech/xrt/${XRT_VERSION}/lib/libxrt-mt3620-dk-device.a)
  set (TARGET_CONFIG "mt3620_rdb.json")
elseif (${BOARD} STREQUAL "mt3620-sk")
  target_link_libraries (${PROJECT_NAME} ${SYSROOT}/opt/iotech/xrt/${XRT_VERSION}/lib/libxrt-mt3620-sk-device.a)
  set (TARGET_CONFIG "avnet_mt3620_sk.json")
elseif (${BOARD} STREQUAL "mt3620-sr620")
  target_link_libraries (${PROJECT_NAME} ${SYSROOT}/opt/iotech/xrt/${XRT_VERSION}/lib/libxrt-mt3620-sr620-device.a)
  set (TARGET_CONFIG "ailink_wfm620rsc1.json")
endif ()

if (${DEVICE} STREQUAL "ethernetip")
  target_link_libraries (${PROJECT_NAME} ${SYSROOT}/opt/iotech/xrt/${XRT_VERSION}/lib/libxrt-ethernet-ip-device-service.a)
  set (DEVICE_CONFIG "config/ethernetip.json" "config/profiles/Allen-Bradley-Azure.json"  "config/azure-ethernetip.json")
  set (DRIVER ethernet-ip)
  add_definitions ("-DDEVICE_ETHERNETIP")
elseif (${DEVICE} STREQUAL "modbus")
  target_link_libraries (${PROJECT_NAME} ${SYSROOT}/opt/iotech/xrt/${XRT_VERSION}/lib/libxrt-modbus-device-service.a)
  set (DEVICE_CONFIG "config/modbus.json" "config/profiles/Damocles2-Mini.json" "config/azure-modbus.json")
  set (DRIVER modbus)
  add_definitions ("-DDEVICE_MODBUS")
elseif (${DEVICE} STREQUAL "bacnet")
  target_link_libraries (${PROJECT_NAME} ${SYSROOT}/opt/iotech/xrt/${XRT_VERSION}/lib/libxrt-bacnet-ip-device-service.a)
  set (DEVICE_CONFIG "config/bacnet.json" "config/profiles/bacnet-simulator.json" "config/azure-bacnet.json")
  set (DRIVER bacnet-ip)
  add_definitions ("-DDEVICE_BACNET")
elseif (${DEVICE} STREQUAL "virtual")
  target_link_libraries (${PROJECT_NAME} ${SYSROOT}/opt/iotech/xrt/${XRT_VERSION}/lib/libxrt-virtual-device-service.a)
  set (DEVICE_CONFIG "config/virtual.json" "config/profiles/device-virtual.json" "config/azure-virtual.json")
  add_definitions ("-DDEVICE_VIRTUAL")
endif ()

add_custom_command(
  OUTPUT ${MAIN_CFG_DIR_DST} 
  OUTPUT ${AZURE_CFG_DIR_DST}
  PRE_BUILD 
  COMMAND ${CMAKE_COMMAND} ARGS -E copy_if_different ${MAIN_CFG_DIR_SRC} ${MAIN_CFG_DIR_DST}
  COMMAND ${CMAKE_COMMAND} ARGS -E copy_if_different ${AZURE_CFG_DIR_SRC} ${AZURE_CFG_DIR_DST}

)

target_link_libraries (${PROJECT_NAME} ${SYSROOT}/opt/iotech/xrt/${XRT_VERSION}/lib/libxrt-devsdk.a)
target_link_libraries (${PROJECT_NAME} ${SYSROOT}/opt/iotech/xrt/${XRT_VERSION}/lib/libxrt.a)
target_link_libraries (${PROJECT_NAME} ${SYSROOT}/opt/iotech/iot/${IOT_VERSION}/lib/libiot.a)
target_link_libraries (${PROJECT_NAME} ${DRIVER} applibs azureiot curl pthread gcc_s c)

target_include_directories (${PROJECT_NAME} PRIVATE ${SYSROOT}/opt/iotech/xrt/${XRT_VERSION}/include/)
target_include_directories (${PROJECT_NAME} PRIVATE ${SYSROOT}/opt/iotech/iot/${IOT_VERSION}/include/)

azsphere_target_hardware_definition (${PROJECT_NAME} TARGET_DIRECTORY "${SDK_ROOT}/HardwareDefinitions" TARGET_DEFINITION ${TARGET_CONFIG})
azsphere_target_add_image_package (${PROJECT_NAME} RESOURCE_FILES "config/azure.json" "config/main.json" "config/logger.json" "config/pool.json" "config/scheduler.json" "config/bus.json" "config/logexport.json" "config/mt3620.json" ${DEVICE_CONFIG} "config/profiles/profiles.json")

