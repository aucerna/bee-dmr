"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #BcryptDLL,
	#superclass : #ExternalLibrary,
	#type : #bytes,
	#category : #Cryptography
}

{ #category : #initialization }
BcryptDLL class >> initializeConstants [
	BcryptConstants
		at: 'BCRYPT_ALG_HANDLE_HMAC_FLAG' put: 0x00000008;
		at: 'BCRYPT_PROV_DISPATCH' put: 0x00000001;
		at: 'BCRYPT_BLOCK_PADDING' put: 0x00000001;
		at: 'STATUS_SUCCESS' put: 0;
		at: 'STATUS_INVALID_HANDLE' put: 0xC0000008;
		at: 'STATUS_INVALID_PARAMETER' put: 0xC000000D;
		at: 'STATUS_BUFFER_TOO_SMALL' put: 0xC0000023;
		at: 'STATUS_NOT_SUPPORTED' put: 0xC00000BB]

{ #category : #accessing }
BcryptDLL class >> moduleName [
	^'Bcrypt.dll']

{ #category : #services }
BcryptDLL >> aesDecrypt: aByteArray key: anotherArray [
	^self decrypt: aByteArray symmetricKey: anotherArray method: 'AES']

{ #category : #services }
BcryptDLL >> aesEncrypt: aByteArray key: anotherArray [
	^self encrypt: aByteArray symmetricKey: anotherArray method: 'AES']

{ #category : #private }
BcryptDLL >> algorithm: algorithm property: aString [
	| prop length count status |
	prop := aString externalCopy.
	length := ExternalInt32 external.
	count := ExternalInt32 external.
	status := self
		BCryptGetProperty: algorithm asInteger
		pszProperty: prop asParameter
		pbOutput: length asParameter
		cbOutput: 4
		pcbResult: count asParameter
		dwFlags: 0.
	self status: status.
	self ASSERT: count makeInteger = 4.
	^length makeInteger]

{ #category : #private }
BcryptDLL >> algorithm: algorithm property: aString value: anotherString [
	| prop input status |
	prop := aString externalCopy.
	input := anotherString externalCopy.
	status := self
		BCryptSetProperty: algorithm asInteger
		pszProperty: prop asParameter
		pbInput: input asParameter
		cbInput: input length
		dwFlags: 0.
	self status: status]

{ #category : #api }
BcryptDLL >> BCryptCloseAlgorithmProvider: hAlgorithm dwFlags: zero [
	<ulong: BCryptCloseAlgorithmProvider>
	^self invalidArgument

"
NTSTATUS BCryptCloseAlgorithmProvider(
  BCRYPT_ALG_HANDLE hAlgorithm,
  ULONG             dwFlags
);
"]

{ #category : #api }
BcryptDLL >> BCryptCreateHash: hAlgorithm
phHash: hash
pbHashObject: buffer
cbHashObject: bytes
pbSecret: secret
cbSecret: length
dwFlags: flags [
	<ulong: BCryptCreateHash>
	^self invalidArgument

"
NTSTATUS BCryptCreateHash(
  BCRYPT_ALG_HANDLE  hAlgorithm,
  BCRYPT_HASH_HANDLE *phHash,
  PUCHAR             pbHashObject,
  ULONG              cbHashObject,
  PUCHAR             pbSecret,
  ULONG              cbSecret,
  ULONG              dwFlags
);
"]

{ #category : #api }
BcryptDLL >> BCryptDecrypt: hKey
pbInput: input
cbInput: count1
pPaddingInfo: padding
pbIV: public
cbIV: count2
pbOutput: output
cbOutput: count3
pcbResult: result
dwFlags: flags [
	<ulong: BCryptDecrypt>
	^self invalidArgument

"
NTSTATUS BCryptDecrypt(
  BCRYPT_KEY_HANDLE hKey,
  PUCHAR            pbInput,
  ULONG             cbInput,
  VOID              *pPaddingInfo,
  PUCHAR            pbIV,
  ULONG             cbIV,
  PUCHAR            pbOutput,
  ULONG             cbOutput,
  ULONG             *pcbResult,
  ULONG             dwFlags
);
"]

{ #category : #api }
BcryptDLL >> BCryptDestroyHash: hHash [
	<ulong: BCryptDestroyHash>
	^self invalidArgument

"
NTSTATUS BCryptDestroyHash(
  BCRYPT_HASH_HANDLE hHash
);
"]

{ #category : #api }
BcryptDLL >> BCryptDestroyKey: hKey [
	<ulong: BCryptDestroyKey>
	^self invalidArgument

"
NTSTATUS BCryptDestroyKey(
  BCRYPT_KEY_HANDLE hKey
);
"]

{ #category : #api }
BcryptDLL >> BCryptEncrypt: hKey
pbInput: input
cbInput: count1
pPaddingInfo: padding
pbIV: public
cbIV: count2
pbOutput: output
cbOutput: count3
pcbResult: result
dwFlags: flags [
	<ulong: BCryptEncrypt>
	^self invalidArgument

"
NTSTATUS BCryptEncrypt(
  BCRYPT_KEY_HANDLE hKey,
  PUCHAR            pbInput,
  ULONG             cbInput,
  VOID              *pPaddingInfo,
  PUCHAR            pbIV,
  ULONG             cbIV,
  PUCHAR            pbOutput,
  ULONG             cbOutput,
  ULONG             *pcbResult,
  ULONG             dwFlags
);
"]

{ #category : #api }
BcryptDLL >> BCryptExportKey: hKey
hExportKey: handle
pszBlobType: string
pbOutput: output
cbOutput: count
pcbResult: result
dwFlags: flags [
	<ulong: BCryptExportKey>
	^self invalidArgument

"
NTSTATUS BCryptExportKey(
  BCRYPT_KEY_HANDLE hKey,
  BCRYPT_KEY_HANDLE hExportKey,
  LPCWSTR           pszBlobType,
  PUCHAR            pbOutput,
  ULONG             cbOutput,
  ULONG             *pcbResult,
  ULONG             dwFlags
);
"]

{ #category : #api }
BcryptDLL >> BCryptFinishHash: handle
pbOutput: output
cbOutput: obytes
dwFlags: flags [
	<ulong: BCryptFinishHash>
	^self invalidArgument

"
NTSTATUS BCryptFinishHash(
  BCRYPT_HASH_HANDLE hHash,
  PUCHAR             pbOutput,
  ULONG              cbOutput,
  ULONG              dwFlags
);
"]

{ #category : #api }
BcryptDLL >> BCryptGenerateSymmetricKey: hAlgorithm
phKey: key
pbKeyObject: object
cbKeyObject: count1
pbSecret: secret
cbSecret: count2
dwFlags: flags [
	<ulong: BCryptGenerateSymmetricKey>
	^self invalidArgument

"
NTSTATUS BCryptGenerateSymmetricKey(
  BCRYPT_ALG_HANDLE hAlgorithm,
  BCRYPT_KEY_HANDLE *phKey,
  PUCHAR            pbKeyObject,
  ULONG             cbKeyObject,
  PUCHAR            pbSecret,
  ULONG             cbSecret,
  ULONG             dwFlags
);
"]

{ #category : #api }
BcryptDLL >> BCryptGetProperty: hObject
pszProperty: input
pbOutput: output
cbOutput: obytes
pcbResult: count
dwFlags: flags [
	<ulong: BCryptGetProperty>
	^self invalidArgument

"
NTSTATUS BCryptGetProperty(
  BCRYPT_HANDLE hObject,
  LPCWSTR       pszProperty,
  PUCHAR        pbOutput,
  ULONG         cbOutput,
  ULONG         *pcbResult,
  ULONG         dwFlags
);
"]

{ #category : #api }
BcryptDLL >> BCryptHash: hAlgorithm
pbSecret: null
cbSecret: zero
pbInput: input
cbInput: ibytes
pbOutput: output
cbOutput: obytes [
	<ulong: BCryptHash>
	^self invalidArgument

"
NTSTATUS BCryptHash(
  BCRYPT_ALG_HANDLE hAlgorithm,
  PUCHAR            pbSecret,
  ULONG             cbSecret,
  PUCHAR            pbInput,
  ULONG             cbInput,
  PUCHAR            pbOutput,
  ULONG             cbOutput
);
"]

{ #category : #api }
BcryptDLL >> BCryptHashData: hHash
pbInput: input
cbInput: length
dwFlags: flags [
	<ulong: BCryptHashData>
	^self invalidArgument

"
NTSTATUS BCryptHashData(
  BCRYPT_HASH_HANDLE hHash,
  PUCHAR             pbInput,
  ULONG              cbInput,
  ULONG              dwFlags
);
"]

{ #category : #api }
BcryptDLL >> BCryptImportKey: hAlgorithm
hImportKey: import
pszBlobType: string
phKey: key
pbKeyObject: object
cbKeyObject: count1
pbInput: input
cbInput: count2
dwFlags: flags [
	<ulong: BCryptImportKey>
	^self invalidArgument

"
NTSTATUS BCryptImportKey(
  BCRYPT_ALG_HANDLE hAlgorithm,
  BCRYPT_KEY_HANDLE hImportKey,
  LPCWSTR           pszBlobType,
  BCRYPT_KEY_HANDLE *phKey,
  PUCHAR            pbKeyObject,
  ULONG             cbKeyObject,
  PUCHAR            pbInput,
  ULONG             cbInput,
  ULONG             dwFlags
);
"]

{ #category : #api }
BcryptDLL >> BCryptOpenAlgorithmProvider: phAlgorithm
pszAlgId: id
pszImplementation: string
dwFlags: flags [
	<ulong: BCryptOpenAlgorithmProvider>
	^self invalidArgument

"
NTSTATUS BCryptOpenAlgorithmProvider(
  BCRYPT_ALG_HANDLE *phAlgorithm,
  LPCWSTR           pszAlgId,
  LPCWSTR           pszImplementation,
  ULONG             dwFlags
);
"]

{ #category : #api }
BcryptDLL >> BCryptSetProperty: hObject
pszProperty: property
pbInput: input
cbInput: count
dwFlags: flags [
	<ulong: BCryptSetProperty>
	^self invalidArgument

"
NTSTATUS BCryptSetProperty(
  BCRYPT_HANDLE hObject,
  LPCWSTR       pszProperty,
  PUCHAR        pbInput,
  ULONG         cbInput,
  ULONG         dwFlags
);
"]

{ #category : #private }
BcryptDLL >> closeProvider: anInteger [
	| status |
	status := self
		BCryptCloseAlgorithmProvider: anInteger asParameter
		dwFlags: 0.
	self status: status]

{ #category : #private }
BcryptDLL >> createHash: hAlgorithm [
	| hash status |
	hash := ExternalPointer external.
	status := self
		BCryptCreateHash: hAlgorithm
		phHash: hash asParameter
		pbHashObject: 0
		cbHashObject: 0
		pbSecret: 0
		cbSecret: 0
		dwFlags: 0.
	self status: status.
	^hash makeInteger]

{ #category : #private }
BcryptDLL >> decrypt: aByteArray symmetricKey: anotherByteArray method: aString [
	^self
		openAlgorithm: aString
		while: [:algorithm | | length object block m n key secret status output |
			length := self algorithm: algorithm property: 'ObjectLength'.
			object := length externalBytes.
			block := self algorithm: algorithm property: 'BlockLength'.
			m := anotherByteArray asByteArray sizeInBytes.
			n := m + block - 1 // block * block.
			key := ExternalPointer external.
			secret := (anotherByteArray asByteArray , (ByteArray new: n - m)) externalCopy.
			self
				algorithm: algorithm
				property: 'ChainingMode'
				value: 'ChainingModeCBC'.
			status := self
				BCryptGenerateSymmetricKey: algorithm asParameter
				phKey: key asParameter
				pbKeyObject: object asParameter
				cbKeyObject: length
				pbSecret: secret asParameter
				cbSecret: secret length
				dwFlags: 0.
			self status: status.
			secret free.
			[| input result |
				key := key makeLocal.
				input := aByteArray asByteArray externalCopy.
				result := ExternalInt32 external.
				status := self
					BCryptEncrypt: key asParameter
					pbInput: input asParameter
					cbInput: input length
					pPaddingInfo: 0
					pbIV: 0
					cbIV: 0
					pbOutput: 0
					cbOutput: 0
					pcbResult: result asParameter
					dwFlags: BCRYPT_BLOCK_PADDING.
				self status: status.
				output := result asInteger externalBytes.
				status := self
					BCryptDecrypt: key asParameter
					pbInput: input asParameter
					cbInput: input length
					pPaddingInfo: 0
					pbIV: 0
					cbIV: 0
					pbOutput: output asParameter
					cbOutput: output length
					pcbResult: result asParameter
					dwFlags: BCRYPT_BLOCK_PADDING.
				self status: status.
				input free.
				result]
				ensure: [
					object free.
					self BCryptDestroyKey: key asParameter].
			output makeBytes]]

{ #category : #private }
BcryptDLL >> destroyHash: handle [
	| status |
	status := self BCryptDestroyHash: handle.
	self status: status]

{ #category : #private }
BcryptDLL >> encrypt: aByteArray symmetricKey: anotherByteArray method: aString [
	^self
		openAlgorithm: aString
		while: [:algorithm | | length object block m n key secret status output |
			length := self algorithm: algorithm property: 'ObjectLength'.
			object := length externalBytes.
			block := self algorithm: algorithm property: 'BlockLength'.
			m := anotherByteArray asByteArray sizeInBytes.
			n := m + block - 1 // block * block.
			key := ExternalPointer external.
			secret := (anotherByteArray asByteArray , (ByteArray new: n - m)) externalCopy.
			self
				algorithm: algorithm
				property: 'ChainingMode'
				value: 'ChainingModeCBC'.
			status := self
				BCryptGenerateSymmetricKey: algorithm asParameter
				phKey: key asParameter
				pbKeyObject: object asParameter
				cbKeyObject: length
				pbSecret: secret asParameter
				cbSecret: secret length
				dwFlags: 0.
			self status: status.
			secret free.
			[| input result |
				key := key makeLocal.
				input := aByteArray asByteArray externalCopy.
				result := ExternalInt32 external.
				status := self
					BCryptEncrypt: key asParameter
					pbInput: input asParameter
					cbInput: input length
					pPaddingInfo: 0
					pbIV: 0
					cbIV: 0
					pbOutput: 0
					cbOutput: 0
					pcbResult: result asParameter
					dwFlags: BCRYPT_BLOCK_PADDING.
				self status: status.
				output := result asInteger externalBytes.
				status := self
					BCryptEncrypt: key asParameter
					pbInput: input asParameter
					cbInput: input length
					pPaddingInfo: 0
					pbIV: 0
					cbIV: 0
					pbOutput: output asParameter
					cbOutput: output length
					pcbResult: result asParameter
					dwFlags: BCRYPT_BLOCK_PADDING.
				self status: status.
				input free.
				result free]
				ensure: [
					object free.
					self BCryptDestroyKey: key asParameter].
			output makeBytes]]

{ #category : #private }
BcryptDLL >> finishHash: handle algorithm: algorithm [
	| length output status |
	length := self algorithm: algorithm property: 'HashDigestLength'.
	output := length externalBytes.
	status := self
		BCryptFinishHash: handle
		pbOutput: output asParameter
		cbOutput: length
		dwFlags: 0.
	self status: status.
	^output makeBytes]

{ #category : #services }
BcryptDLL >> hash: aByteArray method: aString [
	^self openAlgorithm: aString while: [:algorithm | | handle reader |
		handle := self createHash: algorithm.
		[
			reader := aByteArray binaryReadStream.
			[
				[reader atEnd] whileFalse: [| data |
					data := reader peek: 128 kbytes.
					self hashData: data handle: handle.
					reader skip: data sizeInBytes]]
				ensure: [reader == aByteArray ifFalse: [reader close]].
			self finishHash: handle algorithm: algorithm]
			ensure: [self destroyHash: handle]]]

{ #category : #private }
BcryptDLL >> hashData: aByteArray handle: handle [
	| data status |
	data := aByteArray externalCopy.
	status := self
		BCryptHashData: handle
		pbInput: data asParameter
		cbInput: data length
		dwFlags: 0.
	self status: status.
	data free]

{ #category : #services }
BcryptDLL >> md5: aByteArray [
	| data |
	data := aByteArray isString ifTrue: [aByteArray utf8] ifFalse: [aByteArray].
	^self hash: data method: 'MD5']

{ #category : #private }
BcryptDLL >> openAlgorithm: aString while: aBlock [
	| algorithm method status |
	algorithm := ExternalPointer external.
	method := aString externalCopy.
	status := self
		BCryptOpenAlgorithmProvider: algorithm asParameter
		pszAlgId: method asParameter
		pszImplementation: 0
		dwFlags: 0.
	self status: status.
	method free.
	algorithm := algorithm makeInteger.
	^[aBlock evaluateWith: algorithm] ensure: [self closeProvider: algorithm]]

{ #category : #services }
BcryptDLL >> sha1: aByteArray [
	| data |
	data := aByteArray isString ifTrue: [aByteArray utf8] ifFalse: [aByteArray].
	^self hash: data method: 'SHA1']

{ #category : #services }
BcryptDLL >> sha256: aByteArray [
	| data |
	data := aByteArray isString ifTrue: [aByteArray utf8] ifFalse: [aByteArray].
	^self hash: data method: 'SHA256']

{ #category : #api }
BcryptDLL >> status: anInteger [
	| reason |
	anInteger = 0 ifTrue: [^self].
	reason := BcryptConstants keyAtValue: anInteger.
	self error: reason]

