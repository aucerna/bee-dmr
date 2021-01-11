"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTP_SERVICE_CONFIG_SSL_KEY,
	#superclass : #HttpApiStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Server'
}

{ #category : #inspecting }
HTTP_SERVICE_CONFIG_SSL_KEY class >> aspects [
	^#(#pIpPort)]

{ #category : #private }
HTTP_SERVICE_CONFIG_SSL_KEY class >> def [
	^<def>
	typedef struct _HTTP_SERVICE_CONFIG_SSL_KEY {
		PSOCKADDR pIpPort;
	} HTTP_SERVICE_CONFIG_SSL_KEY, *PHTTP_SERVICE_CONFIG_SSL_KEY;
	</def>]

{ #category : #'instance creation' }
HTTP_SERVICE_CONFIG_SSL_KEY class >> fromIP: ip [
	^self new fromIP: ip]

{ #category : #private }
HTTP_SERVICE_CONFIG_SSL_KEY class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 8;
		at: 'pIpPort' put: 0;
		yourself]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_SSL_KEY class >> sizeInBytes [
	^sizeInBytes]

{ #category : #input }
HTTP_SERVICE_CONFIG_SSL_KEY >> fromIP: ip [
	| sa |
	sa := SOCKADDR fromIP: ip.
	self pIpPort: sa externalCopy]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_SSL_KEY >> pIpPort [
	^self pointerAtOffset: pIpPort]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_SSL_KEY >> pIpPort: anInteger [
	self pointerAtOffset: pIpPort put: anInteger]

