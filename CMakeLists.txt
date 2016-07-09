#	Copyright (c) 2016, TecSec, Inc.
#
#	Redistribution and use in source and binary forms, with or without
#	modification, are permitted provided that the following conditions are met:
#	
#		* Redistributions of source code must retain the above copyright
#		  notice, this list of conditions and the following disclaimer.
#		* Redistributions in binary form must reproduce the above copyright
#		  notice, this list of conditions and the following disclaimer in the
#		  documentation and/or other materials provided with the distribution.
#		* Neither the name of TecSec nor the names of the contributors may be
#		  used to endorse or promote products derived from this software 
#		  without specific prior written permission.
#		 
#	ALTERNATIVELY, provided that this notice is retained in full, this product
#	may be distributed under the terms of the GNU General Public License (GPL),
#	in which case the provisions of the GPL apply INSTEAD OF those given above.
#		 
#	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
#	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
#	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#	DISCLAIMED.  IN NO EVENT SHALL TECSEC BE LIABLE FOR ANY 
#	DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
#	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#	LOSS OF USE, DATA OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
#	ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
#	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# Written by Roger Butler

IF(WIN32)
	cmake_minimum_required(VERSION 3.2)
	set_property(GLOBAL PROPERTY USE_FOLDERS On)
ELSE()
	cmake_minimum_required(VERSION 3.2)
ENDIF()
cmake_policy(SET CMP0048 NEW)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmakemodules")

set(CMAKE_BUILD_TYPE ${TS_VS_CONFIG} CACHE STRING "The configuration build type")
if (CMAKE_CONFIGURATION_TYPES)
  set (CMAKE_CONFIGURATION_TYPES ${TS_VS_CONFIG})
  set (CMAKE_CONFIGURATION_TYPES "${CMAKE_CONFIGURATION_TYPES}" CACHE STRING "Reset the configurations" )
endif()

#
# Set up the project name and look for the compiler configuration
#
project(VEILSamples C CXX)

#
# Configure some of the Linux SO parameters
#
if(UNIX)
    SET(CMAKE_SKIP_BUILD_RPATH FALSE)
    SET(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
    SET(CMAKE_INSTALL_RPATH "$ORIGIN")
    SET(CMAKE_INSTALL_RPATH_USE_LINK_PATH FALSE)
endif(UNIX)

#
# Include the TecSec macros and variables.  Look for the OpaqueVEIL, OpenVEIL and VEILCrypto
#
include(tecsec_configure_env)
include(tecsec_ConfigureOpenVEIL)
set(SDK_FOLDER ${VEIL_ROOT_DIR}/..)
set(TS_INSTALL_PREFIX ${VEIL_ROOT_DIR})
include (tecsec_installdirs)
include(tecsec_packages)
IF(MSVC)
	# include(compiler_tecsec_msvc.noWarnings)
ENDIF(MSVC)
include(precompiled.header)
include(summary)

#
# Place the output into these folders
#
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${PUBLIC_BINARY_TOP_DIR}/lib")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${PUBLIC_BINARY_TOP_DIR}/bin")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${PUBLIC_BINARY_TOP_DIR}/bin")

#####################################################################
## Start Options
#####################################################################

add_definitions(-DHIDE_SERVICE_LOCATOR)
set(ENABLE_SMART_CARD ON)
set(NO_PCH OFF)

#####################################################################
## End Options
#####################################################################

set(SuperProject ON)


if(MINGW)
    set(NO_PCH ON)
endif(MINGW)

#
# Look for optional packages here
#
IF(ENABLE_SMART_CARD)
	if (NOT WIN32)
		find_package(PCSC)
		
		if (PCSC_FOUND)
			get_property(_tmp TARGET pcsc PROPERTY INTERFACE_INCLUDE_DIRECTORIES)
			if(NOT ("${_tmp}" STREQUAL ""))
				include_directories(${_tmp})
				set(CMAKE_REQUIRED_INCLUDES ${CMAKE_REQUIRED_INCLUDES} ${_tmp})
			endif(NOT ("${_tmp}" STREQUAL ""))
			get_property(_tmp TARGET pcsc PROPERTY DLOPEN_SONAME)
			set(PCSC_SO_NAME, ${_tmp})
			message(STATUS 	"set(PCSC_SO_NAME, ${_tmp})")
		else()
			set(ENABLE_SMART_CARD OFF)
		endif()
	endif(NOT WIN32)
ENDIF(ENABLE_SMART_CARD)

#
# set up the solution specific files (replaces variables and copies to the output folders)
#

#
# Configure the system using settings in the imported targets
#
ImportTarget(VEILCryptoCore)
ImportTarget(VEILCore)
ImportTarget(VEILCmsHeader)
ImportTarget(VEILFileSupport)
IF(ENABLE_SMART_CARD)
	ImportTarget(VEILSmartCard)
ENDIF(ENABLE_SMART_CARD)

#
# Set up the project level include paths
#
INCLUDE_DIRECTORIES(
    ${CMAKE_CURRENT_SOURCE_DIR}/include
	${CMAKE_CURRENT_BINARY_DIR} 
	)

if(NOT ANDROID)
ELSE()
	set(CMAKE_INSTALL_DO_STRIP ON)
ENDIF()

#
# Now include the sub-folder CMakeLists.txt files
#
add_subdirectory(Crypto)

#
# Copy the modules from the required imported targets so that the programs in this
# project can run
#
CopyImportTargetBinaries(VEILCryptoCore ${BIN_DIR})
CopyImportTargetBinaries(VEILCore ${BIN_DIR})
CopyImportTargetBinaries(VEILCmsHeader ${BIN_DIR})
CopyImportTargetBinaries(VEILFileSupport ${BIN_DIR})
IF(HAVE_SMARTCARD)
    CopyImportTargetBinaries(VEILSmartCard ${BIN_DIR})
ENDIF(HAVE_SMARTCARD)

#
# Set up the files that are "installed" from this CMakeLists.txt
#

#
# This is where CPack (if used) would be set up
#

#
# Now issue the summary configuration screen
#
summary()

#
# Set up the "uninstall" project
#
add_uninstall()

# DumpAllVariables()
