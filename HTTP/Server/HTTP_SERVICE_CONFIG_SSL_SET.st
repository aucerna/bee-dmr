"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTP_SERVICE_CONFIG_SSL_SET,
	#superclass : #HttpApiStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Server'
}

{ #category : #inspecting }
HTTP_SERVICE_CONFIG_SSL_SET class >> aspects [
	^#(#KeyDesc
		#ParamDesc)]

{ #category : #private }
HTTP_SERVICE_CONFIG_SSL_SET class >> def [
	^<def>
	typedef struct _HTTP_SERVICE_CONFIG_SSL_SET {
		HTTP_SERVICE_CONFIG_SSL_KEY   KeyDesc;
		HTTP_SERVICE_CONFIG_SSL_PARAM ParamDesc;
	} HTTP_SERVICE_CONFIG_SSL_SET, *PHTTP_SERVICE_CONFIG_SSL_SET;
	</def>]

{ #category : #private }
HTTP_SERVICE_CONFIG_SSL_SET class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 88;
		at: 'KeyDesc' put: 0;
		at: 'ParamDesc' put: 8;
		yourself]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_SSL_SET class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_SSL_SET >> KeyDesc [
	^self structureAtOffset: KeyDesc ofClass: HTTP_SERVICE_CONFIG_SSL_KEY]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_SSL_SET >> KeyDesc: aHTTP_SERVICE_CONFIG_SSL_KEY [
	self bytesAtOffset: KeyDesc put: aHTTP_SERVICE_CONFIG_SSL_KEY asParameter]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_SSL_SET >> ParamDesc [
	^self structureAtOffset: ParamDesc ofClass: HTTP_SERVICE_CONFIG_SSL_PARAM]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_SSL_SET >> ParamDesc: aHTTP_SERVICE_CONFIG_SSL_PARAM [
	self bytesAtOffset: ParamDesc put: aHTTP_SERVICE_CONFIG_SSL_PARAM asParameter]

