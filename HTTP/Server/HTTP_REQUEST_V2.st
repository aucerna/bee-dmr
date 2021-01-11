"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTP_REQUEST_V2,
	#superclass : #HttpRequestStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Server'
}

{ #category : #inspecting }
HTTP_REQUEST_V2 class >> aspects [
	^#(#Flags
		#Padding
		#ConnectionId
		#RequestId
		#UrlContext
		#Version
		#Verb
		#UnknownVerbLength
		#RawUrlLength
		#pUnknownVerb
		#pRawUrl
		#CookedUrl
		#Address
		#Headers
		#BytesReceived
		#EntityChunkCount
		#pEntityChunks
		#RawConnectionId
		#pSslInfo
		#padding
		#RequestInfoCount
		#pRequestInfo)]

{ #category : #accessing }
HTTP_REQUEST_V2 class >> def [
	^<def>
		typedef struct  {
			struct  {
				ULONG Flags; // 0
				HTTP_CONNECTION_ID ConnectionId; // 8
				HTTP_REQUEST_ID RequestId; // 16
				HTTP_URL_CONTEXT UrlContext; // 24
				HTTP_VERSION Version; // 32
				HTTP_VERB Verb; // 36
				USHORT UnknownVerbLength; // 40
				USHORT RawUrlLength; // 42
				PCSTR pUnknownVerb; // 44
				PCSTR pRawUrl; // 48
				HTTP_COOKED_URL CookedUrl; // 52
				HTTP_TRANSPORT_ADDRESS Address; // 76
				HTTP_REQUEST_HEADERS Headers; // 84
				ULONGLONG BytesReceived; // 432
				USHORT EntityChunkCount; // 440
				PHTTP_DATA_CHUNK pEntityChunks; // 444
				HTTP_RAW_CONNECTION_ID RawConnectionId; // 448
				PHTTP_SSL_INFO pSslInfo; // 456
			} s; // 0
			USHORT RequestInfoCount; // 464
			PHTTP_REQUEST_INFO pRequestInfo; // 468
		} HTTP_REQUEST_V2, *PHTTP_REQUEST_V2; // sizeInBytes = 472
	</def>]

{ #category : #initialization }
HTTP_REQUEST_V2 class >> initializeConstants [
	self initializeRequestInfoTypeConstants]

{ #category : #initialization }
HTTP_REQUEST_V2 class >> initializeRequestInfoTypeConstants [
	WinConstants at: 'HttpRequestInfoTypeAuth' put: 0]

{ #category : #accessing }
HTTP_REQUEST_V2 class >> offsets64 [
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
		at: 'sizeInBytes' put: 864;
		at: 'Version' put: 32;
		at: 'RequestInfoCount' put: 848;
		at: 'pRequestInfo' put: 856;
		at: 'RawUrlLength' put: 42;
		at: 'UnknownVerbLength' put: 40;
		at: 'BytesReceived' put: 808;
		at: 'EntityChunkCount' put: 816;
		at: 'UrlContext' put: 24;
		yourself]

{ #category : #accessing }
HTTP_REQUEST_V2 class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
HTTP_REQUEST_V2 >> Address [
	^self structureAtOffset: Address ofClass: HTTP_TRANSPORT_ADDRESS]

{ #category : #accessing }
HTTP_REQUEST_V2 >> Address: aHTTP_TRANSPORT_ADDRESS [
	self bytesAtOffset: Address put: aHTTP_TRANSPORT_ADDRESS asParameter]

{ #category : #testing }
HTTP_REQUEST_V2 >> authenticationInfo [
	| infos |
	infos := self requestInfos.
	infos isNil ifTrue: [^nil].
	^infos detect: [:inf | inf InfoType = HttpRequestInfoTypeAuth] ifNone: nil]

{ #category : #accessing }
HTTP_REQUEST_V2 >> BytesReceived [
	^self structureAtOffset: BytesReceived ofClass: LARGE_INTEGER]

{ #category : #accessing }
HTTP_REQUEST_V2 >> BytesReceived: aLARGE_INTEGER [
	self bytesAtOffset: BytesReceived put: aLARGE_INTEGER asParameter]

{ #category : #output }
HTTP_REQUEST_V2 >> clientIP [
	^self Address remoteIp]

{ #category : #accessing }
HTTP_REQUEST_V2 >> ConnectionId [
	^self structureAtOffset: ConnectionId ofClass: LARGE_INTEGER]

{ #category : #accessing }
HTTP_REQUEST_V2 >> ConnectionId: aLARGE_INTEGER [
	self bytesAtOffset: ConnectionId put: aLARGE_INTEGER asParameter]

{ #category : #accessing }
HTTP_REQUEST_V2 >> CookedUrl [
	^self structureAtOffset: CookedUrl ofClass: HTTP_COOKED_URL]

{ #category : #accessing }
HTTP_REQUEST_V2 >> CookedUrl: aHTTP_COOKED_URL [
	self structureAtOffset: CookedUrl put: aHTTP_COOKED_URL]

{ #category : #accessing }
HTTP_REQUEST_V2 >> EntityChunkCount [
	^self uShortAtOffset: EntityChunkCount]

{ #category : #accessing }
HTTP_REQUEST_V2 >> EntityChunkCount: anInteger [
	self uShortAtOffset: EntityChunkCount put: anInteger]

{ #category : #accessing }
HTTP_REQUEST_V2 >> Flags [
	^self uLongAtOffset: Flags]

{ #category : #accessing }
HTTP_REQUEST_V2 >> Flags: anInteger [
	self uLongAtOffset: Flags put: anInteger]

{ #category : #accessing }
HTTP_REQUEST_V2 >> Headers [
	^self structureAtOffset: Headers ofClass: HTTP_REQUEST_HEADERS]

{ #category : #accessing }
HTTP_REQUEST_V2 >> Headers: aHTTP_REQUEST_HEADERS [
	self structureAtOffset: Headers put: aHTTP_REQUEST_HEADERS]

{ #category : #output }
HTTP_REQUEST_V2 >> ip [
	self ASSERT: false.
	^self clientIP]

{ #category : #accessing }
HTTP_REQUEST_V2 >> pEntityChunks [
	^self addressAtOffset: pEntityChunks]

{ #category : #accessing }
HTTP_REQUEST_V2 >> pEntityChunks: anExternalMemory [
	self addressAtOffset: pEntityChunks register: anExternalMemory]

{ #category : #output }
HTTP_REQUEST_V2 >> port [
	^self Address locaAddress port]

{ #category : #accessing }
HTTP_REQUEST_V2 >> pRawUrl [
	^self addressAtOffset: pRawUrl]

{ #category : #accessing }
HTTP_REQUEST_V2 >> pRawUrl: anExternalMemory [
	self addressAtOffset: pRawUrl register: anExternalMemory]

{ #category : #accessing }
HTTP_REQUEST_V2 >> pRequestInfo [
	^self addressAtOffset: pRequestInfo]

{ #category : #accessing }
HTTP_REQUEST_V2 >> pRequestInfo: anExternalMemory [
	self addressAtOffset: pRequestInfo register: anExternalMemory]

{ #category : #accessing }
HTTP_REQUEST_V2 >> pSslInfo [
	^self addressAtOffset: pSslInfo]

{ #category : #accessing }
HTTP_REQUEST_V2 >> pSslInfo: anExternalMemory [
	self addressAtOffset: pSslInfo register: anExternalMemory]

{ #category : #accessing }
HTTP_REQUEST_V2 >> pUnknownVerb [
	^self addressAtOffset: pUnknownVerb]

{ #category : #accessing }
HTTP_REQUEST_V2 >> pUnknownVerb: anExternalMemory [
	self addressAtOffset: pUnknownVerb register: anExternalMemory]

{ #category : #accessing }
HTTP_REQUEST_V2 >> RawConnectionId [
	^self structureAtOffset: RawConnectionId ofClass: LARGE_INTEGER]

{ #category : #accessing }
HTTP_REQUEST_V2 >> RawConnectionId: aLARGE_INTEGER [
	self structureAtOffset: RawConnectionId put: aLARGE_INTEGER]

{ #category : #accessing }
HTTP_REQUEST_V2 >> RawUrlLength [
	^self uShortAtOffset: RawUrlLength]

{ #category : #accessing }
HTTP_REQUEST_V2 >> RawUrlLength: anInteger [
	self uShortAtOffset: RawUrlLength put: anInteger]

{ #category : #accessing }
HTTP_REQUEST_V2 >> RequestId [
	^self structureAtOffset: RequestId ofClass: LARGE_INTEGER]

{ #category : #accessing }
HTTP_REQUEST_V2 >> RequestId: aLARGE_INTEGER [
	self bytesAtOffset: RequestId put: aLARGE_INTEGER asParameter]

{ #category : #accessing }
HTTP_REQUEST_V2 >> RequestInfoCount [
	^self uShortAtOffset: RequestInfoCount]

{ #category : #accessing }
HTTP_REQUEST_V2 >> RequestInfoCount: anInteger [
	self uShortAtOffset: RequestInfoCount put: anInteger]

{ #category : #output }
HTTP_REQUEST_V2 >> requestInfos [
	| memory buffer |
	memory := self pRequestInfo.
	^memory isValid ifTrue: [
		buffer := BufferArray
			at: memory
			count: self RequestInfoCount
			type: HTTP_REQUEST_INFO.
		buffer asArray]]

{ #category : #output }
HTTP_REQUEST_V2 >> serverIP [
	^self Address localIp]

{ #category : #accessing }
HTTP_REQUEST_V2 >> UnknownVerbLength [
	^self uShortAtOffset: UnknownVerbLength]

{ #category : #accessing }
HTTP_REQUEST_V2 >> UnknownVerbLength: anInteger [
	self uShortAtOffset: UnknownVerbLength put: anInteger]

{ #category : #output }
HTTP_REQUEST_V2 >> uriStem [
	^(URL fromString: self rawUrl) path]

{ #category : #accessing }
HTTP_REQUEST_V2 >> UrlContext [
	^self structureAtOffset: UrlContext ofClass: LARGE_INTEGER]

{ #category : #accessing }
HTTP_REQUEST_V2 >> UrlContext: aLARGE_INTEGER [
	self structureAtOffset: UrlContext put: aLARGE_INTEGER]

{ #category : #accessing }
HTTP_REQUEST_V2 >> Verb [
	^self uLongAtOffset: Verb]

{ #category : #accessing }
HTTP_REQUEST_V2 >> Verb: anInteger [
	self uLongAtOffset: Verb put: anInteger]

{ #category : #accessing }
HTTP_REQUEST_V2 >> Version [
	^self structureAtOffset: Version ofClass: HTTP_VERSION]

{ #category : #accessing }
HTTP_REQUEST_V2 >> Version: aHTTP_VERSION [
	self structureAtOffset: Version put: aHTTP_VERSION]

