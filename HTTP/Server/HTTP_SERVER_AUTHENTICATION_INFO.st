"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTP_SERVER_AUTHENTICATION_INFO,
	#superclass : #HttpApiStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Server'
}

{ #category : #inspecting }
HTTP_SERVER_AUTHENTICATION_INFO class >> aspects [
	^#(
		#Flags
		#AuthSchemes
		#ReceiveMutualAuth
		#ReceiveContextHandle
		#DisableNTLMCredentialCaching
		#ExFlags
		#DigestParams
		#BasicParams)]

{ #category : #accessing }
HTTP_SERVER_AUTHENTICATION_INFO class >> def [
	^<def>
	typedef struct {
		HTTP_PROPERTY_FLAGS                      Flags;
		ULONG                                    AuthSchemes;
		BOOLEAN                                  ReceiveMutualAuth;
		BOOLEAN                                  ReceiveContextHandle;
		BOOLEAN                                  DisableNTLMCredentialCaching;
		UCHAR                                    ExFlags;
		HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS DigestParams;
		HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS		BasicParams;
	} HTTP_SERVER_AUTHENTICATION_INFO, *PHTTP_SERVER_AUTHENTICATION_INFO;
	</def>]

{ #category : #private }
HTTP_SERVER_AUTHENTICATION_INFO class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 64;
		at: 'Flags' put: 0;
		at: 'AuthSchemes' put: 4;
		at: 'ReceiveMutualAuth' put: 8;
		at: 'ReceiveContextHandle' put: 9;
		at: 'DisableNTLMCredentialCaching' put: 10;
		at: 'ExFlags' put: 11;
		at: 'DigestParams' put: 16;
		at: 'BasicParams' put: 48;
		yourself]

{ #category : #accessing }
HTTP_SERVER_AUTHENTICATION_INFO class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
HTTP_SERVER_AUTHENTICATION_INFO >> AuthSchemes [
	^self uLongAtOffset: AuthSchemes]

{ #category : #accessing }
HTTP_SERVER_AUTHENTICATION_INFO >> AuthSchemes: anInteger [
	self uLongAtOffset: AuthSchemes put: anInteger]

{ #category : #accessing }
HTTP_SERVER_AUTHENTICATION_INFO >> BasicParams [
	| bytes |
	bytes := self
		bytesAtOffset: BasicParams
		count: HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS sizeInBytes.
	^HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS usingBytes: bytes]

{ #category : #accessing }
HTTP_SERVER_AUTHENTICATION_INFO >> BasicParams: anHTTP_SERVER_AUTHENTICATION_BASIC_PARAMS [
	self
		bytesAtOffset: BasicParams
		put: anHTTP_SERVER_AUTHENTICATION_BASIC_PARAMS contents.
	anHTTP_SERVER_AUTHENTICATION_BASIC_PARAMS transferRegistryTo: self]

{ #category : #accessing }
HTTP_SERVER_AUTHENTICATION_INFO >> DigestParams [
	| bytes |
	bytes := self
		bytesAtOffset: DigestParams
		count: HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS sizeInBytes.
	^HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS usingBytes: bytes]

{ #category : #accessing }
HTTP_SERVER_AUTHENTICATION_INFO >> DigestParams: anHTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS [
	self
		bytesAtOffset: DigestParams
		put: anHTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS contents.
	anHTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS transferRegistryTo: self]

{ #category : #accessing }
HTTP_SERVER_AUTHENTICATION_INFO >> DisableNTLMCredentialCaching [
	^self byteAtOffset: DisableNTLMCredentialCaching]

{ #category : #accessing }
HTTP_SERVER_AUTHENTICATION_INFO >> DisableNTLMCredentialCaching: aBoolean [
	self byteAtOffset: DisableNTLMCredentialCaching put: aBoolean asParameter]

{ #category : #accessing }
HTTP_SERVER_AUTHENTICATION_INFO >> ExFlags [
	^self byteAtOffset: ExFlags]

{ #category : #accessing }
HTTP_SERVER_AUTHENTICATION_INFO >> ExFlags: aBoolean [
	self byteAtOffset: ExFlags put: aBoolean]

{ #category : #accessing }
HTTP_SERVER_AUTHENTICATION_INFO >> Flags [
	| data |
	data := self bytesAtOffset: Flags count: HTTP_PROPERTY_FLAGS sizeInBytes.
	^HTTP_PROPERTY_FLAGS usingBytes: data]

{ #category : #accessing }
HTTP_SERVER_AUTHENTICATION_INFO >> Flags: anHTTP_PROPERTY_FLAGS [
	self bytesAtOffset: Flags put: anHTTP_PROPERTY_FLAGS contents]

{ #category : #accessing }
HTTP_SERVER_AUTHENTICATION_INFO >> ReceiveContextHandle [
	^self byteAtOffset: ReceiveContextHandle]

{ #category : #accessing }
HTTP_SERVER_AUTHENTICATION_INFO >> ReceiveContextHandle: aBoolean [
	self byteAtOffset: ReceiveContextHandle put: aBoolean asParameter]

{ #category : #accessing }
HTTP_SERVER_AUTHENTICATION_INFO >> ReceiveMutualAuth [
	^self byteAtOffset: ReceiveMutualAuth]

{ #category : #accessing }
HTTP_SERVER_AUTHENTICATION_INFO >> ReceiveMutualAuth: aBoolean [
	self byteAtOffset: ReceiveMutualAuth put: aBoolean asParameter]

