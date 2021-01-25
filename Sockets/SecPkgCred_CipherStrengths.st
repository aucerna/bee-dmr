"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SecPkgCred_CipherStrengths,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #sockets
}

{ #category : #accessing }
SecPkgCred_CipherStrengths class >> def [
	^<def>
	typedef struct _SecPkgCred_CipherStrengths {
		DWORD dwMinimumCipherStrength;
		DWORD dwMaximumCipherStrength;
	} SecPkgCred_CipherStrengths, *PSecPkgCred_CipherStrengths;
	</def>]

{ #category : #unclassified }
SecPkgCred_CipherStrengths class >> sizeInBytes [
	^sizeInBytes]

{ #category : #unclassified }
SecPkgCred_CipherStrengths >> dwMaximumCipherStrength [
	^self uLongAtOffset: dwMaximumCipherStrength]

{ #category : #accessing }
SecPkgCred_CipherStrengths >> dwMaximumCipherStrength: anInteger [
	self uLongAtOffset: dwMaximumCipherStrength put: anInteger]

{ #category : #unclassified }
SecPkgCred_CipherStrengths >> dwMinimumCipherStrength [
	^self uLongAtOffset: dwMinimumCipherStrength]

{ #category : #accessing }
SecPkgCred_CipherStrengths >> dwMinimumCipherStrength: anInteger [
	self uLongAtOffset: dwMinimumCipherStrength put: anInteger]

