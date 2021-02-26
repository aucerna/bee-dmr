"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CRYPTOAPI_BLOB,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #Cryptography
}

{ #category : #accessing }
CRYPTOAPI_BLOB class >> def [
	^<def>
	typedef struct _CRYPTOAPI_BLOB {
		DWORD cbData;
		BYTE  *pbData;
	} CRYPT_INTEGER_BLOB, *PCRYPT_INTEGER_BLOB, CRYPT_UINT_BLOB, *PCRYPT_UINT_BLOB, CRYPT_OBJID_BLOB, *PCRYPT_OBJID_BLOB, CERT_NAME_BLOB, *PCERT_NAME_BLOB, CERT_RDN_VALUE_BLOB, *PCERT_RDN_VALUE_BLOB, CERT_BLOB, *PCERT_BLOB, CRL_BLOB, *PCRL_BLOB, DATA_BLOB, *PDATA_BLOB, CRYPT_DATA_BLOB, *PCRYPT_DATA_BLOB, CRYPT_HASH_BLOB, *PCRYPT_HASH_BLOB, CRYPT_DIGEST_BLOB, *PCRYPT_DIGEST_BLOB, CRYPT_DER_BLOB, *PCRYPT_DER_BLOB, CRYPT_ATTR_BLOB, *PCRYPT_ATTR_BLOB;
	</def>]

{ #category : #private }
CRYPTOAPI_BLOB class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 16;
		at: 'cbData' put: 0;
		at: 'pbData' put: 8;
		yourself]

{ #category : #accessing }
CRYPTOAPI_BLOB class >> sizeInBytes [
	^sizeInBytes]

{ #category : #private }
CRYPTOAPI_BLOB class >> typedefTable [
	^Crypt32DLL typedefTable]

{ #category : #accessing }
CRYPTOAPI_BLOB >> cbData [
	^self uLongAtOffset: cbData]

{ #category : #accessing }
CRYPTOAPI_BLOB >> cbData: anInteger [
	self uLongAtOffset: cbData put: anInteger]

{ #category : #input }
CRYPTOAPI_BLOB >> clear [
	self pbData pointedMemory clear: self cbData]

{ #category : #output }
CRYPTOAPI_BLOB >> data [
	| memory |
	memory := self pbData pointedMemory.
	memory isValid ifFalse: [^nil].
	^memory copyFrom: 1 to: self cbData]

{ #category : #input }
CRYPTOAPI_BLOB >> data: aByteArray [
	| memory |
	memory := aByteArray isExternalMemory
		ifTrue: [aByteArray]
		ifFalse: [aByteArray asByteArray externalCopy].
	self pbData: memory; cbData: memory length]

{ #category : #finalization }
CRYPTOAPI_BLOB >> free [
	self clear.
	super free]

{ #category : #output }
CRYPTOAPI_BLOB >> integer [
	| data |
	data := ByteArray new: self cbData.
	^data
		replaceFrom: 1
		to: data size
		with: self pbData asInteger
		startingAt: 1]

{ #category : #accessing }
CRYPTOAPI_BLOB >> pbData [
	^self addressAtOffset: pbData]

{ #category : #accessing }
CRYPTOAPI_BLOB >> pbData: anExternalMemory [
	self addressAtOffset: pbData register: anExternalMemory]

