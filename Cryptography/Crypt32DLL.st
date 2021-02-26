"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #Crypt32DLL,
	#superclass : #ExternalLibrary,
	#type : #bytes,
	#category : #Cryptography
}

{ #category : #parsing }
Crypt32DLL class >> h [
	^SmalltalkSession current devDirectory \ 'wincrypt.h']

{ #category : #initialization }
Crypt32DLL class >> initializeConstants [
	"
	Crypt32DLL initializeConstants
	"
	self
		initializeEncodingConstants;
		initializeStoreConstants;
		initializeFindConstants;
		initializeErrorCodes;
		initializeCredentialUseConstants;
		initializeStringTypeConstants]

{ #category : #initialization }
Crypt32DLL class >> initializeCredentialUseConstants [
	"
	Crypt32DLL initializeCredentialUseConstants
	"
	WindowsConstants
		at: 'SECPKG_CRED_INBOUND' put: 1;
		at: 'SECPKG_CRED_OUTBOUND' put: 2;
		at: 'SECPKG_CRED_ATTR_NAMES' put: 1]

{ #category : #initialization }
Crypt32DLL class >> initializeEncodingConstants [
	"
	Crypt32DLL initializeEncodingConstants
	"
	WindowsConstants
		at: 'PKCS_7_ASN_ENCODING'
		put: 16r10000 "Specifies PKCS #7 message encoding.";
		at: 'X509_ASN_ENCODING'
		put: 1 "Specifies X.509 certificate encoding.";
		at: 'CRYPT_STRING_BASE64' put: 1 "Base64, without headers."]

{ #category : #initialization }
Crypt32DLL class >> initializeErrorCodes [
	WindowsConstants at: 'CRYPT_E_NOT_FOUND' put: 16r80092004]

{ #category : #initialization }
Crypt32DLL class >> initializeFindConstants [
	"
	Crypt32DLL initializeFindConstants
	"
	WindowsConstants
		at: 'CERT_FIND_ANY' put: 0;
		at: 'CERT_FIND_CERT_ID' put: 1048576;
		at: 'CERT_FIND_CTL_USAGE' put: 655360;
		at: 'CERT_FIND_ENHKEY_USAGE' put: 655360;
		at: 'CERT_FIND_EXISTING' put: 851968;
		at: 'CERT_FIND_HASH' put: 65536;
		at: 'CERT_FIND_ISSUER_ATTR' put: 196612;
		at: 'CERT_FIND_ISSUER_NAME' put: 131076;
		at: 'CERT_FIND_ISSUER_OF' put: 786432;
		at: 'CERT_FIND_KEY_IDENTIFIER' put: 983040;
		at: 'CERT_FIND_KEY_SPEC' put: 589824;
		at: 'CERT_FIND_MD5_HASH' put: 262144;
		at: 'CERT_FIND_PROPERTY' put: 327680;
		at: 'CERT_FIND_PUBLIC_KEY' put: 393216;
		at: 'CERT_FIND_SHA1_HASH' put: 65536;
		at: 'CERT_FIND_SIGNATURE_HASH' put: 917504;
		at: 'CERT_FIND_SUBJECT_ATTR' put: 196615;
		at: 'CERT_FIND_SUBJECT_CERT' put: 720896;
		at: 'CERT_FIND_SUBJECT_NAME' put: 131079;
		at: 'CERT_FIND_SUBJECT_STR_A' put: 458759;
		at: 'CERT_FIND_SUBJECT_STR_W' put: 524295;
		at: 'CERT_FIND_ISSUER_STR_A' put: 458756;
		at: 'CERT_FIND_ISSUER_STR_W' put: 524292;
		at: 'CERT_FIND_OR_ENHKEY_USAGE_FLAG' put: 16;
		at: 'CERT_FIND_OPTIONAL_ENHKEY_USAGE_FLAG' put: 1;
		at: 'CERT_FIND_NO_ENHKEY_USAGE_FLAG' put: 8;
		at: 'CERT_FIND_VALID_ENHKEY_USAGE_FLAG' put: 32;
		at: 'CERT_FIND_EXT_ONLY_ENHKEY_USAGE_FLAG' put: 2]

{ #category : #initialization }
Crypt32DLL class >> initializeStoreConstants [
	"
	Crypt32DLL initializeStoreConstants
	"
	WindowsConstants
		at: 'CERT_STORE_PROV_SYSTEM_A' put: 9;
		at: 'CERT_STORE_PROV_SYSTEM_W' put: 10;
		at: 'CERT_STORE_OPEN_EXISTING_FLAG' put: 16r4000;
		at: 'CERT_SYSTEM_STORE_LOCAL_MACHINE' put: 16r20000;
		at: 'CERT_SYSTEM_STORE_CURRENT_USER' put: 16r10000;
		at: 'CERT_SYSTEM_STORE_USERS' put: 16r60000;
		at: 'CERT_STORE_ADD_ALWAYS' put: 4;
		at: 'CERT_STORE_READONLY_FLAG' put: 16r8000;
		at: 'CRYPT_ACQUIRE_COMPARE_KEY_FLAG' put: 16r4]

{ #category : #initialization }
Crypt32DLL class >> initializeStringTypeConstants [
	"
	Crypt32DLL initializeStringTypeConstants
	"
	WindowsConstants
		at: 'CERT_SIMPLE_NAME_STR'
		put: 1 "All object identifiers (OIDs) are discarded. CERT_RDN entries are separated by a comma followed by a space (, ). Multiple attributes in a CERT_RDN are separated by a plus sign enclosed within spaces ( + ), for example, Microsoft, Kim Abercrombie + Programmer.";
		at: 'CERT_OID_NAME_STR'
		put: 2 "OIDs are included with an equal sign (=) separator from their attribute value. CERT_RDN entries are separated by a comma followed by a space (, ). Multiple attributes in a CERT_RDN are separated by a plus sign followed by a space (+ ).";
		at: 'CERT_X500_NAME_STR'
		put: 3 "OIDs are converted to their X.500 key names; otherwise, they are the same as CERT_OID_NAME_STR. If an OID does not have a corresponding X.500 name, the OID is used with a prefix of OID.

The RDN value is quoted if it contains leading or trailing white space or one of the following characters:

    Comma (,)
    Plus sign (+)
    Equal sign (=)
    Inch mark 
    Backslash followed by the letter n (\n)
    Less than sign (<)
    Greater than sign (>)
    Number sign (#)
    Semicolon (;)

The quotation character is an inch mark. If the RDN value contains an inch mark, it is enclosed within quotation marks."]

{ #category : #accessing }
Crypt32DLL class >> moduleName [
	^'Crypt32']

{ #category : #private }
Crypt32DLL class >> typedefTable [
	^#(
		('ALG_ID' #pointer #ulong)
		('IntPtr' #pointer)
		('PCCERT_CONTEXT' #pointer)
		('HCERTCHAINENGINE' #pointer)
		('PCERT_CHAIN_PARA' #pointer)
		('HCRYPTPROV_LEGACY' #pointer)
		('_HMAPPER' #pointer)
		('LPTCSTR' #pointer)
		('PCCERT_CHAIN_CONTEXT' #pointer)
		('PCERT_CHAIN_POLICY_PARA' #pointer)
		('HCERTSTORE' #pointer)
		('SEC_CHAR' #CHAR)
		('SEC_WCHAR' #WCHAR)
	)]

{ #category : #'ffi - certificates' }
Crypt32DLL >> CertCloseStore: hCertStore dwFlags: flags [
	<boolean: CertCloseStore>
	^self invalidArgument

"
BOOL WINAPI CertCloseStore(
  _In_  HCERTSTORE hCertStore,
  _In_  DWORD dwFlags
);
"]

{ #category : #'ffi - certificates' }
Crypt32DLL >> CertFindCertificateInStore: hCertStore
dwCertEncodingType: encoding
dwFindFlags: flags
dwFindType: type
pvFindPara: wparam
pPrevCertContext: ulong [
	<pointer: CertFindCertificateInStore>
	^self invalidArgument

"
PCCERT_CONTEXT WINAPI CertFindCertificateInStore(
  _In_  HCERTSTORE hCertStore,
  _In_  DWORD dwCertEncodingType,
  _In_  DWORD dwFindFlags,
  _In_  DWORD dwFindType,
  _In_  const void *pvFindPara,
  _In_  PCCERT_CONTEXT pPrevCertContext
);
"]

{ #category : #'ffi - certificates' }
Crypt32DLL >> CertFreeCertificateContext: pCertContext [
	<boolean: CertFreeCertificateContext>
	^self invalidArgument

"
BOOL WINAPI CertFreeCertificateContext(
  _In_  PCCERT_CONTEXT pCertContext
);
"]

{ #category : #'ffi - certificates' }
Crypt32DLL >> CertGetCertificateChain: hChainEngine
pCertContext: pCertContext
pTime: aLPFILETIME
hAdditionalStore: aHCERTSTORE
pChainPara: aPCERT_CHAIN_PARA
dwFlags: integer
pvReserved: pvReserved
ppChainContext: ppChainContext [
	<boolean: CertGetCertificateChain>
	^self invalidArgument

"
BOOL WINAPI CertGetCertificateChain(
  _In_opt_ HCERTCHAINENGINE     hChainEngine,
  _In_     PCCERT_CONTEXT       pCertContext,
  _In_opt_ LPFILETIME           pTime,
  _In_     HCERTSTORE           hAdditionalStore,
  _In_     PCERT_CHAIN_PARA     pChainPara,
  _In_     DWORD                dwFlags,
  _In_     LPVOID               pvReserved,
  _Out_    PCCERT_CHAIN_CONTEXT *ppChainContext
);
"]

{ #category : #services }
Crypt32DLL >> certificateName: encodingType pName: aCERT_NAME_BLOB [
	| buffer struct |
	buffer := 1000 externalCharacters.
	struct := aCERT_NAME_BLOB externalCopy.
	self
		CertNameToStr: encodingType asParameter
		pName: struct asParameter
		dwStrType: CERT_X500_NAME_STR
		psz: buffer asParameter
		csz: 1000.
	struct == aCERT_NAME_BLOB ifFalse: [struct free].
	^buffer makeUnicode]

{ #category : #services }
Crypt32DLL >> certificatesDo: aBlock [
	"
	Array streamContents: [:strm | Crypt32DLL current certificatesDo: [:c | strm nextPut: c]]
	"
	| para store prev success |
	para := 'Root' externalCopy.
	store := self
		CertOpenStore: CERT_STORE_PROV_SYSTEM_W
		dwMsgAndCertEncodingType: X509_ASN_ENCODING
		hCryptProv: 0
		dwFlags: CERT_SYSTEM_STORE_CURRENT_USER
		pvPara: para asParameter.
	self ASSERT: store != 0.
	para free.
	prev := 0.
	[| context |
		[
			context := self
				CertFindCertificateInStore: store
				dwCertEncodingType: X509_ASN_ENCODING
				dwFindFlags: 0
				dwFindType: CERT_FIND_ANY
				pvFindPara: 0
				pPrevCertContext: prev.
			context = 0]
			whileFalse: [
				aBlock evaluateWith: context.
				prev = 0 ifFalse: [
					success := self CertFreeCertificateContext: prev.
					success ifFalse: [self winError]].
				prev := context]]
		ensure: [
			success := self CertCloseStore: store dwFlags: 0.
			success ifFalse: [self winError]]]

{ #category : #'ffi - certificates' }
Crypt32DLL >> CertNameToStr: encodingType
pName: PCERT_NAME_BLOB
dwStrType: dwStrType
psz: psz
csz: csz [
	<ulong: CertNameToStrW>
	^self invalidArgument

"
DWORD WINAPI CertNameToStr(
  _In_   DWORD dwCertEncodingType,
  _In_   PCERT_NAME_BLOB pName,
  _In_   DWORD dwStrType,
  _Out_  LPTSTR psz,
  _In_   DWORD csz
);
"]

{ #category : #'ffi - certificates' }
Crypt32DLL >> CertOpenStore: lpszStoreProvider
dwMsgAndCertEncodingType: type
hCryptProv: zero
dwFlags: flags
pvPara: ulong [
	<pointer: CertOpenStore>
	^self invalidArgument

"
HCERTSTORE WINAPI CertOpenStore(
  _In_  LPCSTR lpszStoreProvider,
  _In_  DWORD dwMsgAndCertEncodingType,
  _In_  HCRYPTPROV_LEGACY hCryptProv,
  _In_  DWORD dwFlags,
  _In_  const void *pvPara
);
"]

{ #category : #'ffi - certificates' }
Crypt32DLL >> CertOpenSystemStoreW: hprov szSubsystemProtocol: aString [
	<pointer: CertOpenSystemStoreW>
	^self invalidArgument

"
HCERTSTORE WINAPI CertOpenSystemStore(
  _In_  HCRYPTPROV_LEGACY hprov,
  _In_  LPTCSTR szSubsystemProtocol
);
"]

{ #category : #'ffi - certificates' }
Crypt32DLL >> CertVerifyCertificateChainPolicy: pszPolicyOID
pChainContext: pChainContext
pPolicyPara: pPolicyPara
pPolicyStatus: pPolicyStatus [
	<boolean: CertVerifyCertificateChainPolicy>
	^self invalidArgument

"
	BOOL WINAPI CertVerifyCertificateChainPolicy(
  _In_     LPCSTR pszPolicyOID,
  _In_     PCCERT_CHAIN_CONTEXT pChainContext,
  _In_     PCERT_CHAIN_POLICY_PARA pPolicyPara,
  _Inout_  PCERT_CHAIN_POLICY_STATUS pPolicyStatus
);
"]

{ #category : #services }
Crypt32DLL >> credentialsBase64: aByteArray [
	| memory credentials |
	aByteArray isExternalMemory ifTrue: [memory := aByteArray] ifFalse: [
		memory := aByteArray externalCopy.
		aByteArray atAllPut: 0].
	credentials := UserCredentials fromMemory: memory.
	memory clear: memory length; free.
	^credentials]

{ #category : #'ffi - certificates' }
Crypt32DLL >> CryptBinaryToString: pbBinary
cbBinary: n
dwFlags: flags
pszString: encoded
pcchString: chars [
	<boolean: CryptBinaryToStringW>
	^self invalidArgument

"
BOOL CryptBinaryToStringW(
  CONST BYTE *pbBinary,
  DWORD      cbBinary,
  DWORD      dwFlags,
  LPWSTR     pszString,
  DWORD      *pcchString
);
"]

{ #category : #'ffi - certificates' }
Crypt32DLL >> CryptBinaryToStringA: pbBinary
cbBinary: n
dwFlags: flags
pszString: encoded
pcchString: chars [
	<boolean: CryptBinaryToStringA>
	^self invalidArgument

"
BOOL CryptBinaryToStringA(
  CONST BYTE *pbBinary,
  DWORD      cbBinary,
  DWORD      dwFlags,
  LPWSTR     pszString,
  DWORD      *pcchString
);
"]

{ #category : #'ffi - data' }
Crypt32DLL >> CryptProtectData: pDataIn
szDataDescr: optional
pOptionalEntropy: password
pvReserved: zero
pPromptStruct: prompt
dwFlags: flags
pDataOut: encrypted [
	<boolean: CryptProtectData>
	^self invalidArgument

"
DPAPI_IMP BOOL CryptProtectData(
  DATA_BLOB                 *pDataIn,
  LPCWSTR                   szDataDescr,
  DATA_BLOB                 *pOptionalEntropy,
  PVOID                     pvReserved,
  CRYPTPROTECT_PROMPTSTRUCT *pPromptStruct,
  DWORD                     dwFlags,
  DATA_BLOB                 *pDataOut
);
	"]

{ #category : #'ffi - certificates' }
Crypt32DLL >> CryptStringToBinaryW: pszString
cchString: length
dwFlags: flags
pbBinary: decoded
pcbBinary: n
pdwSkip: skip
pdwFlags: flags2 [
	<boolean: CryptStringToBinaryW>
	^self invalidArgument

"
BOOL CryptStringToBinaryW(
  LPCWSTR pszString,
  DWORD   cchString,
  DWORD   dwFlags,
  BYTE    *pbBinary,
  DWORD   *pcbBinary,
  DWORD   *pdwSkip,
  DWORD   *pdwFlags
);
"]

{ #category : #'ffi - data' }
Crypt32DLL >> CryptUnprotectData: pDataIn
ppszDataDescr: optional
pOptionalEntropy: password
pvReserved: zero
pPromptStruct: prompt
dwFlags: flags
pDataOut: plaintext [
	<boolean: CryptUnprotectData>
	^self invalidArgument

"
DPAPI_IMP BOOL CryptUnprotectData(
  DATA_BLOB                 *pDataIn,
  LPWSTR                    *ppszDataDescr,
  DATA_BLOB                 *pOptionalEntropy,
  PVOID                     pvReserved,
  CRYPTPROTECT_PROMPTSTRUCT *pPromptStruct,
  DWORD                     dwFlags,
  DATA_BLOB                 *pDataOut
);
	"]

{ #category : #services }
Crypt32DLL >> decodeBase64: aString [
	"
	Crypt32DLL current decodeBase64: (Crypt32DLL current encodeBase64: 'hola')
	"
	| memory |
	memory := self decodedMemoryBase64: aString.
	^memory makeBytes]

{ #category : #services }
Crypt32DLL >> decodedMemoryBase64: aString [
	"
	Crypt32DLL current decodeBase64: (Crypt32DLL current encodeBase64: 'hola')
	"
	| string length success memory |
	string := aString externalCopy.
	length := ExternalInt32 external.
	success := self
		CryptStringToBinaryW: string asParameter
		cchString: 0
		dwFlags: CRYPT_STRING_BASE64
		pbBinary: 0
		pcbBinary: length asParameter
		pdwSkip: 0
		pdwFlags: 0.
	success ifFalse: [self winError].
	memory := length asInteger externalBytes.
	success := self
		CryptStringToBinaryW: string asParameter
		cchString: 0
		dwFlags: CRYPT_STRING_BASE64
		pbBinary: memory asParameter
		pcbBinary: length asParameter
		pdwSkip: 0
		pdwFlags: 0.
	string == aString ifFalse: [string clear: string length; free].
	length free.
	^memory]

{ #category : #services }
Crypt32DLL >> encodeBase64: aByteArray [
	"
	Crypt32DLL current encodeBase64: 'hola' utf8
	"
	| memory bytes unicode |
	bytes := aByteArray isString
		ifTrue: [aByteArray utf8]
		ifFalse: [aByteArray].
	memory := self encodedMemoryBase64: bytes.
	bytes == aByteArray ifFalse: [bytes atAllPut: 0].
	unicode := WideString fromMemory: memory.
	memory clear: memory length; free.
	^unicode]

{ #category : #services }
Crypt32DLL >> encodedMemoryBase64: aByteArray [
	"
	Crypt32DLL current encodedMemoryBase64: 'hola' utf8
	"
	| binary memory length success base64 |
	self ASSERT: aByteArray isString not.
	binary := aByteArray externalCopy.
	length := ExternalInt32 external.
	success := self
		CryptBinaryToString: binary asParameter
		cbBinary: binary length
		dwFlags: CRYPT_STRING_BASE64
		pszString: 0
		pcchString: length asParameter.
	success ifFalse: [self winError].
	memory := length asInteger externalCharacters.
	success := self
		CryptBinaryToString: binary asParameter
		cbBinary: binary length
		dwFlags: CRYPT_STRING_BASE64
		pszString: memory asParameter
		pcchString: length asParameter.
	binary == aByteArray ifFalse: [binary free].
	base64 := (length makeInteger - 2) externalCharacters.
	1 to: base64 length - 2 do: [:i | base64 at: i put: (memory at: i)].
	memory clear: memory length; free.
	^base64]

{ #category : #services }
Crypt32DLL >> encodedMemoryBase64A: aByteArray [
	"
	Crypt32DLL current encodedMemoryBase64: 'hola' utf8
	"
	| binary memory length success base64 |
	self ASSERT: aByteArray isString not.
	binary := aByteArray externalCopy.
	length := ExternalInt32 external.
	success := self
		CryptBinaryToStringA: binary asParameter
		cbBinary: binary length
		dwFlags: CRYPT_STRING_BASE64
		pszString: 0
		pcchString: length asParameter.
	success ifFalse: [self winError].
	memory := length asInteger externalCharacters.
	success := self
		CryptBinaryToStringA: binary asParameter
		cbBinary: binary length
		dwFlags: CRYPT_STRING_BASE64
		pszString: memory asParameter
		pcchString: length asParameter.
	binary == aByteArray ifFalse: [binary free].
	base64 := (length makeInteger - 2) externalCharacters.
	1 to: base64 length - 2 do: [:i | base64 at: i put: (memory at: i)].
	memory clear: memory length; free.
	^base64]

{ #category : #services }
Crypt32DLL >> getCertificateNamed: serverName currentUser: aBoolean [
	"
	Crypt32DLL current getCertificateNamed: 'server example' currentUser: false
	"
	| para store server flags |
	flags := aBoolean
		ifTrue: [CERT_SYSTEM_STORE_CURRENT_USER]
		ifFalse: [CERT_SYSTEM_STORE_LOCAL_MACHINE | CERT_STORE_READONLY_FLAG].
	para := 'My' externalCopy.
	server := serverName externalCopy.
	store := self
		CertOpenStore: CERT_STORE_PROV_SYSTEM_W
		dwMsgAndCertEncodingType: X509_ASN_ENCODING
		hCryptProv: 0
		dwFlags: flags
		pvPara: para asParameter.
	self ASSERT: store != 0.
	para free.
	[| context |
		context := self
			CertFindCertificateInStore: store
			dwCertEncodingType: X509_ASN_ENCODING
			dwFindFlags: 0
			dwFindType: CERT_FIND_SUBJECT_STR_W
			pvFindPara: server asParameter
			pPrevCertContext: 0.
		context != 0 ifTrue: [^CERT_CONTEXT atMemory: context pointedMemory].
		^nil]
		ensure: [| success |
			success := self CertCloseStore: store dwFlags: 0.
			success ifFalse: [self winError]]]

{ #category : #services }
Crypt32DLL >> openMyCertificateStore [
	| para store |
	para := 'MY' externalCopy.
	store := Crypt32DLL current
		CertOpenSystemStoreW: 0
		szSubsystemProtocol: para asParameter.
	store = 0 ifTrue: [self winError].
	para free.
	^store]

{ #category : #services }
Crypt32DLL >> protect: aString [
	| blob |
	blob := CRYPTOAPI_BLOB external data: aString.
	^self protectBlob: blob]

{ #category : #services }
Crypt32DLL >> protectBlob: aCRYPTOAPI_BLOB [
	| success output |
	output := CRYPTOAPI_BLOB external.
	success := self
		CryptProtectData: aCRYPTOAPI_BLOB asParameter
		szDataDescr: 0
		pOptionalEntropy: 0
		pvReserved: 0
		pPromptStruct: 0
		dwFlags: 0
		pDataOut: output asParameter.
	success ifFalse: [self winError].
	^output data]

{ #category : #services }
Crypt32DLL >> unprotect: aByteArray [
	| input success output n password |
	input := CRYPTOAPI_BLOB external data: aByteArray.
	output := CRYPTOAPI_BLOB external.
	success := self
		CryptUnprotectData: input asParameter
		ppszDataDescr: 0
		pOptionalEntropy: 0
		pvReserved: 0
		pPromptStruct: 0
		dwFlags: 0
		pDataOut: output asParameter.
	input free.
	success ifFalse: [self winError].
	n := output cbData.
	password := (n + 2) externalBytes
		replaceFrom: 1
		to: n
		with: output pbData
		startingAt: 1.
	output free.
	^password]

