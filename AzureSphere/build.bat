mkdir build
cd build
cmake -G "Ninja" -DCMAKE_TOOLCHAIN_FILE="C:/Program Files (x86)/Microsoft Azure Sphere SDK/CMakeFiles/AzureSphereToolchain.cmake" -DAZURE_SPHERE_TARGET_API_SET="7" -DCMAKE_BUILD_TYPE="Debug" ..
ninja
cd ..
