"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CRYPT_BIT_BLOB,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #Cryptography
}

{ #category : #accessing }
CRYPT_BIT_BLOB class >> def [
	^<def>
	typedef struct _CRYPT_BIT_BLOB {
		DWORD cbData;
		BYTE  *pbData;
		DWORD cUnusedBits;
	} CRYPT_BIT_BLOB, *PCRYPT_BIT_BLOB;
	</def>]

{ #category : #accessing }
CRYPT_BIT_BLOB class >> offsets64 [
^PoolDictionary new
		at: 'cUnusedBits' put: 16;
		at: 'sizeInBytes' put: 24;
		at: 'pbData' put: 8;
		at: 'cbData' put: 0;
		yourself]

{ #category : #accessing }
CRYPT_BIT_BLOB class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
CRYPT_BIT_BLOB >> cbData [
	^self uLongAtOffset: cbData]

{ #category : #accessing }
CRYPT_BIT_BLOB >> cbData: anInteger [
	self uLongAtOffset: cbData put: anInteger]

{ #category : #accessing }
CRYPT_BIT_BLOB >> cUnusedBits [
	^self uLongAtOffset: cUnusedBits]

{ #category : #accessing }
CRYPT_BIT_BLOB >> cUnusedBits: anInteger [
	self uLongAtOffset: cUnusedBits put: anInteger]

{ #category : #output }
CRYPT_BIT_BLOB >> data [
	| memory |
	memory := self pbData.
	^memory isValid ifTrue: [memory copyFrom: 1 to: self cbData]]

{ #category : #output }
CRYPT_BIT_BLOB >> integer [
	| data |
	data := ByteArray new: self cbData.
	^data
		replaceFrom: 1
		to: data size
		with: self pbData asInteger
		startingAt: 1]

{ #category : #accessing }
CRYPT_BIT_BLOB >> pbData [
	^self pointerAtOffset: pbData]

{ #category : #accessing }
CRYPT_BIT_BLOB >> pbData: anInteger [
	self pointerAtOffset: pbData put: anInteger]

