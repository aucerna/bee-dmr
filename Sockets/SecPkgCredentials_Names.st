"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SecPkgCredentials_Names,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #sockets
}

{ #category : #inspecting }
SecPkgCredentials_Names class >> aspects [
	^super aspects , #(#username)]

{ #category : #accessing }
SecPkgCredentials_Names class >> def [
	^<def>
	typedef struct _SecPkgCredentials_Names {
		SEC_CHAR *sUserName;
	} SecPkgCredentials_Names, *PSecPkgCredentials_Names;
	</def>]

{ #category : #private }
SecPkgCredentials_Names class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 8;
		at: 'sUserName' put: 0;
		yourself]

{ #category : #accessing }
SecPkgCredentials_Names class >> sizeInBytes [
	^sizeInBytes]

{ #category : #private }
SecPkgCredentials_Names class >> typedefTable [
	^Crypt32DLL typedefTable]

{ #category : #accessing }
SecPkgCredentials_Names >> sUserName [
	^self addressAtOffset: sUserName]

{ #category : #accessing }
SecPkgCredentials_Names >> username [
	^WideString fromMemory: self sUserName]

