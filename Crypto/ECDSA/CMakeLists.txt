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

INCLUDE_DIRECTORIES(
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_BINARY_DIR}
    )

# copies the DLL's/SO's for development
CopyImportTargetBinariesToBuildFolder(VEILCryptoCore ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${TS_VS_CONFIG})

# installs the DLL's/SO's for use
CopyImportTargetBinaries(VEILCryptoCore ${BIN_DIR}/samples/crypto/ECDSA)

add_executable(ECDSA_Sample 
	targetver.h 
	stdafx.h 
    stdafx.cpp

    ECDSA_Sample.cpp

	${soFilesToCopy}
	)
add_precompiled_header(ECDSA_Sample stdafx.h FORCEINCLUDE SOURCE_CXX stdafx.cpp)

set_target_properties(ECDSA_Sample PROPERTIES FOLDER "Samples/Crypto")
TARGET_LINK_LIBRARIES(ECDSA_Sample VEILCryptoCore)

install(TARGETS ECDSA_Sample RUNTIME DESTINATION ${BIN_DIR}/samples/crypto/ECDSA)
