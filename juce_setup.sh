#!/bin/bash

# Stop on error
set -e

BASE_PATH=$(pwd)

if [ -z "$1" ]; then
    echo "Usage: $0 ProjectName"
    exit 1
fi

PROJECT_NAME=$1

echo "|/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/|"
echo "|--------->FKMG AUTOMATED JUCE BUILD SCRIPT<----------|"
echo "|/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/|"
echo "                                                       "

# Create Project directory and subdirectories
mkdir -p "$PROJECT_NAME"/{libs,plugin}
mkdir "$PROJECT_NAME"/.vscode

touch "$PROJECT_NAME"/.vscode/launch.json
touch "$PROJECT_NAME"/.vscode/settings.json
touch "$PROJECT_NAME"/.gitignore
touch "$PROJECT_NAME"/README.md

echo "# $PROJECT_NAME READ ME" > "$PROJECT_NAME"/README.md
echo "This is the README file for the $PROJECT_NAME project" >> "$PROJECT_NAME"/README.md
echo "To build the project, run the following commands:" >> "$PROJECT_NAME"/README.md
echo "cmake --build build" >> "$PROJECT_NAME"/README.md

echo "# This is the .gitignore file" > "$PROJECT_NAME"/.gitignore
echo "libs/JUCE/" >> "$PROJECT_NAME"/.gitignore
echo "build/" >> "$PROJECT_NAME"/.gitignore


cd $PROJECT_NAME/plugin
mkdir include source

echo "                                                       "
echo "Project Directories Created... "
echo "                                                       "

#Clone JUCE repository into libs directory
cd ../libs

if [ ! -d "JUCE" ]; then
    echo "Cloning JUCE repository..."
    git clone --recursive https://github.com/juce-framework/JUCE.git
else
    echo "JUCE directory already exists, skipping clone..."
fi

echo "                                                       "
echo "JUCE Repository Cloned... "
echo "                                                       "

# Copy JUCE templates into source folders
cd "${BASE_PATH}/${PROJECT_NAME}/plugin/include"
cp "${BASE_PATH}/${PROJECT_NAME}/libs/JUCE/examples/CMake/AudioPlugin/PluginEditor.h" .
cp "${BASE_PATH}/${PROJECT_NAME}/libs/JUCE/examples/CMake/AudioPlugin/PluginProcessor.h" .
cd "${BASE_PATH}/${PROJECT_NAME}/plugin/source"
cp "${BASE_PATH}/${PROJECT_NAME}/libs/juce/examples/CMake/AudioPlugin/PluginEditor.cpp" .
cp "${BASE_PATH}/${PROJECT_NAME}/libs/juce/examples/CMake/AudioPlugin/PluginProcessor.cpp" .

echo "                                                       "
echo "JUCE Templates Copied... "
echo "                                                       "


# Create CMakelists.txt files
cd "${BASE_PATH}/${PROJECT_NAME}/plugin"
touch CMakeLists.txt

cd "${BASE_PATH}/${PROJECT_NAME}"
touch CMakeLists.txt


# write to the CMakeLists.txt files

########### 

# Prompt user for inputs concerning juce_add_plugin paramters

read -p "Enter your company name (no spaces): " COMPANY_NAME
read -p "Is this a synth? (TRUE/FALSE): " IS_SYNTH
read -p "Does it need MIDI input? (TRUE/FALSE): " NEEDS_MIDI_INPUT
read -p "Does it need MIDI output? (TRUE/FALSE): " NEEDS_MIDI_OUTPUT
read -p "Enter plugin manufacturer code (Four Characters): " PLUGIN_MANUFACTURER_CODE
read -p "Enter plugin code (e.g., AUPL): " PLUGIN_CODE
read -p "Enter supported formats (e.g., VST3 Standalone): " FORMATS
read -p "Enter the product name (no spaces): " PRODUCT_NAME

cat << EOF > "${BASE_PATH}/${PROJECT_NAME}/plugin/CMakeLists.txt"

cmake_minimum_required(VERSION 3.22)

project($PROJECT_NAME VERSION 0.1.0) # version is required by JUCE

add_subdirectory(../libs/JUCE build)

set(CMAKE_CXX_STANDARD 20)

# Add JUCE plugin
juce_add_plugin($PROJECT_NAME
    COMPANY_NAME "$COMPANY_NAME"
    IS_SYNTH $IS_SYNTH
    NEEDS_MIDI_INPUT $NEEDS_MIDI_INPUT
    NEEDS_MIDI_OUTPUT $NEEDS_MIDI_OUTPUT
    PLUGIN_MANUFACTURER_CODE $PLUGIN_MANUFACTURER_CODE
    PLUGIN_CODE $PLUGIN_CODE
    FORMATS $FORMATS
    PRODUCT_NAME "$PRODUCT_NAME"
)

# Generate the JUCE header file
juce_generate_juce_header($PROJECT_NAME)

target_sources($PROJECT_NAME
    PRIVATE
        source/PluginEditor.cpp
        source/PluginProcessor.cpp
)

target_include_directories($PROJECT_NAME
    PRIVATE
        include
)

target_link_libraries($PROJECT_NAME
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

target_compile_definitions($PROJECT_NAME
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
    target_compile_definitions($PROJECT_NAME
        PRIVATE
            _SILENCE_CXX23_ALIGNED_STORAGE_DEPRECATION_WARNING
    )
endif()

EOF


cat << EOF > "${BASE_PATH}/${PROJECT_NAME}/CMakeLists.txt"

cmake_minimum_required(VERSION 3.22)

project($PROJECT_NAME)

set(CMAKE_CXX_STANDARD 20)

if (MSVC)
    add_compile_options(/Wall /WX)
else()
    add_compile_options(-Wall -Wextra -Wpedantic)
endif()

add_subdirectory(plugin)

EOF

echo "                                                       "
echo "CMakeLists.txt files created... "
echo "                                                       "


### Open the project in Visual Studio Code at the Project root directory
cd "${BASE_PATH}/${PROJECT_NAME}"
git init
git add .
git commit -m "initial commit"

echo "                                                       "
echo "Git Repository Created..."
echo "                                                       "

cmake -S . -B build
cmake --build build

echo "                                                       "
echo "Project Built... "
echo "Opening Project in new Visual Studio Code Window... "
echo "                                                       "

code .