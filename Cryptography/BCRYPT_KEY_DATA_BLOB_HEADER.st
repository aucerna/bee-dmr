"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #BCRYPT_KEY_DATA_BLOB_HEADER,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #Cryptography
}

{ #category : #private }
BCRYPT_KEY_DATA_BLOB_HEADER class >> def [
	^<def>
		typedef struct _BCRYPT_KEY_DATA_BLOB_HEADER {
			ULONG dwMagic; // 0
			ULONG dwVersion; // 4
			ULONG cbKeyData; // 8
		} BCRYPT_KEY_DATA_BLOB_HEADER, *PBCRYPT_KEY_DATA_BLOB_HEADER; // sizeInBytes = 12
	</def>]

{ #category : #accessing }
BCRYPT_KEY_DATA_BLOB_HEADER class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
BCRYPT_KEY_DATA_BLOB_HEADER >> cbKeyData [
	^self uLongAtOffset: cbKeyData]

{ #category : #accessing }
BCRYPT_KEY_DATA_BLOB_HEADER >> cbKeyData: anInteger [
	self uLongAtOffset: cbKeyData put: anInteger]

{ #category : #accessing }
BCRYPT_KEY_DATA_BLOB_HEADER >> dwMagic [
	^self uLongAtOffset: dwMagic]

{ #category : #accessing }
BCRYPT_KEY_DATA_BLOB_HEADER >> dwMagic: anInteger [
	self uLongAtOffset: dwMagic put: anInteger]

{ #category : #accessing }
BCRYPT_KEY_DATA_BLOB_HEADER >> dwVersion [
	^self uLongAtOffset: dwVersion]

{ #category : #accessing }
BCRYPT_KEY_DATA_BLOB_HEADER >> dwVersion: anInteger [
	self uLongAtOffset: dwVersion put: anInteger]

{ #category : #initialization }
BCRYPT_KEY_DATA_BLOB_HEADER >> initialize: anInteger [
	super initialize: anInteger.
	self dwMagic: 0x4d42444b; dwVersion: 1]

{ #category : #outputs }
BCRYPT_KEY_DATA_BLOB_HEADER >> totalLegth [
	^self sizeInBytes + self cbKeyData]

