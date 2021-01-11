"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTP_SSL_INFO,
	#superclass : #HttpApiStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Server'
}

{ #category : #inspecting }
HTTP_SSL_INFO class >> aspects [
	^#(#ServerCertKeySize
		#ConnectionKeySize
		#serverCertIssuer
		#serverCertSubject
		#clientCertInfo
		#SslClientCertNegotiated)]

{ #category : #accessing }
HTTP_SSL_INFO class >> def [
	^<def>
	typedef struct _HTTP_SSL_INFO {
 		USHORT                     ServerCertKeySize;
 		USHORT                     ConnectionKeySize;
 		ULONG                      ServerCertIssuerSize;
 		ULONG                      ServerCertSubjectSize;
		PCSTR                      pServerCertIssuer;
		PCSTR                      pServerCertSubject;
		PHTTP_SSL_CLIENT_CERT_INFO pClientCertInfo;
 		ULONG                      SslClientCertNegotiated;
	} HTTP_SSL_INFO, *PHTTP_SSL_INFO;
	</def>]

{ #category : #private }
HTTP_SSL_INFO class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 48;
		at: 'ServerCertKeySize' put: 0;
		at: 'ConnectionKeySize' put: 2;
		at: 'ServerCertIssuerSize' put: 4;
		at: 'ServerCertSubjectSize' put: 8;
		at: 'pServerCertIssuer' put: 16;
		at: 'pServerCertSubject' put: 24;
		at: 'pClientCertInfo' put: 32;
		at: 'SslClientCertNegotiated' put: 40;
		yourself]

{ #category : #accessing }
HTTP_SSL_INFO class >> sizeInBytes [
	^sizeInBytes]

{ #category : #output }
HTTP_SSL_INFO >> clientCertInfo [
	^HTTP_SSL_CLIENT_CERT_INFO atMemory: self pClientCertInfo]

{ #category : #accessing }
HTTP_SSL_INFO >> ConnectionKeySize [
	^self uShortAtOffset: ConnectionKeySize]

{ #category : #accessing }
HTTP_SSL_INFO >> pClientCertInfo [
	^self addressAtOffset: pClientCertInfo]

{ #category : #accessing }
HTTP_SSL_INFO >> pServerCertIssuer [
	^self addressAtOffset: pServerCertIssuer]

{ #category : #accessing }
HTTP_SSL_INFO >> pServerCertSubject [
	^self addressAtOffset: pServerCertSubject]

{ #category : #output }
HTTP_SSL_INFO >> serverCertIssuer [
	^String
		fromMemory: self pServerCertIssuer
		length: self ServerCertIssuerSize]

{ #category : #accessing }
HTTP_SSL_INFO >> ServerCertIssuerSize [
	^self uLongAtOffset: ServerCertIssuerSize]

{ #category : #accessing }
HTTP_SSL_INFO >> ServerCertKeySize [
	^self uShortAtOffset: ServerCertKeySize]

{ #category : #output }
HTTP_SSL_INFO >> serverCertSubject [
	^String
		fromMemory: self pServerCertSubject
		length: self ServerCertSubjectSize]

{ #category : #accessing }
HTTP_SSL_INFO >> ServerCertSubjectSize [
	^self uLongAtOffset: ServerCertSubjectSize]

{ #category : #accessing }
HTTP_SSL_INFO >> SslClientCertNegotiated [
	^self uLongAtOffset: SslClientCertNegotiated]

