"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CERT_INFO,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #Cryptography
}

{ #category : #accessing }
CERT_INFO class >> def [
	^<def>
	typedef struct _CERT_INFO {
		DWORD                      dwVersion;
		CRYPT_INTEGER_BLOB         SerialNumber;
		CRYPT_ALGORITHM_IDENTIFIER SignatureAlgorithm;
		CERT_NAME_BLOB             Issuer;
		FILETIME                   NotBefore;
		FILETIME                   NotAfter;
		CERT_NAME_BLOB             Subject;
		CERT_PUBLIC_KEY_INFO       SubjectPublicKeyInfo;
		CRYPT_BIT_BLOB             IssuerUniqueId;
		CRYPT_BIT_BLOB             SubjectUniqueId;
		DWORD                      cExtension;
		PCERT_EXTENSION            rgExtension;
	}CERT_INFO, *PCERT_INFO;
	</def>]

{ #category : #accessing }
CERT_INFO class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 208;
		at: 'dwVersion' put: 0;
		at: 'SerialNumber' put: 8;
		at: 'SignatureAlgorithm' put: 24;
		at: 'Issuer' put: 48;
		at: 'NotBefore' put: 64;
		at: 'NotAfter' put: 72;
		at: 'Subject' put: 80;
		at: 'SubjectPublicKeyInfo' put: 96;
		at: 'IssuerUniqueId' put: 144;
		at: 'SubjectUniqueId' put: 168;
		at: 'cExtension' put: 192;
		at: 'rgExtension' put: 200;
		yourself]

{ #category : #accessing }
CERT_INFO class >> sizeInBytes [
	^sizeInBytes]

{ #category : #private }
CERT_INFO class >> typedefTable [
	^Crypt32DLL typedefTable]

{ #category : #accessing }
CERT_INFO >> blobAtOffset: anInteger [
	^self bytesAtOffset: anInteger count: CRYPTOAPI_BLOB sizeInBytes]

{ #category : #accessing }
CERT_INFO >> cExtension [
	^self uLongAtOffset: cExtension]

{ #category : #accessing }
CERT_INFO >> dwVersion [
	^self uLongAtOffset: dwVersion]

{ #category : #output }
CERT_INFO >> extension [
	| buffer |
	buffer := BufferArray
		at: self rgExtension
		count: self cExtension
		type: CERT_EXTENSION.
	^buffer asArray]

{ #category : #accessing }
CERT_INFO >> Issuer [
	^self structureAtOffset: Issuer ofClass: CERT_NAME_BLOB]

{ #category : #accessing }
CERT_INFO >> IssuerUniqueId [
	^self structureAtOffset: IssuerUniqueId ofClass: CRYPT_BIT_BLOB]

{ #category : #accessing }
CERT_INFO >> NotAfter [
	| bytes |
	bytes := self bytesAtOffset: NotAfter count: FILETIME sizeInBytes.
	^FILETIME usingBytes: bytes]

{ #category : #accessing }
CERT_INFO >> NotBefore [
	| bytes |
	bytes := self bytesAtOffset: NotBefore count: FILETIME sizeInBytes.
	^FILETIME usingBytes: bytes]

{ #category : #accessing }
CERT_INFO >> rgExtension [
	^self pointerAtOffset: rgExtension]

{ #category : #accessing }
CERT_INFO >> SerialNumber [
	^self structureAtOffset: SerialNumber ofClass: CRYPT_INTEGER_BLOB]

{ #category : #accessing }
CERT_INFO >> SignatureAlgorithm [
	^self structureAtOffset: SignatureAlgorithm ofClass: CRYPT_ALGORITHM_IDENTIFIER]

{ #category : #accessing }
CERT_INFO >> Subject [
	^self structureAtOffset: Subject ofClass: CERT_NAME_BLOB]

{ #category : #accessing }
CERT_INFO >> SubjectPublicKeyInfo [
	^self structureAtOffset: SubjectPublicKeyInfo ofClass: CERT_PUBLIC_KEY_INFO]

{ #category : #accessing }
CERT_INFO >> SubjectUniqueId [
	^self structureAtOffset: SubjectUniqueId ofClass: CRYPT_BIT_BLOB]

