# OpenVEILSamples
Short sample code using OpenVEIL

The samples in this repository are mostly commandline programs.  They can be built using any compiler that you can use to build OpenVEIL.  In fact the build process is the same as for OpenVEIL.

The VEIL system uses the CMAKE system to create the build environment needed to build the programs.  You can get CMAKE from cmake.org.  You version 3.2 or higher.  We use the out-of-source paradigm where the solutions/make files are put into a folder called build.  This folder will hold a number of scripts to make it easier to build the code and a folder for each compiler/configuration/processor.

There are a number of scripts in the "make" folder structure.  Currently there are subfolders for linux and windows.  

## Installation

We use an out of source build process.  The project/make files and output
can be found in the build folder that is created by the bootstrap.

### Requirements
- VEIL Cryptographic Library (Contact TecSec, Inc.)
- Windows
  - CMake 3.2+
  - Visual Studio 2013 or Visual Studio 2015 or mingw-w64.
- Linux
  - CMake 3.2+
  - GCC 4.8.2+
	
### Windows
	
1. Clone the repository
2. Go to the directory of the repository in a command prompt
3. `cd make\windows`
4. Run the following command to bootstrap x86 and x64(Debug and Release)
  - If Visual Studio 2015:
    - `bootstrap_VS2015.cmd`
  - If Visual Studio 2013:
    - `bootstrap_VS2013.cmd`
5. `cd ..\..\Build`
6. Run the following command to build x86 and x64(Debug and Release)
  - If Visual Studio 2015:
    - `buildall-vc14.cmd`
  - If Visual Studio 2013:
    - `buildall-vc12.cmd`
7. After the build is complete there should be a C:\TecSec\OpenVEIL_7-0 directory. Within that
directory there is a folder depending on which version of Visual Studio was used. Within that
directory there is a bin directory that has DLLs and executables for OpenVEIL. Directories
that end in 'd' were built with Debug.

If you are going to use mingw then copy the files in make\windows\mingw_support to a folder in your path.  Then modify the files so that they reference the path to the required mingw folder.  The files are currently configured as if you had installed the mingw system in the folder c:\mingw-w64.  To bootstrap a mingw environment use the following:

`cd make\windows`

`bootstrap_mingw 4.8.2w x64`

This will use the file UseGcc4.8.2w.cmd to configure the path and then create the makefiles needed to build the samples.  In this command the 4.8.2 is the version of GCC.  The 'w' represents 'win32' threads.  Replace this with a 'p' if you are using pthreads.  The x64 is the processor type.  This could be replaced with x86 for 32 bit.

### Linux

Under Linux we support gcc but you may be able to use any compiler that cmake supports.  Note however that you must use a C++11 compiler.  The lowest version that we have tested is GCC 4.8.2.
