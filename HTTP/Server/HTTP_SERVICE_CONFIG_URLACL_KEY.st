"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTP_SERVICE_CONFIG_URLACL_KEY,
	#superclass : #HttpApiStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Server'
}

{ #category : #inspecting }
HTTP_SERVICE_CONFIG_URLACL_KEY class >> aspects [
	^#(#pUrlPrefix)]

{ #category : #private }
HTTP_SERVICE_CONFIG_URLACL_KEY class >> def [
	^<def>
	typedef struct _HTTP_SERVICE_CONFIG_URLACL_KEY {
		PWSTR pUrlPrefix;
	} HTTP_SERVICE_CONFIG_URLACL_KEY, *PHTTP_SERVICE_CONFIG_URLACL_KEY;
	</def>]

{ #category : #private }
HTTP_SERVICE_CONFIG_URLACL_KEY class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 8;
		at: 'pUrlPrefix' put: 0;
		yourself]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_URLACL_KEY class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_URLACL_KEY >> pUrlPrefix [
	^self addressAtOffset: pUrlPrefix]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_URLACL_KEY >> pUrlPrefix: anInteger [
	self addressAtOffset: pUrlPrefix register: anInteger]

{ #category : #output }
HTTP_SERVICE_CONFIG_URLACL_KEY >> urlPrefix [
	| memory |
	memory := self pUrlPrefix pointedMemory.
	^memory isValid ifTrue: [WideString fromMemory: memory]]

