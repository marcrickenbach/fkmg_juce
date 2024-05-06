## Setting Up a JUCE Project

This file serves as a hub of resources and guides for setting up JUCE projects in various environments. The goal is eventually to have a Dockerfile or Vagrant configuration for turnkey project setup within a container or Virtual Machine (Linux). 



# JUCE with CMake in VS Code

1. Make sure you have VS Code Installed (Link below).

2. Navigate to where you want to create your project folder and create a new directory:
```bash
$ mkdir projectName
$ cd projectName
$ touch .gitignore
$ mkdir libs
$ cd libs
$ git clone --recursive https://github.com/juce-framework/JUCE.git
$ mkdir plugin
$ cd plugin 
$ mkdir include
$ mkdir source
$ touch CMakeLists.txt
$ cd ..
$ touch CMakeLists.txt
$ code . # open folder in 
```

4. Verify that CMake is installed by opening up a new terminal in VS Code:
```bash
$ cmake --version
```

If not installed:
```bash
$ brew install cmake
$ cmake --version #verify new version was upgraded
```

If in need of upgrade:
```bash
$ brew upgrade cmake #verify new version was upgraded
```


Once the CMakeLists.txt has been created, open the file in VS Code from the File Explorer in the left pane (usually). 


6. Add the following to CMakeLists.txt:
```cmake
cmake_minimum_required(VERSION 3.22)

project(projectNameStarter) # Change name

set(CMAKE_CXX_STANDARD 23)

set(LIB_DIR ${CMAKE_CURRENT_SOURCE_DIR}/libs)

include(cmake/cpm.cmake)

CPMAddPackage(
    NAME JUCE
    GITHUB_REPOSITORY juce-framework/JUCE
    GIT_TAG 7.0.12
    VERSION 7.0.12
    SOURCE_DIR ${LIB_DIR}/juce
)

if (MSVC)
    add_compile_options(/Wall /WX)
else()
    add_compile_options(-Wall -Wextra -Wpedantic)
endif()

add_subdirectory(plugin)

```

7. Run CMake to build project
```bash
$ cmake -S . -B build
```
A successful build should result in the creation of the libs/ directory with a juce/ sub-directory. 


8. Copy JUCE templates into project
 ```bash
$ cd ~
$ cd include
$ cp ~/libs/juce/examples/CMake/AudioPlugin/PluginEditor.h
$ cp ~/libs/juce/examples/CMake/AudioPlugin/PluginProcessor.h
$ cd ..
$ cd source
$ cp ~/libs/juce/examples/CMake/AudioPlugin/PluginEditor.cpp
$ cp ~/libs/juce/examples/CMake/AudioPlugin/PluginProcessor.cpp
```

9. Open CMakeLists.txt in VS Code and copy the following:

```cmake
cmake_minimum_required(VERSION 3.22)

project(projectName VERSION 0.1.0) # version is required by JUCE

juce_add_plugin(${PROJECT_NAME}
    COMPANY_NAME your_company_name
    IS_SYNTH FALSE # or TRUE
    NEEDS_MIDI_INPUT FALSE # or TRUE
    NEEDS_MIDI_OUTPUT TRUE # or FALSE
    PLUGIN_MANUFACTURER_CODE CODE #Four Character
    PLUGIN_CODE AUPL
    FORMATS VST3 Standalone # check for other formats
    PRODUCT_NAME "ProductName"
)

target_sources(${PROJECT_NAME}
    PRIVATE
        source/PluginEditor.cpp
        source/PluginProcessor.cpp
)

target_include_directories(${PROJECT_NAME}
    PRIVATE
        include
)

target_link_libraries(${PROJECT_NAME}
    PRIVATE
        juce::juce_audio_basics
        juce::juce_audio_devices
        juce::juce_audio_formats
        juce::juce_audio_plugin_client
        juce::juce_audio_processors
        juce::juce_audio_utils
        juce::juce_core
        juce::juce_data_structures
        juce::juce_events
        juce::juce_graphics
        juce::juce_gui_basics
        juce::juce_gui_extra
        # Check to see if there are any other libraries you need

    PUBLIC
        juce::juce_recommended_config_flags
        juce::juce_recommended_lto_flags
        juce::juce_recommended_warning_flags
)

target_compile_definitions(${PROJECT_NAME}
    PUBLIC
        # Double Check these when starting a new project
        JUCE_WEB_BROWSER=0
        JUCE_USE_CURL=0
        JUCE_VST3_CAN_REPLACE_VST2=0
        # JUCE_WASAPI=1
        # JUCE_DIRECTSOUND=1
        # JUCE_ALSA=1
        # JUCE_USE_FLAC=1
        # JUCE_USE_OGGVORBIS=1
        # JUCE_USE_WINDOWS_MEDIA_FORMAT=1
        # JUCE_USE_STUDIO_ONE_COMPATIBLE_PARAMETERS=1
        # JUCE_CHECK_MEMORY_LEAKS=1
        # JUCE_INCLUDE_ZLIB_CODE=1
        # JUCE_STRICT_REFCOUNTEDPOINTER=1
        # JUCE_USE_COREIMAGE_LOADER=1
        # JUCE_USE_DIRECTWRITE=1
        # JUCE_USE_XRANDR=1
        # JUCE_USE_XINERAMA=1
        # JUCE_USE_XSHM=1
        # JUCE_USE_XCURSOR=1
        # JUCE_WIN_PER_MONITOR_DPI_AWARE=1
)

if(MSVC)
    target_compile_definitions(${PROJECT_NAME}
        PRIVATE
            _SILENCE_CXX23_ALIGNED_STORAGE_DEPRECATION_WARNING
    )
endif()
```

10. Open .gitignore file and add the following:
```bash
build/
libs/
```

11. Initialize git repository, commit changes and push.
 ```bash
$ git init
$ git add .
$ git commit -m "initial commit"
$ git push
```

Create a new repository on github if you want/need a remote repo and follow directions there to link the local git to the remote. 


## Resources
# Tutorials
WolfSound Tuturial : https://www.youtube.com/watch?v=Uq7Hwt18s3s

# Links
JUCE - https://juce.com/
CMake - https://cmake.org/
VS Code - https://code.visualstudio.com/

