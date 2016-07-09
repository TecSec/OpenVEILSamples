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


include (CheckIncludeFiles)
include (CheckLibraryExists)
include (CheckSymbolExists)

find_path(ZLIB_INCLUDE_DIR zlib.h
    HINTS
        $ENV{ZLIB_ROOT}/include
        $ENV{ZLIB_ROOT}/include/zLib
        ${BZ2_ROOT}/include
        ${BZ2_ROOT}/include/zLib
)
mark_as_advanced(ZLIB_INCLUDE_DIR)

# if (NOT ZLIB_LIBRARIES)
    find_library(ZLIB_SHARED_LIBRARY_RELEASE NAMES z zdll HINTS $ENV{ZLIB_ROOT}/lib${TS_LIB_DIR_SUFFIX} ${ZLIB_ROOT}/lib${TS_LIB_DIR_SUFFIX})
    find_library(ZLIB_SHARED_LIBRARY_RELWITHDEBINFO NAMES z zdll HINTS $ENV{ZLIB_ROOT}/lib${TS_LIB_DIR_SUFFIX} ${ZLIB_ROOT}/lib${TS_LIB_DIR_SUFFIX})
    find_library(ZLIB_STATIC_LIBRARY_RELEASE NAMES zlib HINTS $ENV{ZLIB_ROOT}/lib${TS_LIB_DIR_SUFFIX} ${ZLIB_ROOT}/lib${TS_LIB_DIR_SUFFIX})
    find_library(ZLIB_STATIC_LIBRARY_RELWITHDEBINFO NAMES zlib HINTS $ENV{ZLIB_ROOT}/lib${TS_LIB_DIR_SUFFIX} ${ZLIB_ROOT}/lib${TS_LIB_DIR_SUFFIX})
    find_library(ZLIB_SHARED_LIBRARY_DEBUG NAMES zd  zdlld HINTS $ENV{ZLIB_ROOT}/lib${TS_LIB_DIR_SUFFIX} ${ZLIB_ROOT}/lib${TS_LIB_DIR_SUFFIX})
    find_library(ZLIB_STATIC_LIBRARY_DEBUG NAMES zlibd HINTS $ENV{ZLIB_ROOT}/lib${TS_LIB_DIR_SUFFIX} ${ZLIB_ROOT}/lib${TS_LIB_DIR_SUFFIX})
	IF(WIN32)
		SET(_tmp ${CMAKE_FIND_LIBRARY_SUFFIXES})
		SET(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_SHARED_LIBRARY_SUFFIX})
		find_library(ZLIB_SHARED_SO_RELEASE NAMES zdll1 HINTS $ENV{ZLIB_ROOT}/bin${TS_LIB_DIR_SUFFIX} ${ZLIB_ROOT}/bin${TS_LIB_DIR_SUFFIX})
		find_library(ZLIB_SHARED_SO_RELWITHDEBINFO NAMES zdll1 HINTS $ENV{ZLIB_ROOT}/bin${TS_LIB_DIR_SUFFIX} ${ZLIB_ROOT}/bin${TS_LIB_DIR_SUFFIX})
		find_library(ZLIB_SHARED_SO_DEBUG NAMES zdlld1 HINTS $ENV{ZLIB_ROOT}/bin${TS_LIB_DIR_SUFFIX} ${ZLIB_ROOT}/bin${TS_LIB_DIR_SUFFIX})
		SET(CMAKE_FIND_LIBRARY_SUFFIXES ${_tmp})
	endif(WIN32)
# endif ()

if(ZLIB_INCLUDE_DIR AND EXISTS "${ZLIB_INCLUDE_DIR}/zlib.h")
    file(STRINGS "${ZLIB_INCLUDE_DIR}/zlib.h" ZLIB_H REGEX "^#define ZLIB_VERSION \"[^\"]*\"$")

    string(REGEX REPLACE "^.*ZLIB_VERSION \"([0-9]+).*$" "\\1" ZLIB_VERSION_MAJOR "${ZLIB_H}")
    string(REGEX REPLACE "^.*ZLIB_VERSION \"[0-9]+\\.([0-9]+).*$" "\\1" ZLIB_VERSION_MINOR  "${ZLIB_H}")
    string(REGEX REPLACE "^.*ZLIB_VERSION \"[0-9]+\\.[0-9]+\\.([0-9]+).*$" "\\1" ZLIB_VERSION_PATCH "${ZLIB_H}")
    set(ZLIB_VERSION_STRING "${ZLIB_VERSION_MAJOR}.${ZLIB_VERSION_MINOR}.${ZLIB_VERSION_PATCH}")

    # only append a TWEAK version if it exists:
    set(ZLIB_VERSION_TWEAK "")
    if( "${ZLIB_H}" MATCHES "ZLIB_VERSION \"[0-9]+\\.[0-9]+\\.[0-9]+\\.([0-9]+)")
        set(ZLIB_VERSION_TWEAK "${CMAKE_MATCH_1}")
        set(ZLIB_VERSION_STRING "${ZLIB_VERSION_STRING}.${ZLIB_VERSION_TWEAK}")
    endif()

    set(ZLIB_MAJOR_VERSION "${ZLIB_VERSION_MAJOR}")
    set(ZLIB_MINOR_VERSION "${ZLIB_VERSION_MINOR}")
    set(ZLIB_PATCH_VERSION "${ZLIB_VERSION_PATCH}")
endif()

# handle the QUIETLY and REQUIRED arguments and set BZip2_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
IF(WIN32)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(ZLIB
                                  REQUIRED_VARS ZLIB_SHARED_LIBRARY_RELEASE ZLIB_STATIC_LIBRARY_RELEASE ZLIB_SHARED_LIBRARY_DEBUG ZLIB_STATIC_LIBRARY_DEBUG ZLIB_INCLUDE_DIR
                                  VERSION_VAR ZLIB_VERSION_STRING)
ELSE(WIN32)
set(ZLIB_SHARED_LIBRARY_DEBUG ${ZLIB_SHARED_LIBRARY_RELEASE})
FIND_PACKAGE_HANDLE_STANDARD_ARGS(ZLIB
                                  REQUIRED_VARS ZLIB_SHARED_LIBRARY_RELEASE ZLIB_INCLUDE_DIR
                                  VERSION_VAR ZLIB_VERSION_STRING)
ENDIF(WIN32)

if(ZLIB_FOUND)
    set(ZLIB_INCLUDE_DIRS ${ZLIB_INCLUDE_DIR})
    set(ZLIB_LIBRARIES ${ZLIB_LIBRARY})

    if(NOT TARGET ZLIB)
		if(WIN32)
		  add_library(ZLIB SHARED IMPORTED)
		  set_property(TARGET ZLIB PROPERTY IMPORTED_LOCATION_DEBUG "${ZLIB_SHARED_SO_DEBUG}")
		  set_property(TARGET ZLIB PROPERTY IMPORTED_LOCATION_RELEASE "${ZLIB_SHARED_SO_RELEASE}")
		  set_property(TARGET ZLIB PROPERTY IMPORTED_LOCATION_RELWITHDEBINFO "${ZLIB_SHARED_SO_RELWITHDEBINFO}")
		  set_property(TARGET ZLIB PROPERTY IMPORTED_IMPLIB_DEBUG "${ZLIB_SHARED_LIBRARY_DEBUG}")
		  set_property(TARGET ZLIB PROPERTY IMPORTED_IMPLIB_RELEASE "${ZLIB_SHARED_LIBRARY_RELEASE}")
		  set_property(TARGET ZLIB PROPERTY IMPORTED_IMPLIB_RELWITHDEBINFO "${ZLIB_SHARED_LIBRARY_RELWITHDEBINFO}")
		  set_property(TARGET ZLIB PROPERTY INTERFACE_INCLUDE_DIRECTORIES "${ZLIB_INCLUDE_DIRS}")
		else(WIN32)
		  add_library(ZLIB SHARED IMPORTED)
		  set_target_properties(ZLIB PROPERTIES
			IMPORTED_LOCATION_DEBUG "${ZLIB_SHARED_LIBRARY_DEBUG}"
			IMPORTED_LOCATION_RELEASE "${ZLIB_SHARED_LIBRARY_RELEASE}"
			IMPORTED_LOCATION_RELWITHDEBINFO "${ZLIB_SHARED_LIBRARY_RELWITHDEBINFO}"
			INTERFACE_INCLUDE_DIRECTORIES "${ZLIB_INCLUDE_DIRS}")
		endif(WIN32)
    endif()
   
    if(NOT TARGET ZLIB_STATIC)
      add_library(ZLIB_STATIC UNKNOWN IMPORTED)
      set_target_properties(ZLIB_STATIC PROPERTIES
        IMPORTED_LOCATION_DEBUG "${ZLIB_STATIC_LIBRARY_DEBUG}"
        IMPORTED_LOCATION_RELEASE "${ZLIB_STATIC_LIBRARY_RELEASE}"
        IMPORTED_LOCATION_RELWITHDEBINFO "${ZLIB_STATIC_LIBRARY_RELWITHDEBINFO}"
        INTERFACE_INCLUDE_DIRECTORIES "${ZLIB_INCLUDE_DIR}")
    endif()
	
endif()

mark_as_advanced(ZLIB_INCLUDE_DIR)