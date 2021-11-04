# The CID is a unique identifier for the application. Replace with a
# new UUID if you wish to deploy the application from the cloud. The
# value does not need to be changed if you are only doing local
# sideloading for development and debugging.
CID=495c9398-a6af-49cd-84af-82eaf63fd929

BOARD?=mt3620-g100
DEVICE?=bacnet
BUILD_TYPE?=Release

# Default action will build, sideload and debug the example application
all: monitor-udp

# Build the application in a 'build' directory
build:
	if [ ! -d build ]; then mkdir build; fi
	cp config/profiles/profiles-$(DEVICE).json config/profiles/profiles.json; \
	cp config/azure-$(DEVICE).json config/azure.json; \
	cp $(BOARD)/app_manifest.json app_manifest.json; \
	(cd build && cmake -G "Ninja" \
        -DCMAKE_TOOLCHAIN_FILE="/opt/azurespheresdk/CMakeFiles/AzureSphereToolchain.cmake" \
        -DAZURE_SPHERE_TARGET_TOOLS_REVISION="21.02" \
        -DAZURE_SPHERE_TARGET_API_SET="8" \
        -DCMAKE_BUILD_TYPE=$(BUILD_TYPE) \
        -DBOARD=$(BOARD) \
        -DDEVICE=$(DEVICE) \
	.. && ninja)

# Deploy as a sideloaded application
deploy: build/xrt-app.imagepackage connect
	azsphere device sideload delete
	azsphere device sideload deploy --imagepackage build/xrt-app.imagepackage

# Start the application in debug mode
debug:  deploy
	azsphere device app stop --componentid ${CID}
	azsphere device app start --debug --componentid ${CID}

# Ensure the Guardian 100 is connected via USB. If not connected it
# will attempt to connect. Connect command is run using 'sudo' and
# may prompt for password entry.
connect:
	azsphere device show || sudo /opt/azurespheresdk/DeviceConnection/azsphere_connect.sh

# Uses telnet to observe log output from the application
monitor: debug
	telnet 192.168.35.2 2342

monitor-udp: deploy
	socat -u UDP-RECV:1999 STDOUT

build/xrt-app.imagepackage: build

clean:
	rm -rf build
