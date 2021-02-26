"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CERT_PUBLIC_KEY_INFO,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #Cryptography
}

{ #category : #accessing }
CERT_PUBLIC_KEY_INFO class >> def [
	^<def>
	typedef struct _CERT_PUBLIC_KEY_INFO {
		CRYPT_ALGORITHM_IDENTIFIER Algorithm;
		CRYPT_BIT_BLOB             PublicKey;
	} CERT_PUBLIC_KEY_INFO, *PCERT_PUBLIC_KEY_INFO;
	</def>]

{ #category : #accessing }
CERT_PUBLIC_KEY_INFO class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 48;
		at: 'Algorithm' put: 0;
		at: 'PublicKey' put: 24;
		yourself]

{ #category : #accessing }
CERT_PUBLIC_KEY_INFO class >> sizeInBytes [
	^sizeInBytes]

