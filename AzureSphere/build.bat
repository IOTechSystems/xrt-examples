set device=%1
set board=%2

copy deployment\profiles\profiles-%device%.json deployment\profiles\profiles.json /y
copy deployment\config\main-%device%.json deployment\config\main.json /y
copy deployment\config\azure-%device%.json deployment\config\azure.json /y
copy %board%\app_manifest.json app_manifest.json /y

mkdir build
cd build
cmake -G "Ninja" ^
  -DCMAKE_TOOLCHAIN_FILE="C:/Program Files (x86)/Microsoft Azure Sphere SDK/CMakeFiles/AzureSphereToolchain.cmake" ^
  -DAZURE_SPHERE_TARGET_TOOLS_REVISION="21.10" ^
  -DAZURE_SPHERE_TARGET_API_SET="11" ^
  -DDEVICE="%device%" ^
  -DBOARD="%board%" ^
  -DCMAKE_BUILD_TYPE="Debug" ..
ninja
cd ..

