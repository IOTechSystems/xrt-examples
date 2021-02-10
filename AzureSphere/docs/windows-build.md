# Building On Windows

## Building Using Visual Studio

1. Create a new Project. Search for the "azure sphere" template, then select "Azure Sphere Blink"

2. In the generated project directory from this example:

* Copy the provided config directory into the project
* Overwrite CMakeLists.txt, app_manifest.json and main.c with the files provided
* Edit CMakeSettings.json and set "AZURE_SPHERE_TARGET_API_SET" to "7"

3. Create the CMake build configuration
4. Build the application with the "Build" menu

## Building Using Visual Studio Command Prompt

Run the build.bat batch file. This should build the application image in a build sub directory.

