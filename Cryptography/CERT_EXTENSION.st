"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CERT_EXTENSION,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #Cryptography
}

{ #category : #accessing }
CERT_EXTENSION class >> def [
	^<def>
	typedef struct _CERT_EXTENSION {
		LPSTR            pszObjId;
		BOOL             fCritical;
		CRYPT_OBJID_BLOB Value;
	} CERT_EXTENSION, *PCERT_EXTENSION;
	</def>]

{ #category : #accessing }
CERT_EXTENSION class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 32;
		at: 'pszObjId' put: 0;
		at: 'fCritical' put: 8;
		at: 'Value' put: 16;
		yourself]

{ #category : #accessing }
CERT_EXTENSION class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
CERT_EXTENSION >> fCritical [
	^self longAtOffset: fCritical]

{ #category : #accessing }
CERT_EXTENSION >> fCritical: anInteger [
	self longAtOffset: fCritical put: anInteger]

{ #category : #output }
CERT_EXTENSION >> oid [
	| memory |
	memory := self pszObjId.
	^memory isValid ifTrue: [String fromMemory: memory]]

{ #category : #accessing }
CERT_EXTENSION >> pszObjId [
	^self pointerAtOffset: pszObjId]

{ #category : #accessing }
CERT_EXTENSION >> pszObjId: anInteger [
	self pointerAtOffset: pszObjId put: anInteger]

{ #category : #accessing }
CERT_EXTENSION >> Value [
	^self structureAtOffset: Value ofClass: CRYPT_OBJID_BLOB]

{ #category : #accessing }
CERT_EXTENSION >> Value: aCRYPT_OBJID_BLOB [
	self bytesAtOffset: Value put: aCRYPT_OBJID_BLOB asParameter]

