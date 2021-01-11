"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTP_SERVICE_CONFIG_URLACL_PARAM,
	#superclass : #HttpApiStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Server'
}

{ #category : #inspecting }
HTTP_SERVICE_CONFIG_URLACL_PARAM class >> aspects [
	^#(#pStringSecurityDescriptor)]

{ #category : #private }
HTTP_SERVICE_CONFIG_URLACL_PARAM class >> def [
	^<def>
	typedef struct _HTTP_SERVICE_CONFIG_URLACL_PARAM {
		PWSTR pStringSecurityDescriptor;
	} HTTP_SERVICE_CONFIG_URLACL_PARAM, *PHTTP_SERVICE_CONFIG_URLACL_PARAM;
	</def>]

{ #category : #private }
HTTP_SERVICE_CONFIG_URLACL_PARAM class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 8;
		at: 'pStringSecurityDescriptor' put: 0;
		yourself]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_URLACL_PARAM class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_URLACL_PARAM >> pStringSecurityDescriptor [
	^self addressAtOffset: pStringSecurityDescriptor]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_URLACL_PARAM >> pStringSecurityDescriptor: anInteger [
	self addressAtOffset: pStringSecurityDescriptor register: anInteger]

{ #category : #output }
HTTP_SERVICE_CONFIG_URLACL_PARAM >> sddl [
	| memory |
	memory := self pStringSecurityDescriptor.
	^memory isValid ifTrue: [WideString fromMemory: memory]]

