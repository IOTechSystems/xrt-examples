cmake_minimum_required (VERSION 3.10)
project (xrt-app C)

if (${CMAKE_SYSTEM_NAME} MATCHES "Windows")
  set (SDK_ROOT "C:/Program Files (x86)/Microsoft Azure Sphere SDK")
else
  set (SDK_ROOT "/opt/azurespheresdk")
endif ()

azsphere_configure_tools (TOOLS_REVISION "20.10")
azsphere_configure_api (TARGET_API_SET "${AZURE_SPHERE_TARGET_API_SET}")
set (SYSROOT "${SDK_ROOT}/Sysroots/${AZURE_SPHERE_TARGET_API_SET}")

add_executable (${PROJECT_NAME} main.c)

target_link_libraries (${PROJECT_NAME} ${SYSROOT}/opt/iotech/xrt/lib/libxrt-azure-exporter.a)
target_link_libraries (${PROJECT_NAME} ${SYSROOT}/opt/iotech/xrt/lib/libxrt-influxdb-exporter.a)
target_link_libraries (${PROJECT_NAME} ${SYSROOT}/opt/iotech/xrt/lib/libxrt-log-exporter.a)
target_link_libraries (${PROJECT_NAME} ${SYSROOT}/opt/iotech/xrt/lib/libxrt-transform.a)
target_link_libraries (${PROJECT_NAME} ${SYSROOT}/opt/iotech/xrt/lib/libxrt-lua-transform.a lua)

target_link_libraries (${PROJECT_NAME} ${SYSROOT}/opt/iotech/xrt/lib/libxrt-mt3620-g100-device.a)
set (TARGET_CONFIG "mt3620.json")

target_link_libraries (${PROJECT_NAME} ${SYSROOT}/opt/iotech/xrt/lib/libxrt-modbus-device-service.a)
set (DEVICE_CONFIG "config/modbus.json" "config/profiles/Damocles2-Mini.json")
set (DRIVER modbus)
add_definitions ("-DDEVICE_MODBUS")

target_link_libraries (${PROJECT_NAME} ${SYSROOT}/opt/iotech/xrt/lib/libxrt-devsdk.a)
target_link_libraries (${PROJECT_NAME} ${SYSROOT}/opt/iotech/xrt/lib/libxrt.a)
target_link_libraries (${PROJECT_NAME} ${SYSROOT}/opt/iotech/iot/lib/libiot.a)
target_link_libraries (${PROJECT_NAME} ${SYSROOT}/opt/iotech/thrift/lib/libthrift.a)
target_link_libraries (${PROJECT_NAME} ${SYSROOT}/opt/iotech/thrift/lib/libthrift-tcp.a)
target_link_libraries (${PROJECT_NAME} ${DRIVER} applibs azureiot curl pthread gcc_s c)

target_include_directories (${PROJECT_NAME} PRIVATE ${SYSROOT}/opt/iotech/xrt/include/)
target_include_directories (${PROJECT_NAME} PRIVATE ${SYSROOT}/opt/iotech/iot/include/)

azsphere_target_hardware_definition (${PROJECT_NAME} TARGET_DIRECTORY "${SDK_ROOT}/HardwareDefinitions" TARGET_DEFINITION ${TARGET_CONFIG})
azsphere_target_add_image_package (${PROJECT_NAME} RESOURCE_FILES "config/main.json" "config/azure.json" "config/logger.json" "config/pool.json" "config/scheduler.json" "config/bus.json" "config/logexport.json" "config/lua.json" "config/transform.lua" ${DEVICE_CONFIG} "config/profiles/profiles.json")
