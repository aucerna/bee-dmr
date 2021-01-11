"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTP_SSL_CLIENT_CERT_INFO,
	#superclass : #HttpApiStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Server'
}

{ #category : #inspecting }
HTTP_SSL_CLIENT_CERT_INFO class >> aspects [
	^#(#CertFlags
		#CertEncodedSize
		#pCertEncoded
		#Token
		#CertDeniedByMapper)]

{ #category : #accessing }
HTTP_SSL_CLIENT_CERT_INFO class >> def [
	^<def>
	typedef struct _HTTP_SSL_CLIENT_CERT_INFO {
		ULONG   CertFlags;
		ULONG   CertEncodedSize;
		PUCHAR  pCertEncoded;
		HANDLE  Token;
		BOOLEAN CertDeniedByMapper;
	} HTTP_SSL_CLIENT_CERT_INFO, *PHTTP_SSL_CLIENT_CERT_INFO;
	</def>]

{ #category : #private }
HTTP_SSL_CLIENT_CERT_INFO class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 32;
		at: 'CertFlags' put: 0;
		at: 'CertEncodedSize' put: 4;
		at: 'pCertEncoded' put: 8;
		at: 'Token' put: 16;
		at: 'CertDeniedByMapper' put: 24;
		yourself]

{ #category : #accessing }
HTTP_SSL_CLIENT_CERT_INFO class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
HTTP_SSL_CLIENT_CERT_INFO >> CertDeniedByMapper [
	^self byteAtOffset: CertDeniedByMapper]

{ #category : #accessing }
HTTP_SSL_CLIENT_CERT_INFO >> CertDeniedByMapper: anInteger [
	self byteAtOffset: CertDeniedByMapper put: anInteger]

{ #category : #output }
HTTP_SSL_CLIENT_CERT_INFO >> certEncoded [
	^self pCertEncoded copyFrom: 1 to: self CertEncodedSize]

{ #category : #accessing }
HTTP_SSL_CLIENT_CERT_INFO >> CertEncodedSize [
	^self uLongAtOffset: CertEncodedSize]

{ #category : #accessing }
HTTP_SSL_CLIENT_CERT_INFO >> CertEncodedSize: anInteger [
	self uLongAtOffset: CertEncodedSize put: anInteger]

{ #category : #accessing }
HTTP_SSL_CLIENT_CERT_INFO >> CertFlags [
	^self uLongAtOffset: CertFlags]

{ #category : #accessing }
HTTP_SSL_CLIENT_CERT_INFO >> CertFlags: anInteger [
	self uLongAtOffset: CertFlags put: anInteger]

{ #category : #accessing }
HTTP_SSL_CLIENT_CERT_INFO >> pCertEncoded [
	^self pointerAtOffset: pCertEncoded]

{ #category : #accessing }
HTTP_SSL_CLIENT_CERT_INFO >> pCertEncoded: anInteger [
	self pointerAtOffset: pCertEncoded put: anInteger]

{ #category : #accessing }
HTTP_SSL_CLIENT_CERT_INFO >> Token [
	^self pointerAtOffset: Token]

{ #category : #accessing }
HTTP_SSL_CLIENT_CERT_INFO >> Token: anInteger [
	self pointerAtOffset: Token put: anInteger]

