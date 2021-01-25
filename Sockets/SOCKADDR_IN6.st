"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SOCKADDR_IN6,
	#superclass : #SOCKADDR,
	#classVars : [
		'Offsets'
	],
	#category : #sockets
}

{ #category : #accessing }
SOCKADDR_IN6 class >> def [
	^<def>
	typedef struct sockaddr_in {
		ADDRESS_FAMILY sin6_family;
		USHORT         sin6_port;
		ULONG          sin6_flowinfo;
		IN6_ADDR       sin6_addr;
		union {
			ULONG    sin6_scope_id;
			SCOPE_ID sin6_scope_struct;
		};
	} SOCKADDR_IN6, *PSOCKADDR_IN6;
	</def>]

{ #category : #private }
SOCKADDR_IN6 class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 28;
		at: 'sin6_family' put: 0;
		at: 'sin6_port' put: 2;
		at: 'sin6_flowinfo' put: 4;
		at: 'sin6_addr' put: 8;
		at: 'sin6_scope_id' put: 24;
		at: 'sin6_scope_struct' put: 24;
		yourself]

{ #category : #accessing }
SOCKADDR_IN6 class >> sizeInBytes [
	^sizeInBytes]

{ #category : #output }
SOCKADDR_IN6 >> address [
	^self sin6_addr]

{ #category : #input }
SOCKADDR_IN6 >> address: anIN6_ADDR [
	self sin6_addr: anIN6_ADDR]

{ #category : #output }
SOCKADDR_IN6 >> family [
	^self sin6_family]

{ #category : #initialization }
SOCKADDR_IN6 >> initialize: anInteger [
	super initialize: anInteger.
	self sin6_family: AF_INET6]

{ #category : #output }
SOCKADDR_IN6 >> port [
	^self sin6_port]

{ #category : #input }
SOCKADDR_IN6 >> port: anInteger [
	self sin6_port: anInteger]

{ #category : #accessing }
SOCKADDR_IN6 >> sin6_addr [
	^self structureAtOffset: sin6_addr ofClass: IN6_ADDR]

{ #category : #accessing }
SOCKADDR_IN6 >> sin6_addr: anIN6_ADDR [
	self bytesAtOffset: sin6_addr put: anIN6_ADDR asParameter]

{ #category : #accessing }
SOCKADDR_IN6 >> sin6_family [
	^self shortAtOffset: sin6_family]

{ #category : #accessing }
SOCKADDR_IN6 >> sin6_family: anInteger [
	self shortAtOffset: sin6_family put: anInteger]

{ #category : #accessing }
SOCKADDR_IN6 >> sin6_flowinfo [
	^self uLongAtOffset: sin6_flowinfo]

{ #category : #accessing }
SOCKADDR_IN6 >> sin6_flowinfo: anInteger [
	self uLongAtOffset: sin6_flowinfo put: anInteger]

{ #category : #accessing }
SOCKADDR_IN6 >> sin6_port [
	| net |
	net := self bytesAtOffset: sin6_port count: 2.
	^self hostFromNetwork: net]

{ #category : #accessing }
SOCKADDR_IN6 >> sin6_port: anInteger [
	| net |
	net := self networkFromShort: anInteger.
	self uShortAtOffset: sin6_port put: net]

{ #category : #accessing }
SOCKADDR_IN6 >> sin6_scope_id [
	^self uLongAtOffset: sin6_scope_id]

{ #category : #accessing }
SOCKADDR_IN6 >> sin6_scope_id: anInteger [
	self uLongAtOffset: sin6_scope_id put: anInteger]

{ #category : #accessing }
SOCKADDR_IN6 >> sin6_scope_struct [
	^self structureAtOffset: sin6_scope_struct ofClass: SCOPE_ID]

{ #category : #accessing }
SOCKADDR_IN6 >> sin6_scope_struct: aSCOPE_ID [
	self bytesAtOffset: sin6_scope_struct put: aSCOPE_ID asParameter]

