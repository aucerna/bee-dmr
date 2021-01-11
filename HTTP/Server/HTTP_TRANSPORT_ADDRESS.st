"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTP_TRANSPORT_ADDRESS,
	#superclass : #HttpApiStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Server'
}

{ #category : #inspecting }
HTTP_TRANSPORT_ADDRESS class >> aspects [
	^#(#localAddress #remoteAddress)]

{ #category : #accessing }
HTTP_TRANSPORT_ADDRESS class >> def [
	^<def>
	typedef struct _HTTP_TRANSPORT_ADDRESS {
		PSOCKADDR pRemoteAddress;
		PSOCKADDR pLocalAddress;
	} HTTP_TRANSPORT_ADDRESS, *PHTTP_TRANSPORT_ADDRESS;
	</def>]

{ #category : #private }
HTTP_TRANSPORT_ADDRESS class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 16;
		at: 'pRemoteAddress' put: 0;
		at: 'pLocalAddress' put: 8;
		yourself]

{ #category : #accessing }
HTTP_TRANSPORT_ADDRESS class >> sizeInBytes [
	^sizeInBytes]

{ #category : #private }
HTTP_TRANSPORT_ADDRESS >> addressClass [
	| memory |
	memory := self pRemoteAddress.
	memory isValid ifFalse: [^nil].
	memory := SOCKADDR_IN atMemory: memory.
	^memory family = AF_INET6 ifTrue: [SOCKADDR_IN6] ifFalse: [SOCKADDR_IN]]

{ #category : #testing }
HTTP_TRANSPORT_ADDRESS >> isValid [
	^super isValid
		and: [self pLocalAddress isValid]
		and: [self pRemoteAddress isValid]]

{ #category : #output }
HTTP_TRANSPORT_ADDRESS >> localAddress [
	| memory |
	memory := self pLocalAddress.
	memory isValid ifFalse: [^nil].
	^self addressClass fromMemory: memory]

{ #category : #output }
HTTP_TRANSPORT_ADDRESS >> localIp [
	^self localAddress ip]

{ #category : #accessing }
HTTP_TRANSPORT_ADDRESS >> pLocalAddress [
	^self addressAtOffset: pLocalAddress]

{ #category : #accessing }
HTTP_TRANSPORT_ADDRESS >> pRemoteAddress [
	^self addressAtOffset: pRemoteAddress]

{ #category : #printing }
HTTP_TRANSPORT_ADDRESS >> printOn: aStream [
	aStream
		nextPutAll: self class name;
		space;
		nextPutAll: 'local: ';
		nextPutAll: self localAddress ip asString;
		nextPutAll: ' remote: ';
		nextPutAll: self remoteAddress ip asString]

{ #category : #output }
HTTP_TRANSPORT_ADDRESS >> remoteAddress [
	^self addressClass fromMemory: self pRemoteAddress]

{ #category : #output }
HTTP_TRANSPORT_ADDRESS >> remoteIp [
	^self remoteAddress ip]

