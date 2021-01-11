"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS,
	#superclass : #HttpApiStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Server'
}

{ #category : #inspecting }
HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS class >> aspects [
	^#(
		#DomainNameLength
		#DomainName
		#RealmLength
		#Realm)]

{ #category : #accessing }
HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS class >> def [
	^<def>
	typedef struct {
		USHORT DomainNameLength;
		PWSTR  DomainName;
		USHORT RealmLength;
		PWSTR  Realm;
	} HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS, *PHTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS;
	</def>]

{ #category : #private }
HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 32;
		at: 'DomainNameLength' put: 0;
		at: 'DomainName' put: 8;
		at: 'RealmLength' put: 16;
		at: 'Realm' put: 24;
		yourself]

{ #category : #accessing }
HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS class >> sizeInBytes [
	^sizeInBytes]

{ #category : #output }
HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS >> domain [
	^self DomainName isValid
		ifTrue: [String fromMemory: self DomainName length: self DomainName Length]]

{ #category : #input }
HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS >> domain: aString [
	| memory |
	memory := aString externalCopy.
	self
		DomainNameLength: memory length - 2;
		DomainName: memory]

{ #category : #accessing }
HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS >> DomainName [
	^self addressAtOffset: DomainName]

{ #category : #accessing }
HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS >> DomainName: anExternalMemory [
	self addressAtOffset: DomainName register: anExternalMemory]

{ #category : #accessing }
HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS >> DomainNameLength [
	^self uShortAtOffset: DomainNameLength]

{ #category : #accessing }
HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS >> DomainNameLength: anInteger [
	self uShortAtOffset: DomainNameLength put: anInteger]

{ #category : #output }
HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS >> realm [
	^self Realm isValid
		ifTrue: [String fromMemory: self Realm length: self RealmLength]]

{ #category : #accessing }
HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS >> Realm [
	^self addressAtOffset: Realm]

{ #category : #input }
HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS >> realm: aString [
	| memory |
	memory := aString utf16 externalCopy.
	self
		RealmLength: memory length - 2;
		Realm: memory]

{ #category : #accessing }
HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS >> Realm: anExternaAddress [
	self addressAtOffset: Realm register: anExternaAddress]

{ #category : #accessing }
HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS >> RealmLength [
	^self uShortAtOffset: RealmLength]

{ #category : #accessing }
HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS >> RealmLength: anInteger [
	self uShortAtOffset: RealmLength put: anInteger]

