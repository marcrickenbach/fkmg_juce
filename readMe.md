# Setting Up a JUCE Project

This file serves as a hub of resources and guides for setting up JUCE projects in various environments. The goal is eventually to have a Dockerfile or Vagrant configuration for turnkey project setup within a container or Virtual Machine (Linux). 


## JUCE with CMake in VS Code (MacOS)
These instructions will automatically build a JUCE Plugin template. First you'll want to verify that you have the correct tools, including CMake. This is a work in progress, so please raise an issue if tools need to be verified by the script to make the build as hands-off as possible. 

First, verify that CMake is installed by opening up a new terminal in VS Code:
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

### Running Build Task
Once CMake is verified, open a terminal in VS Code at the folder in which you wish to set up your JUCE plugin. 

1. Open the VSCode Command Palette (MacOS: CMD + SHIFT + P)
2. Start typing and/or select "Tasks: Run Task" and press return.
3. Select "Setup JUCE Project" and press return.
4. You will be prompted to enter your project name with NO SPACES. Press return. 
5. You will be prompted to enter project details in the terminal. Follow the prompts and avoid using spaces. FORMATS can include the following: VST VST3 AU AAX Standalone. Consult JUCE Documentation for more details. 
6. The script will build both the environment and the plugin. When the build is completed, a new VS Code window will open at the project folder. 

A git repository is automatically built at the project level. Create a new repository on GitHub and follow directions to link the local repository to the remote one. 



## Orientation

This only serves as a brief orientation. For more detailed information and examples, refer to the official JUCE documentation and their tutorials, begnining here: https://docs.juce.com/master/tutorial_code_basic_plugin.html

Each project begins with two core template source files and their respective headers:
* PluginEditor.cpp
* PluginEditor.h
* PluginProcessor.cpp
* PluginProcessor.h

All audio processing is handled from the processBlock() method in the PluginProcessor.cpp file. This is where all audio and MIDI data is received and produced. 

All GUI components are handled in PluginEditor.cpp.

A Listener is assigned to each control in the PluginEditor.cpp constructor.



## JUCE with Projucer (MacOS)
Building a JUCE application with Projucer, JUCE's own Build System, on MacOS requires XCode (see above for instructions on how to build with CMake).

After selecting the appropriate template from which to start to start your project, Projucer will open to a screen of code along with a left side panel containing three sections: File Explorer, Modules and Exporters. To get started, nothing needs to be changed here. 

XCode defaults as the IDE on MacOS. The XCode exporter will appear at the top of the screen next to the dropdown menu for "Selected exporter". Click the icon to open up the produced code in the IDE. 

One thing to note if going this route: for some reason, JUCE names the main files differently when produced by Projucer than in the CMake schema above. Three files are produced here:
* Main.c
* MainComponent.c
* MainComponent.h

WARNING: You should never add, rename, and/or remove source files from JUCE projects inside your native IDE (such as Xcode, Visual Studio). These changes would be overwritten the next time you save the project in Projucer (which re-generates the native IDE projects every time). Instead, always use the Projucer itself to make such changes. (from JUCE Documenation)

All audio processing is handled in getNextAudioBlock() in MainComponent.c/ 
All GUI components are handled in paint(). 

[note: haven't yet worked directly with a Projucer produced project, this will be updated as I move forward]. 



## Debugging

JUCE offers a plug-in host for testing. The .jucer file for this host application is available in JUCE > extras > AudioPluginHost > AudioPluginHost.jucer. Open this file with Projucer, Save Project and Open in IDE then build the project in the IDE of your choice (XCode, VisualStudio, etc.).

Then goto Options > Edit the List of Available Plug-ins to scan for new plugins on your system (presumably the one you've just built). 



# Resources
* JUCE Documentation : https://docs.juce.com/master/index.html
* JUCE Tutorials : https://juce.com/learn/tutorials/

## Links
* JUCE - https://juce.com/
* CMake - https://cmake.org/
* VSCode - https://code.visualstudio.com/

