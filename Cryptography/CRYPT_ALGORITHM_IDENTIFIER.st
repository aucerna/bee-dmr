"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CRYPT_ALGORITHM_IDENTIFIER,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #Cryptography
}

{ #category : #inspecting }
CRYPT_ALGORITHM_IDENTIFIER class >> aspects [
	^super aspects , #(#oid)]

{ #category : #accessing }
CRYPT_ALGORITHM_IDENTIFIER class >> def [
	^<def>
	typedef struct _CRYPT_ALGORITHM_IDENTIFIER {
		LPSTR            pszObjId;
		CRYPT_OBJID_BLOB Parameters;
	} CRYPT_ALGORITHM_IDENTIFIER, *PCRYPT_ALGORITHM_IDENTIFIER;
	</def>]

{ #category : #accessing }
CRYPT_ALGORITHM_IDENTIFIER class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 24;
		at: 'pszObjId' put: 0;
		at: 'Parameters' put: 8;
		yourself]

{ #category : #accessing }
CRYPT_ALGORITHM_IDENTIFIER class >> sizeInBytes [
	^sizeInBytes]

{ #category : #output }
CRYPT_ALGORITHM_IDENTIFIER >> oid [
	| memory |
	memory := self pszObjId.
	^memory isValid ifTrue: [String fromMemory: memory]]

{ #category : #accessing }
CRYPT_ALGORITHM_IDENTIFIER >> Parameters [
	| data |
	data := self bytesAtOffset: Parameters count: CRYPT_OBJID_BLOB sizeInBytes.
	^CRYPT_OBJID_BLOB usingBytes: data]

{ #category : #accessing }
CRYPT_ALGORITHM_IDENTIFIER >> pszObjId [
	^self addressAtOffset: pszObjId]

