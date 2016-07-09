//	Copyright (c) 2016, TecSec, Inc.
//
//	Redistribution and use in source and binary forms, with or without
//	modification, are permitted provided that the following conditions are met:
//	
//		* Redistributions of source code must retain the above copyright
//		  notice, this list of conditions and the following disclaimer.
//		* Redistributions in binary form must reproduce the above copyright
//		  notice, this list of conditions and the following disclaimer in the
//		  documentation and/or other materials provided with the distribution.
//		* Neither the name of TecSec nor the names of the contributors may be
//		  used to endorse or promote products derived from this software 
//		  without specific prior written permission.
//		 
//	ALTERNATIVELY, provided that this notice is retained in full, this product
//	may be distributed under the terms of the GNU General Public License (GPL),
//	in which case the provisions of the GPL apply INSTEAD OF those given above.
//		 
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED.  IN NO EVENT SHALL TECSEC BE LIABLE FOR ANY 
//	DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//	ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// Written by Roger Butler

#include "stdafx.h"

int main(int argc, const char* argv[])
{
    // Initialize the VEIL crypto system by retrieving the CryptoLocator
    if (!CryptoLocator())
    {
        printf("ERROR:  Unable to initialize the VEIL Crypto system.\n");
        return 1;
    }
    // Now we will use a C++ helper to ensure that the VEIL system is shut down. (uses a lambda function and a helper template)
    auto finalCleanup = finally([](){
		TerminateCryptoSystem();
    });

	// Declare the variables needed for the key generation.
	// NOTE:  The VEIL system makes heavy use of C++11 and shared_ptr's
	std::shared_ptr<EccKey> ecc; // Holds an ECC key pair

	if (!TSGenerateECCKeysByName("KEY-P256", ecc))
	{
		printf("ERROR:  Unable to generate the key pair.\n");
		return 2;
	}

	// Now we will generate a random block of data to sign.  This could be replaced by any data you want to sign.
	tsCryptoData dataToSign;

	if (!GenerateRandom(dataToSign, 592)) // Could use any size
	{
		printf("ERROR:  Unable to generate the random data to sign.\n");
		return 3;
	}

	// Now we will sign the data.  This helper function handles RSA and ECC signature generation.
	tsCryptoData signature;

	// NOTE:  The hash does not have to be specified if the default hash for the ECC curve is appropriate.  Otherwise any
	//        hash function in the system can be specified.
	if (!TSSignData(std::dynamic_pointer_cast<AsymmetricKey>(ecc), dataToSign, signature, "SHA256")) 
	{
		printf("ERROR:  Unable to generate the signature.\n");
		return 4;
	}

	// Now verify the signature
	if (!TSVerifyData(std::dynamic_pointer_cast<AsymmetricKey>(ecc), dataToSign, signature, "SHA256"))
	{
		printf("ERROR:  Unable to verify the signature.\n");
		return 5;
	}

	// Now to prove that an invalid signature or hash causes the math to fail.
	//
	// Wrong hash
	if (TSVerifyData(std::dynamic_pointer_cast<AsymmetricKey>(ecc), dataToSign, signature, "SHA384"))
	{
		printf("ERROR:  This should have failed.\n");
		return 6;
	}
	// Wrong signature
	signature[signature.size() - 1] = (uint8_t)(signature.back() - 1);
	if (TSVerifyData(std::dynamic_pointer_cast<AsymmetricKey>(ecc), dataToSign, signature, "SHA384"))
	{
		printf("ERROR:  This should have failed.\n");
		return 7;
	}
	// put the signature back
	signature[signature.size() - 1] = (uint8_t)(signature.back() + 1);
	// Wrong data
	dataToSign[0] = (uint8_t)(dataToSign[0] - 1);
	if (TSVerifyData(std::dynamic_pointer_cast<AsymmetricKey>(ecc), dataToSign, signature, "SHA384"))
	{
		printf("ERROR:  This should have failed.\n");
		return 8;
	}
	printf("SUCCESS\n");
	return 0;
}