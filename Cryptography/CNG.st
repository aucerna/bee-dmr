"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CNG,
	#superclass : #Object,
	#instVars : [
		'method',
		'output',
		'algorithm',
		'chaining',
		'key'
	],
	#category : #Cryptography
}

{ #category : #'instance creation' }
CNG class >> new [
	^super new initialize]

{ #category : #accessing }
CNG >> algorithm: aString [
	method := aString]

{ #category : #private }
CNG >> blockLength [
	^self property: 'BlockLength']

{ #category : #accessing }
CNG >> chainingMode: aString [
	chaining := 'ChainingMode' , aString asUppercase]

{ #category : #private }
CNG >> close [
	| status |
	algorithm isNil ifTrue: [^self].
	self closeKey.
	status := BcryptDLL current
		BCryptCloseAlgorithmProvider: algorithm
		dwFlags: 0.
	self status: status.
	algorithm := nil]

{ #category : #private }
CNG >> closeKey [
	| status |
	key isNil ifTrue: [^self].
	status := BcryptDLL current BCryptDestroyKey: key key asInteger.
	self status: status.
	key value free.
	key := nil]

{ #category : #private }
CNG >> decrypt: aStream [
	| block |
	block := self blockLength.
	[aStream atEnd] whileFalse: [| blob |
		blob := aStream peek: block.
		self decryptNext: blob.
		aStream skip: blob size]]

{ #category : #services }
CNG >> decrypt: aStream symmetricKey: aString [
	self open.
	[self symmetricKey: aString; decrypt: aStream readStream]
		ensure: [self close]]

{ #category : #private }
CNG >> decryptNext: aByteArray [
	| plaintext result status out |
	plaintext := aByteArray asByteArray externalCopy.
	result := ExternalInt32 external.
	status := BcryptDLL current
		BCryptDecrypt: key key asParameter
		pbInput: plaintext asParameter
		cbInput: plaintext length
		pPaddingInfo: 0
		pbIV: 0
		cbIV: 0
		pbOutput: 0
		cbOutput: 0
		pcbResult: result asParameter
		dwFlags: BCRYPT_BLOCK_PADDING.
	self status: status.
	out := result asInteger externalBytes.
	status := BcryptDLL current
		BCryptDecrypt: key key asParameter
		pbInput: plaintext asParameter
		cbInput: plaintext length
		pPaddingInfo: 0
		pbIV: 0
		cbIV: 0
		pbOutput: out asParameter
		cbOutput: out length
		pcbResult: result asParameter
		dwFlags: BCRYPT_BLOCK_PADDING.
	self status: status.
	output nextBytesPut: out makeBytes.
	plaintext free.
	result free]

{ #category : #private }
CNG >> encrypt: aStream [
	| block |
	block := self blockLength.
	[aStream atEnd] whileFalse: [| plaintext |
		plaintext := aStream peek: block.
		self encryptNext: plaintext.
		aStream skip: plaintext size]]

{ #category : #services }
CNG >> encrypt: aStream symmetricKey: aString [
	self open.
	[self symmetricKey: aString; encrypt: aStream readStream]
		ensure: [self close]]

{ #category : #private }
CNG >> encryptNext: aString [
	| plaintext result status out |
	plaintext := aString asByteArray externalCopy.
	result := ExternalInt32 external.
	status := BcryptDLL current
		BCryptEncrypt: key key asParameter
		pbInput: plaintext asParameter
		cbInput: plaintext length
		pPaddingInfo: 0
		pbIV: 0
		cbIV: 0
		pbOutput: 0
		cbOutput: 0
		pcbResult: result asParameter
		dwFlags: BCRYPT_BLOCK_PADDING.
	self status: status.
	out := result asInteger externalBytes.
	status := BcryptDLL current
		BCryptEncrypt: key key asParameter
		pbInput: plaintext asParameter
		cbInput: plaintext length
		pPaddingInfo: 0
		pbIV: 0
		cbIV: 0
		pbOutput: out asParameter
		cbOutput: out length
		pcbResult: result asParameter
		dwFlags: BCRYPT_BLOCK_PADDING.
	self status: status.
	output nextBytesPut: out makeBytes.
	plaintext free.
	result free]

{ #category : #services }
CNG >> exportKey [
	| type result status struct out n |
	type := 'KeyDataBlob' externalCopy.
	result := ExternalInt32 external.
	status := BcryptDLL current
		BCryptExportKey: key key asParameter
		hExportKey: 0
		pszBlobType: type asParameter
		pbOutput: 0
		cbOutput: 0
		pcbResult: result asParameter
		dwFlags: 0.
	self status: status.
	struct := BCRYPT_KEY_DATA_BLOB_HEADER new cbKeyData: result asInteger.
	n := struct sizeInBytes + result asInteger.
	out := n externalBytes.
	status := BcryptDLL current
		BCryptExportKey: key key asParameter
		hExportKey: 0
		pszBlobType: type asParameter
		pbOutput: out asParameter
		cbOutput: out length
		pcbResult: result asParameter
		dwFlags: 0.
	self status: status.
	type free.
	result free.
	^out makeBytes]

{ #category : #services }
CNG >> importKey: blob [
	| type hkey object input status |
	type := 'KeyDataBlob' externalCopy.
	hkey := ExternalPointer external.
	object := self objectLength externalBytes.
	input := blob externalCopy.
	status := BcryptDLL current
		BCryptImportKey: algorithm
		hImportKey: 0
		pszBlobType: type asParameter
		phKey: hkey asParameter
		pbKeyObject: object asParameter
		cbKeyObject: object length
		pbInput: input asParameter
		cbInput: input length
		dwFlags: 0.
	self status: status.
	type free.
	input free.
	key := hkey makeLocal -> object]

{ #category : #initialization }
CNG >> initialize [
	super initialize.
	output := #[] writeStream.
	method := 'AES'.
	chaining := 'ChainingModeCBC']

{ #category : #private }
CNG >> objectLength [
	^self property: 'ObjectLength']

{ #category : #private }
CNG >> open [
	| name status pointer |
	pointer := ExternalPointer external.
	name := method externalCopy.
	status := BcryptDLL current
		BCryptOpenAlgorithmProvider: pointer asParameter
		pszAlgId: name asParameter
		pszImplementation: 0
		dwFlags: 0.
	self status: status.
	name free.
	algorithm := pointer makeInteger]

{ #category : #output }
CNG >> output [
	^output contents]

{ #category : #accessing }
CNG >> output: anObject [
	output := self writeStreamFrom: anObject]

{ #category : #private }
CNG >> property: aString [
	| prop data count status |
	prop := aString externalCopy.
	data := ExternalInt32 external.
	count := ExternalInt32 external.
	status := BcryptDLL current
		BCryptGetProperty: algorithm
		pszProperty: prop asParameter
		pbOutput: data asParameter
		cbOutput: 4
		pcbResult: count asParameter
		dwFlags: 0.
	self status: status.
	self ASSERT: count makeInteger = 4.
	^data makeInteger]

{ #category : #private }
CNG >> property: aString value: anObject [
	| prop data status |
	prop := aString externalCopy.
	data := anObject externalCopy.
	status := BcryptDLL current
		BCryptSetProperty: algorithm
		pszProperty: prop asParameter
		pbInput: data asParameter
		cbInput: data length
		dwFlags: 0.
	self status: status]

{ #category : #private }
CNG >> status: anInteger [
	| reason |
	anInteger = 0 ifTrue: [^self].
	reason := BcryptConstants keyAtValue: anInteger.
	self error: reason]

{ #category : #private }
CNG >> symmetricKey: aString [
	| length object block bytes padding k secret status |
	length := self objectLength.
	object := length externalBytes.
	block := self blockLength.
	bytes := aString asByteArray.
	padding := ByteArray new: block - bytes sizeInBytes.
	k := ExternalPointer external.
	secret := (bytes , padding) externalCopy.
	self property: 'ChainingMode' value: chaining.
	status := BcryptDLL current
		BCryptGenerateSymmetricKey: algorithm
		phKey: k asParameter
		pbKeyObject: object asParameter
		cbKeyObject: length
		pbSecret: secret asParameter
		cbSecret: secret length
		dwFlags: 0.
	self status: status.
	secret free.
	key := k makeLocal -> object]

{ #category : #private }
CNG >> writeStreamFrom: anObject [
	anObject isStream ifTrue: [^anObject].
	anObject isFile ifTrue: [^anObject binaryWriteStream].
	anObject isFilename ifTrue: [^anObject newFile].
	anObject isNil ifTrue: [^#[] writeStream].
	self error: 'invalid object']

