"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTP_RESPONSE_V2,
	#superclass : #HttpResponseStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Server'
}

{ #category : #inspecting }
HTTP_RESPONSE_V2 class >> aspects [
	^#(#Flags
		#Version
		#StatusCode
		#ReasonLength
		#pReason
		#Headers
		#EntityChunkCount
		#pEntityChunks
		#ResponseInfoCount
		#pResponseInfo)]

{ #category : #accessing }
HTTP_RESPONSE_V2 class >> def [
	^<def>
	typedef struct {
		ULONG                 Flags;
		HTTP_VERSION          Version;
		USHORT                StatusCode;
		USHORT                ReasonLength;
		PCSTR                 pReason;
		HTTP_RESPONSE_HEADERS Headers;
		USHORT                EntityChunkCount;
		PHTTP_DATA_CHUNK      pEntityChunks;
		USHORT              ResponseInfoCount;
		PHTTP_RESPONSE_INFO pResponseInfo;
	} HTTP_RESPONSE_V2, *PHTTP_RESPONSE_V2;
	</def>]

{ #category : #accessing }
HTTP_RESPONSE_V2 class >> offsets64 [
^PoolDictionary new
		at: 'pResponseInfo' put: 560;
		at: 'Version' put: 4;
		at: 'ResponseInfoCount' put: 552;
		at: 'Flags' put: 0;
		at: 'StatusCode' put: 8;
		at: 'sizeInBytes' put: 568;
		at: 'Headers' put: 24;
		at: 'pEntityChunks' put: 544;
		at: 'pReason' put: 16;
		at: 'ReasonLength' put: 10;
		at: 'EntityChunkCount' put: 536;
		yourself]

{ #category : #accessing }
HTTP_RESPONSE_V2 class >> sizeInBytes [
	^sizeInBytes]

{ #category : #input }
HTTP_RESPONSE_V2 >> body: data [
	| chunks |
	(data isNil or: [data isEmpty]) ifTrue: [^self].
	chunks := HTTP_DATA_CHUNK fromData: data maxBytes: data sizeInBytes.
	self entityChunks: chunks]

{ #category : #accessing }
HTTP_RESPONSE_V2 >> EntityChunkCount [
	^self uShortAtOffset: EntityChunkCount]

{ #category : #accessing }
HTTP_RESPONSE_V2 >> EntityChunkCount: anInteger [
	self uShortAtOffset: EntityChunkCount put: anInteger]

{ #category : #output }
HTTP_RESPONSE_V2 >> entityChunks [
	^BufferArray
		at: self pEntityChunks
		count: self EntityChunkCount
		type: HTTP_DATA_CHUNK]

{ #category : #input }
HTTP_RESPONSE_V2 >> entityChunks: aBufferArray [
	| memory |
	memory := aBufferArray isInExternalMemory
		ifTrue: [aBufferArray pointedMemory]
		ifFalse: [aBufferArray externalCopy pointedMemory].
	self EntityChunkCount: aBufferArray count; pEntityChunks: memory]

{ #category : #accessing }
HTTP_RESPONSE_V2 >> Flags [
	^self uLongAtOffset: Flags]

{ #category : #accessing }
HTTP_RESPONSE_V2 >> Flags: anInteger [
	self uLongAtOffset: Flags put: anInteger]

{ #category : #input }
HTTP_RESPONSE_V2 >> fromResponse: anHttpResponse [
	self
		version1;
		StatusCode: anHttpResponse status;
		reason: anHttpResponse reason;
		updateHeadersFrom: anHttpResponse;
		body: anHttpResponse body]

{ #category : #accessing }
HTTP_RESPONSE_V2 >> Headers [
	| data |
	data := self
		bytesAtOffset: Headers
		count: HTTP_RESPONSE_HEADERS sizeInBytes.
	^HTTP_RESPONSE_HEADERS usingBytes: data]

{ #category : #accessing }
HTTP_RESPONSE_V2 >> Headers: anHTTP_RESPONSE_HEADERS [
	self bytesAtOffset: Headers put: anHTTP_RESPONSE_HEADERS asParameter.
	anHTTP_RESPONSE_HEADERS transferRegistryTo: self]

{ #category : #accessing }
HTTP_RESPONSE_V2 >> pEntityChunks [
	^self addressAtOffset: pEntityChunks]

{ #category : #accessing }
HTTP_RESPONSE_V2 >> pEntityChunks: anExternalMemory [
	self addressAtOffset: pEntityChunks register: anExternalMemory]

{ #category : #accessing }
HTTP_RESPONSE_V2 >> pReason [
	^self addressAtOffset: pReason]

{ #category : #accessing }
HTTP_RESPONSE_V2 >> pReason: anInteger [
	self addressAtOffset: pReason register: anInteger]

{ #category : #accessing }
HTTP_RESPONSE_V2 >> pResponseInfo [
	^self addressAtOffset: pResponseInfo]

{ #category : #accessing }
HTTP_RESPONSE_V2 >> pResponseInfo: anInteger [
	self addressAtOffset: pResponseInfo register: anInteger]

{ #category : #accessing }
HTTP_RESPONSE_V2 >> ReasonLength [
	^self uShortAtOffset: ReasonLength]

{ #category : #accessing }
HTTP_RESPONSE_V2 >> ReasonLength: anInteger [
	self uShortAtOffset: ReasonLength put: anInteger]

{ #category : #output }
HTTP_RESPONSE_V2 >> responseInfo [
	| buffer |
	buffer := BufferArray
		at: self pResponseInfo
		count: self ResponseInfoCount
		type: HTTP_RESPONSE_INFO.
	^buffer asArray]

{ #category : #accessing }
HTTP_RESPONSE_V2 >> ResponseInfoCount [
	^self uShortAtOffset: ResponseInfoCount]

{ #category : #accessing }
HTTP_RESPONSE_V2 >> ResponseInfoCount: anInteger [
	self uShortAtOffset: ResponseInfoCount put: anInteger]

{ #category : #accessing }
HTTP_RESPONSE_V2 >> StatusCode [
	^self uShortAtOffset: StatusCode]

{ #category : #accessing }
HTTP_RESPONSE_V2 >> StatusCode: anInteger [
	self uShortAtOffset: StatusCode put: anInteger]

{ #category : #accessing }
HTTP_RESPONSE_V2 >> Version [
	^self structureAtOffset: Version ofClass: HTTP_VERSION]

{ #category : #accessing }
HTTP_RESPONSE_V2 >> Version: aHTTP_VERSION [
	self bytesAtOffset: Version put: aHTTP_VERSION asParameter]

