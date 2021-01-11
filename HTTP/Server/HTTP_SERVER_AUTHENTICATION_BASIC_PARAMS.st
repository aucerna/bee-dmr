"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS,
	#superclass : #HttpApiStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Server'
}

{ #category : #inspecting }
HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS class >> aspects [
	^#(#realm)]

{ #category : #accessing }
HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS class >> def [
	^<def>
	typedef struct {
		USHORT RealmLength;
		PWSTR  Realm;
	} HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS, *PHTTP_SERVER_AUTHENTICATION_BASIC_PARAMS;
	</def>]

{ #category : #private }
HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 16;
		at: 'RealmLength' put: 0;
		at: 'Realm' put: 8;
		yourself]

{ #category : #accessing }
HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS class >> sizeInBytes [
	^sizeInBytes]

{ #category : #output }
HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS >> realm [
	^self Realm isValid
		ifTrue: [UTF16 decodeFromAddress: self Realm length: self RealmLength]]

{ #category : #accessing }
HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS >> Realm [
	^self addressAtOffset: Realm]

{ #category : #accessing }
HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS >> Realm: anExternalMemory [
	self addressAtOffset: Realm register: anExternalMemory]

{ #category : #input }
HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS >> realm: aString [
	| memory |
	memory := aString externalCopy.
	self
		RealmLength: memory length - 2;
		Realm: memory]

{ #category : #accessing }
HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS >> RealmLength [
	^self uShortAtOffset: RealmLength]

{ #category : #accessing }
HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS >> RealmLength: anInteger [
	self uShortAtOffset: RealmLength put: anInteger]

