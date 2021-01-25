"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SecPkgContext_ConnectionInfo,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #sockets
}

{ #category : #accessing }
SecPkgContext_ConnectionInfo class >> def [
	^<def>
	typedef struct _SecPkgContext_ConnectionInfo {
		DWORD  dwProtocol;
		ALG_ID aiCipher;
		DWORD  dwCipherStrength;
		ALG_ID aiHash;
		DWORD  dwHashStrength;
		ALG_ID aiExch;
		DWORD  dwExchStrength;
	} SecPkgContext_ConnectionInfo, *PSecPkgContext_ConnectionInfo;
	</def>]

{ #category : #accessing }
SecPkgContext_ConnectionInfo class >> offsets64 [
^PoolDictionary new
		at: 'dwCipherStrength' put: 16;
		at: 'aiHash' put: 24;
		at: 'dwHashStrength' put: 32;
		at: 'sizeInBytes' put: 56;
		at: 'aiExch' put: 40;
		at: 'dwProtocol' put: 0;
		at: 'dwExchStrength' put: 48;
		at: 'aiCipher' put: 8;
		yourself]

{ #category : #accessing }
SecPkgContext_ConnectionInfo class >> sizeInBytes [
	^sizeInBytes]

{ #category : #private }
SecPkgContext_ConnectionInfo class >> typedefTable [
	^Crypt32DLL typedefTable]

{ #category : #accessing }
SecPkgContext_ConnectionInfo >> aiCipher [
	^self uLongAtOffset: aiCipher]

{ #category : #accessing }
SecPkgContext_ConnectionInfo >> aiCipher: anInteger [
	self pointerAtOffset: aiCipher put: anInteger]

{ #category : #accessing }
SecPkgContext_ConnectionInfo >> aiExch [
	^self uLongAtOffset: aiExch]

{ #category : #accessing }
SecPkgContext_ConnectionInfo >> aiExch: anInteger [
	self pointerAtOffset: aiExch put: anInteger]

{ #category : #accessing }
SecPkgContext_ConnectionInfo >> aiHash [
	^self uLongAtOffset: aiHash]

{ #category : #accessing }
SecPkgContext_ConnectionInfo >> aiHash: anInteger [
	self pointerAtOffset: aiHash put: anInteger]

{ #category : #accessing }
SecPkgContext_ConnectionInfo >> dwCipherStrength [
	^self uLongAtOffset: dwCipherStrength]

{ #category : #accessing }
SecPkgContext_ConnectionInfo >> dwCipherStrength: anInteger [
	self uLongAtOffset: dwCipherStrength put: anInteger]

{ #category : #accessing }
SecPkgContext_ConnectionInfo >> dwExchStrength [
	^self uLongAtOffset: dwExchStrength]

{ #category : #accessing }
SecPkgContext_ConnectionInfo >> dwExchStrength: anInteger [
	self uLongAtOffset: dwExchStrength put: anInteger]

{ #category : #accessing }
SecPkgContext_ConnectionInfo >> dwHashStrength [
	^self uLongAtOffset: dwHashStrength]

{ #category : #accessing }
SecPkgContext_ConnectionInfo >> dwHashStrength: anInteger [
	self uLongAtOffset: dwHashStrength put: anInteger]

{ #category : #accessing }
SecPkgContext_ConnectionInfo >> dwProtocol [
	^self uLongAtOffset: dwProtocol]

{ #category : #accessing }
SecPkgContext_ConnectionInfo >> dwProtocol: anInteger [
	self uLongAtOffset: dwProtocol put: anInteger]

