"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM,
	#superclass : #HttpApiStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Server'
}

{ #category : #inspecting }
HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM class >> aspects [
	^#(#AddrLength
		#pAddress)]

{ #category : #private }
HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM class >> def [
	^<def>
	typedef struct _HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM {
		USHORT    AddrLength;
		PSOCKADDR pAddress;
	} HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM, *PHTTP_SERVICE_CONFIG_IP_LISTEN_PARAM;
	</def>]

{ #category : #'instance creation' }
HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM class >> fromIP: ip [
	^self new fromIP: ip]

{ #category : #initialization }
HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM class >> initializeConfigIdConstants [
	WinConstants
		at: 'HttpServiceConfigIPListenList'
		put: 0 "Deletes a specified IP address from the IP Listen List.";
		at: 'HttpServiceConfigSSLCertInfo'
		put: 1 "Deletes a specified SSL certificate record.";
		at: 'HttpServiceConfigUrlAclInfo'
		put: 2 "Deletes a specified URL reservation record.";
		at: 'HttpServiceConfigTimeout'
		put: 3 "Deletes a specified connection timeout. Windows Vista and later:  This enumeration is supported.";
		at: 'HttpServiceConfigSslSniCertInfo'
		put: 4 "Deletes a specified SSL Server Name Indication (SNI) certificate record. Windows 8 and later:  This enumeration value is supported."]

{ #category : #initialization }
HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM class >> initializeConstants [
	self initializeConfigIdConstants]

{ #category : #private }
HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 16;
		at: 'AddrLength' put: 0;
		at: 'pAddress' put: 8;
		yourself]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM >> AddrLength [
	^self uShortAtOffset: AddrLength]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM >> AddrLength: anInteger [
	self uShortAtOffset: AddrLength put: anInteger]

{ #category : #input }
HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM >> fromIP: ip [
	| sa |
	sa := SOCKADDR fromIP: ip.
	self sockaddr: sa]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM >> pAddress [
	^self pointerAtOffset: pAddress]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM >> pAddress: anInteger [
	self pointerAtOffset: pAddress put: anInteger]

{ #category : #input }
HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM >> sockaddr: aSOCKADDR [
	self pAddress: aSOCKADDR externalCopy; AddrLength: aSOCKADDR sizeInBytes]

