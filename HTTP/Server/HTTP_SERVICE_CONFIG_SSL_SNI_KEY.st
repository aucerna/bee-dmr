"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTP_SERVICE_CONFIG_SSL_SNI_KEY,
	#superclass : #HttpApiStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Server'
}

{ #category : #inspecting }
HTTP_SERVICE_CONFIG_SSL_SNI_KEY class >> aspects [
	^#(#IpPort
		#Host)]

{ #category : #private }
HTTP_SERVICE_CONFIG_SSL_SNI_KEY class >> def [
	^<def>
	typedef struct _HTTP_SERVICE_CONFIG_SSL_SNI_KEY {
		SOCKADDR_STORAGE IpPort;
		PWSTR Host;
	} HTTP_SERVICE_CONFIG_SSL_SNI_KEY, *PHTTP_SERVICE_CONFIG_SSL_SNI_KEY;
	</def>]

{ #category : #private }
HTTP_SERVICE_CONFIG_SSL_SNI_KEY class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 136;
		at: 'IpPort' put: 0;
		at: 'Host' put: 128;
		yourself]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_SSL_SNI_KEY class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_SSL_SNI_KEY >> Host [
	^self addressAtOffset: Host]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_SSL_SNI_KEY >> Host: anInteger [
	self addressAtOffset: Host register: anInteger]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_SSL_SNI_KEY >> IpPort [
	^self structureAtOffset: IpPort ofClass: SOCKADDR_STORAGE]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_SSL_SNI_KEY >> IpPort: aSOCKADDR_STORAGE [
	self bytesAtOffset: IpPort put: aSOCKADDR_STORAGE asParameter]

