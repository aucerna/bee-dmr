"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTP_SERVICE_CONFIG_URLACL_SET,
	#superclass : #HttpApiStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Server'
}

{ #category : #inspecting }
HTTP_SERVICE_CONFIG_URLACL_SET class >> aspects [
	^#(#KeyDesc
		#ParamDesc)]

{ #category : #private }
HTTP_SERVICE_CONFIG_URLACL_SET class >> def [
	^<def>
	typedef struct _HTTP_SERVICE_CONFIG_URLACL_SET {
		HTTP_SERVICE_CONFIG_URLACL_KEY KeyDesc;
		HTTP_SERVICE_CONFIG_URLACL_PARAM ParamDesc;
	} HTTP_SERVICE_CONFIG_URLACL_SET, *PHTTP_SERVICE_CONFIG_URLACL_SET;
	</def>]

{ #category : #private }
HTTP_SERVICE_CONFIG_URLACL_SET class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 16;
		at: 'KeyDesc' put: 0;
		at: 'ParamDesc' put: 8;
		yourself]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_URLACL_SET class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_URLACL_SET >> KeyDesc [
	^self structureAtOffset: KeyDesc ofClass: HTTP_SERVICE_CONFIG_URLACL_KEY]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_URLACL_SET >> KeyDesc: aHTTP_SERVICE_CONFIG_URLACL_KEY [
	self bytesAtOffset: KeyDesc put: aHTTP_SERVICE_CONFIG_URLACL_KEY asParameter]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_URLACL_SET >> ParamDesc [
	^self structureAtOffset: ParamDesc ofClass: HTTP_SERVICE_CONFIG_URLACL_PARAM]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_URLACL_SET >> ParamDesc: aHTTP_SERVICE_CONFIG_URLACL_PARAM [
	self bytesAtOffset: ParamDesc put: aHTTP_SERVICE_CONFIG_URLACL_PARAM asParameter]

