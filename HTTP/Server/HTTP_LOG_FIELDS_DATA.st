"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTP_LOG_FIELDS_DATA,
	#superclass : #HttpApiStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Server'
}

{ #category : #inspecting }
HTTP_LOG_FIELDS_DATA class >> aspects [
	^#(#Base
		#UserNameLength
		#UriStemLength
		#ClientIpLength
		#ServerNameLength
		#ServiceNameLength
		#ServerIpLength
		#MethodLength
		#UriQueryLength
		#HostLength
		#UserAgentLength
		#CookieLength
		#ReferrerLength
		#UserName
		#UriStem
		#ClientIp
		#ServerName
		#ServiceName
		#ServerIp
		#Method
		#UriQuery
		#Host
		#UserAgent
		#Cookie
		#Referrer
		#ServerPort
		#ProtocolStatus
		#Win32Status
		#MethodNum
		#SubStatus)]

{ #category : #private }
HTTP_LOG_FIELDS_DATA class >> def [
	^<def>
	typedef struct _HTTP_LOG_FIELDS_DATA {
		HTTP_LOG_DATA Base;
		USHORT        UserNameLength;
		USHORT      		UriStemLength;
		USHORT        ClientIpLength;
		USHORT        ServerNameLength;
		USHORT        ServiceNameLength;
		USHORT        ServerIpLength;
		USHORT        MethodLength;
		USHORT      		UriQueryLength;
		USHORT        HostLength;
		USHORT      		UserAgentLength;
		USHORT        CookieLength;
		USHORT        ReferrerLength;
		PWCHAR      		UserName;
		PWCHAR      		UriStem;
		PCHAR         ClientIp;
		PCHAR         ServerName;
		PCHAR         ServiceName;
		PCHAR         ServerIp;
		PCHAR         Method;
		PCHAR       		UriQuery;
		PCHAR         Host;
		PCHAR       		UserAgent;
		PCHAR         Cookie;
		PCHAR         Referrer;
		USHORT        ServerPort;
		USHORT      		ProtocolStatus;
		ULONG         Win32Status;
		HTTP_VERB     MethodNum;
		USHORT        SubStatus;
	} HTTP_LOG_FIELDS_DATA, *PHTTP_LOG_FIELDS_DATA;
	</def>]

{ #category : #'instance creation' }
HTTP_LOG_FIELDS_DATA class >> fromResponse: anHttpResponse [
	^self new fromResponse: anHttpResponse]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA class >> offsets64 [
^PoolDictionary new
		at: 'UriStemLength' put: 6;
		at: 'UriQuery' put: 88;
		at: 'ReferrerLength' put: 26;
		at: 'UserName' put: 32;
		at: 'CookieLength' put: 24;
		at: 'ServerPort' put: 128;
		at: 'Method' put: 80;
		at: 'ServerNameLength' put: 10;
		at: 'Win32Status' put: 132;
		at: 'Cookie' put: 112;
		at: 'ServiceName' put: 64;
		at: 'ClientIp' put: 48;
		at: 'UserNameLength' put: 4;
		at: 'ClientIpLength' put: 8;
		at: 'MethodLength' put: 16;
		at: 'ProtocolStatus' put: 130;
		at: 'UserAgent' put: 104;
		at: 'Base' put: 0;
		at: 'UriStem' put: 40;
		at: 'SubStatus' put: 140;
		at: 'ServerIpLength' put: 14;
		at: 'ServerIp' put: 72;
		at: 'Host' put: 96;
		at: 'HostLength' put: 20;
		at: 'sizeInBytes' put: 144;
		at: 'UserAgentLength' put: 22;
		at: 'ServiceNameLength' put: 12;
		at: 'MethodNum' put: 136;
		at: 'ServerName' put: 56;
		at: 'UriQueryLength' put: 18;
		at: 'Referrer' put: 120;
		yourself]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA class >> sizeInBytes [
	^sizeInBytes]

{ #category : #private }
HTTP_LOG_FIELDS_DATA class >> typedefTable [
	^HttpApiDLL typedefTable]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> Base [
	^self structureAtOffset: Base ofClass: HTTP_LOG_DATA]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> Base: aHTTP_LOG_DATA [
	self bytesAtOffset: Base put: aHTTP_LOG_DATA asParameter]

{ #category : #input }
HTTP_LOG_FIELDS_DATA >> clientIP [
	^self ansiAtAddress: self ClientIp length: self ClientIpLength]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> ClientIp [
	^self addressAtOffset: ClientIp]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> ClientIp: anExternalMemory [
	self addressAtOffset: ClientIp register: anExternalMemory]

{ #category : #input }
HTTP_LOG_FIELDS_DATA >> clientIP: aString [
	| external |
	external := aString ansiz externalCopy.
	self ClientIp: external; ClientIpLength: external length]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> ClientIpLength [
	^self uShortAtOffset: ClientIpLength]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> ClientIpLength: anInteger [
	self uShortAtOffset: ClientIpLength put: anInteger]

{ #category : #input }
HTTP_LOG_FIELDS_DATA >> cookie [
	^self ansiAtAddress: self Cookie length: self CookieLength]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> Cookie [
	^self addressAtOffset: Cookie]

{ #category : #input }
HTTP_LOG_FIELDS_DATA >> cookie: aString [
	| external |
	aString isNil ifTrue: [^self].
	external := aString ansiz externalCopy.
	self Cookie: external; CookieLength: external length]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> Cookie: anExternalMemory [
	self addressAtOffset: Cookie register: anExternalMemory]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> CookieLength [
	^self uShortAtOffset: CookieLength]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> CookieLength: anInteger [
	self uShortAtOffset: CookieLength put: anInteger]

{ #category : #input }
HTTP_LOG_FIELDS_DATA >> fromResponse: anHttpResponse [
	self
		serviceName: anHttpResponse serviceName;
		serverName: Socket hostName reduced;
		serverIP: anHttpResponse serverIP;
		method: anHttpResponse verb;
		uriStem: anHttpResponse uri;
		uriQuery: anHttpResponse queryString;
		ServerPort: anHttpResponse port;
		username: anHttpResponse username;
		clientIP: anHttpResponse clientIP;
		userAgent: anHttpResponse userAgent;
		cookie: anHttpResponse cookie asString;
		referrer: anHttpResponse referer;
		host: anHttpResponse host;
		ProtocolStatus: anHttpResponse status;
		SubStatus: anHttpResponse substatus;
		Win32Status: 0]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> Host [
	^self addressAtOffset: Host]

{ #category : #input }
HTTP_LOG_FIELDS_DATA >> host [
	^self ansiAtAddress: self Host length: self HostLength]

{ #category : #input }
HTTP_LOG_FIELDS_DATA >> host: aString [
	| external |
	external := aString ansiz externalCopy.
	self Host: external; HostLength: external length]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> Host: anInteger [
	self addressAtOffset: Host register: anInteger]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> HostLength [
	^self uShortAtOffset: HostLength]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> HostLength: anInteger [
	self uShortAtOffset: HostLength put: anInteger]

{ #category : #input }
HTTP_LOG_FIELDS_DATA >> method [
	^self ansiAtAddress: self Method length: self MethodLength]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> Method [
	^self addressAtOffset: Method]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> Method: anExternalMemory [
	self addressAtOffset: Method register: anExternalMemory]

{ #category : #input }
HTTP_LOG_FIELDS_DATA >> method: aString [
	| external |
	external := aString ansiz externalCopy.
	self Method: external; MethodLength: external length]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> MethodLength [
	^self uShortAtOffset: MethodLength]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> MethodLength: anInteger [
	self uShortAtOffset: MethodLength put: anInteger]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> MethodNum [
	^self longAtOffset: MethodNum]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> MethodNum: anInteger [
	self longAtOffset: MethodNum put: anInteger]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> ProtocolStatus [
	^self uShortAtOffset: ProtocolStatus]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> ProtocolStatus: anInteger [
	self uShortAtOffset: ProtocolStatus put: anInteger]

{ #category : #input }
HTTP_LOG_FIELDS_DATA >> referrer [
	^self ansiAtAddress: self Referrer length: self ReferrerLength]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> Referrer [
	^self addressAtOffset: Referrer]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> Referrer: anExternalMemory [
	self addressAtOffset: Referrer register: anExternalMemory]

{ #category : #input }
HTTP_LOG_FIELDS_DATA >> referrer: aString [
	| external |
	aString isNil ifTrue: [^self].
	external := aString ansiz externalCopy.
	self Referrer: external; ReferrerLength: external length]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> ReferrerLength [
	^self uShortAtOffset: ReferrerLength]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> ReferrerLength: anInteger [
	self uShortAtOffset: ReferrerLength put: anInteger]

{ #category : #input }
HTTP_LOG_FIELDS_DATA >> serverIP [
	^self ansiAtAddress: self ServerIp length: self ServerIpLength]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> ServerIp [
	^self addressAtOffset: ServerIp]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> ServerIp: anExternalMemory [
	self addressAtOffset: ServerIp register: anExternalMemory]

{ #category : #input }
HTTP_LOG_FIELDS_DATA >> serverIP: aString [
	| external |
	external := aString ansiz externalCopy.
	self ServerIp: external; ServerIpLength: external length]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> ServerIpLength [
	^self uShortAtOffset: ServerIpLength]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> ServerIpLength: anInteger [
	self uShortAtOffset: ServerIpLength put: anInteger]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> ServerName [
	^self addressAtOffset: ServerName]

{ #category : #input }
HTTP_LOG_FIELDS_DATA >> serverName [
	^self ansiAtAddress: self ServerName length: self ServerNameLength]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> ServerName: anExternalMemory [
	self addressAtOffset: ServerName register: anExternalMemory]

{ #category : #input }
HTTP_LOG_FIELDS_DATA >> serverName: aString [
	| external |
	external := aString ansiz externalCopy.
	self ServerName: external; ServerNameLength: external length]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> ServerNameLength [
	^self uShortAtOffset: ServerNameLength]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> ServerNameLength: anInteger [
	self uShortAtOffset: ServerNameLength put: anInteger]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> ServerPort [
	^self uShortAtOffset: ServerPort]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> ServerPort: anInteger [
	self uShortAtOffset: ServerPort put: anInteger]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> ServiceName [
	^self addressAtOffset: ServiceName]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> ServiceName: anExternalMemory [
	self addressAtOffset: ServiceName register: anExternalMemory]

{ #category : #input }
HTTP_LOG_FIELDS_DATA >> serviceName: aString [
	| external |
	aString isNil ifTrue: [^self].
	external := aString ansiz externalCopy.
	self ServiceName: external; ServiceNameLength: external length]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> ServiceNameLength [
	^self uShortAtOffset: ServiceNameLength]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> ServiceNameLength: anInteger [
	self uShortAtOffset: ServiceNameLength put: anInteger]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> SubStatus [
	^self uShortAtOffset: SubStatus]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> SubStatus: anInteger [
	self uShortAtOffset: SubStatus put: anInteger]

{ #category : #input }
HTTP_LOG_FIELDS_DATA >> uriQuery [
	^self ansiAtAddress: self UriQuery length: self UriQueryLength]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> UriQuery [
	^self addressAtOffset: UriQuery]

{ #category : #input }
HTTP_LOG_FIELDS_DATA >> uriQuery: aString [
	| external |
	external := aString ansiz externalCopy.
	self UriQuery: external; UriQueryLength: external length]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> UriQuery: anExternalMemory [
	self addressAtOffset: UriQuery register: anExternalMemory]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> UriQueryLength [
	^self uShortAtOffset: UriQueryLength]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> UriQueryLength: anInteger [
	self uShortAtOffset: UriQueryLength put: anInteger]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> UriStem [
	^self pointerAtOffset: UriStem]

{ #category : #input }
HTTP_LOG_FIELDS_DATA >> uriStem [
	^UTF16 decodeFromAddress: self UriStem length: self UriStemLength // 2]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> UriStem: anExternalMemory [
	self addressAtOffset: UriStem register: anExternalMemory]

{ #category : #input }
HTTP_LOG_FIELDS_DATA >> uriStem: aString [
	| external |
	external := aString externalCopy.
	self
		UriStem: external;
		UriStemLength: external length - 2]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> UriStemLength [
	^self uShortAtOffset: UriStemLength]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> UriStemLength: anInteger [
	self uShortAtOffset: UriStemLength put: anInteger]

{ #category : #input }
HTTP_LOG_FIELDS_DATA >> userAgent [
	^self ansiAtAddress: self UserAgent length: self UserAgentLength]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> UserAgent [
	^self addressAtOffset: UserAgent]

{ #category : #input }
HTTP_LOG_FIELDS_DATA >> userAgent: aString [
	| external |
	aString isNil ifTrue: [^self].
	external := aString ansiz externalCopy.
	self UserAgent: external; UserAgentLength: external length]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> UserAgent: anExternalMemory [
	self addressAtOffset: UserAgent register: anExternalMemory]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> UserAgentLength [
	^self uShortAtOffset: UserAgentLength]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> UserAgentLength: anInteger [
	self uShortAtOffset: UserAgentLength put: anInteger]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> UserName [
	^self pointerAtOffset: UserName]

{ #category : #input }
HTTP_LOG_FIELDS_DATA >> username [
	^UTF16 decodeFromAddress: self UserName length: self UserNameLength // 2]

{ #category : #input }
HTTP_LOG_FIELDS_DATA >> username: aString [
	| external |
	aString isNil ifTrue: [^self].
	external := aString externalCopy.
	self
		UserName: external;
		UserNameLength: external length - 2]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> UserName: anExternalMemory [
	self addressAtOffset: UserName put: anExternalMemory]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> UserNameLength [
	^self uShortAtOffset: UserNameLength]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> UserNameLength: anInteger [
	self uShortAtOffset: UserNameLength put: anInteger]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> Win32Status [
	^self uLongAtOffset: Win32Status]

{ #category : #accessing }
HTTP_LOG_FIELDS_DATA >> Win32Status: anInteger [
	self uLongAtOffset: Win32Status put: anInteger]

