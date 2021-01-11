"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTP_REQUEST_V1,
	#superclass : #HttpRequestStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Server'
}

{ #category : #inspecting }
HTTP_REQUEST_V1 class >> aspects [
	^#(#Flags
		#ConnectionId
		#RequestId
		#UrlContext
		#Version
		#verbName
		#unknownVerb
		#rawUrl
		#CookedUrl
		#Address
		#Headers
		#BytesReceived
		#entityChunks
		#RawConnectionId
		#sslInfo)]

{ #category : #accessing }
HTTP_REQUEST_V1 class >> def [
	^<def>
	typedef struct _HTTP_REQUEST {
		ULONG                  Flags;
		HTTP_CONNECTION_ID     ConnectionId;
		HTTP_REQUEST_ID        RequestId;
		HTTP_URL_CONTEXT       UrlContext;
		HTTP_VERSION           Version;
		HTTP_VERB              Verb;
		USHORT                 UnknownVerbLength;
		USHORT                 RawUrlLength;
		PCSTR                  pUnknownVerb;
		PCSTR                  pRawUrl;
		HTTP_COOKED_URL        CookedUrl;
		HTTP_TRANSPORT_ADDRESS Address;
		HTTP_REQUEST_HEADERS 		Headers;
		ULONGLONG              BytesReceived;
		USHORT                 EntityChunkCount;
		PHTTP_DATA_CHUNK       pEntityChunks;
		HTTP_RAW_CONNECTION_ID RawConnectionId;
		PHTTP_SSL_INFO         pSslInfo;
	} HTTP_REQUEST_V1, *PHTTP_REQUEST_V1;
	</def>]

{ #category : #initialization }
HTTP_REQUEST_V1 class >> initializeConstants [
	"
	HTTP_REQUEST initializeConstants
	"
	self initializeVerbConstants]

{ #category : #initialization }
HTTP_REQUEST_V1 class >> initializeVerbConstants [
	WinConstants
		at: 'HttpVerbUnparsed' put: 0;
		at: 'HttpVerbUnknown' put: 1;
		at: 'HttpVerbInvalid' put: 2;
		at: 'HttpVerbOPTIONS' put: 3;
		at: 'HttpVerbGET' put: 4;
		at: 'HttpVerbHEAD' put: 5;
		at: 'HttpVerbPOST' put: 6;
		at: 'HttpVerbPUT' put: 7;
		at: 'HttpVerbDELETE' put: 8;
		at: 'HttpVerbTRACE' put: 9;
		at: 'HttpVerbCONNECT' put: 10;
		at: 'HttpVerbTRACK' put: 11;
		at: 'HttpVerbMOVE' put: 12;
		at: 'HttpVerbCOPY' put: 13;
		at: 'HttpVerbPROPFIND' put: 14;
		at: 'HttpVerbPROPPATCH' put: 15;
		at: 'HttpVerbMKCOL' put: 16;
		at: 'HttpVerbLOCK' put: 17;
		at: 'HttpVerbUNLOCK' put: 18;
		at: 'HttpVerbSEARCH' put: 19;
		at: 'HttpVerbMaximum' put: 20]

{ #category : #accessing }
HTTP_REQUEST_V1 class >> offsets64 [
^PoolDictionary new
		at: 'RawConnectionId' put: 832;
		at: 'pUnknownVerb' put: 48;
		at: 'RequestId' put: 16;
		at: 'pSslInfo' put: 840;
		at: 'ConnectionId' put: 8;
		at: 'pEntityChunks' put: 824;
		at: 'Flags' put: 0;
		at: 'CookedUrl' put: 64;
		at: 'Headers' put: 120;
		at: 'Verb' put: 36;
		at: 'Address' put: 104;
		at: 'pRawUrl' put: 56;
		at: 'sizeInBytes' put: 848;
		at: 'Version' put: 32;
		at: 'RawUrlLength' put: 42;
		at: 'UnknownVerbLength' put: 40;
		at: 'BytesReceived' put: 808;
		at: 'EntityChunkCount' put: 816;
		at: 'UrlContext' put: 24;
		yourself]

{ #category : #accessing }
HTTP_REQUEST_V1 class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
HTTP_REQUEST_V1 >> Address [
	| data |
	data := self bytesAtOffset: Address count: HTTP_TRANSPORT_ADDRESS sizeInBytes.
	^HTTP_TRANSPORT_ADDRESS usingBytes: data]

{ #category : #accessing }
HTTP_REQUEST_V1 >> BytesReceived [
	^self largeAtOffset: BytesReceived]

{ #category : #accessing }
HTTP_REQUEST_V1 >> ConnectionId [
	| data |
	data := self bytesAtOffset: ConnectionId count: LARGE_INTEGER sizeInBytes.
	^LARGE_INTEGER usingBytes: data]

{ #category : #accessing }
HTTP_REQUEST_V1 >> CookedUrl [
	| data |
	data := self bytesAtOffset: CookedUrl count: HTTP_COOKED_URL sizeInBytes.
	^HTTP_COOKED_URL usingBytes: data]

{ #category : #accessing }
HTTP_REQUEST_V1 >> CookedUrl: anHTTP_COOKED_URL [
	self bytesAtOffset: CookedUrl put: anHTTP_COOKED_URL contents]

{ #category : #accessing }
HTTP_REQUEST_V1 >> EntityChunkCount [
	^self uShortAtOffset: EntityChunkCount]

{ #category : #accessing }
HTTP_REQUEST_V1 >> Flags [
	^self uLongAtOffset: Flags]

{ #category : #accessing }
HTTP_REQUEST_V1 >> Headers [
	| data |
	data := self bytesAtOffset: Headers count: HTTP_REQUEST_HEADERS sizeInBytes.
	^HTTP_REQUEST_HEADERS usingBytes: data]

{ #category : #accessing }
HTTP_REQUEST_V1 >> Headers: anHTTP_REQUEST_HEADERS [
	self bytesAtOffset: RequestId put: anHTTP_REQUEST_HEADERS contents.
	anHTTP_REQUEST_HEADERS transferRegistryTo: self]

{ #category : #accessing }
HTTP_REQUEST_V1 >> pEntityChunks [
	^self addressAtOffset: pEntityChunks]

{ #category : #accessing }
HTTP_REQUEST_V1 >> pRawUrl [
	^self addressAtOffset: pRawUrl]

{ #category : #accessing }
HTTP_REQUEST_V1 >> pRawUrl: anExternalMemory [
	self addressAtOffset: pRawUrl register: anExternalMemory]

{ #category : #accessing }
HTTP_REQUEST_V1 >> pSslInfo [
	^self addressAtOffset: pSslInfo]

{ #category : #accessing }
HTTP_REQUEST_V1 >> pUnknownVerb [
	^self addressAtOffset: pUnknownVerb]

{ #category : #accessing }
HTTP_REQUEST_V1 >> RawConnectionId [
	| data |
	data := self bytesAtOffset: RawConnectionId count: LARGE_INTEGER sizeInBytes.
	^LARGE_INTEGER usingBytes: data]

{ #category : #accessing }
HTTP_REQUEST_V1 >> RawUrlLength [
	^self uShortAtOffset: RawUrlLength]

{ #category : #accessing }
HTTP_REQUEST_V1 >> RawUrlLength: anInteger [
	self uShortAtOffset: RawUrlLength put: anInteger]

{ #category : #accessing }
HTTP_REQUEST_V1 >> RequestId [
	| data |
	data := self bytesAtOffset: RequestId count: LARGE_INTEGER sizeInBytes.
	^LARGE_INTEGER usingBytes: data]

{ #category : #accessing }
HTTP_REQUEST_V1 >> UnknownVerbLength [
	^self uShortAtOffset: UnknownVerbLength]

{ #category : #accessing }
HTTP_REQUEST_V1 >> UrlContext [
	| data |
	data := self bytesAtOffset: UrlContext count: LARGE_INTEGER sizeInBytes.
	^LARGE_INTEGER usingBytes: data]

{ #category : #accessing }
HTTP_REQUEST_V1 >> Verb [
	^self longAtOffset: Verb]

{ #category : #accessing }
HTTP_REQUEST_V1 >> Version [
	| data |
	data := self bytesAtOffset: Version count: HTTP_VERSION sizeInBytes.
	^HTTP_VERSION usingBytes: data]

